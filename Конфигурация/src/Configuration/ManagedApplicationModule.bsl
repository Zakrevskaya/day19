ДвухзначноеЧисло = 50;
Степень = 3;
Результат = 1;
Для Индекс = 1 По Степень Цикл
	Результат = Результат * ДвухзначноеЧисло;
КонецЦикла;
Сообщить (Результат);

Если Результат > 10000 Тогда
	Сообщить ("Результат превышает 10000");
КонецЕсли;


КонецГода = КонецГода(ТекущаяДата());
для Индекс = 1 по 10 Цикл
	ДеньНедели = ДеньНедели(КонецГода);
	Если ДеньНедели = 1 Тогда
		Сообщить ("Понедельник");
	ИначеЕсли ДеньНедели = 2 Тогда
		Сообщить ("Вторник");
	ИначеЕсли ДеньНедели = 3 Тогда
		Сообщить ("Среда");
	ИначеЕсли ДеньНедели = 4 Тогда
		Сообщить ("Четверг");
	ИначеЕсли ДеньНедели = 5 Тогда
		Сообщить ("Пятница");
	ИначеЕсли ДеньНедели = 6 Тогда
		Сообщить ("Суббота");
	Иначе
		Сообщить ("Воскресенье");
	КонецЕсли;
	КонецГода = КонецГода(КонецДня(КонецГода)+1);
КонецЦикла;


МассивЧисел= Новый Массив;
МассивЧисел.Добавить(123);
МассивЧисел.Добавить(456);
Для каждого ЭлементМассива из МассивЧисел Цикл 
	Сообщить(ЭлементМассива);
КонецЦикла;