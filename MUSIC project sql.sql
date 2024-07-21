
use music_sql_project;

--SQL PROJECT- MUSIC STORE DATA ANALYSIS
--Question Set 1 - Easy

--	1. Who is the senior most employee based on job title?

select top 1 *  from employee
order by levels desc;


--	2. Which countries have the most Invoices?
select top 1 * from invoice
select top 1 * from invoice_line ;

select top 5 billing_country , sum(quantity)from invoice as A
join invoice_line as B
On A.invoice_id=B.invoice_id
group by billing_country
order by sum(quantity) desc;

--or

select top 5 billing_country , count(*) as count_of_invoices from invoice a
group by billing_country
order by count_of_invoices  desc;


--	3. What are top 3 values of total invoice?

select top 3  total  from invoice
group by total
order by total desc;


--	4. Which city has the best customers? We would like to throw a promotional Music
-- festival in the city we made the most money. Write a query that returns one city that
--	has the highest sum of invoice totals. Return both the city name & sum of all invoice
--	totals

select top 1 billing_city, sum(total) as invoice_totals from invoice
group by billing_city
order by sum(total) desc;

--	5. Who is the best customer? The customer who has spent the most money will be
--	declared the best customer. Write a query that returns the person who has spent the
--	most money

select top 1 A.customer_id,first_name,last_name,sum(total) as Total_money_spent from customer as A
join invoice as B
on B.customer_id =A.customer_id
Group by A.customer_id,first_name,last_name
order by sum(total) desc;




	--Question Set 2 – Moderate

--1. Write query to return the email, first name, last name, & Genre of all Rock Music--listeners. 
--Return your list ordered alphabetically by email starting with A

select distinct E.email,E.first_name, E.last_name,A.name from genre as A
join track as B
on A.genre_id=B.genre_id
join invoice_line as C
on B.track_id=C.track_id
join invoice D
on C.invoice_id=D.invoice_id
join customer as E
on D.customer_id=E.customer_id
where A.name = 'Rock'
order by email 

--	2. Let's invite the artists who have written the most rock music in our dataset. Write a
--	query that returns the Artist name and total track count of the top 10 rock bands

select top 10 D.name as artist_name,A.name as band_name,count(*) as total_track_count from genre as A 
Join track as B 
On A.genre_id=B.genre_id
join album as C
on B.album_id=C.album_id
join artist as D
on D.artist_id=C.artist_id
where A.name='Rock'
group by D.name,A.name
order by total_track_count desc;


--	3. Return all the track names that have a song length longer than the average song length.
--	Return the Name and Milliseconds for each track. Order by the song length with the
--	longest songs listed first

select name, milliseconds from track
where  milliseconds >(select avg(milliseconds) as avg_length  from track)
order by milliseconds desc;

--	Question Set 3 – Advance

--	1. Find how much amount spent by each customer on artists? Write a query to return
--	customer name, artist name and total spent

select  (first_name+last_name) as customer_name, f.name as artist_name ,
sum(c.unit_price*c.quantity) as total_spent from customer as A
join invoice as B
on A.customer_id=B.customer_id
join invoice_line as C
on B.invoice_id=C.invoice_id
join track as D
on C.track_id=D.track_id
join album as E
on D.album_id=E.album_id
join artist as F
on E.artist_id=F.artist_id
group by (first_name+last_name) , f.name 
order by total_spent desc;



--	2. We want to find out the most popular music Genre for each country. We determine the
--	most popular genre as the genre with the highest amount of purchases. Write a query
--	that returns each country along with the top Genre. For countries where the maximum
--	number of purchases is shared return all Genres

select * from (select    A.country,E.name,count (quantity) as amt_purchase
, ROW_NUMBER() OVER(PARTITION BY a.country ORDER BY COUNT(c.quantity) DESC) AS RowNo from customer as A
join invoice as B
on A.customer_id=B.customer_id
join invoice_line as C
on B.invoice_id=C.invoice_id
join track as D
on C.track_id=D.track_id
join genre as E
on E.genre_id=D.genre_id
group by A.country,E.name, quantity
)as M
WHERE RowNo=1
ORDER BY amt_purchase  DESC;



--	3. Write a query that determines the customer that has spent the most on music for each
--	country. Write a query that returns the country along with the top customer and how
--	much they spent. For countries where the top amount spent is shared, provide all
--	customers who spent this amount

select * from (select A.first_name+A.last_name as customer_name,A.country,sum(total) as total_spent,
ROW_NUMBER() OVER(PARTITION BY a.country ORDER BY sum(total) DESC) AS RowNo
from customer as A
join invoice as B
on A.customer_id=B.customer_id
Group by A.country, A.first_name+A.last_name
) b
where RowNo = 1
order by total_spent desc;

