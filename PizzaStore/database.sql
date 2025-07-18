-- Create PizzaStore Database
CREATE DATABASE PizzaStore;
GO

USE PizzaStore;
GO

-- Create Categories Table
CREATE TABLE Categories (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255)
);

-- Create Suppliers Table
CREATE TABLE Suppliers (
    SupplierID INT IDENTITY(1,1) PRIMARY KEY,
    CompanyName NVARCHAR(100) NOT NULL,
    Address NVARCHAR(255),
    Phone NVARCHAR(20)
);

-- Create Products Table
CREATE TABLE Products (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName NVARCHAR(100) NOT NULL,
    SupplierID INT,
    CategoryID INT,
    QuantityPerUnit INT,
    UnitPrice DECIMAL(10,2),
    ProductImage NVARCHAR(255),
    Description NVARCHAR(500),
    IsPizzaOfTheWeek BIT DEFAULT 0,
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

-- Create Account Table
CREATE TABLE Account (
    AccountID INT IDENTITY(1,1) PRIMARY KEY,
    UserName NVARCHAR(50) UNIQUE NOT NULL,
    Password NVARCHAR(50) NOT NULL,
    FullName NVARCHAR(100) NOT NULL,
    Type INT NOT NULL -- 1 = Staff, 2 = Normal User
);

-- Create Customers Table
CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    Password NVARCHAR(50) NOT NULL,
    ContactName NVARCHAR(100) NOT NULL,
    Address NVARCHAR(255),
    Phone NVARCHAR(20)
);

-- Create Orders Table
CREATE TABLE Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT,
    OrderDate DATETIME,
    RequiredDate DATETIME,
    ShippedDate DATETIME,
    Freight DECIMAL(10,2),
    ShipAddress NVARCHAR(255),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Create Order Details Table
CREATE TABLE OrderDetails (
    OrderID INT,
    ProductID INT,
    UnitPrice DECIMAL(10,2),
    Quantity INT,
    PRIMARY KEY (OrderID, ProductID),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Insert sample data

-- Categories
INSERT INTO Categories (CategoryName, Description) VALUES
('Standard', 'Standard pizza category'),
('Specialties', 'Specialty pizzas with unique toppings');

-- Suppliers
INSERT INTO Suppliers (CompanyName, Address, Phone) VALUES
('Pizza Ingredients Co.', '123 Main St', '555-1234'),
('Fresh Foods Ltd.', '456 Oak Ave', '555-5678');

-- Products
INSERT INTO Products (ProductName, SupplierID, CategoryID, QuantityPerUnit, UnitPrice, ProductImage, Description, IsPizzaOfTheWeek) VALUES
('Capricciosa', 1, 1, 1, 70.00, 'Pizza_capricciosa.jpg', 'A normal pizza with a taste from the forest', 1),
('Hawaii', 1, 1, 1, 75.00, 'Hawaiian_pizza_1.jpg', 'A nice tasting pizza from Hawaii', 0),
('Margarita', 1, 1, 1, 65.00, 'Eq_it-na_pizza-margherita_sep2005_sml.jpg', 'A basic pizza for everyone', 0),
('Pescatore', 1, 2, 1, 80.00, 'doc_0231.jpg', 'A pizza with taste from the ocean', 1),
('Barcelona', 1, 2, 1, 70.00, 'pizza-jamon-dulce-y-champinones.jpg', 'A pizza with taste from Spain, Barcelona', 0);

-- Account
INSERT INTO Account (UserName, Password, FullName, Type) VALUES
('admin', 'admin123', 'Administrator', 1),
('staff', 'staff123', 'Staff Member', 1),
('user1', 'user123', 'John Doe', 2),
('user2', 'user123', 'Jane Smith', 2);

-- Customers
INSERT INTO Customers (Password, ContactName, Address, Phone) VALUES
('cust123', 'Mike Johnson', '789 Pine St', '555-9999'),
('cust456', 'Sarah Wilson', '321 Elm St', '555-8888');

-- Orders
INSERT INTO Orders (CustomerID, OrderDate, RequiredDate, ShippedDate, Freight, ShipAddress) VALUES
(1, '2024-01-15', '2024-01-20', '2024-01-18', 5.00, '789 Pine St'),
(2, '2024-01-16', '2024-01-21', NULL, 3.50, '321 Elm St'),
(1, '2024-01-17', '2024-01-22', '2024-01-19', 4.00, '789 Pine St');

-- Order Details
INSERT INTO OrderDetails (OrderID, ProductID, UnitPrice, Quantity) VALUES
(1, 1, 70.00, 2),
(1, 3, 65.00, 1),
(2, 2, 75.00, 1),
(2, 4, 80.00, 1),
(3, 5, 70.00, 3);

GO