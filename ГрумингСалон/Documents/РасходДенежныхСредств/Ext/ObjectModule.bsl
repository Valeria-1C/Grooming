﻿Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка) 
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПоступлениеУслуг") Тогда
		АвторДокумента = ДанныеЗаполнения.АвторДокумента;
		ДоговорКонтрагента = ДанныеЗаполнения.ДоговорПоставщика;
		Комментарий = ДанныеЗаполнения.Комментарий;
		Получатель = ДанныеЗаполнения.Поставщик;
		ДокументОснование = ДанныеЗаполнения.Ссылка;
		СуммаДокумента = ДанныеЗаполнения.СуммаДокумента;
		ВидОперации = Перечисления.ВидыОперацийРасходаДенег.ОплатаПоставщику;
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.РеализацияТоваровИУслуг") Тогда
		Получатель = ДанныеЗаполнения.Клиент;
		Комментарий = ДанныеЗаполнения.Комментарий;
		ДокументОснование = ДанныеЗаполнения.Ссылка;
		СуммаДокумента = ДанныеЗаполнения.СуммаДокумента;
		ВидОперации = Перечисления.ВидыОперацийРасходаДенег.ВозвратДенегПокупателю;
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПоступлениеТоваровИМатериалов") Тогда	
		ВидОперации = Перечисления.ВидыОперацийРасходаДенег.ОплатаПоставщику;
		ДоговорКонтрагента = ДанныеЗаполнения.Договор;
		Комментарий = ДанныеЗаполнения.Комментарий;
		Получатель = ДанныеЗаполнения.Поставщик;
		ДокументОснование = ДанныеЗаполнения.Ссылка;
		СуммаДокумента = ДанныеЗаполнения.СуммаДокумента;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	РасходДенежныхСредств.Дата КАК Период,
	|	РасходДенежныхСредств.Касса КАК БанковскийСчетКасса,
	|	РасходДенежныхСредств.СуммаДокумента КАК Сумма,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыДенежныхСредств.Наличные) КАК ТипДенежныхСредств
	|ИЗ
	|	Документ.РасходДенежныхСредств КАК РасходДенежныхСредств
	|ГДЕ
	|	РасходДенежныхСредств.Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	РасходДенежныхСредств.Дата,
	|	РасходДенежныхСредств.Касса,
	|	РасходДенежныхСредств.СуммаДокумента";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Движение = Движения.ДенежныеСредства.ДобавитьРасход();
		ЗаполнитьЗначенияСвойств(Движение, Выборка);
	КонецЦикла;
	
	Движения.ДенежныеСредства.Записывать = Истина;
	Движения.ДенежныеСредства.БлокироватьДляИзменения = Истина;
	Движения.Записать();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Касса", Касса);
	Запрос.УстановитьПараметр("МоментВремени", Новый Граница(МоментВремени()));
	Запрос.Текст =
	"ВЫБРАТЬ
	|	-ДенежныеСредстваОстатки.СуммаОстаток КАК Сумма,
	|	ДенежныеСредстваОстатки.БанковскийСчетКасса.Представление КАК Касса
	|ИЗ
	|	РегистрНакопления.ДенежныеСредства.Остатки(
	|			&МоментВремени,
	|			БанковскийСчетКасса = &Касса
	|				И ТипДенежныхСредств = ЗНАЧЕНИЕ(Перечисление.ТипыДенежныхСредств.Наличные)) КАК ДенежныеСредстваОстатки
	|ГДЕ
	|	ДенежныеСредстваОстатки.СуммаОстаток < 0";
	
	Рез = Запрос.Выполнить();
	Если НЕ Рез.Пустой() Тогда
		Отказ = Истина;
		Выборка = Рез.Выбрать();
		Выборка.Следующий();
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = СтрШаблон("По кассе ""%1"" недостаточно денежных средств в размере ""%2", Выборка.Касса, Выборка.Сумма);
		Сообщение.Сообщить();
	КонецЕсли;
	
	АналитикаПроводки = ПолучитьАналитикуПроводки();
	
	Движения.Хозрасчетный.Записывать = Истина;
	Движение = Движения.Хозрасчетный.Добавить();
	Движение.СчетДт = АналитикаПроводки.СчетДебета;
	Движение.СчетКт = АналитикаПроводки.СчетКредита;
	Движение.Период = Дата;
	Движение.Сумма = СуммаДокумента;
	Движение.Содержание = АналитикаПроводки.СодержаниеОперации;
	БухгалтерскийУчет.ЗаполнитьСубконтоПоСчету(Движение.СчетДт, Движение.СубконтоДт, АналитикаПроводки.СубконтоДебет);
	БухгалтерскийУчет.ЗаполнитьСубконтоПоСчету(Движение.СчетКт, Движение.СубконтоКт, АналитикаПроводки.СубконтоКредит);
	
	Движения.Записать();
	
	
КонецПроцедуры 

Функция ПолучитьАналитикуПроводки()
	
	ОплатаПоставщику = Перечисления.ВидыОперацийРасходаДенег.ОплатаПоставщику;
	ВзносНаличнымиВБанк = Перечисления.ВидыОперацийРасходаДенег.ВзносНаличнымиВБанк;
	ВозвратДенегПокупателю = Перечисления.ВидыОперацийРасходаДенег.ВозвратДенегПокупателю;
	ВыдачаДенегПодотчетнику = Перечисления.ВидыОперацийРасходаДенег.ВыдачаДенегПодотчетнику;
	
	СтруктураАналитики = Новый Структура;
	СтруктураАналитики.Вставить("СчетКредита", ПланыСчетов.Хозрасчетный.Касса);
	СтруктураАналитики.Вставить("СубконтоКредит", Касса);
	
	Если ВидОперации = ОплатаПоставщику Тогда
		СтруктураАналитики.Вставить("СчетДебета", ПланыСчетов.Хозрасчетный.РасчетыСПоставщиками);
		СтруктураАналитики.Вставить("СубконтоДебет", Получатель);
		СтруктураАналитики.Вставить("СодержаниеОперации", "Оплата поставщику наличными из кассы");
	ИначеЕсли ВидОперации = ВозвратДенегПокупателю Тогда
		СтруктураАналитики.Вставить("СчетДебета", ПланыСчетов.Хозрасчетный.РасчетыСПокупателями);    
		СтруктураАналитики.Вставить("СубконтоДебет", Получатель);
		СтруктураАналитики.Вставить("СодержаниеОперации", "Возврат покупателю наличными из кассы");
	ИначеЕсли ВидОперации = ВыдачаДенегПодотчетнику Тогда
		СтруктураАналитики.Вставить("СчетДебета", ПланыСчетов.Хозрасчетный.РасчетыСПодотчетнымиЛицами);
		СтруктураАналитики.Вставить("СубконтоДебет", Получатель);
		СтруктураАналитики.Вставить("СодержаниеОперации", "Выдача в подотчет наличных из кассы");
	ИначеЕсли ВидОперации = ВзносНаличнымиВБанк Тогда 
		СтруктураАналитики.Вставить("СчетДебета", ПланыСчетов.Хозрасчетный.РасчетныеСчета);
		СтруктураАналитики.Вставить("СубконтоДебет", РасчетныйСчет);
		СтруктураАналитики.Вставить("СодержаниеОперации", "Взнос наличных из кассы на расчетный счет");
	КонецЕсли;
	
	Возврат СтруктураАналитики;
	
	
КонецФункции































