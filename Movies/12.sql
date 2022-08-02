SELECT title
FROM movies JOIN stars ON movies.id = stars.movie_id
JOIN people ON stars.person_id = people.id
WHERE name = "Johnny Depp"
AND movie_id IN (
    SELECT movie_id
    FROM movies JOIN stars ON movies.id = stars.movie_id
    JOIN people ON stars.person_id = people.id
    WHERE name = "Helena Bonham Carter");