USE amediateka;

--Фильмы
CREATE VIEW movies_actors_directors
AS SELECT 
	movies.name AS movie,
	movies.relase_date AS relase_date,
	actors.first_name AS actor_name,
	actors.last_name AS actor_lastname,
	directors.first_name AS director_name,
	directors.last_name AS director_lastname
FROM movies INNER JOIN actors ON actors.movies_id = movies.id 
INNER JOIN directors ON directors.movies_id = movies.id;

--Сериалы
CREATE VIEW serials_actors_directors
AS SELECT 
	serials.name AS movie,
	serials.relase_date AS relase_date,
	actors.first_name AS actor_name,
	actors.last_name AS actor_lastname,
	directors.first_name AS director_name,
	directors.last_name AS director_lastname
FROM serials INNER JOIN actors ON actors.movies_id = serials.id 
INNER JOIN directors ON directors.serials_id = serials.id;

