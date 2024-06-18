#

```
SELECT * FROM myview.GOVTRACK

create table US_STATES (CODE VARCHAR(2), NAME_EN VARCHAR(100), NAME_JP VARCHAR(100), PRIMARY KEY (CODE))

LOAD DATA FROM FILE '/home/irisowner/csv/us_states.txt' INTO US_STATES (CODE,NAME_EN,NAME_JP) VALUES (CODE,EN,JP) USING {"from":{"file":{"header":"1","charset":"UTF-8"}}}


SELECT TOP 100 state, name,birth_day,st.NAME_JP
  FROM JSON_TABLE(%Net.GetJson('https://www.govtrack.us/api/v2/role?current=true&role_type=senator', '{"SSLConfiguration":"Default"}'), 
    '$.content.objects'
    COLUMNS(
        name VARCHAR(50) PATH '$.person.name',
        sort_name VARCHAR(50) PATH '$.person.sortname',
        birth_day Date PATH '$.person.birthday',
        state VARCHAR(2) PATH '$.state')
    ) as jt,US_STATES st
    WHERE jt.state=st.CODE
    ORDER BY birth_day,sort_name



https://docs.intersystems.com/iris20241/csp/docbook/Doc.View.cls?KEY=RSQL_jsontable

CREATE TABLE Senators ( person VARCHAR(1000),extra VARCHAR (1000),state VARCHAR(2) )

INSERT INTO Senators ( person, extra, state )
  SELECT person, extra, state
    FROM JSON_TABLE(%Net.GetJson('https://www.govtrack.us/api/v2/role?current=true&role_type=senator','{"SSLConfiguration":"Default"}'),
  '$.content.objects'
      COLUMNS ( person VARCHAR(100) PATH '$.person',
                extra VARCHAR(100) PATH '$.extra',
                state VARCHAR(50) PATH '$.state'
      )
    )



SELECT TOP 10 jtp.name, state, jtp.birth_date, jte.address
  FROM Senators as Sen,
       JSON_TABLE(Sen.person, '$'
         COLUMNS ( name VARCHAR(60) path '$.sortname',
                   birth_date VARCHAR(10) path '$.birthday'
         )
       ) as jtp,
       JSON_TABLE(Sen.extra, '$'
         COLUMNS ( address VARCHAR(100) path '$.address' )
       ) as jte

```