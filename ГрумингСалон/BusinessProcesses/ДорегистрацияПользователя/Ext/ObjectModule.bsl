﻿
Процедура ПометкаНаУдалениеПользователяОбработка(ТочкаМаршрутаБизнесПроцесса)
	
	Пользователь = Справочники.Пользователи.НайтиПоНаименованию(Пользователь);
	ПользовательПУ = Пользователь.ПолучитьОбъект();
	ПользовательПУ.ПометкаУдаления = Истина;
	ПользовательПУ.Записать();
	
КонецПроцедуры

Процедура КлиентПотвердилРегистрациюПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	
	Если БизнесПроцессы.ДорегистрацияПользователя.ПроверитьОтветПользователя(Ссылка) = "1" Тогда
		Результат = Истина;
		РегистрацияПотверждена = Истина;
	Иначе
		Результат = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПолучитьПотверждениеРегистрацииКлиентаПриСозданииЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, Отказ)
	
	Для Каждого Задача Из ФормируемыеЗадачи Цикл
		Задача.Наименование = ТочкаМаршрутаБизнесПроцесса.НаименованиеЗадачи + " " + Пользователь.Наименование + " на регистрацию";
	КонецЦикла;
	
КонецПроцедуры



