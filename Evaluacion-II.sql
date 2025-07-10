USE sakila;

-- 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados.

SELECT DISTINCT title AS nombres_películas
	FROM film;
    
    
-- 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".   

SELECT title AS nombres_películas
	FROM film
    WHERE rating = 'PG-13';
    
    
-- 3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.
    
SELECT title AS título, description AS descripción
	FROM film
    WHERE description LIKE '%amazing%';
    
    
-- 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.

SELECT title AS título, length AS duración
	FROM film
    WHERE length > 120;
    
    
-- 5.  Recupera los nombres de todos los actores.

SELECT first_name AS nombre, last_name AS apellidos
	FROM actor
    
    
-- 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.

SELECT first_name AS nombre, last_name AS apellidos
	FROM actor
    WHERE last_name = 'Gibson';


-- 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.

SELECT first_name AS nombre, last_name AS apellidos, actor_id
	FROM actor 
    WHERE actor_id BETWEEN 10 AND 20;


-- 8. Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación.
    
SELECT title AS título, rating AS clasificación
	FROM film
	WHERE rating NOT IN ('R', 'PG-13');
    
    
/* 9. Encuentra la cantidad total de películas en cada clasificación de la tabla film 
y muestra la clasificación junto con el recuento.*/ 

SELECT COUNT(title) AS cantidad_total, rating AS clasificación
	FROM film
    GROUP BY rating;
    
    
/* 10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, 
su nombre y apellido junto con la cantidad de películas alquiladas.*/

SELECT rental.customer_id, customer.first_name AS nombre_cliente, customer.last_name AS apellido_cliente, COUNT(rental.rental_id) AS cantidad_total
	FROM customer
    INNER JOIN rental
		ON rental.customer_ID = customer.customer_ID
        GROUP BY rental.customer_id;
     
     
/* 11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría
 junto con el recuento de alquileres.*/ 
 -- (Llegar desde rental a category para coger 'name'; reviso conexiones en SCHEMA; unir rental-inventory-film-film_category-category / 4 JOINS

SELECT COUNT(r.rental_id) AS alquileres, cat.name AS nombre_categoria
	FROM rental AS r
    INNER JOIN inventory AS i
		ON r.inventory_id = i.inventory_id
    INNER JOIN film AS f
		ON f.film_id = i.film_id
	INNER JOIN film_category AS f_c
		ON f.film_id = f_c.film_id
	INNER JOIN category AS cat
		ON f_c.category_id = cat.category_id
	GROUP BY nombre_categoria;
	
/* 12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla
film y muestra la clasificación junto con el promedio de duración. */

SELECT rating AS Clasificación, AVG(length) AS PromedioDuración
	FROM film
    GROUP BY Clasificación; -- calculo del AVG por rating
    
    
-- 13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".
    -- Unir actor, film_actor y film
    
SELECT first_name AS nombre, last_name AS apellido
	FROM actor
    INNER JOIN film_actor
		ON actor.actor_id = film_actor.actor_id
	INNER JOIN film
		ON film.film_id = film_actor.film_id
        WHERE film.title = 'Indian Love';
		
-- 14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.


    -- ------------------------------------------------------------------------------------------
-- Testings

SELECT * 
	FROM film
    
SELECT *
	FROM actor
    
SELECT *
	FROM rental
    
SELECT *
	FROM film_category