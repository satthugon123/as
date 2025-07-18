# PizzaStore - Quick Start Guide

## Prerequisites
- Java JDK 8+
- Apache Tomcat 8.5+
- Microsoft SQL Server
- SQL Server JDBC Driver

## Quick Setup (5 minutes)

### 1. Database Setup
```sql
-- Run the database.sql script in SQL Server Management Studio
-- This creates the PizzaStore database with sample data
```

### 2. Download SQL Server JDBC Driver
- Download `mssql-jdbc-x.x.x.jre8.jar` from Microsoft
- Copy it to `PizzaStore/WebContent/WEB-INF/lib/`

### 3. Update Database Connection
Edit `src/utils/DBContext.java` and update:
```java
private static final String DB_URL = "jdbc:sqlserver://localhost:1433;databaseName=PizzaStore;trustServerCertificate=true";
private static final String DB_USER = "your_username";
private static final String DB_PASSWORD = "your_password";
```

### 4. Build and Deploy
**Option A: Using batch file (Windows)**
```batch
run.bat
```

**Option B: Manual compilation**
```bash
# Compile
javac -cp "WebContent/WEB-INF/lib/*:$CATALINA_HOME/lib/servlet-api.jar" -d build/classes src/*/*.java

# Create WAR
jar -cvf dist/PizzaStore.war -C WebContent . -C build/classes .

# Deploy
cp dist/PizzaStore.war $CATALINA_HOME/webapps/
```

### 5. Start Application
1. Start Tomcat server
2. Open browser: `http://localhost:8080/PizzaStore`

## Test Login Credentials

### Staff Account (Full Access)
- **Username**: `admin`
- **Password**: `admin123`

### Normal User Account
- **Username**: `user1`
- **Password**: `user123`

## Features to Test

### As Staff User (admin/admin123):
1. **Product Management (CRUD)**
   - **Create**: Go to Products → Add New Product (with description & pizza of the week)
   - **Read**: View all products with full details
   - **Update**: Edit existing products
   - **Delete**: Remove products with confirmation
   - **View Details**: Click "View" to see detailed product information

2. **Sales Report**
   - Navigate to Sales Report
   - Select date range: 2024-01-01 to 2024-12-31
   - View detailed sales analytics sorted by amount

### As Normal User (user1/user123):
1. **Product Browsing**
   - View product catalog with descriptions
   - Search for "pizza" or "hawaii" (case insensitive)
   - Filter by price range
   - View "Pizza of the Week" featured section

2. **Shopping Cart Functionality**
   - **Add to Cart**: Click "Add to Cart" from product list or detail page (saves to Orders table with Status='PENDING')
   - **View Cart**: Navigate to Cart to see all items (from pending orders)
   - **Update Cart**: Change quantities of items in cart
   - **Remove from Cart**: Remove individual items
   - **Checkout**: Place order (converts Status from 'PENDING' to 'COMPLETED')

3. **Product Details**
   - Click "View" to see detailed product information
   - Add items to cart from detail page with custom quantity

4. **Order History**
   - View personal orders (limited to user's orders)

## Troubleshooting

### Common Issues:
1. **"Database connection failed"**
   - Check SQL Server is running
   - Verify connection string in DBContext.java
   - Ensure JDBC driver is in lib folder

2. **"404 Not Found"**
   - Check Tomcat is running
   - Verify WAR file is deployed correctly
   - Check URL: `http://localhost:8080/PizzaStore`

3. **"Login failed"**
   - Use default credentials: admin/admin123
   - Check database has sample data

4. **Compilation errors**
   - Ensure CATALINA_HOME is set
   - Check all dependencies are in classpath
   - Verify Java version compatibility

## Project Structure Overview
```
PizzaStore/
├── src/                    # Java source code
│   ├── controller/         # Servlets
│   ├── model/             # Data models
│   ├── dao/               # Database access
│   └── utils/             # Utilities
├── WebContent/            # Web resources
│   ├── WEB-INF/          # Web configuration
│   └── *.jsp             # JSP pages
├── database.sql          # Database creation script
└── README.md            # Full documentation
```

## Next Steps
- Read the full README.md for detailed documentation
- Customize the database connection settings
- Add your own products and test the functionality
- Explore the code structure to understand MVC2 architecture

Happy coding! 🍕