/*
======================================================================================================
EJERCICIO: Practicing grouping queries
OBJETIVO:  Entender cómo obtener ratios por grupos.
TECNOLOGÍA: SQL Estándar
======================================================================================================

DESCRIPCIÓN DEL RETO:

1. Produce the survival rate for each passenger class in our dataset
------------------------------------------------------------------------------------------------------
*/

CREATE TABLE Titanic (
    PassengerId INT PRIMARY KEY,
    Survived INT,      -- 0 = No, 1 = Sí
    Pclass INT,        -- 1 = Primera, 2 = Segunda, 3 = Tercera
    Name VARCHAR(100),
    Sex VARCHAR(10),
    Age DECIMAL(5, 2), -- Decimal por si hay edades de bebés (ej: 0.42)
    SibSp INT,         -- Hermanos o cónyuges a bordo
    Parch INT,         -- Padres o hijos a bordo
    Ticket VARCHAR(50),
    Fare DECIMAL(10, 4),
    Cabin VARCHAR(20),
    Embarked CHAR(1)   -- C = Cherbourg, Q = Queenstown, S = Southampton
);

-- data that is not from the original exercise
INSERT INTO Titanic (PassengerId, Survived, Pclass, Name, Sex, Age, SibSp, Parch, Ticket, Fare, Cabin, Embarked)
VALUES 
(1, 0, 3, 'Braund, Mr. Owen Harris', 'male', 22, 1, 0, 'A/5 21171', 7.2500, NULL, 'S'),
(2, 1, 1, 'Cumings, Mrs. John Bradley (Florence Briggs Thayer)', 'female', 38, 1, 0, 'PC 17599', 71.2833, 'C85', 'C'),
(3, 1, 3, 'Heikkinen, Miss. Laina', 'female', 26, 0, 0, 'STON/O2. 3101282', 7.9250, NULL, 'S'),
(4, 1, 1, 'Futrelle, Mrs. Jacques Heath (Lily May Peel)', 'female', 35, 1, 0, '113803', 53.1000, 'C123', 'S'),
(5, 0, 3, 'Allen, Mr. William Henry', 'male', 35, 0, 0, '373450', 8.0500, NULL, 'S');

-- 1. Produce the survival rate for each passenger class in our dataset
select Pclass, avg(Survived) as survival_rate from titanic group by Pclass;