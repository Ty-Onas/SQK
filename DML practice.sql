--1. Write the appropriate SQL queries to insert all the provided records in their corresponding tables.

--products table:
INSERT INTO Products (Product_ID, Name, Price)
Values 
(1, 'Cookies', 10),
(2, 'Candy', 5.2);

--Customers table:
INSERT INTO Customers (Customer_ID, Name, Address)
Values
(1, 'Ahmed', 'Tunisia'),
(2, 'Coulibaly', 'Senegal'),
(3, 'Hasan', 'Egypt');

--Orders table:
INSERT INTO Orders (Order_ID, Customer_ID, Product_ID, Quantity, Order_date)
Values
(1, 1, 2, 3, '2023-01-22'),
(2, 2, 1, 10, '2023-04-14');


--2. Update the quantity of the second order, the new value should be 6.

UPDATE Orders
SET Quantity= 6
WHERE Order_ID=2;


--3. Delete the third customer from the customers table.

DELETE FROM Customers
WHERE Customer_ID=3;


--4. Delete the orders table content then drop the table.
DELETE FROM Orders

DROP Table Orders;
