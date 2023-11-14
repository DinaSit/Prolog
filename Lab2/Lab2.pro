implement main
    open core, stdio, file

domains
    id = integer.
    name = string.
    population = integer.
    region = string.

class facts - geography
    столица : (id ID, name Name, population Population).
    государство : (id ID, name Name, region Region, population Population).
    представление : (id CapitalID, id CountryID).

class predicates
    население_страны : (id CountryID, population Population) nondeterm.
    столицы_в_регионе : (region Region, count Count) nondeterm.
    общее_население : (region Region, population Population) nondeterm.
    страны_в_регионе : (region Region, count Count) nondeterm.
    среднее_население_региона : (region Region, average Average) nondeterm.
    столицы_и_регионы : (name Capital, region Region) nondeterm.
    представленные_страны : (id CapitalID, region Region, count Count) nondeterm.
    среднее_население_государств : (average Average) nondeterm.

clauses
    % Правило: вычисление общего населения страны
    население_страны(CountryID, Population) :-
        государство(CountryID, _, _, Population).

    % Правило: вычисление количества столиц в регионе
    столицы_в_регионе(Region, Count) :-
        представление(_, CountryID),
        государство(CountryID, _, Region, _),
        count(представление(_, CountryID), Count).

    % Правило: вычисление общего населения в регионе
    общее_население(Region, TotalPopulation) :-
        государство(_, _, Region, Population),
        sum(государство(_, _, Region, Population), TotalPopulation).

    % Правило: вычисление количества стран в регионе
    страны_в_регионе(Region, Count) :-
        государство(_, _, Region, _),
        count(государство(_, _, Region, _), Count).

    % Правило: вычисление среднего населения региона
    среднее_население_региона(Region, Average) :-
        государство(_, _, Region, Population),
        count(государство(_, _, Region, Population), Count),
        if Count > 0 then
            Average = sum(государство(_, _, Region, Population)) / Count
        else
            Average = 0
        end if.

    % Правило: вычисление списка столиц и их регионов
    столицы_и_регионы(Capital, Region) :-
        столица(_, Capital, _),
        государство(CountryID, _, Region, _),
        представление(_, CountryID).

    % Правило: вычисление представленных стран и их регионов
    представленные_страны(CapitalID, Region, Count) :-
        представление(CapitalID, CountryID),
        государство(CountryID, _, Region, _),
        count(представление(_, CountryID), Count).

    % Правило: вычисление среднего населения государств
    среднее_население_государств(Average) :-
        государство(_, _, _, Population),
        count(государство(_, _, _, Population), Count),
        if Count > 0 then
            Average = sum(государство(_, _, _, Population)) / Count
        else
            Average = 0
        end if.

clauses
    run() :-
        file::consult("../base.txt", geography),
        fail.
    run() :-
        % Пример использования правил
        write("Население страны с ID 13:"),
        население_страны(13, Population),
        write(Population),
        write("\nКоличество столиц в регионе 'Азия':"),
        столицы_в_регионе('Азия', Count),
        write(Count),
        write("\nОбщее население в регионе 'Азия':"),
        общее_население('Азия', TotalPopulation),
        write(TotalPopulation),
        write("\nКоличество стран в регионе 'Африка':"),
        страны_в_регионе('Африка', Count),
        write(Count),
        write("\nСреднее население в регионе 'Азия':"),
        среднее_население_региона('Азия', Average),
        write(Average),
        write("\nСтолицы и регионы:"),
        столицы_и_регионы(Capital, Region),
        write(Capital, " - ", Region),
        write("\nПредставленные страны и их регионы:"),
        представленные_страны(CapitalID, Region, Count),
        write("Страны: ", Count),
        write("\nСреднее население государств:"),
        среднее_население_государств(Average),
        write(Average),
        fail.
    run().

end implement main

goal
    console::runUtf8(main::run).
