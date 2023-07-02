# Отношения в бд - "Entity-Relationships"

Важной характеристикой связи является **степень связи**. Возможны следующие степени связи: один к одному, один ко
многим, многие ко многим.  
Кроме того, надо выявить **класс принадлежности сущности**, который характеризует обязательность включения каждого
экзмепляра сущности в связь.

## Entity Framework Core

Общие правила:
1. Стараемся писать код, чтобы работало [обнаружение связей в соответствии с соглашением](https://learn.microsoft.com/ru-ru/ef/core/modeling/relationships/conventions).
2. Не используем теневые свойства - это значит, что все поля, которые учавствуют в создании связи, должны быть явно определены в классах сущностей.
3. Используем Fluent API для названия:
    * форейн кей
    * типа экшенов при удалении (On Delete в постгре например)
    * таблиц связей (многие ко многим)    
    * индексов (проверить! кооректно это возможно только при миграции)

---

1. [Один к одному](https://learn.microsoft.com/ru-ru/ef/core/modeling/relationships/one-to-one)

- [тестовое репо](https://github.com/gonzobard777/c__sharp_OneToOne)

---

2. [Один ко многим](https://learn.microsoft.com/ru-ru/ef/core/modeling/relationships/one-to-many)

- [тестовое репо](https://github.com/gonzobard777/c_sharp_OneToMany)

---

3. Один ко многим на себя

- [тестовое репо](https://github.com/gonzobard777/c_sharp_OneToManyOnYourself)

---

4. [Многие ко многим](https://learn.microsoft.com/ru-ru/ef/core/modeling/relationships/many-to-many)

- [тестовое репо](https://github.com/gonzobard777/c_sharp_ManyToMany)

---
