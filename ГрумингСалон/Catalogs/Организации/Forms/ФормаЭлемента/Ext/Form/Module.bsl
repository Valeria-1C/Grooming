﻿
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьВидимость();
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимость()
	Если Объект.ТипОрганизации = ПредопределенноеЗначение("Перечисление.ТипыОгранизаций.ЮридическоеЛицо") Тогда
		Элементы.ГлавныйБухалтер.Видимость = Истина;
	Иначе
		Элементы.ГлавныйБухалтер.Видимость = Ложь;
		
	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура ТипОрганизацииПриИзменении(Элемент)
	УстановитьВидимость();
КонецПроцедуры
	