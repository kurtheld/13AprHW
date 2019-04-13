USE sakila;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

-- 1a. Display the first and last names of all actors from the table actor.
SELECT 
    first_name 'First Name', last_name 'Last Name'
FROM
    actor;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
SELECT 
    UPPER(CONCAT(first_name, ' ', last_name)) AS 'Actor Name'
FROM
    actor;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
SELECT actor_id, first_name, last_name FROM actor WHERE first_name="JOE";
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

-- 2b. Find all actors whose last name contain the letters GEN:
SELECT 
    last_name
FROM
    actor
WHERE
    last_name LIKE '%GEN%';
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
SELECT 
    last_name
FROM
    actor
WHERE
    last_name LIKE '%LI%'
ORDER BY last_name;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT 
    country_id, country
FROM
    country
WHERE
    country IN ('Afghanistan' , 'Bangladesh', 'China');
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

-- 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).
ALTER TABLE actor
ADD description BLOB;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.
ALTER TABLE actor
DROP COLUMN description;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT 
    last_name, COUNT(last_name)
FROM
    actor
GROUP BY last_name;
--ORDER BY COUNT(last_name) DESC;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors.
SELECT 
    last_name, COUNT(last_name)
FROM
    actor
GROUP BY last_name
HAVING COUNT(last_name) >= 2;
--ORDER BY COUNT(last_name) DESC;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
UPDATE 
    actor
SET 
	first_name = "HARPO"
WHERE
    first_name LIKE 'Groucho' and last_name Like "Williams";
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 4C (CONT.) confirming change in table. 
SELECT first_name, last_name 
FROM
	actor
WHERE
    first_name LIKE 'HARPO' and last_name Like "Williams";
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
UPDATE 
    actor
SET 
	first_name = "GROUCHO"
WHERE
    first_name LIKE 'HARPO' and last_name Like "Williams";
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

-- 4C (CONT.) confirming change in table. 
SELECT 
    first_name, last_name
FROM
    actor
WHERE
    first_name LIKE 'GROUCHO'
        AND last_name LIKE 'Williams';

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
-- I would use a "CREATE TABLE" query to recreate teh address table. 
	-- CREATE TABLE (
		-- address_id SMALLINT (11)
        -- address VARCHAR(50	)
        -- address2 VARCHAR(50)
        -- district VARCHAR(20)
        -- cit_id SMALLINT (5)
        -- postal_code VARCHAR (10)
        -- phone VARCHAR (20)
        -- location VARCHAR GEOMETRY
        -- last_update TIMEST AMP
        );
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
SELECT 
    staff.first_name,
    staff.last_name,
    address.address,
    address.address2
FROM
    staff
        INNER JOIN
    address ON staff.address_id = address.address_id;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- --
SELECT 
    staff.first_name,
    staff.last_name,
    payment.staff_id,
    SUM(payment.amount)
FROM
    payment
        INNER JOIN
    staff ON payment.staff_id = staff.staff_id
GROUP BY payment.staff_id;
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
SELECT 
    staff.first_name,
    staff.last_name,
    payment.staff_id,
    SUM(payment.amount)
FROM
    payment
        INNER JOIN
    staff ON payment.staff_id = staff.staff_id
WHERE
    payment_date BETWEEN '2005-08-01 00:00:0' AND '2005-08-31 11:59:59'
GROUP BY payment.staff_id;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
SELECT
	film.title, COUNT(film_actor.actor_id)
FROM
	film
		INNER JOIN
	film_actor ON film.film_id = film_actor.film_id
GROUP BY film_actor.film_id;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT 	
	film.title, COUNT(inventory.film_id) 
FROM 
	film 
		INNER JOIN 
	inventory ON film.film_id = inventory.film_id
WHERE film.title = "Hunchback Impossible" 
GROUP BY inventory.film_id;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
SELECT
	first_name, last_name, SUM(payment.amount)
FROM 
	payment 
		INNER JOIN 
	customer ON payment.customer_id = customer.customer_id
GROUP BY customer.customer_id
ORDER BY customer.last_name;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
SELECT * FROM 
	film 
		INNER JOIN
	language ON film.language_id = language.language_id
WHERE title LIKE "Q%" 
	OR title like "K%" 
	AND language.name = "english";
    
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT 
	actor.first_name, actor.last_name
FROM
	actor
        INNER JOIN 
	film_actor ON film_actor.actor_id = actor.actor_id 
        INNER JOIN 
	film_actor ON film.film_id = film_actor.film_id 
WHERE title = "ALONE TRIP";
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT
	customer.first_name, customer.last_name, address.address, city.city_id, country.country 
FROM
	customer
		INNER JOIN
	address ON customer.address_id = address.address_id
    	INNER JOIN
	city on address.city_id = city.city_id
		INNER JOIN
	country ON country.country_id = city.country_id 
    WHERE country.country_id = 
		(
			SELECT country_id 
            FROM country 
				WHERE country = "Canada");
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

    
-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
SELECT 
	film.title, film_category.category_id, category.name
 FROM
	film
		INNER JOIN
	film_category on film.film_id = film_category.film_id
		INNER JOIN
   category ON film_category.category_id = category.category_id 
   WHERE film_category.category_id = 
   (
	SELECT category_id 
    FROM category 
		WHERE name = "Family");
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

-- 7e. Display the most frequently rented movies in descending order.
SELECT
	film.title, COUNT(film.film_id)
FROM 
	film
		INNER JOIN
	inventory ON inventory.film_id = film.film_id
		INNER JOIN
 rental ON inventory.inventory_id = rental.inventory_id 
 GROUP BY film.film_id
 ORDER BY COUNT(film.film_id) DESC;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

-- 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT
	store.store_id, SUM(payment.amount)
FROM
	payment
		INNER JOIN
	customer ON payment.customer_id = customer.customer_id
		INNER JOIN
	store ON customer.store_id = store.store_id 
GROUP BY store.store_id;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

-- 7g. Write a query to display for each store its store ID, city, and country.
SELECT
	store.store_id, city.city, country.country
FROM
	store
		INNER JOIN
	address ON store.address_id = address.address_id
		INNER JOIN
	city ON address.city_id = city.city_id
		INNER JOIN
	country ON city.country_id = country.country_id;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

-- 7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
SELECT
	category.name, SUM(payment.amount)
FROM 
	payment
		INNER JOIN
	rental on payment.rental_id = rental.rental_id		
		INNER JOIN
	inventory on rental.inventory_id = inventory.inventory_id
		INNER JOIN
    film_category on inventory.film_id = film_category.film_id
		INNER JOIN
	category on film_category.category_id = category.category_id 
GROUP BY category.name 
ORDER BY SUM(payment.amount) DESC LIMIT 5;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW top_five_genres AS
SELECT
	category.name, SUM(payment.amount)
FROM
	payment
		INNER JOIN
	rental on payment.rental_id = rental.rental_id
		INNER JOIN
	inventory on rental.inventory_id = inventory.inventory_id
		INNER JOIN
	 film_category on inventory.film_id = film_category.film_id
		INNER JOIN
	category on film_category.category_id = category.category_id
GROUP BY category.name 
ORDER BY SUM(payment.amount) DESC LIMIT 5;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 


-- 8b. How would you display the view that you created in 8a?
SELECT * FROM 
	top_five_genres;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW 
	top_five_genres;

