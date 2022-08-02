/*SELECT name FROM people WHERE id = (SELECT person_id from stars WHERE movie_id = (SELECT id FROM movies WHERE title = "Toy Story"));*/
SELECT name FROM people JOIN stars ON people.id = stars.person_id
JOIN movies ON stars.movie_id = movies.id
WHERE title = "Toy Story";