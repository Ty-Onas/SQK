-- Based on the provided data types and constraints, implement the relational model using SQL.
-- Note: ALL COLUMNS SHOULD HAVE THE 'NOT NULL' CONSTRAINT.

CREATE Database DDLCheckpoint

CREATE table Customers (
Customer_ID INT PRIMARY KEY NOT NULL,
Name VARCHAR(50) NOT NULL,
Address VARCHAR(100) NOT NULL,
 );

CREATE TABLE Products (
Product_ID INT PRIMARY KEY NOT NULL,
Name VARCHAR(50) NOT NULL,
Price DECIMAL 
CHECK (Price>0) NOT NULL,
 );

CREATE TABLE Orders (
Order_ID INT PRIMARY KEY NOT NULL,
Customer_ID INT FOREIGN KEY REFERENCES Customers(Customer_ID) NOT NULL,
Product_ID INT FOREIGN KEY REFERENCES Products(Product_ID) NOT NULL,
Quantity INT NOT NULL,
Order_date DATE NOT NULL,
);
