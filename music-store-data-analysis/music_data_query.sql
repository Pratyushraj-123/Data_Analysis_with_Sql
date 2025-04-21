-- Whos is the senior most employee based on the job title?

Select * from employee
order by levels desc
limit 1

--Which country has the most invoices?
SELECT COUNT(*) as c, billing_country
FROM invoice
group by billing_country
order by c desc

--What are top 3 values of total invoice?
SELECT total from invoice
ORDER by total desc
limit 3

--Write a query that returns one city that has the highest sum of invoice totals.Returns both the city name and sum of all invoice totals.
SELECT sum(total) as invoice_total, billing_city
FROM invoice
group by billing_city 
order by invoice_total desc

--Who is the best customer? Write a quesry that returns the person who has spent the most money.
SELECT customer.customer_id, customer.first_name, customer.last_name, sum(invoice.total) as total
from customer
join invoice on customer.customer_id = invoice.customer_id
group by customer.customer_id
order by total desc
limit 1

--Write query to return the email, first name, last name, & Genre of all Rock Music listeners. Return your list ordered alphabetically by email starting with A.
select DISTINCT  email, first_name, last_name from customer
join invoice on customer.customer_id = invoice.customer_id 
join invoice_line on invoice.invoice_id = invoice_line.invoice_id
WHERE track_id IN (
	SELECT track_id FROM track
	join genre on track.genre_id = genre.genre_id
	WHERE genre .name LIKE 'Rock'
)

order by email;

-- artists who have written the most rock music in our dataset. Write a query that returns the Artist name and total track count of the top 10 rock bands
SELECT artist.artist_id, artist.name , COUNT(artist.artist_id) AS number_of_songs
FROM track
JOIN album on album.album_id = track.album_id
JOIN artist on artist.artist_id = album.artist_id
JOIN genre on genre.genre_id = track.genre_id
WHERE genre.name LIKE 'Rock'
GROUP BY artist.artist_id
ORDER BY number_of_songs desc
LIMIT 10

--Return all the track names that have a song length longer than the average song length. Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first.
select name, milliseconds 
from track
WHERE milliseconds > (
	SELECT AVG(milliseconds) as average_track_length
	from track
)

order by milliseconds desc;

--Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent.
WITH best_selling_artist AS (
	SELECT artist.artist_id AS artist_id , artist.name AS artist_name,
	SUM (invoice_line.unit_price*invoice_line.quantity) AS total_sales
	FROM invoice_line
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN album ON album.album_id = track.album_id
	JOIN artist ON artist.artist_id = album.artist_id
	GROUP BY 1
	ORDER BY 3 desc
	LIMIT 1
)

SELECT c.customer_id, c.first_name, c.last_name, bsa.artist_name,
SUM(il.unit_price*il.quantity) AS amount_spent
FROM invoice i
JOIN customer c ON c.customer_id = i.customer_id
JOIN invoice_line il ON il.invoice_id = i.invoice_id
JOIN track t ON t.track_id = il.track_id
JOIN album alb ON alb.album_id = t.album_id
JOIN Best_selling_artist bsa ON bsa.artist_id = alb.artist_id
GROUP BY 1,2,3,4
ORDER BY 5 DESC;










