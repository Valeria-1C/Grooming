﻿
Процедура УстановкаПараметровСеанса(ИменаПараметровСеанса)
	Если ИменаПараметровСеанса = Неопределено Тогда
		
	Иначе
		УстановленныеПараметры = Новый Массив;
		Для каждого ИмяПараметра Из ИменаПараметровСеанса Цикл
			УстановитьЗначениеПараметраСеанса(ИмяПараметра, УстановленныеПараметры);
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

	
Процедура УстановитьЗначениеПараметраСеанса(Знач ИмяПараметра, УстановленныеПараметры)
	Если УстановленныеПараметры.Найти(ИмяПараметра) <> Неопределено Тогда	
		Возврат;	
	КонецЕсли;
	
	Если ИмяПараметра = "ТекущийПользователь" Тогда 	
		ПользовательИБ = ПользователиИнформационнойБазы.ТекущийПользователь();		
		Если ПользовательИБ = Неопределено Тогда	
		Возврат;
		КонецЕсли;
		
		ТекущийПользователь = Справочники.Пользователи.НайтиПоКоду(ПользовательИБ.УникальныйИдентификатор);
		
		Если ТекущийПользователь.Пустая() Тогда 	
			ПользовательОбъект = Справочники.Пользователи.СоздатьЭлемент();
			ПользовательОбъект.Код = ПользовательИБ.УникальныйИдентификатор;
			ПользовательОбъект.Наименование = ПользовательИБ.Имя;
			ПользовательОбъект.Записать(); 
			ТекущийПользователь = ПользовательОбъект.Ссылка;		
		КонецЕсли;
		
		ПараметрыСеанса.ТекущийПользователь = ТекущийПользователь;	
	КонецЕсли;
	
	УстановленныеПараметры.Добавить(ИмяПараметра);
	
КонецПроцедуры 



