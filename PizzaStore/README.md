# PizzaStore - Java Web Application

A comprehensive Java Web Application for managing a pizza store with member management, product management, and order management functionality.

## Features

### Core Functionality
- **Member Management**: User registration and authentication with role-based access (Staff/Normal User)
- **Product Management**: Complete CRUD operations for pizza products
- **Order Management**: Order creation, viewing, and management
- **Search**: Advanced product search by name, price range
- **Sales Reports**: Detailed sales analytics with date range filtering (Staff only)

### User Roles
- **Staff (Type=1)**: Full access to all features including product management and sales reports
- **Normal User (Type=2)**: Can view products, manage their own profile and orders

## Technology Stack
- **Backend**: Java Servlets, JSP, JSTL, EL
- **Database**: Microsoft SQL Server
- **Architecture**: MVC2 Model with JavaBean
- **Data Access**: JDBC

## Project Structure

```
PizzaStore/
├── src/
│   ├── controller/
│   │   └── MainController.java          # Main servlet handling all requests
│   ├── model/                           # Data Transfer Objects (DTOs)
│   │   ├── Account.java
│   │   ├── Product.java
│   │   ├── Order.java
│   │   ├── OrderDetail.java
│   │   └── Customer.java
│   ├── dao/                             # Data Access Objects
│   │   ├── AccountDAO.java
│   │   ├── ProductDAO.java
│   │   └── OrderDAO.java
│   └── utils/
│       └── DBContext.java               # Database connection utility
├── WebContent/
│   ├── WEB-INF/
│   │   └── web.xml                      # Web application configuration
│   ├── index.jsp                        # Home page
│   ├── login.jsp                        # Login page
│   ├── register.jsp                     # Registration page
│   ├── products.jsp                     # Product listing and search
│   ├── addProduct.jsp                   # Add new product (Staff only)
│   ├── editProduct.jsp                  # Edit product (Staff only)
│   ├── orders.jsp                       # Order management
│   └── salesReport.jsp                  # Sales report (Staff only)
├── database.sql                         # Database creation script
└── README.md                           # This file
```

## Database Schema

The application uses the following main tables:
- **Account**: User accounts with role-based access
- **Products**: Pizza products with details and pricing
- **Orders**: Customer orders
- **OrderDetails**: Order line items
- **Categories**: Product categories
- **Suppliers**: Product suppliers
- **Customers**: Customer information

## Setup Instructions

### Prerequisites
1. Java Development Kit (JDK) 8 or higher
2. Apache Tomcat 8.5 or higher
3. Microsoft SQL Server
4. SQL Server JDBC Driver

### Database Setup
1. Install Microsoft SQL Server
2. Run the `database.sql` script to create the database and sample data
3. Update database connection settings in `src/utils/DBContext.java`:
   - Server URL
   - Username
   - Password

### Application Deployment
1. Copy the SQL Server JDBC driver JAR to `WebContent/WEB-INF/lib/`
2. Compile the Java source files
3. Package the application as a WAR file or deploy directly to Tomcat
4. Start Tomcat server
5. Access the application at `http://localhost:8080/PizzaStore`

## Default User Accounts

The database comes with pre-configured accounts:

### Staff Accounts
- **Username**: `admin` / **Password**: `admin123` (Administrator)
- **Username**: `staff` / **Password**: `staff123` (Staff Member)

### Normal User Accounts
- **Username**: `user1` / **Password**: `user123` (John Doe)
- **Username**: `user2` / **Password**: `user123` (Jane Smith)

## Usage Guide

### For Staff Users
1. **Login** with staff credentials
2. **Product Management**:
   - View all products
   - Add new products
   - Edit existing products
   - Delete products
   - Search products by name and price range
3. **Order Management**:
   - View all orders
   - Edit order details
   - Delete orders
4. **Sales Reports**:
   - Generate sales reports by date range
   - View detailed sales analytics sorted by amount

### For Normal Users
1. **Login** with user credentials
2. **Product Browsing**:
   - View product catalog
   - Search products
3. **Order Management**:
   - View personal order history
   - Create new orders (future enhancement)

## Key Features Implementation

### Search Functionality
- Case-insensitive product name search
- Price range filtering
- Combined search criteria

### Security
- Session-based authentication
- Role-based access control
- Input validation

### Data Validation
- Required field validation
- Data type validation
- SQL injection prevention through prepared statements

### Reporting
- Sales report with date range filtering
- Descending order sorting by sales amount
- Grand total calculation

## Future Enhancements
- Shopping cart functionality
- Order creation interface for customers
- Email notifications
- Advanced reporting features
- CSS styling for better UI/UX
- AJAX for dynamic content loading

## Troubleshooting

### Common Issues
1. **Database Connection Issues**:
   - Verify SQL Server is running
   - Check connection string in DBContext.java
   - Ensure JDBC driver is in classpath

2. **Login Issues**:
   - Use default accounts provided
   - Check database data integrity

3. **Permission Issues**:
   - Verify user roles in database
   - Check session management

## License
This project is created for educational purposes as part of a Java Web Application assignment.