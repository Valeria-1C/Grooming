﻿&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ ЗначениеЗаполнено(Объект.АвторДокумента)Тогда
		Объект.АвторДокумента = ПараметрыСеанса.ТекущийПользователь;
	КонецЕсли;  
	
	Если Параметры.Свойство("Основание")
		И ЗначениеЗаполнено(Параметры.Основание)
		И ТипЗнч(Параметры.Основание) = Тип("ДокументСсылка.РеализацияТоваровИУслуг") Тогда
		СтруктураОплаты = Документы.РеализацияТоваровИУслуг.ПроверитьОплатуДокумента(Параметры.Основание);
		ПризнакОплаты = СтруктураОплаты.ПризнакОплаты;
		
		Если ПризнакОплаты = Перечисления.ВидыОплатДокумента.ПолностьюОплачен Тогда
			СообщениеПользователю = Новый СообщениеПользователю();
			СообщениеПользователю.Текст = "Данный документ уже полностью оплачен. Ввод дополнительного документа оплаты не требуется!";
			СообщениеПользователю.Сообщить();
			Отказ = Истина;
			возврат;
		Иначе
			Объект.СуммаДокумента = СтруктураОплаты.ОсталосьОплатить;
		КонецЕсли;
	КонецЕсли;
	
	ЗаполнитьРеквизитыФормы();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеквизитыФормы()
	
	Плательщик = Объект.Плательщик;
	ВидОперации = Объект.ВидОперации;
	ТипДенежныхСредств = Объект.ТипДенежныхСредств;
	
	Если Объект.Ссылка.Пустая() Тогда
		Объект.ТипДенежныхСредств = Перечисления.ТипыДенежныхСредств.Наличные;
		Объект.ВидОперации = Перечисления.ВидыОперацийПоступленияДенег.ОплатаОтПокупателя;	
	КонецЕсли;
	
КонецПроцедуры 

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьВидимость();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимость()
	
	СтрокаТипПлательщик = "";
	
	Если Объект.ТипДенежныхСредств = ПредопределенноеЗначение("Перечисление.ТипыДенежныхСредств.Наличные") Тогда
		Элементы.Касса.Видимость = Истина;
		Элементы.ЭквайринговыйТерминал.Видимость = Ложь;
	ИначеЕсли Объект.ТипДенежныхСредств = ПредопределенноеЗначение("Перечисление.ТипыДенежныхСредств.Безналичные") Тогда
		Элементы.Касса.Видимость = Ложь;
		Элементы.ЭквайринговыйТерминал.Видимость = Истина;
	КонецЕсли;
	
	Если Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступленияДенег.ВозвратОтПодотчетника") Тогда
		Элементы.ДоговорКонтрагента.Видимость = Ложь;
		Элементы.Плательщик.Видимость = Истина;
		Элементы.Касса.Видимость = Истина;
		Элементы.ЭквайринговыйТерминал.Видимость = Ложь;
		СтрокаТипПлательщик = "СправочникСсылка.Сотрудники";
	ИначеЕсли Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступленияДенег.ПолучениеНаличныхВБанке") Тогда
		Элементы.ДоговорКонтрагента.Видимость = Ложь;
		Элементы.Плательщик.Видимость = Истина;
		Элементы.Касса.Видимость = Истина;
		Элементы.ЭквайринговыйТерминал.Видимость = Ложь;
		СтрокаТипПлательщик = "СправочникСсылка.Банки";
	ИначеЕсли Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступленияДенег.ВозвратОтПоставщика") Тогда
		Элементы.ДоговорКонтрагента.Видимость = Истина;
		Элементы.Плательщик.Видимость = Истина;
		Элементы.Касса.Видимость = Истина;
		Элементы.ЭквайринговыйТерминал.Видимость = Ложь;
		СтрокаТипПлательщик = "СправочникСсылка.Контрагенты";
	ИначеЕсли Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступленияДенег.ОплатаОтПокупателя") Тогда
		Элементы.ДоговорКонтрагента.Видимость = Ложь;
		Элементы.Плательщик.Видимость = Истина; 
		СтрокаТипПлательщик = "СправочникСсылка.Контрагенты";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СтрокаТипПлательщик) Тогда
		Массив = Новый Массив();
		Массив.Добавить(Тип(СтрокаТипПлательщик));
		ОписаниеТипаПлательщика = Новый ОписаниеТипов(Массив);
		Элементы.Плательщик.ОграничениеТипа = ОписаниеТипаПлательщика;
	КонецЕсли;
	
	Если Элементы.ДоговорКонтрагента.Видимость = Истина
		И ЗначениеЗаполнено(Объект.Плательщик) Тогда
		Элементы.ДоговорКонтрагента.Видимость = ПроверитьВидимостьДоговораВЗависимостиОтТипаКонтрагента(Объект.Плательщик);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПроверитьВидимостьДоговораВЗависимостиОтТипаКонтрагента(Плательщик)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Плательщик", Плательщик);
	Запрос.Текст = "ВЫБРАТЬ
	|    Контрагенты.ТипКонтрагента КАК ТипКонтрагента,
	|    Контрагенты.Ссылка КАК Контрагент
	|ИЗ
	|    Справочник.Контрагенты КАК Контрагенты
	|ГДЕ
	|    Контрагенты.Ссылка = &Плательщик";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Если ЗначениеЗаполнено(Выборка.ТипКонтрагента)
		И Выборка.ТипКонтрагента = Перечисления.ТипыКонтрагента.Клиент Тогда
		возврат Ложь;
	Иначе
		возврат Истина;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ТипДенежныхСредствПриИзменении(Элемент)
	
	МассивОчищаемыхРеквизитов = Новый Массив;
	
	Если Объект.ТипДенежныхСредств = ПредопределенноеЗначение("Перечисление.ТипыДенежныхСредств.Наличные")
		И ЗначениеЗаполнено(Объект.ЭквайринговыйТерминал) Тогда
		МассивОчищаемыхРеквизитов.Добавить("ЭквайринговыйТерминал");
		ТекстВопроса = "При изменении ""Тип оплаты"" будут очищены слейдующие данные:
		| -Эквайринговый терминал
		| Продолжить?";
		
	ИначеЕсли Объект.ТипДенежныхСредств = ПредопределенноеЗначение("Перечисление.ТипыДенежныхСредств.Безналичные")
		И ЗначениеЗаполнено(Объект.Касса) Тогда
		МассивОчищаемыхРеквизитов.Добавить("Касса");
		Текствопроса = "При изменении ""Тип оплаты"" будут очищены слейдующие данные:
		| -Касса
		| Продолжить?";
	Конецесли;
	
	Если ЗначениеЗаполнено(МассивОчищаемыхРеквизитов) Тогда
		Оповещение = Новый ОписаниеОповещения("ПослеОтветаНаВопросОбИзмененииТипаДенежныхСредств", ЭтаФорма, МассивочищаемыхРеквизитов);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогавопрос.ДаНет,,,"Внимание!");
	Иначе
		ТипДенежныхСредств = Объект.ТипДенежныхСредств;
		УстановитьВидимость();
	КонецЕсли;
	
КонецПроцедуры 

&НаКлиенте
Процедура ПослеОтветаНаВопросОбИзмененииТипаДенежныхСредств(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Для Каждого Реквизит Из ДополнительныеПараметры Цикл
			Объект[Реквизит] = Неопределено;
		КонецЦикла;
		УстановитьВидимость();
		ТипДенежныхСредств = Объект.ТипДенежныхСредств;
	Иначе
		Объект.ТипДенежныхСредств = ТипДенежныхСредств;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидОперацииПриИзменении(Элемент)
	
	МассивОчищаемыхРеквизитов = Новый Массив;
	
	Если (Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступленияДенег.ВозвратОтПодотчетника")
		ИЛИ Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступленияДенег.ПолучениеНаличныхВБанке")
		ИЛИ Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступленияДенег.ОплатаОтПокупателя"))
		И ЗначениеЗаполнено(Объект.ДоговорКонтрагента)Тогда
		МассивОчищаемыхРеквизитов.Добавить("ДоговорКонтрагента");
		ТекстВопроса = "При изменении ревизита ""Вид операции"" будут очищены следующие данные:
		| -Договор?
		| Продолжить?";
		//ИначеЕсли Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступленияДенег.ВозвратОтПоставщика")
		//	И ЗначениеЗаполнено(Объект.Плательщик) Тогда
		//	МассивОчищаемыхРеквизитов.Добавить("Плательщик");
		//	ТекстВопроса = "При изменении реквизита ""Вид операции"" будут очищены следующие данные:
		//	| -Плательщик?
		//	| Продолжить?";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(МассивОчищаемыхРеквизитов) Тогда
		Оповещение = Новый ОписаниеОповещения("ПослеОтветаНаВопросОбИзмениенииВидаОперации", ЭтаФорма, МассивОчищаемыхРеквизитов);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет,,,"Внимание!");
	Иначе
		ВидОперации = Объект.ВидОперации;
		УстановитьВидимость();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеОтветаНаВопросОбизмениенииВидаОперации(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Для Каждого Реквизит Из ДополнительныеПараметры Цикл
			Объект[Реквизит] = Неопределено;
		КонецЦикла;
		УстановитьВидимость();
		ВидОперации =  Объект.ВидОперации;
	Иначе
		Объект.ВидОперации = ВидОперации;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПлательщикПриИзменении(Элемент)
	
	ЭтоПоставщик = ПроверитьВидимостьДоговораВЗависимостиОтТипаКонтрагента(Объект.Плательщик);
	МассивОчищаемыхРеквизитов = Новый Массив;
	
	Если НЕ ЭтоПоставщик И ЗначениеЗаполнено(Объект.ДоговорКонтрагента) Тогда
		МассивОчищаемыхРеквизитов.Добавить("ДоговорКонтрагента");
		
		ТекстВопроса = "При изменении реквизита ""Плательщик"" будут очищены следующие данные:
		| - Договор
		| Продолжить?";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(МассивОчищаемыхРеквизитов) Тогда
		Оповещение = Новый ОписаниеОповещения("ПослеОтветаНаВопросОбИзмененииПлательщик", ЭтаФорма, МассивОчищаемыхРеквизитов);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет,,,"Внимание!");
	Иначе
		Плательщик =  Объект.Плательщик;
		УстановитьВидимость();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеОтветаНаВопросОбИзмененииПлательщика(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Для Каждого Реквизит Из ДополнительныеПараметры Цикл
			Объект[Реквизит] = Неопределено;
		КонецЦикла;
		УстановитьВидимость();
		Плательщик =  Объект.Плательщик;
	Иначе
		Объект.Плательщик = Плательщик;
	КонецЕсли;
	
КонецПроцедуры






		
		
	

