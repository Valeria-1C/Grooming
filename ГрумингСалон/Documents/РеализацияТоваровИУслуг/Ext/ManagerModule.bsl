﻿
Процедура Печать(ТабДок, Ссылка) Экспорт
	
	Макет = Документы.РеализацияТоваровИУслуг.ПолучитьМакет("Печать");
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РеализацияТоваровИУслуг.Автор,
	|	РеализацияТоваровИУслуг.Дата,
	|	РеализацияТоваровИУслуг.Клиент,
	|	РеализацияТоваровИУслуг.Номер,
	|	РеализацияТоваровИУслуг.Основание,
	|	РеализацияТоваровИУслуг.Сотрудник,
	|	РеализацияТоваровИУслуг.СуммаДокумента,
	|	РеализацияТоваровИУслуг.Услуги.(
	|		НомерСтроки,
	|		Услуга,
	|		Сумма
	|	),
	|	РеализацияТоваровИУслуг.Товары.(
	|		НомерСтроки,
	|		Товар,
	|		Количество,
	|		Цена,
	|		Сумма
	|	)
	|ИЗ
	|	Документ.РеализацияТоваровИУслуг КАК РеализацияТоваровИУслуг
	|ГДЕ
	|	РеализацияТоваровИУслуг.Ссылка В (&Ссылка)";
	Запрос.Параметры.Вставить("Ссылка", Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();

	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	Шапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьУслугиШапка = Макет.ПолучитьОбласть("УслугиШапка");
	ОбластьУслуги = Макет.ПолучитьОбласть("Услуги");
	ОбластьТоварыШапка = Макет.ПолучитьОбласть("ТоварыШапка");
	ОбластьТовары = Макет.ПолучитьОбласть("Товары");
	Подвал = Макет.ПолучитьОбласть("Подвал");

	ТабДок.Очистить();

	ВставлятьРазделительСтраниц = Ложь;
	Пока Выборка.Следующий() Цикл
		Если ВставлятьРазделительСтраниц Тогда
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;

		ТабДок.Вывести(ОбластьЗаголовок);

		Шапка.Параметры.Заполнить(Выборка);
		ТабДок.Вывести(Шапка, Выборка.Уровень());

		ВыборкаУслуги = Выборка.Услуги.Выбрать();
		Если ВыборкаУслуги.Количество() Тогда
			ТабДок.Вывести(ОбластьУслугиШапка);
			Пока ВыборкаУслуги.Следующий() Цикл
				ОбластьУслуги.Параметры.Заполнить(ВыборкаУслуги);
				ТабДок.Вывести(ОбластьУслуги, ВыборкаУслуги.Уровень());
			КонецЦикла;
		КонецЕсли;
	

		ВыборкаТовары = Выборка.Товары.Выбрать();
		Если ВыборкаТовары.Количество() Тогда
			ТабДок.Вывести(ОбластьТоварыШапка);
		Пока ВыборкаТовары.Следующий() Цикл
			ОбластьТовары.Параметры.Заполнить(ВыборкаТовары);
			ТабДок.Вывести(ОбластьТовары, ВыборкаТовары.Уровень());
		КонецЦикла;
	КонецЕсли;

		Подвал.Параметры.Заполнить(Выборка);
		ТабДок.Вывести(Подвал);

		ВставлятьРазделительСтраниц = Истина;
	КонецЦикла;
	
КонецПроцедуры

Функция ПроверитьОплатуДокумента(ДокументРТУ) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка",ДокументРТУ);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СУММА(ПоступлениеДенежныхСредств.СуммаДокумента) КАК СуммаДокумента,
	|	ПоступлениеДенежныхСредств.ДокументОснование КАК ДокументОснование
	|ПОМЕСТИТЬ ВТ_Поступления
	|ИЗ
	|	Документ.ПоступлениеДенежныхСредств КАК ПоступлениеДенежныхСредств
	|ГДЕ
	|	ПоступлениеДенежныхСредств.ДокументОснование = &Ссылка
	|	И ПоступлениеДенежныхСредств.Проведен
	|
	|СГРУППИРОВАТЬ ПО
	|	ПоступлениеДенежныхСредств.ДокументОснование
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РеализацияТоваровИУслуг.СуммаДокумента - ЕСТЬNULL(ВТ_Поступления.СуммаДокумента, 0) КАК ОсталосьОплатить,
	|	ВЫБОР
	|		КОГДА РеализацияТоваровИУслуг.СуммаДокумента - ЕСТЬNULL(ВТ_Поступления.СуммаДокумента, 0) > 0
	|				И ЕСТЬNULL(ВТ_Поступления.СуммаДокумента, 0) > 0
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыОплатДокумента.ЧастичноОплачен)
	|		КОГДА ЕСТЬNULL(ВТ_Поступления.СуммаДокумента, 0) = 0
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыОплатДокумента.НеОплачен)
	|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ВидыОплатДокумента.ПолностьюОплачен)
	|	КОНЕЦ КАК ПризнакОплаты
	|ИЗ
	|	Документ.РеализацияТоваровИУслуг КАК РеализацияТоваровИУслуг
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Поступления КАК ВТ_Поступления
	|		ПО РеализацияТоваровИУслуг.Ссылка = ВТ_Поступления.ДокументОснование
	|ГДЕ
	|	РеализацияТоваровИУслуг.Ссылка = &Ссылка";
	
	СтруктураОтвета = Новый Структура("ПризнакОплаты, ОсталосьОплатить", Перечисления.ВидыОплатДокумента.НеОплачен, 0);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	ЗаполнитьЗначенияСвойств(СтруктураОтвета,Выборка);
	Возврат СтруктураОтвета;
	
КонецФункции

