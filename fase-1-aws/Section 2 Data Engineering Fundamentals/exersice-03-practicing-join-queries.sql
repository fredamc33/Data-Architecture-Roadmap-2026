/*
======================================================================================================
EJERCICIO: Practicing join queries
OBJETIVO:  Entender cómo relacionar tablas.
TECNOLOGÍA: SQL Estándar
======================================================================================================

DESCRIPCIÓN DEL RETO:

1. That every product is listed in your report, even if no match exists in the Suppliers table. Your final results should be sorted alphabetically by ProductName.
------------------------------------------------------------------------------------------------------
*/

CREATE TABLE Suppliers (
    SupplierID INT PRIMARY KEY,
    CompanyName VARCHAR(100) NOT NULL
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY, 
    ProductName VARCHAR(100) NOT NULL,
    SupplierID INT,
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);

-- data that is not from the original exercise
INSERT INTO Suppliers (SupplierID, CompanyName) VALUES 
(1, 'Exotic Liquids'),
(2, 'New Orleans Cajun Delights'),
(3, 'Grandma Kelly''s Homestead'),
(4, 'Tokyo Traders'),
(5, 'Cooperativa de Quesos ''Las Cabras''');

-- data that is not from the original exercise
INSERT INTO Products (ProductName, SupplierID) VALUES 
('Chai', 1),
('Chang', 1),
('Aniseed Syrup', 1),
('Chef Anton''s Cajun Seasoning', 2),
('Chef Anton''s Gumbo Mix', 2);

-- 1. That every product is listed in your report, even if no match exists in the Suppliers table. Your final results should be sorted alphabetically by ProductName.
select p.ProductName, s.CompanyName from Products p 
left join Suppliers s on p.SupplierID = s.SupplierID
order by p.ProductName;