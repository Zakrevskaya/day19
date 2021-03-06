Процедура ОбработкаПроведения(Отказ,Режим)
	
	Движения.ОстаткиТоваров.Записывать = Истина;
	Для Каждого ТекСтрокаТовары из Товары Цикл
		Движение = Движения.ОстаткиТоваров.Добавить();
		Движение.Период = Дата;
		Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
		Движение.Номенклатура = ТекСтрокаТовары.Номенклатура;
		Движение.Количество = ТекСтрокаТовары.Количество;
		Движение.Выручка = ТекСтрокаТовары.Сумма;
	КонецЦикла;
   
   Движения.Записать();
   
   Если Режим = РежимПроведенияДокумента.Оперативный Тогда
   
   Запрос = Новый Запрос;
   Запрос.Текст =
   	"ВЫБРАТЬ
   	|	ОстаткиТоваровОстатки.Номенклатура,
   	|	ОстаткиТоваровОстатки.КоличествоОстаток КАК Количество
   	|ИЗ
   	|	РегистрНакопления.ОстаткиТоваров.Остатки(, Номенклатура В
   	|		(ВЫБРАТЬ
   	|			РеализацияТоваровТовары.Номенклатура
   	|		ИЗ
   	|			Документ.РеализацияТоваров.Товары КАК РеализацияТоваровТовары
   	|		ГДЕ
   	|			РеализацияТоваровТовары.Ссылка = &Ссылка)) КАК ОстаткиТоваровОстатки
   	|ГДЕ
   	|	ОстаткиТоваровОстатки.КоличествоОстаток < 0";
   
   Запрос.УстановитьПараметр("Ссылка", Ссылка);
   
   РезультатЗапроса = Запрос.Выполнить();
   
   Если НЕ РезультатЗапроса.Пустой() Тогда 
   
   Отказ = Истина;
   
   ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
   
   Сообщить ("В документе " + Ссылка + " образовались отрицательные остатки");
   
   Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
   	
   	Сообщить("По номенклатуре "+ ВыборкаДетальныеЗаписи.Номенклатура + " остаток " + ВыборкаДетальныеЗаписи.Количество);
   	
   КонецЦикла;
   КонецЕсли;
   
   КонецЕсли;
   
   Если Отказ Тогда 
   	Возврат;
   КонецЕсли;
   
  
   Запрос = Новый Запрос;
   Запрос.Текст =
   	"ВЫБРАТЬ
   	|	ОстаткиТоваровОстатки.Номенклатура,
   	|	ОстаткиТоваровОстатки.КоличествоОстаток КАК Количество,
   	|	ОстаткиТоваровОстатки.СуммаОстаток КАК Сумма
   	|ИЗ
   	|	РегистрНакопления.ОстаткиТоваров.Остатки(&МоментВремени, Номенклатура В
   	|		(ВЫБРАТЬ
   	|			РеализацияТоваровТовары.Номенклатура
   	|		ИЗ
   	|			Документ.РеализацияТоваров.Товары КАК РеализацияТоваровТовары
   	|		ГДЕ
   	|			РеализацияТоваровТовары.Ссылка = &Ссылка)) КАК ОстаткиТоваровОстатки";
   
   Запрос.УстановитьПараметр("МоментВремени", МоментВремени());
   Запрос.УстановитьПараметр("Ссылка", Ссылка);
   
   РезультатЗапроса = Запрос.Выполнить();
   Движения.ОстаткиТоваров.Записывать = Истина;
   Движения.Продажи.Записывать = Истина;
   ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
   СписаннаяСебестоимость = 0;
   
   Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
   	
   	Для каждого Движение Из Движения.ОстаткиТоваров Цикл
   		
   		Если Движение.Номенклатура = ВыборкаДетальныеЗаписи.Номенклатура Тогда
   			
   			Движение.Сумма = Движение.Количество * ВыборкаДетальныеЗаписи.Сумма / ВыборкаДетальныеЗаписи.Количество;
   			
   			ДвижениеПродажи = Движения.Продажи.Добавить();
   			ДвижениеПродажи.Период = Дата;
   			ДвижениеПродажи.Номенклатура = ВыборкаДетальныеЗаписи.Номенклатура;
   			ДвижениеПродажи.Контрагент = Контрагент;
   			ДвижениеПродажи.Сумма = Движение.Выручка;
   			ДвижениеПродажи.Себестоимость = Движение.Сумма;
   			ДвижениеПродажи.Количество = Движение.Количество;
   			СписаннаяСебестоимость = СписаннаяСебестоимость + Движение.Сумма;
   			
   			КонецЕсли;
   		
   		КонецЦикла;
  
   КонецЦикла;
   
   Движения.РегистрБухУчет.Записывать = Истина;
   Проводка = Движения.РегистрБухУчет.Добавить();
   Проводка.Период = Дата;
   Проводка.СчетДт = ПланыСчетов.БухУчет.Себестоимость;
   Проводка.СчетКт = ПланыСчетов.БухУчет.Товары;
   Проводка.Сумма = СписаннаяСебестоимость;
   
   Проводка = Движения.РегистрБухУчет.Добавить();
   Проводка.Период = Дата;
   Проводка.СчетДт = ПланыСчетов.БухУчет.Покупатели;
   Проводка.СчетКт = ПланыСчетов.БухУчет.Выручка;
   Проводка.Сумма = СуммаДокумента;

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
СуммаДокумента = Товары.Итог("Сумма");
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	если НЕ Контрагент.Клиент  Тогда
		Отказ = Истина;
		Сообщить ("Был выбран не Клиент!");
	КонецЕсли;
КонецПроцедуры
