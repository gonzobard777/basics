# Разделение одной колонки на две колонки (через SQL)

Например, вот такой запрос

```sql
SELECT
    a."Id" as id,
    split_part("FullName", ' ' , 1) as first_name,
    split_part("FullName", ' ' , 2) as last_name
FROM "Authors" as a
```

Разделяет `FullName` на значения:

| id  | first_name | last_name |
|-----|------------|-----------|
| 1   | Стивен     | Кинг      |
| 2   | Ян         | Флеминг   |

И **средствами SQL** эти значения надо будет засунуть в колонки `FirstName` и `LastName`  
