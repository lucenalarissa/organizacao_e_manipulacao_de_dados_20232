-- Funções de Agregação - comandos SELECT

-- 01 - Qual é a receita total da loja até o momento?
SELECT 
    SUM(amount) AS receita_total
FROM payment;

-- 02 - Quantos clientes estão registrados na loja?
SELECT 
    COUNT(customer_id) AS total_clientes
FROM customer;

-- 03 - Qual é o filme mais longo na loja?
SELECT 
    title, 
    MAX(length) AS duracao_maxima
FROM film
GROUP BY 
    title
ORDER BY 
    duracao_maxima;

-- 04 - Quantos filmes cada categoria possui?
SELECT 
    category.name AS categoria, 
    COUNT(film_category.film_id) AS total_filmes
FROM category
LEFT JOIN film_category ON category.category_id = film_category.category_id
GROUP BY 
    categoria;

-- 05 - Qual é a média de aluguéis por cliente?
SELECT 
    AVG(rentals_per_customer) AS media_alugueis_por_cliente
FROM (
    SELECT 
        customer_id, 
        COUNT(rental_id) AS rentals_per_customer
    FROM rental
    GROUP BY 
        customer_id
    ) AS subquery;

-- 06 - Qual é o número total de atores no banco de dados?
SELECT 
    COUNT(*) AS total_atores
FROM actor;

-- 07 - Qual é a soma total de aluguéis de filmes até o momento?
SELECT 
    SUM(amount) AS total_alugueis
FROM payment;

-- 08 - Qual é a duração média de todos os filmes na loja?
SELECT 
    AVG(length) AS duracao_media
FROM film;

-- 09 - Quantos filmes foram alugados no mês de janeiro de 2006?
SELECT 
    COUNT(*) AS total_alugueis_janeiro_2006
FROM rental
WHERE rental_date BETWEEN '2006-01-01' AND '2006-01-31';

-- 10 - Qual é o valor médio dos aluguéis por categoria de filme?
SELECT 
    category.name AS categoria, 
    AVG(payment.amount) AS valor_medio_aluguel
FROM payment
LEFT JOIN rental ON payment.rental_id = rental.rental_id
LEFT JOIN inventory ON rental.inventory_id = inventory.inventory_id
LEFT JOIN film ON inventory.film_id = film.film_id
LEFT JOIN film_category ON film.film_id = film_category.film_id
LEFT JOIN category ON film_category.category_id = category.category_id
GROUP BY 
    categoria;

-- 11 - Qual é o ator que mais aparece em filmes?
SELECT 
    actor.actor_id, 
    actor.first_name, 
    actor.last_name, 
    COUNT(film_actor.film_id) AS total_filmes_atuados
FROM actor
LEFT JOIN film_actor ON actor.actor_id = film_actor.actor_id
GROUP BY 
    actor.actor_id
ORDER BY 
    total_filmes_atuados DESC
LIMIT 1;

-- 12 - Quantos filmes têm uma classificação indicativa (rating) de 'PG-13'?
SELECT 
    COUNT(*) AS total_filmes_PG13
FROM film
WHERE rating = 'PG-13';

-- 13 - Qual é o dia mais movimentado em termos de aluguéis de filmes?
SELECT 
    DATE(rental_date) AS data_aluguel, 
    COUNT(*) AS total_alugueis
FROM rental
GROUP BY 
    data_aluguel
ORDER BY 
    total_alugueis DESC
LIMIT 1;

-- 14 - Qual é o valor total gasto por cada cliente em aluguéis de filmes?
SELECT 
    customer_id, 
    SUM(amount) AS total_gasto
FROM payment
GROUP BY 
    customer_id;

-- 15 - Quantos atores diferentes atuaram em filmes do gênero "Comédia"?
SELECT 
    COUNT(DISTINCT actor.actor_id) AS total_atores_comedia
FROM actor
JOIN film_actor ON actor.actor_id = film_actor.actor_id
JOIN film_category ON film_actor.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
WHERE category.name = 'Comedy';

-- 16 - Qual é o filme mais recente disponível para aluguel?
SELECT 
    title, 
    release_year
FROM film
WHERE film_id NOT IN (
    SELECT 
        DISTINCT inventory.film_id
    FROM inventory
    JOIN rental ON inventory.inventory_id = rental.inventory_id
    WHERE rental.return_date IS NULL
)
ORDER BY 
    release_year DESC
LIMIT 1;

-- 17 - Quantos clientes alugaram mais de 10 filmes?
SELECT 
    customer_id, 
    COUNT(rental_id) AS total_alugueis
FROM rental
GROUP BY 
    customer_id
HAVING total_alugueis > 10;

-- 18 - Qual é o valor total dos aluguéis de cada mês em 2005?
SELECT 
    DATE_FORMAT(rental_date, '%Y-%m') AS mes, 
    SUM(amount) AS total_alugueis
FROM payment
WHERE DATE_FORMAT(rental_date, '%Y') = '2005'
GROUP BY mes;

-- 19 - Quantos filmes cada ator principal atuou em?
SELECT 
    actor.actor_id, 
    actor.first_name, 
    actor.last_name, 
    COUNT(film_actor.film_id) AS total_filmes_atuados
FROM actor
JOIN film_actor ON actor.actor_id = film_actor.actor_id
WHERE film_actor.ordem = 1
GROUP BY 
    actor.actor_id
ORDER BY 
    total_filmes_atuados DESC;

-- 20 - Qual é o filme mais alugado da categoria 'Horror'?
SELECT 
    film.title, 
    COUNT(rental.rental_id) AS total_alugueis
FROM film
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
WHERE category.name = 'Horror'
GROUP BY 
    film.title
ORDER BY 
    total_alugueis DESC
LIMIT 1;