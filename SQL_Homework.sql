-- ZWEIBACK - MySQL HOMEWORK ASSIGNMENT
USE sakila;

-- 1a. Display the first and last names of all actors from the table actor.
SELECT first_name, last_name FROM actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
SELECT UPPER(CONCAT(first_name, " ", last_name)) FROM actor as Actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
SELECT actor_id, first_name, last_name FROM actor
WHERE first_name = "Joe";

-- 2b. Find all actors whose last name contain the letters GEN:
SELECT * FROM actor
WHERE last_name LIKE "%GEN%";

-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
SELECT last_name, first_name FROM actor
WHERE last_name LIKE "%LI%"
ORDER BY last_name, first_name;

-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT country_id, country FROM country WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, 
-- so create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).
ALTER TABLE `sakila`.`actor` 
ADD COLUMN `description` BLOB NULL AFTER `last_update`;

-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.
ALTER TABLE `sakila`.`actor` 
DROP COLUMN `description`;

-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT COUNT(DISTINCT last_name) FROM actor;
 
-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT last_name, COUNT(last_name)
FROM actor
GROUP BY last_name
HAVING COUNT(*) > 1
ORDER BY last_name;

-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
UPDATE `sakila`.`actor` SET `first_name` = 'HARPO' WHERE (`actor_id` = '172');

-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
UPDATE `sakila`.`actor` SET `first_name` = 'GROUCHO' WHERE (`actor_id` = '172');

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
-- Hint: https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html
CREATE TABLE address (
'address_id' SMALLINT(5),
'address' VARCHAR(50),
'address2' VARCHAR(50),
'district' VARCHAR(20),
'city_id' SMALLINT(5),
'postal_code' VARCHAR(10),
'phone' VARCHAR(20),
'location' GEOMETRY,
'last_update' TIMESTAMP);

-- JOINS --
-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
SELECT first_name, last_name, address
FROM staff, address
WHERE staff.address_id = address.address_id;

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
SELECT first_name, last_name, SUM(amount)
FROM staff, payment
WHERE staff.staff_id = payment.staff_id
GROUP BY staff.staff_id;

-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
SELECT title, COUNT(actor_id)
FROM film, film_actor
WHERE film.film_id = film_actor.film_id
GROUP BY title;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT film.film_id, title, COUNT(inventory.film_id) as count
FROM film, inventory
WHERE film.film_id = inventory.film_id AND film.title = "Hunchback Impossible";

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
SELECT last_name, sum(amount)
FROM customer
JOIN payment
ON customer.customer_id = payment.customer_id
GROUP BY last_name;

-- SUBQUERIES
-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence,films starting with the letters K and Q have also soared in popularity.
-- Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
SELECT title FROM film 
WHERE language_id 
IN (SELECT language_id FROM language WHERE name = "English")
AND title LIKE "K%" OR title LIKE "Q%";

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT first_name, last_name FROM actor
WHERE actor_id
IN (SELECT actor_id FROM film_actor WHERE film_id IN (SELECT film_id FROM film WHERE title = "Alone Trip"));
 
-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT first_name, last_name, email, country
FROM customer 
INNER JOIN address ON customer.address_id = address.address_id
INNER JOIN city ON address.city_id = city.city_id
INNER JOIN country ON city.country_id = country.country_id 
WHERE country.country = 'Canada';

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
SELECT film.*, category.name FROM film
INNER JOIN film_category ON film.film_id = film_category.film_id
INNER JOIN category ON category.category_id = film_category.category_id
WHERE name = 'Family';

-- 7e. Display the most frequently rented movies in descending order.
SELECT rental.rental_id, title, COUNT(payment_id) as frequent_rentals
FROM rental
JOIN payment ON rental.rental_ID = payment.rental_ID
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id 
GROUP BY title
ORDER BY frequent_rentals DESC;

-- 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT store_id, SUM(amount) as revenue
FROM rental
JOIN payment ON rental.rental_ID = payment.rental_ID
JOIN inventory ON rental.inventory_id = inventory.inventory_id
GROUP BY store_id
ORDER BY revenue;

-- 7g. Write a query to display for each store its store ID, city, and country.
SELECT store_id, city, country
FROM store
JOIN address ON store.address_id = address.address_id
JOIN city ON address.city_id = city.city_id
JOIN country ON city.country_id = country.country_id;
 
-- 7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
SELECT name, SUM(amount) as revenue
FROM payment
JOIN rental ON rental.rental_ID = payment.rental_ID
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film_category ON inventory.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
GROUP BY name
ORDER BY revenue DESC LIMIT 5;

-- SELECT name, SUM(amount) as revenue
-- FROM payment
-- WHERE rental_id IN (SELECT rental.rental_ID FROM rental)
-- (SELECT inventory_id IN (SELECT inventory.film_id in film_category
-- WHERE category_id IN (SELECT category.category_id)
-- GROUP BY name
-- ORDER BY revenue DESC LIMIT 5;

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue.
-- Use the solution from the problem above to create a view.
-- If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW vtop_five_genres AS
SELECT name, SUM(amount) as revenue
FROM payment
JOIN rental ON rental.rental_ID = payment.rental_ID
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film_category ON inventory.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
GROUP BY name
ORDER BY revenue DESC LIMIT 5;

-- 8b. How would you display the view that you created in 8a?
SELECT * FROM sakila.vtop_five_genres;

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW IF EXISTS sakila.vtop_five_genres;

-- Instructions - Part 2
-- Using your gwsis database, develop a stored procedure that will drop an individual student's enrollment from a class. Be sure to refer to the existing stored procedures,
-- enroll_student and terminate_all_class_enrollment in the gwsis database for reference.
-- The procedure should be called terminate_student_enrollment and should accept the course code, section, student ID, and effective date of the withdrawal as parameters.
USE gwsis;

