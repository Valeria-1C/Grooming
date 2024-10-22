﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ ЗначениеЗаполнено(Объект.Автор) Тогда	
		Объект.Автор = ПараметрыСеанса.ТекущийПользователь;  	
	КонецЕсли; 
	
	Если Объект.Ссылка.Пустая() Тогда
		Объект.ПризнакОплаты = Перечисления.ВидыОплатДокумента.НеОплачен; 
	Иначе
		Если Объект.ПризнакОплаты <> Перечисления.ВидыОплатДокумента.ПолностьюОплачен Тогда
			СтруктураОплаты = Документы.РеализацияТоваровИУслуг.ПроверитьОплатуДокумента(Объект.Ссылка);
			Объект.ПризнакОплаты = СтруктураОплаты.ПризнакОплаты;
		КонецЕсли;
	КонецЕсли;
	
	Если Параметры.Свойство("Основание")
    И ЗначениеЗаполнено(Параметры.Основание)
    И ТипЗнч(Параметры.Основание) = Тип("ДокументСсылка.ЗаписьКлиента") Тогда
	УслугаОказана = Документы.ЗаписьКлиента.ПроверитьОказаниеУслуг(Параметры.Основание);
	
	Если УслугаОказана = Истина Тогда
		СообщениеПользователю = Новый СообщениеПользователю();
        СообщениеПользователю.Текст = СтрШаблон("Для документа уже введен документ реализации");
        СообщениеПользователю.Сообщить();
        Отказ = Истина;
        возврат;
	КонецЕсли;
КонецЕсли;

		
КонецПроцедуры

&НаКлиенте
Процедура УслугиУслугаПриИзменении(Элемент)
	СтрокаТЧ = Элементы.Услуги.ТекущиеДанные;
		
	Если ЗначениеЗаполнено(СтрокаТЧ.Услуга) Тогда
		СтрокаТЧ.Сумма = РаботаСЦенамиВызовСервера.ПолучитьЦенуПродажиНаДату(СтрокаТЧ.Услуга, , Объект.Дата);
	Иначе
		СтрокаТЧ.Сумма = 0;
	КонецЕсли;  
	
   ПерерасчетСуммуДокумента();	

КонецПроцедуры

&НаКлиенте
Процедура ТоварыТоварПриИзменении(Элемент)
	СтрокаТЧ = Элементы.Товары.ТекущиеДанные;
	
	Если ЗначениеЗаполнено(СтрокаТЧ.Товар) Тогда
		СтрокаТЧ.Цена = РаботаСЦенамиВызовСервера.ПолучитьЦенуПродажиНаДату(СтрокаТЧ.Товар, , Объект.Дата);
	Иначе
		СтрокаТЧ.Цена = 0;
	КонецЕсли;

    РаботаСтабличнымиЧастямиКлиент.ПересчитатьСуммуВСтрокеТабличнойЧасти(СтрокаТЧ);
	
	ПерерасчетСуммуДокумента();
	
	КонецПроцедуры

&НаКлиенте
Процедура ТоварыКоличествоПриИзменении(Элемент)
	СтрокаТЧ = Элементы.Товары.ТекущиеДанные;
	
	РаботаСтабличнымиЧастямиКлиент.ПересчитатьСуммуВСтрокеТабличнойЧасти(СтрокаТЧ); 
	
	ПерерасчетСуммуДокумента();
		
КонецПроцедуры

&НаКлиенте
Процедура ПерерасчетСуммуДокумента()
	Объект.СуммаДокумента = Объект.Услуги.Итог("Сумма") + Объект.Товары.Итог("Сумма");  
КонецПроцедуры




