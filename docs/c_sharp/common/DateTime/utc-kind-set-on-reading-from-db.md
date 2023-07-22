# Потеря kind UTC при сохранении в БД

При сохранении в БД теряется признак того, что дата в UTC.  
Чтобы этого избежать можно использовать конвертер:

```csharp
protected override void OnModelCreating(ModelBuilder modelBuilder)
{
    var utcKindSetter = new ValueConverter<DateTime, DateTime>(
        toDb => toDb, // бездействовать при сохранении в БД
        fromDb => DateTime.SpecifyKind(fromDb, DateTimeKind.Utc) // добавить kind UTC при чтении из БД
    );

    modelBuilder.Entity<License>(b =>
    {
        b
         .Property(x => x.ExpirationDateTime)
         .HasColumnType("datetime")
         .HasConversion(utcKindSetter);
    });
}
```
