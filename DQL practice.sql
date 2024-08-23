-- ### Practice Questions for Data Query Language (DQL) Statements ###

USE BOOKSTORE;

-- 1. Retrieve all authors.
SELECT *
FROM Authors;

-- 2. Retrieve the names and email addresses of all customers.
SELECT name, email
FROM Customers;

-- 3. List all books along with their authors' names.
SELECT Books.title, Authors.author_name 
FROM Books
INNER JOIN Authors ON Books.author_id = Authors.author_id;

-- 4. Find all books published before the year 2000.
SELECT * FROM Books
WHERE Publication_year < 2000;

-- 5. Get the total number of books written by British authors.
SELECT COUNT(*) AS TotalBooksByBritishAuthors
FROM Books 
JOIN Authors ON Books.author_id = Authors.author_id
WHERE Authors.nationality = 'British';

-- 6. Retrieve the titles of all books reviewed by 'John Doe'. 
SELECT B.title FROM Books B
JOIN Reviews R ON B.book_id = R.book_id
JOIN Customers C ON C.Customer_id = R.customer_id
WHERE C.name = 'John Doe';

-- 7. Find the average rating for each book.
SELECT book_id, AVG(rating) Avg_Rating
FROM Reviews 
GROUP BY book_id 

SELECT COUNT(*) Count, AVG(rating) Avg_Rating
FROM Reviews 
GROUP BY book_id;

-- 8. List all orders made in the year 2023.
SELECT * FROM Orders
WHERE order_date BETWEEN '2023-01-01' AND '2023-12-31';

SELECT * FROM Orders
WHERE order_date LIKE '2023%';

-- 9. Retrieve the most recent review for each book.
SELECT B.title, R.review_text, O.order_date
FROM Books B
JOIN Reviews R ON B.book_id = R.book_id
JOIN Orders O ON R.book_id = O.book_id
WHERE O.order_date IN (
SELECT MAX(O2.order_date) FROM Orders O2
GROUP BY O2.book_id
)

WITH LatestOrders AS (
	SELECT book_id, MAX(order_date) most_recent_order_date
	FROM Orders
	GROUP BY book_id
	)
	SELECT B.title, R.review_text, L.most_recent_order_date
	FROM Books B
	JOIN Reviews R ON B.book_id = R.book_id
	JOIN LatestOrders L ON R.book_id = L.book_id
	ORDER BY L.most_recent_order_date DESC

-- 10. Find all customers who have never placed an order.
SELECT Customers.Customer_id, Customers.name, Orders.order_id
FROM Customers
RIGHT JOIN Orders ON Customers.Customer_id = Orders.customer_id
WHERE Orders.order_id = 0;

-- 11. List the top 5 highest-rated books based on average ratings.
SELECT TOP 5 AVG(Reviews.rating) Avg_Rating, Books.title 
FROM Reviews
JOIN Books ON Books.book_id = Reviews.book_id
GROUP BY Books.title
ORDER BY Avg_Rating DESC;

-- 12. Retrieve the details of all American authors.
SELECT *
FROM Authors 
WHERE nationality = 'American';

-- 13. Find the total number of orders placed by each customer.
SELECT Customer_id, COUNT(Order_id) TotalOrders
FROM Orders 
GROUP BY customer_id;

-- 14. List the titles of all books and their corresponding review texts.
SELECT Books.title,Reviews.review_text
FROM Reviews
JOIN Books ON Books.book_id = Reviews.book_id;

-- 15. Retrieve the names of all authors who have written more than one book.
SELECT Authors.author_name, COUNT(Books.book_id) TotalBooks 
FROM Authors 
JOIN Books ON Books.author_id = Authors.author_id
GROUP BY Authors.author_name 
HAVING COUNT(Books.book_id) > 1
ORDER BY TotalBooks;

SELECT Authors.author_name
FROM Authors 
JOIN Books ON Books.author_id = Authors.author_id
GROUP BY Authors.author_name
HAVING COUNT(Books.book_id) > 1;

-- 16. Retrieve all books with the word 'the' in the title (case-insensitive).
SELECT title FROM Books
WHERE title LIKE '%the%';

-- 17. Find all customers whose email addresses end with 'example.com'.
SELECT name, email 
FROM Customers
WHERE email LIKE '%example.com';

SELECT name 
FROM Customers
WHERE email LIKE '%example.com';

-- 18. Retrieve the names and birthdates of customers born in the 1980s.
SELECT name, birthdate 
FROM Customers
WHERE birthdate LIKE '%1980%';

-- 19. List all authors from either the 'British' or 'American' nationality using a set operator.
SELECT *
FROM Authors 
WHERE nationality = 'American' OR nationality = 'British';

-- 20. Retrieve the titles and publication years of books published after 2000 but not in 2023 using a set operator.
SELECT title, Publication_year 
FROM Books
WHERE Publication_year BETWEEN '2000' AND '2022';

SELECT title, Publication_year 
FROM Books
WHERE Publication_year >'2000' AND Publication_year < '2023';

-- 21. Find all books whose titles start with 'The'.
SELECT title
FROM Books
WHERE title LIKE 'The%';

-- 22. Retrieve the titles of books and their genres where the genre contains 'Fiction'.
SELECT title, genre
FROM Books
WHERE genre LIKE '%Fiction%';

-- 23. List the names of customers who have either 'John' or 'Jane' in their name.
SELECT name
FROM Customers
WHERE name LIKE '%John%' OR name LIKE '%Jane%';

-- 24. Find all authors whose names end with 'ing'.
SELECT author_name
FROM Authors
WHERE author_name LIKE '%ing';

-- 25. Retrieve the names and nationalities of authors where the name contains exactly five letters.
SELECT author_name, nationality
FROM Authors
WHERE LEN(author_name) = '5';

