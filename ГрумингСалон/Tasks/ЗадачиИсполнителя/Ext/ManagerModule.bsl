﻿Функция ВозвратПредмет(БизнесПроцесс) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДорегистрацияПользователя.Пользователь КАК Пользователь,
	|	ДорегистрацияПользователя.Ссылка КАК Ссылка
	|ИЗ
	|	БизнесПроцесс.ДорегистрацияПользователя КАК ДорегистрацияПользователя
	|ГДЕ
	|	ДорегистрацияПользователя.Ссылка = &Ссылка";
	Запрос.УстановитьПараметр("Ссылка", БизнесПроцесс);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	Возврат Выборка.Пользователь;
КонецФункции

Функция ВозвратТелефон(БизнесПроцесс) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДорегистрацияПользователя.Пользователь.Клиент.КонтактныйТелефон КАК КонтактныйТелефон
	|ИЗ
	|	БизнесПроцесс.ДорегистрацияПользователя КАК ДорегистрацияПользователя
	|ГДЕ
	|	ДорегистрацияПользователя.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", БизнесПроцесс);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	Возврат Выборка.КонтактныйТелефон;
	
КонецФункции
