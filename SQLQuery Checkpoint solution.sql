
USE CommercialDB;


--1.	Display in descending order of seniority the male employees whose net salary (salary + commission) is greater than or equal to 8000. 
--The resulting table should include the following columns: Employee Number, First Name and Last Name (using LPAD or RPAD for formatting), Age, and Seniority.

SELECT 
    EMPLOYEE_NUMBER, 
    LPAD(FIRST_NAME, 20, ' ') AS FIRST_NAME, 
    RPAD(LAST_NAME, 20, ' ') AS LAST_NAME, 
    FLOOR((SYSDATE - BIRTH_DATE) / 365) AS AGE, 
    FLOOR((SYSDATE - HIRE_DATE) / 365) AS SENIORITY
FROM 
    EMPLOYEES
WHERE 
    TITLE = 'Mr.' 
    AND (SALARY + NVL(COMMISSION, 0)) >= 8000
ORDER BY 
    SENIORITY DESC;

--2.	Display products that meet the following criteria: 
--(C1) quantity is packaged in bottle(s), (C2) the third character in the product name is 't' or 'T', (C3) supplied by suppliers 1, 2, or 3, 
--(C4) unit price ranges between 70 and 200, and (C5) units ordered are specified (not null). 
--The resulting table should include the following columns: product number, product name, supplier number, units ordered, and unit price.

SELECT 
    PRODUCT_REF, 
    PRODUCT_NAME, 
    SUPPLIER_NUMBER, 
    UNITS_ON_ORDER, 
    UNIT_PRICE
FROM 
    PRODUCTS
WHERE 
    -- Condition C1: Quantity is packaged in bottle(s)
    LOWER(QUANTITY) LIKE '%bottle%'
    
    -- Condition C2: The third character in the product name is 't' or 'T'
    AND (SUBSTR(PRODUCT_NAME, 3, 1) = 't' OR SUBSTR(PRODUCT_NAME, 3, 1) = 'T')
    
    -- Condition C3: Supplied by suppliers 1, 2, or 3
    AND SUPPLIER_NUMBER IN (1, 2, 3)
    
    -- Condition C4: Unit price between 70 and 200
    AND UNIT_PRICE BETWEEN 70 AND 200
    
    -- Condition C5: Units on order is not null
    AND UNITS_ON_ORDER IS NOT NULL;

--3.	Display customers who reside in the same region as supplier 1, meaning they share the same country, city, and the last three digits of the postal code. 
--The query should utilize a single subquery. The resulting table should include all columns from the customer table.

SELECT *
FROM CUSTOMERS
WHERE COUNTRY = (SELECT COUNTRY FROM SUPPLIERS WHERE SUPPLIER_NUMBER = 1)
  AND CITY = (SELECT CITY FROM SUPPLIERS WHERE SUPPLIER_NUMBER = 1)
  AND SUBSTR(POSTAL_CODE, -3) = (SELECT SUBSTR(POSTAL_CODE, -3) FROM SUPPLIERS WHERE SUPPLIER_NUMBER = 1);

--4.	For each order number between 10998 and 11003, do the following:  
--Display the new discount rate, which should be 0% if the total order amount before discount (unit price * quantity) is between 0 and 2000, 
--5% if between 2001 and 10000, 10% if between 10001 and 40000, 15% if between 40001 and 80000, and 20% otherwise.
--Display the message "apply old discount rate" if the order number is between 10000 and 10999, and "apply new discount rate" otherwise. 
--The resulting table should display the columns: order number, new discount rate, and discount rate application note.

SELECT 
    ORDER_NUMBER, 
    CASE 
        WHEN (UNIT_PRICE * QUANTITY) BETWEEN 0 AND 2000 THEN 0
        WHEN (UNIT_PRICE * QUANTITY) BETWEEN 2001 AND 10000 THEN 0.05
        WHEN (UNIT_PRICE * QUANTITY) BETWEEN 10001 AND 40000 THEN 0.10
        WHEN (UNIT_PRICE * QUANTITY) BETWEEN 40001 AND 80000 THEN 0.15
        ELSE 0.20
    END AS NEW_DISCOUNT_RATE,
    CASE 
        WHEN ORDER_NUMBER BETWEEN 10000 AND 10999 THEN 'apply old discount rate'
        ELSE 'apply new discount rate'
    END AS DISCOUNT_RATE_APPLICATION_NOTE
FROM 
    ORDER_DETAILS
WHERE 
    ORDER_NUMBER BETWEEN 10998 AND 11003;

--5.	Display suppliers of beverage products. The resulting table should display the columns: supplier number, company, address, and phone number.

SELECT 
    S.SUPPLIER_NUMBER, 
    S.COMPANY, 
    S.ADDRESS, 
    S.PHONE
FROM 
    SUPPLIERS S
JOIN 
    PRODUCTS P ON S.SUPPLIER_NUMBER = P.SUPPLIER_NUMBER
JOIN 
    CATEGORIES C ON P.CATEGORY_CODE = C.CATEGORY_CODE
WHERE 
    C.CATEGORY_NAME = 'Beverages';

--6.	Display customers from Berlin who have ordered at most 1 (0 or 1) dessert product. The resulting table should display the column: customer code.

SELECT 
    C.CUSTOMER_CODE
FROM 
    CUSTOMERS C
LEFT JOIN 
    ORDERS O ON C.CUSTOMER_CODE = O.CUSTOMER_CODE
LEFT JOIN 
    ORDER_DETAILS OD ON O.ORDER_NUMBER = OD.ORDER_NUMBER
LEFT JOIN 
    PRODUCTS P ON OD.PRODUCT_REF = P.PRODUCT_REF
LEFT JOIN 
    CATEGORIES CAT ON P.CATEGORY_CODE = CAT.CATEGORY_CODE
WHERE 
    C.CITY = 'Berlin'
    AND (CAT.CATEGORY_NAME = 'Desserts' OR CAT.CATEGORY_NAME IS NULL)
GROUP BY 
    C.CUSTOMER_CODE
HAVING 
    COUNT(CASE WHEN CAT.CATEGORY_NAME = 'Desserts' THEN 1 END) <= 1;

--7.	Display customers who reside in France and the total amount of orders they placed every Monday in April 1998 (considering customers who haven't placed any orders yet).
--The resulting table should display the columns: customer number, company name, phone number, total amount, and country.

SELECT 
    C.CUSTOMER_CODE, 
    C.COMPANY, 
    C.PHONE, 
    NVL(SUM(OD.UNIT_PRICE * OD.QUANTITY), 0) AS TOTAL_AMOUNT, 
    C.COUNTRY
FROM 
    CUSTOMERS C
LEFT JOIN 
    ORDERS O ON C.CUSTOMER_CODE = O.CUSTOMER_CODE
LEFT JOIN 
    ORDER_DETAILS OD ON O.ORDER_NUMBER = OD.ORDER_NUMBER
WHERE 
    C.COUNTRY = 'France'
    AND (O.ORDER_DATE IS NULL 
         OR (EXTRACT(MONTH FROM O.ORDER_DATE) = 4 
             AND EXTRACT(YEAR FROM O.ORDER_DATE) = 1998 
             AND TO_CHAR(O.ORDER_DATE, 'DY') = 'MON'))
GROUP BY 
    C.CUSTOMER_CODE, C.COMPANY, C.PHONE, C.COUNTRY
ORDER BY 
    C.CUSTOMER_CODE;

--8.	Display customers who have ordered all products. The resulting table should display the columns: customer code, company name, and telephone number.

SELECT 
    C.CUSTOMER_CODE, 
    C.COMPANY, 
    C.PHONE
FROM 
    CUSTOMERS C
JOIN 
    ORDERS O ON C.CUSTOMER_CODE = O.CUSTOMER_CODE
JOIN 
    ORDER_DETAILS OD ON O.ORDER_NUMBER = OD.ORDER_NUMBER
JOIN 
    PRODUCTS P ON OD.PRODUCT_REF = P.PRODUCT_REF
GROUP BY 
    C.CUSTOMER_CODE, C.COMPANY, C.PHONE
HAVING 
    COUNT(DISTINCT P.PRODUCT_REF) = (SELECT COUNT(DISTINCT PRODUCT_REF) FROM PRODUCTS);

--9.	 Display for each customer from France the number of orders they have placed. 
--The resulting table should display the columns: customer code and number of orders.

SELECT 
    C.CUSTOMER_CODE, 
    COUNT(O.ORDER_NUMBER) AS NUMBER_OF_ORDERS
FROM 
    CUSTOMERS C
LEFT JOIN 
    ORDERS O ON C.CUSTOMER_CODE = O.CUSTOMER_CODE
WHERE 
    C.COUNTRY = 'France'
GROUP BY 
    C.CUSTOMER_CODE;

--10.	Display the number of orders placed in 1996, the number of orders placed in 1997, and the difference between these two numbers. 
--The resulting table should display the columns: orders in 1996, orders in 1997, and Difference.

SELECT 
    (SELECT COUNT(*) FROM ORDERS WHERE EXTRACT(YEAR FROM ORDER_DATE) = 1996) AS ORDERS_1996,
    (SELECT COUNT(*) FROM ORDERS WHERE EXTRACT(YEAR FROM ORDER_DATE) = 1997) AS ORDERS_1997,
    ( (SELECT COUNT(*) FROM ORDERS WHERE EXTRACT(YEAR FROM ORDER_DATE) = 1997) 
    - (SELECT COUNT(*) FROM ORDERS WHERE EXTRACT(YEAR FROM ORDER_DATE) = 1996) ) AS DIFFERENCE
FROM 
    DUAL;

