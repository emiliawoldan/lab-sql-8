/*
Instructions
1. Rank films by length (filter out the rows that have nulls or 0s in length column). 
In your output, only select the columns title, length, and the rank.
2. Rank films by length within the rating category (filter out the rows that have nulls or 0s in length column). 
In your output, only select the columns title, length, rating and the rank.
3. How many films are there for each of the categories in the category table. Use appropriate join to write this query
4. Which actor has appeared in the most films?
5. Most active customer (the customer that has rented the most number of films)
Bonus: Which is the most rented film? The answer is Bucket Brotherhood This query might require using more than one join statement. 
Give it a try. We will talk about queries with multiple join statements later in the lessons.
*/

-- 1
SELECT title, length, RANK () OVER(ORDER BY length DESC) AS 'rank' FROM sakila.film
WHERE length IS NOT NULL AND length <> ' ';

-- 2
SELECT title, rating, length, RANK() OVER(PARTITION BY rating ORDER BY length DESC) AS 'rank' 
FROM sakila.film
WHERE length IS NOT NULL AND length <> ' ';

-- 3 How many films are there for each of the categories in the category table.
SELECT name, count(film_id) AS '#films' 
FROM sakila.category
JOIN sakila.film_category ON category.category_id = film_category.category_id
GROUP BY category.category_id;

-- 4 Which actor has appeared in the most films?
SELECT concat(first_name,' ', last_name) AS actor, count(film_id) AS '#films' 
FROM sakila.actor
JOIN sakila.film_actor ON actor.actor_id = film_actor.actor_id
GROUP BY actor
ORDER BY count(film_id) DESC;

-- 5 Most active customer (the customer that has rented the most number of films)
SELECT customer_id, count(rental_id) FROM sakila.rental
GROUP BY customer_id
ORDER BY count(rental_id) DESC;

-- Bonus: Which is the most rented film? The answer is Bucket Brotherhood
SELECT film.title AS film, count(rental_id) AS 'Most rented film' 
FROM sakila.film
JOIN sakila.inventory ON film.film_id = inventory.film_id
JOIN sakila.rental ON inventory.inventory_id = rental.inventory_id
GROUP BY film
ORDER BY count(rental_id) DESC
LIMIT 1;
