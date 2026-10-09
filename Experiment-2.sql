```sql
-- Database Setup
CREATE DATABASE EcommerceDB;
USE EcommerceDB;

-- 1. Create Customer Table
CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    PhoneNo VARCHAR(15) NOT NULL,
    DOB DATE NOT NULL
);

-- 2. Create Address Table
CREATE TABLE Address (
    AddressID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT NOT NULL,
    Pincode VARCHAR(10) NOT NULL,
    State VARCHAR(50) NOT NULL,
    City VARCHAR(50) NOT NULL,
    FOREIGN KEY (CustomerID)
        REFERENCES Customer(CustomerID)
        ON DELETE CASCADE
);

-- 3. Create Category Table
CREATE TABLE Category (
    CategoryID INT PRIMARY KEY AUTO_INCREMENT,
    CategoryName VARCHAR(100) NOT NULL UNIQUE,
    Description VARCHAR(255)
);

-- 4. Create Seller Table
CREATE TABLE Seller (
    SellerID INT PRIMARY KEY AUTO_INCREMENT,
    SellerName VARCHAR(100) NOT NULL,
    PhoneNo VARCHAR(15) NOT NULL UNIQUE
);

-- 5. Create Product Table
CREATE TABLE Product (
    ProductID INT PRIMARY KEY AUTO_INCREMENT,
    CategoryID INT NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    Image VARCHAR(255),
    FOREIGN KEY (CategoryID)
        REFERENCES Category(CategoryID)
        ON DELETE CASCADE
);

-- 6. Create Subclass Tables for Product

CREATE TABLE Electronic (
    ProductID INT PRIMARY KEY,
    FOREIGN KEY (ProductID)
        REFERENCES Product(ProductID)
        ON DELETE CASCADE
);

CREATE TABLE Fashion (
    ProductID INT PRIMARY KEY,
    FOREIGN KEY (ProductID)
        REFERENCES Product(ProductID)
        ON DELETE CASCADE
);

CREATE TABLE Books (
    ProductID INT PRIMARY KEY,
    SellerID INT,
    FOREIGN KEY (ProductID)
        REFERENCES Product(ProductID)
        ON DELETE CASCADE,
    FOREIGN KEY (SellerID)
        REFERENCES Seller(SellerID)
        ON DELETE SET NULL
);

-- 7. Create Orders Table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT NOT NULL,
    OrderDate DATE NOT NULL,
    OrderStatus VARCHAR(30) NOT NULL,
    FOREIGN KEY (CustomerID)
        REFERENCES Customer(CustomerID)
        ON DELETE CASCADE
);

-- 8. Create OrderItem Table
CREATE TABLE OrderItem (
    OrderID INT NOT NULL,
    ItemSeqNo INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (OrderID, ItemSeqNo),
    FOREIGN KEY (OrderID)
        REFERENCES Orders(OrderID)
        ON DELETE CASCADE,
    FOREIGN KEY (ProductID)
        REFERENCES Product(ProductID)
        ON DELETE CASCADE
);

-- 9. Create Payment Table
CREATE TABLE Payment (
    PaymentID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT NOT NULL UNIQUE,
    PaymentDate DATE NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,
    PaymentMethod VARCHAR(30) NOT NULL,
    Status VARCHAR(30) NOT NULL,
    FOREIGN KEY (OrderID)
        REFERENCES Orders(OrderID)
        ON DELETE CASCADE
);

-- 10. Create Delivery Table
CREATE TABLE Delivery (
    DeliveryID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT NOT NULL UNIQUE,
    CourierName VARCHAR(100) NOT NULL,
    Status VARCHAR(30) NOT NULL,
    DeliveryDate DATE,
    FOREIGN KEY (OrderID)
        REFERENCES Orders(OrderID)
        ON DELETE CASCADE
);

-- =========================================================
-- Sample Data Insertion
-- =========================================================

-- Insert Customers
INSERT INTO Customer (Name, Email, PhoneNo, DOB) VALUES
('Sahil', 'sahil@gmail.com', '9839105025', '2005-05-15'),
('Arjun', 'arjun@gmail.com', '9336677989', '2004-08-20');

-- Insert Categories
INSERT INTO Category (CategoryName, Description) VALUES
('Electronics', 'Electronic Products'),
('Fashion', 'Fashion products'),
('Books', 'Books');

-- Insert Sellers
INSERT INTO Seller (SellerName, PhoneNo) VALUES
('Tech Store', '9000000001'),
('Book Store', '9000000002');

-- Insert Products
INSERT INTO Product (CategoryID, Price, Image) VALUES
(1, 50000.00, 'Laptop.jpg'),
(2, 999.00, 'Shirt.png'),
(3, 599.00, 'Book.jpg');

-- Insert Product Subclasses
INSERT INTO Electronic (ProductID) VALUES (1);
INSERT INTO Fashion (ProductID) VALUES (2);
INSERT INTO Books (ProductID, SellerID) VALUES (3, 2);

-- Insert Addresses
INSERT INTO Address (CustomerID, Pincode, State, City) VALUES
(1, '208001', 'Uttar Pradesh', 'Kanpur'),
(2, '110001', 'Delhi', 'Delhi');

-- Insert Orders
INSERT INTO Orders (CustomerID, OrderDate, OrderStatus) VALUES
(1, '2026-08-19', 'Placed'),
(2, '2026-08-19', 'Shipped');

-- Insert Order Items
INSERT INTO OrderItem
(OrderID, ItemSeqNo, ProductID, Quantity, UnitPrice) VALUES
(1, 1, 1, 1, 50000.00),
(2, 1, 2, 2, 999.00);

-- Insert Payments
INSERT INTO Payment
(OrderID, PaymentDate, Amount, PaymentMethod, Status) VALUES
(1, '2026-08-19', 50000.00, 'UPI', 'Success'),
(2, '2026-08-19', 1998.00, 'Card', 'Success');

-- Insert Deliveries
INSERT INTO Delivery
(OrderID, CourierName, Status, DeliveryDate) VALUES
(1, 'Delhivery', 'Delivered', '2026-08-20'),
(2, 'DTDC', 'Pending', NULL);

-- =========================================================
-- Demonstration of Referential Integrity Violations
-- =========================================================

-- Foreign Key Constraint Violation Test
-- Expected: Error because CustomerID 999 does not exist.
INSERT INTO Orders (CustomerID, OrderDate, OrderStatus)
VALUES (999, '2026-08-19', 'Placed');

-- Unique Constraint Violation Test
-- Expected: Error because this email already exists.
INSERT INTO Customer (Name, Email, PhoneNo, DOB)
VALUES ('Test', 'sahil@gmail.com', '9999999999', '2025-01-01');

-- =========================================================
-- Testing ON DELETE SET NULL and ON DELETE CASCADE
-- =========================================================

-- Test ON DELETE SET NULL
DELETE FROM Seller WHERE SellerID = 2;

-- SellerID in Books should now be NULL.
SELECT * FROM Books;

-- Test ON DELETE CASCADE
DELETE FROM Customer WHERE CustomerID = 2;

-- The orders belonging to CustomerID 2 should be deleted.
SELECT * FROM Orders WHERE CustomerID = 2;
```
