CREATE VIEW myview.Person AS SELECT PID ,name , born FROM SQLUser.PERSON
GO
CREATE VIEW myview.GOVTRACK AS SELECT TOP 100 state, name,birth_day
  FROM JSON_TABLE(%Net.GetJson('https://www.govtrack.us/api/v2/role?current=true&role_type=senator', '{"SSLConfiguration":"Default"}'), 
    '$.content.objects'
    COLUMNS(
        name VARCHAR(50) PATH '$.person.name',
        sort_name VARCHAR(50) PATH '$.person.sortname',
        birth_day Date PATH '$.person.birthday',
        state VARCHAR(2) PATH '$.state')
    ) as jt
    ORDER BY birth_day,sort_name
GO
