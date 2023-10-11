%Лабораторная работа №1 (Вариант 6) - Ситникова Диана 1032201746
% факты о столицах (id, Название, население(тыс))
столица(1, 'Анкара', 5663).
столица(2, 'Астана', 1002).
столица(3, 'Дели', 20500).
столица(4, 'Токио', 13960).
столица(5, 'Богота', 7181).
столица(6, 'Оттава', 995).
столица(7, 'Антананариву', 1275).
столица(8, 'Каир', 9540).
столица(9, 'Мадрид', 3223).
столица(10, 'Париж', 2161).

% факты о государствах (id, Название, Часть света, население(млн))
государство(11, 'Турция', 'Азия', 85).
государство(12, 'Казахстан', 'Азия', 19).
государство(13, 'Индия', 'Азия', 1408).
государство(14, 'Япония', 'Азия', 126).
государство(15, 'Колумбия', 'Америка', 52).
государство(16, 'Канада', 'Америка', 38).
государство(17, 'Мадагаскар', 'Африка', 29).
государство(18, 'Египет', 'Африка', 109).
государство(19, 'Испания', 'Европа', 47).
государство(20, 'Франция', 'Европа', 68).

% факты о представительстве (id_столицы, id_государства)
представляет (1, 11).
представляет (2, 12).
представляет (3, 13).
представляет (4, 14).
представляет (5, 15).
представляет (6, 16).
представляет (7, 17).
представляет (8, 18).
представляет (9, 19).
представляет (19, 20).

% Генерация столиц для заданной части света
столицы_для_части_света(Часть_света, Столица):-
    государство(Id_государства, _, Часть_света, _),
    представляет(Id_столицы, Id_государства),
    столица(Id_столицы, Столица, _).

% Часть света для столицы по id_столицы
часть_света_для_столицы(Id_столицы, Часть_света):-
    представляет(Id_столицы, Id_государства),
    государство(Id_государства, _, Часть_света, _).

% Процент населения государства живущих в столице
процент_населения_в_столице(Столица, Процент):-
    столица(Id_столицы, Столица, Население_Столицы),
    представляет(Id_столицы, Id_государства),
    государство(Id_государства, _, _, Население_государства),
    Процент is Население_Столицы / (Население_государства * 1000) * 100.


% Государства с населением меньше N
государства_с_населением_меньше_N(N, Государство):-
    государство(_, Государство, _, Население),
    Население < N.
    
% Государства с населением больше или равно N
государства_с_населением_больше_N(N, Государство):-
    государство(_, Государство, _, Население),
    Население >= N.

% Население в заданной части света
население_в_части_света(Часть_света, X):-
    findall(Население, государство(_, _, Часть_света, Население), Список),
    sum_list(Список, X*1000000).


/* Примеры запросов:

Запрс:
столицы_для_части_света('Азия', Столица).
Выво:
СТОЛИЦА = 'Анкара'.
СТОЛИЦА = 'Астана'.
СТОЛИЦА = 'Дели'.
СТОЛИЦА = 'Токио'.

Запрос:
часть_света_для_столицы(6, Часть_света).
Вывод:
ЧАСТЬ_СВЕТА = 'Америка'.

Запрос:
государства_с_населением_меньше_N(55, Государство).
Вывод:
ГОСУДАРСТВО = 'Казахстан'.
ГОСУДАРСТВО = 'Колумбия'.
ГОСУДАРСТВО = 'Канада'.
ГОСУДАРСТВО = 'Мадагаскар'.
ГОСУДАРСТВО = 'Испания'.

Запрос:
государства_с_населением_больше_N(55, Государство).
Вывод:
ГОСУДАРСТВО = 'Турция'.
ГОСУДАРСТВО = 'Индия'.
ГОСУДАРСТВО = 'Япония'.
ГОСУДАРСТВО = 'Египет'.
ГОСУДАРСТВО = 'Франция'.

Запрос:
население_в_части_света('Азия', X).
*/
