-- =========================================
-- 1. DATA UNDERSTANDING
-- =========================================

select * from customers;

select * from employees;

select companyname, city, country
from suppliers s ;

select distinct country
from customers c ;

select distinct region
from suppliers s ;

select count (*)
from customers c ;

select count (*)
from products ;

select count (*)
from orders ;

select count (distinct city)
from suppliers ;

Select count (distinct productid)
From order_details ;

select customerid , shippeddate - orderdate as long
from orders o ;

-- =========================================
-- 2. DATA FILTERING
-- =========================================

select companyname
from suppliers s
where city='Berlin'

select contactname, phone  
from customers c 
where country ='Mexico';

select contactname as customernames, phone as contacts 
from customers c 
where country = 'Mexico';

select count(*)
from orders o
where employeeid = 3;

select count (*)
from orders o
where freight >= 250;

select count (*)
from orders o 
where orderdate >'1998-01-01';

select count (*)
from orders o 
where orderdate <'1997-07-05';

select count (*)
from orders o 
where orderdate >'1996-12-31';

select * 
from orders o 
where customerid = 'VINET' and orderdate >= '1996-09-02'

select * 
from orders o 
where customerid = 'VINET' or customerid = 'HANAR'

select *
from orders o
where not shippeddate > '1997-07-05';

select *
from orders o
where not shippeddate > '1997-07-04'
and not shippeddate < '1996-06-30';

select * 
from orders o
where freight between 50 and 100;

select * 
from orders o 
where freight>= 50 and freight <=100;

select *
from orders o 
where orderdate between '1996-06-01' and '1996-09-30' 


select count (*)
from categories c  
where categoryid in (1,4,6,7);

select count (*)
from products p  
where categoryid in (1,4,6,7);

select * 
from usstates u 
where stateid in (2,3,22);

select *
from usstates u  
where stateid=2 or stateid=3 or stateid=22;

-- =========================================
-- 3. DATA INTEGRATION FOR ANALYSIS
-- Combining multiple tables for business insights
-- =========================================

select companyname, orderdate, shipcountry
from orders 
join customers on customers.customerid = orders.customerid;

SELECT customers.companyname, orders.orderdate, orders.shipcountry
FROM customers
JOIN orders ON customers.customerid = orders.customerid
WHERE customers.country = 'Germany';

select employees.firstname, employees.lastname, orders.orderdate, orders.shipcountry
from employees
join orders on employees.employeeid = orders.employeeid
where employees.title = 'Sales Representative';

select companyname, orderid
from customers
left join orders on customers.customerid = orders.customerid

select employees.lastname, orders.orderid
from employees
left join orders on employees.employeeid = orders.employeeid;

select companyname, orderid
from orders
right join customers on customers.customerid = orders.customerid;

select customers.companyname, orders.orderid, orders.orderdate
from customers
right join orders on customers.customerid = orders.customerid;

select companyname, orderid
from orders
full join customers on customers.customerid =orders.customerid;

select customers.companyname, orders.orderid
from orders
full join customers on customers.customerid = orders.customerid
where orders.orderdate is null or customers.companyname is null;

select companyname,orderdate,unitprice,quantity
from orders
join order_details on orders.orderid = order_details.orderid
join customers on customers.customerid = orders.customerid;

select companyname, orders.orderid, productid, unitprice, quantity
from customers
join orders on customers.customerid = orders.customerid
join order_details on orders.orderid = order_details.orderid;

SELECT DISTINCT Country
FROM (
    SELECT Country FROM Customers
    UNION
    SELECT Country FROM Suppliers
) AS AllCountries
ORDER BY Country;

SELECT Country, 'Customer' AS Type FROM Customers
UNION
SELECT Country, 'Supplier' AS Type FROM Suppliers
ORDER BY Country, Type;

SELECT Country, COUNT(*) AS NumPairs
FROM (
SELECT Country FROM Customers
INTERSECT
SELECT Country FROM Suppliers
) AS SharedCountries
GROUP BY Country;

SELECT DISTINCT Suppliers.City
FROM Suppliers
LEFT JOIN Customers ON Suppliers.City = Customers.City
WHERE Customers.CustomerID IS NULL;

SELECT COUNT(DISTINCT Customers.CustomerID) AS NumCustomers
FROM Customers
LEFT JOIN Suppliers ON Customers.City = Suppliers.City
WHERE Suppliers.SupplierID IS NULL;

-- =========================================
-- 4. SALES PERFORMANCE ANALYSIS
-- Evaluating product and revenue performance
-- =========================================

SELECT CategoryName, COUNT(ProductID) AS NumberOfProducts
FROM Categories
JOIN Products ON Categories.CategoryID = Products.CategoryID
GROUP BY CategoryName;

select * from products p 

SELECT ProductName, SUM(UnitPrice * Quantityperunit) AS TotalValue
FROM Products
JOIN order_details od  ON Products.ProductID = order_details.ProductID
JOIN Orders ON order_details.OrderID = Orders.OrderID
WHERE YEAR(Orders.OrderDate) = 1997
GROUP BY ProductName;

SELECT ProductName, SUM(UnitPrice * Quantityperunit) AS TotalValue
FROM order_details od 
JOIN Products ON order_details.ProductID = Products.ProductID
JOIN Orders ON order_details.OrderID = Orders.OrderID
WHERE EXTRACT(YEAR FROM Orders.OrderDate) = 1997
GROUP BY ProductName;

SELECT Customers.CustomerID, SUM(order_details.UnitPrice * order_details.Quantity) AS TotalSpent
FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID
JOIN order_details ON Orders.OrderID = order_details.OrderID
GROUP BY Customers.CustomerID
HAVING SUM(order_details.UnitPrice * order_details.Quantity) > 5000;

SELECT Customers.CustomerID, SUM(order_details.UnitPrice * order_details.Quantity) AS TotalSpent
FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID
JOIN order_details ON Orders.OrderID = order_details.OrderID
WHERE YEAR(Orders.OrderDate) = 1997 AND MONTH(Orders.OrderDate) < = 6
GROUP BY Customers.CustomerID
HAVING SUM(order_details.UnitPrice * order_details.Quantity) > 5000;

select c.customerid, c.contactname, sum(od.quantity*od.unitprice) as
totalspent
from customers c
join orders o on c.customerid = o.customerid
join order_details od on o.orderid = od.orderid
where o.orderdate >= '1997-01-01' and o.orderdate <= '1997-07-01'
group by c.customerid, contactname
having sum(od.quantity*od.unitprice) > 5000;

select p.productid, p.productname, sum(od.quantity*od.unitprice) as
totalvalue
from products p
join order_details od on p.productid =od.productid
join orders o on od.orderid =o.orderid
where extract (year from o.orderdate) = 1997
group by p.productid, p.productname;

select c.companyname as buyer, s.companyname as supplier,
sum(od.quantity*od.unitprice) as totalsales
from orders as o
join customers as c on o.customerid = c.customerid
join order_details as od on o.orderid = od.orderid
join products as p on od.productid = p.productid
join suppliers as s on p.supplierid = s.supplierid
group by c.companyname, s.companyname
order by c.companyname, s.companyname;

select s.supplierid, s.companyname,p.productid, p.productname,
c.customerid, c.contactname, (sum(od.quantity*od.unitprice),0) as
totalsales
from suppliers as s
join products as p on s.supplierid = p.supplierid
left join order_details as od on p.productid = od.orderid
left join orders as o on od.orderid = o.orderid
left join customers as c on o.customerid = c.customerid
group by rollup (s.supplierid, s.companyname, p.productid,p.productname,
c.customerid, c.contactname)
order by s.supplierid, p.productid, c.customerid;

select c.companyname, p.productname , s.companyname, sum (od.unitprice *
od.quantity)as total_penjualan from orders o
join customers c on o.customerid = c.customerid
join order_details od on o.orderid = od.orderid
join products p on od.productid = p.productid
join suppliers s on p.supplierid = s.supplierid
group by cube(s.companyname, p.productname, c.companyname)
order by s.companyname , p.productname , c.companyname


-- =========================================
-- 5. CUSTOMER SEGMENTATION
-- Categorizing customers based on behavior
-- =========================================

select companyname, country,
case when country in ('Austria', 'Germany', 'Poland') then 'Europe'
when country in ('Mexico', 'USA', 'Canada') then 'North America'
when country in ('Brazil', 'Venezuela', 'Argentina') then 'South America'
else 'unknown'
end as continent
from customers c ;

select orderid, productid, quantity,
case when quantity > 30 then 'Menguntungkan'
when quantity = 30 then 'Rata-rata'
else 'Kurang dari 30'
end as QuantityDesc
from order_details od ;

select companyname,
case city when 'New Orleans' then 'Big Easy'
when 'Paris' then 'City of Lights'
else city 
end as Citydesc
from suppliers s ;

select companyname, country,
case when country in ('Austria', 'Gernamy', 'Poland') then 'Europe'
when country in ('Mexico', 'USA', 'Canada') then 'North America'
when country in ('Brazil', 'Venezuela', 'Argentina') then 'South America'
else 'unknown'
end as continent
from customers c ;

select orderid, productid, quantity,
case when quantity > 30 then 'Menguntungkan'
when quantity = 30 then 'Rata-rata'
else 'Kurang dari 30'
end as QuantityDesc
from order_details od ;

select companyname,
case city when 'New Orleand' then 'Bigh Easy'
when 'Paris' then 'City of Lights'
else city 
end as Citydesc
from suppliers s ;

-- =========================================
-- 6. DATAMART PREPARATION
-- Categorizing customers based on behavior
-- =========================================


select * from dim_customer dc;

drop table dim_customer ;


select * from dim_product ;

select * from public.date;

select * from public.dim_order;

select * from public.dim_shipper ds 

select * from public."dim supplier" ds 

drop table public."dim supplier" ;

drop table public.dim_order

select * from public.dim_order

drop table public.dim_order

select * from dim.dim_date dd 

select * from public.

select * from public.order_details od

select * from staging_northwind

drop table public.fact_orders

select * from public.datamart d 

select * from public.dim_employee de 

select * from public."dim supplier" ds 

select * from public.dim_customer dc 

drop table public.datamart

select * from public.datamart d

select * from public.fact_orders fo 