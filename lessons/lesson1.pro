/* 
    Семейные отношения    
    gender enum: male / female
*/

person(4, "Maggy", female).
person(3, "Matt", male).

person(1, "Tom", male).
person(2, "Pam", female).

person(5, "Julia", female).
person(6, "Daemon", male).
person(7, "Tony", male).

/* Семантика и последовательность атрибутов определяется программистом */

% parent(Child, Parent)
parent(4, 1).

parent(3, 1).
parent(3, 2).

parent(4, 2).

parent(1, 5).
parent(1, 6).

parent(2, 7).

/* строки: father("Matt", "Tom")  */
father(Child, Father) :- 
    person(ChildId, Child, _), 
    person(FatherId, Father, male),
    parent(ChildId, FatherId).

% мама
mother(Child, Mother):-
    person(ChildId, Child, _), 
    person(MotherId, Mother, female),
    parent(ChildId, MotherId).

% дедушка
gfather(Gchild, Gfather):-
    person(GchildId, Gchild, _),
    parent(GchildId, FatherId),
    person(FatherId, Father, _),
    father(Father, Gfather).

% бабушка
gmother(Gchild, Gmother) :-
    person(GchildId, Gchild, _),
    parent(GchildId, MotherId),
    person(MotherId, Mother, _),
    mother(Mother, Gmother).

% сестра
sister(Child, Sister):-
    person(ChildId, Child, _),
    person(SisterId, Sister, female),
    parent(ChildId, ParentId), 
    parent(SisterId, ParentId), not(Child = Sister).

% брат
brother(Child, Brother):-
    person(ChildId, Child, _),
    person(BrotherId, Brother, male),
    parent(ChildId, ParentId), 
    parent(BrotherId, ParentId), not(Child = Brother).

% рекурсивный предок 
ancestor(X, Y):- father(X, Y).
ancestor(X, Y):- father(X, Z), ancestor(Z, Y).

ancestor(X, Y):- mother(X, Y).
ancestor(X, Y):- mother(X, Z), ancestor(Z, Y).

/* Запросы:

father("Maggy", X).
Вывод:
X = "Tom".

mother("Maggy", X).
Вывод:
X = "Pam".

gmother("Maggy", X).
Вывод:
X = "Julia".

gfather("Maggy", X).
Вывод:
X = "Daemon".
X = "Tony".

sister("Matt", X).
Вывод:
X = "Maggy". % со стороны одного родителя
X = "Maggy". % со стороны другого родителя

brother("Maggy", X).
Вывод:
X = "Matt". % со стороны одного родителя
X = "Matt". % со стороны другого родителя

ancestor("Maggy", Y).
Вывод:
Y = "Tom". % папа
Y = "Daemon". % дедушка по папе
Y = "Julia". % бабушка по папе
Y = "Pam". % мама
Y = "Tony". % дедушка по маме
*/