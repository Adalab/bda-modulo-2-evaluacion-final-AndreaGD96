USE sakila;

/* 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados. */

SELECT DISTINCT title AS nombres_películas
	FROM film;
    
    
/* 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13". */  

SELECT title AS nombres_películas
	FROM film
    WHERE rating = 'PG-13';
    
    
/* 3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción. */  
    
SELECT title AS título, description AS descripción
	FROM film
    WHERE description LIKE '%amazing%';
    
    
/* 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos. */  

SELECT title AS título, length AS duración
	FROM film
    WHERE length > 120;
    
    
/* 5.  Recupera los nombres de todos los actores. */  

SELECT first_name AS nombre, last_name AS apellido
	FROM actor
    
    
/* 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido. */  

SELECT first_name AS nombre, last_name AS apellido
	FROM actor
    WHERE last_name = 'Gibson';


/* 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20. */  

SELECT first_name AS nombre, last_name AS apellido, actor_id
	FROM actor 
    WHERE actor_id BETWEEN 10 AND 20;


/* 8. Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación. */  
    
SELECT title AS título, rating AS clasificación
	FROM film
	WHERE rating NOT IN ('R', 'PG-13');
    
    
/* 9. Encuentra la cantidad total de películas en cada clasificación de la tabla film 
y muestra la clasificación junto con el recuento. */ 

SELECT COUNT(title) AS cantidad_total, rating AS clasificación
	FROM film
    GROUP BY rating;
    
    
/* 10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, 
su nombre y apellido junto con la cantidad de películas alquiladas. */

SELECT r.customer_id, c.first_name AS nombre_cliente, c.last_name AS apellido_cliente, COUNT(r.rental_id) AS cantidad_total
	FROM customer AS c
    INNER JOIN rental AS r
		ON r.customer_ID = c.customer_ID
        GROUP BY r.customer_id;
     
     
/* 11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría
 junto con el recuento de alquileres. */ 
 
	-- Llegar desde rental a category para coger 'name'; reviso conexiones en SCHEMA; 
	-- unir rental - inventory - film - film_category - category / 4 JOINS

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

SELECT rating AS clasificación, AVG(length) AS promedio_duración
	FROM film
    GROUP BY clasificación; -- calculo del AVG por rating
    
    
/* 13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love". */  

	-- Unir actor - film_actor - film
    
SELECT first_name AS nombre, last_name AS apellido
	FROM actor
    INNER JOIN film_actor
		ON actor.actor_id = film_actor.actor_id
	INNER JOIN film
		ON film.film_id = film_actor.film_id
        WHERE film.title = 'Indian Love';
		
        
/* 14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción. */  

SELECT title AS título -- , description 
	FROM film
    WHERE description REGEXP 'dog' OR description REGEXP 'cat';
    
    
/* 15. Hay algún actor o actriz que no aparezca en ninguna película en la tabla film_actor. */  

	-- quiero que me aparezcan todos los actores asi que uso LEFT J 

SELECT a.first_name, a.last_name, f_a.actor_id
	FROM actor AS a
    LEFT JOIN film_actor AS f_a
		ON a.actor_id = f_a.actor_id
		WHERE f_a.actor_id IS NULL;


/* 16. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010. */  

SELECT title AS título
	FROM film
    WHERE release_year BETWEEN 2005 AND 2010;


/* 17. Encuentra el título de todas las películas que son de la misma categoría que "Family". */  

	-- unir film - film_category - category

SELECT f.title AS título
	FROM film AS f
    INNER JOIN film_category AS f_c
		ON f.film_id = f_c.film_id
    INNER JOIN category AS cat
		ON cat.category_id = f_c.category_id
        WHERE cat.name = 'Family';

	-- tb puedo hacerlo uniendo 2 tablas conociendo previamente el numero de la categoria 
	-- primero veo que categoria tiene family

SELECT *
	FROM category
	WHERE name = 'Family'; -- es category_id 8
    
SELECT f.title AS título 
	FROM film AS f
    INNER JOIN film_category AS f_c
		ON f.film_id = f_c.film_id
		WHERE category_id = 8;
    
    
/* 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas. */  

	-- unir actor y film_actor
 
SELECT a.first_name AS nombre, a.last_name AS apellido, COUNT(f_a.film_id) AS num_películas
	FROM actor AS a
    INNER JOIN film_actor AS f_a
		ON a.actor_id = f_a.actor_id
        GROUP BY nombre, apellido
        HAVING num_películas > 10;


/* 19. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film. */

	-- R se refiere al rating
	-- 2 h en minutos: 120
 
SELECT title AS título -- , rating, length
	FROM film
    WHERE rating = 'R' AND length > 120;


/* 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos 
y muestra el nombre de la categoría junto con el promedio de duración. */

	-- unir film - category - film_category para el name
 
SELECT c.name AS categoría, AVG(f.length) AS duración_promedio
	FROM film AS f
    INNER JOIN film_category AS f_c
		ON f.film_id = f_c.film_id
	INNER JOIN category AS c
		ON f_c.category_id = c.category_id
		GROUP BY categoría
        HAVING AVG(f.length) > 120;
    
    
/* 21. Encuentra los actores que han actuado en al menos 5 películas 
y muestra el nombre del actor junto con la cantidad de películas en las que han actuado. */

SELECT a.first_name AS nombre, a.last_name AS apellido, COUNT(f_a.film_id) AS num_películas
	FROM actor AS a
    INNER JOIN film_actor AS f_a
		ON a.actor_id = f_a.actor_id
        GROUP BY nombre, apellido
        HAVING num_películas >= 5;
        
        
/* 22. Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. 
Utiliza una subconsulta para encontrar los rental_ids con una duración superior a 5 días 
y luego selecciona las películas correspondientes */

	-- necesito las tablas film - inventory - rental
	-- primero subconsulta rental_id (duración diferencia entre rental_date y return_date - uso la función DATEDIFF):
        
SELECT rental_id
	FROM rental
    WHERE DATEDIFF(return_date, rental_date) > 5;

SELECT title AS título
	FROM film
    INNER JOIN inventory AS i
		ON film.film_id = i.film_id
	WHERE i.inventory_id IN (SELECT inventory_id                                  -- inventory_id es la columna que tiene relacion entre rental e inventory
								FROM rental
								WHERE DATEDIFF(return_date, rental_date) > 5);

	-- RESULTADO SIN REPETICIONES:

SELECT DISTINCT title AS título
	FROM film
    INNER JOIN inventory AS i
		ON film.film_id = i.film_id
	WHERE i.inventory_id IN (SELECT inventory_id                                  
								FROM rental
								WHERE DATEDIFF(return_date, rental_date) > 5);
    
        
/* 23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría
 "Horror". Utiliza una subconsulta para encontrar los actores que han actuado en películas de la
 categoría "Horror" y luego exclúyelos de la lista de actores. */
   
SELECT *
	FROM category
    WHERE name = 'Horror' -- categoria 11
    
-- defino subcategoria--

SELECT *
	FROM actor AS a
    INNER JOIN film_actor AS f_a
		ON a.actor_id = f_a.actor_id
     INNER JOIN film_category  AS f_c
		ON f_a.film_id = f_c.film_id
        WHERE f_c.category_id = 11;
        
-- RESULTADO:

SELECT a.first_name AS nombre, a.last_name AS apellido
	FROM actor AS a
    WHERE a.actor_id NOT IN (SELECT f_a.actor_id
								FROM film_actor AS f_a
								INNER JOIN film_category  AS f_c
									ON f_a.film_id = f_c.film_id
									WHERE f_c.category_id = 11);
    
    
	-- forma alternativa sin calcular el category_id; utilizando otro JOIN con la tabla category para filtrar por 'Horror' directamente: 

SELECT a.first_name AS nombre, a.last_name AS apellido
	FROM actor AS a
    WHERE a.actor_id NOT IN (SELECT f_a.actor_id
								FROM film_actor AS f_a
								INNER JOIN film_category  AS f_c
									ON f_a.film_id = f_c.film_id
								INNER JOIN category AS c
									ON f_c.category_id = c.category_id
                                    WHERE name = 'Horror');


/* 24. Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla film. */ 

		-- unir film - film_category - category
        
SELECT f.title AS título, f.length AS duración
	FROM film AS f
	INNER JOIN film_category AS f_c
		ON f.film_id = f_c.film_id
	INNER JOIN category AS cat
		ON cat.category_id = f_c.category_id
	WHERE f.length > 180 AND cat.name = 'Comedy';
    
    -- tb se puede hacer como el anterior; uniendo 2 tablas conociendo previamente el numero de la categoria 
	-- primero veo que categoria tiene comedia
    
SELECT *
	FROM category
	WHERE name = 'Comedy'; -- es category_id 5
    
SELECT title AS título, f.length AS duración
	FROM film AS f
    INNER JOIN film_category AS f_c
		ON f.film_id = f_c.film_id
    WHERE f.length > 180 AND f_c.category_id = 5;


---------------------------------------------------------------------------------------------
-- Tests

SELECT * 
	FROM film
    
SELECT *
	FROM actor
    
SELECT *
	FROM rental
    
SELECT *
	FROM film_actor
    
SELECT *
	FROM film_category
    
SELECT *
	FROM inventory