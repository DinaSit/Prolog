implement main
    open core, stdio, file

domains
    id = integer.
    population = integer.
    area = integer.
    count = integer.
    average = integer.
    name = string.
    region = string.
    lang = string.
    info = string.
    list = integer*.
    sum = integer.
    length = integer.

class facts - geography
    столица : (id ID, name Name, population Population, area Area).
    государство : (id ID, name Name, region Region, population Population, area Area, lang Language).
    представление : (id CapitalID, id CountryID).
    культура : (id ID, info Info).

class predicates
    столица_с_макс_населением : (region Region, name CapitalName, population Population) nondeterm.
    столица_с_мин_населением : (region Region, name CapitalName, population Population) nondeterm.
    государство_с_макс_площадью : (region Region, name CountryName, area Area) nondeterm.
    государство_с_мин_площадью : (region Region, name CountryName, area Area) nondeterm.
    сумма_населения_в_части : (region Region, population Population) nondeterm.
    средняя_площадь_в_части : (region Region, average Average) nondeterm.
    среднее_население_в_части : (region Region, average Average) nondeterm.
    количество_государств_с_населением_больше : (region Region, population Threshold, count Count) nondeterm.
    количество_государств_с_населением_меньше : (region Region, population Threshold, count Count) nondeterm.
    столицы_в_части : (region Region, name CapitalName) nondeterm.
    процент_населения_столицы_относительно_государства : (id CapitalID, id CountryID, average Percent) nondeterm.
    процент_населения_государства_относительно_части_света : (region Region, id CountryID, average Percent) nondeterm.
    население_в_части : (region Region, population Population) nondeterm.
    государства_с_языком : (lang Language, name CountryName) nondeterm.
    языки_в_части : (region Region, lang Language) nondeterm.
    культура_в_государстве : (id CountryID, id CultureID) nondeterm.
    sum_list : (list List, sum Sum) procedure (i, o).
    length_list : (list, integer) procedure (i, o).

clauses
    sum_list([], 0).
    sum_list([Head | Tail], Sum + Head) :-
        sum_list(Tail, Sum1).

    length_list([], 0).
    length_list([_ | Tail], Length + 1) :-
        length_list(Tail, Length).

    столица_с_макс_населением(Region, CapitalName, Population) :-
        представление(CapitalID, CountryID),
        государство(CountryID, _, Region, Population, _, _),
        столица(CapitalID, CapitalName, Population, _),
        not(
            (представление(OtherCapitalID, OtherCountryID) and государство(OtherCountryID, _, Region, OtherPopulation, _, _)
                and столица(OtherCapitalID, _, OtherPopulation, _) and OtherPopulation > Population)).

    столица_с_мин_населением(Region, CapitalName, Population) :-
        представление(CapitalID, CountryID),
        государство(CountryID, _, Region, Population, _, _),
        столица(CapitalID, CapitalName, Population, _),
        not(
            (представление(OtherCapitalID, OtherCountryID) and государство(OtherCountryID, _, Region, OtherPopulation, _, _)
                and столица(OtherCapitalID, _, OtherPopulation, _) and OtherPopulation < Population)).

    государство_с_макс_площадью(Region, CountryName, Area) :-
        государство(_, CountryName, Region, _, Area, _),
        not((государство(_, _, Region, _, OtherArea, _) and OtherArea > Area)).

    государство_с_мин_площадью(Region, CountryName, Area) :-
        государство(_, CountryName, Region, _, Area, _),
        not((государство(_, _, Region, _, OtherArea, _) and OtherArea < Area)).

    сумма_населения_в_части(Region, Population) :-
        Pops =
            [ Pop ||
                государство(_, _, Region, Pop, _, _),
                столица(_, _, Pop, _)
            ],
        sum_list(Pops, Population).

    средняя_площадь_в_части(Region, Average) :-
        Areas =
            [ Area ||
                государство(_, _, Region, _, Area, _),
                столица(_, _, _, Area)
            ],
        length_list(Areas, Count),
        sum_list(Areas, Sum),
        Count > 0,
        Average = Sum / Count.

    среднее_население_в_части(Region, Average) :-
        Populations =
            [ Population ||
                государство(_, _, Region, Population, _, _),
                столица(_, _, Population, _)
            ],
        length_list(Populations, Count),
        sum_list(Populations, Sum),
        Average = Sum / Count.

    количество_государств_с_населением_больше(Region, Threshold, Count) :-
        Countries =
            [ CountryID ||
                государство(CountryID, _, Region, Population, _, _),
                столица(_, _, Population, _),
                Population > Threshold
            ],
        length_list(Countries, Count).

    количество_государств_с_населением_меньше(Region, Threshold, Count) :-
        Countries =
            [ CountryID ||
                государство(CountryID, _, Region, Population, _, _),
                столица(_, _, Population, _),
                Population < Threshold
            ],
        length_list(Countries, Count).

    столицы_в_части(Region, CapitalName) :-
        представление(CapitalID, CountryID),
        государство(CountryID, _, Region, _, _, _),
        столица(CapitalID, CapitalName, _, _).

    процент_населения_столицы_относительно_государства(CapitalID, CountryID, Percent) :-
        столица(CapitalID, _, CapitalPopulation, _),
        государство(CountryID, _, _, CountryPopulation, _, _),
        Percent = CapitalPopulation * 100 / CountryPopulation.

    процент_населения_государства_относительно_части_света(Region, CountryID, Percent) :-
        государство(CountryID, _, Region, CountryPopulation, _, _),
        сумма_населения_в_части(Region, RegionPopulation),
        Percent = CountryPopulation * 100 / RegionPopulation.

    население_в_части(Region, Population) :-
        сумма_населения_в_части(Region, Population).

    государства_с_языком(Language, CountryName) :-
        государство(_, CountryName, _, _, _, Language).

    языки_в_части(Region, Language) :-
        государства_с_языком(Language, _),
        государство(_, _, Region, _, _, Language).

    культура_в_государстве(CountryID, CultureID) :-
        представление(_, CountryID),
        культура(CultureID, _).

clauses
    run() :-
        file::consult("../base.txt", geography),
        fail.
% Пример использования правил
    run() :-
        write("\nСтолица с наибольшим населением в Азии:"),
        столица_с_макс_населением('Азия', MaxPopCapital, MaxPop),
        write(MaxPopCapital, " - ", MaxPop, " тыс."),
        fail.

    run() :-
        write("\nСтолица с наименьшим населением в Азии:"),
        столица_с_мин_населением('Азия', MinPopCapital, MinPop),
        write(MinPopCapital, " - ", MinPop, " тыс."),
        fail.

    run() :-
        write("\nГосударство с наибольшей площадью в Азии:"),
        государство_с_макс_площадью('Азия', MaxAreaCountry, MaxArea),
        write(MaxAreaCountry, " - ", MaxArea, " тыс. км^2."),
        fail.

    run() :-
        write("\nГосударство с наименьшей площадью в Азии:"),
        государство_с_мин_площадью('Азия', MinAreaCountry, MinArea),
        write(MinAreaCountry, " - ", MinArea, " тыс. км^2."),
        fail.

    run() :-
        write("\nСуммарное население в Азии:"),
        сумма_населения_в_части('Азия', TotalPop),
        write(TotalPop, " млн."),
        fail.

    run() :-
        write("\nСредняя площадь в Азии:"),
        средняя_площадь_в_части('Азия', AvgArea),
        write(AvgArea, " тыс. км^2."),
        fail.

    run() :-
        write("\nКоличество государств в Азии с населением более 50 млн.:"),
        количество_государств_с_населением_больше('Азия', 50, CountAbove50),
        write(CountAbove50),
        fail.

    run() :-
        write("\nКоличество государств в Азии с населением менее 30 млн.:"),
        количество_государств_с_населением_меньше('Азия', 30, CountBelow30),
        write(CountBelow30),
        fail.

    run() :-
        write("\nСтолицы в Азии:"),
        столицы_в_части('Азия', CapitalName),
        write(CapitalName),
        fail.

    run() :-
        write("\nПроцент населения столицы относительно государства:"),
        процент_населения_столицы_относительно_государства(1, 2, PercentCapital),
        write(PercentCapital, "%"),
        fail.

    run() :-
        write("\nПроцент населения государства относительно Азии:"),
        процент_населения_государства_относительно_части_света('Азия', 1, PercentCountry),
        write(PercentCountry, "%"),
        fail.

    run() :-
        write("\nГосударства, где говорят на русском:"),
        государства_с_языком('Русский', RussianCountries),
        write(RussianCountries),
        fail.

    run() :-
        write("\nЯзыки в Азии:"),
        языки_в_части('Азия', LanguagesInAsia),
        write(LanguagesInAsia),
        fail.

    run() :-
        write("\nКультура в России:"),
        культура_в_государстве(1, CultureID),
        write(CultureID),
        fail.

    run().

end implement main

goal
    console::runUtf8(main::run).
