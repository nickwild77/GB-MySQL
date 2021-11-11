USE amediateka;

--Сортировка фильмов по жанру
SELECT
	id, name, genre_id
FROM
	movies
ORDER BY
	genre_id
;

--Сортировка сериалов по жанру
SELECT
	id, name, genre_id
FROM
	serials
ORDER BY
	genre_id
;

--Выборка актеров по фильму.
SELECT
	a.first_name AS name, 
	a.last_name AS lastname,
	m.name AS movie
FROM 
	actors AS a
JOIN
	movies AS m
ON
	a.movies_id = m.id
WHERE a.movies_id ='15'
;

--Выборка режиссеров по фильму.
SELECT
	d.first_name AS name, 
	d.last_name AS lastname,
	m.name AS movie
FROM 
	directors AS d
JOIN
	movies AS m
ON
	d.movies_id = m.id
WHERE d.movies_id ='23'
;

--Показать 20 профилей с подпиской №2
SELECT
	p.nick_name AS profile,
	u.first_name AS name,
	u.last_name AS lastname,
	s.subscribe_name AS subscribe
FROM 
	profiles AS p
JOIN 
	users as u
ON 
	u.id = p.user_id
JOIN
	subscribes AS s
ON
	s.id ='2'
LIMIT 20
;

--Выборка по стране прозводства фильма
SELECT
	m.name AS movie,
	c.country_name AS country
FROM 
	movies AS m
JOIN 
	country as c
ON 
	m.country_id = c.id
WHERE 
	c.country_name LIKE 'Ru%'
LIMIT 20
;


