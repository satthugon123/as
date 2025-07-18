<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>PizzaStore - Home</title>
    </head>
    <body>
        <h1>Welcome to PizzaStore</h1>
        
        <div>
            <c:if test="${sessionScope.account != null}">
                <p>Welcome, ${sessionScope.account.fullName}!</p>
                <a href="MainController?action=logout">Logout</a>
            </c:if>
            <c:if test="${sessionScope.account == null}">
                <a href="MainController?action=login">Login</a> | 
                <a href="MainController?action=register">Register</a>
            </c:if>
        </div>
        
        <div>
            <h2>Navigation</h2>
            <a href="MainController?action=home">Home</a> | 
            <a href="MainController?action=products">Products</a> | 
            <a href="MainController?action=orders">Orders</a>
            <c:if test="${sessionScope.account != null && !sessionScope.account.staff}">
                | <a href="MainController?action=viewCart">Cart</a>
            </c:if>
            <c:if test="${sessionScope.account != null && sessionScope.account.staff}">
                | <a href="MainController?action=viewAllCarts">All Carts</a>
                | <a href="MainController?action=salesReport">Sales Report</a>
                | <a href="MainController?action=addOrder">Add Order</a>
            </c:if>
        </div>
        
        <div>
            <h2>🍕 Pizza of the Week</h2>
            <c:set var="hasSpecialPizza" value="false"/>
            <c:if test="${not empty products}">
                <div style="display: flex; flex-wrap: wrap; gap: 20px; margin-top: 20px;">
                    <c:forEach var="product" items="${products}">
                        <c:if test="${product.pizzaOfTheWeek}">
                            <c:set var="hasSpecialPizza" value="true"/>
                            <div style="border: 2px solid #ff6b6b; padding: 15px; border-radius: 10px; max-width: 300px; background-color: #fff5f5;">
                                <div style="text-align: center;">
                                    <c:if test="${not empty product.productImage}">
                                        <img src="${product.productImage}" alt="${product.productName}" 
                                             style="width: 150px; height: 150px; object-fit: cover; border-radius: 8px;">
                                    </c:if>
                                </div>
                                <h3 style="color: #ff6b6b; margin: 10px 0;">${product.productName}</h3>
                                <p style="color: #666; font-size: 14px;">${product.description}</p>
                                <p style="font-size: 18px; font-weight: bold; color: #ff6b6b;">$${product.unitPrice}</p>
                                <div style="text-align: center;">
                                    <a href="MainController?action=viewProductDetail&id=${product.productID}" 
                                       style="background-color: #ff6b6b; color: white; padding: 8px 16px; text-decoration: none; border-radius: 5px; margin-right: 5px;">View Details</a>
                                    <c:if test="${sessionScope.account != null && !sessionScope.account.staff}">
                                        <a href="MainController?action=addToCart&productID=${product.productID}&quantity=1" 
                                           style="background-color: #4CAF50; color: white; padding: 8px 16px; text-decoration: none; border-radius: 5px;">Add to Cart</a>
                                    </c:if>
                                </div>
                            </div>
                        </c:if>
                    </c:forEach>
                </div>
            </c:if>
            
            <c:if test="${!hasSpecialPizza}">
                <p>No special pizzas this week.</p>
            </c:if>
            
            <div style="margin-top: 40px;">
                <h2>All Our Pizzas</h2>
                <c:if test="${not empty products}">
                    <table border="1" style="width: 100%;">
                        <tr>
                            <th>Product Name</th>
                            <th>Description</th>
                            <th>Unit Price</th>
                            <th>Image</th>
                            <th>Actions</th>
                        </tr>
                        <c:forEach var="product" items="${products}">
                            <tr>
                                <td style="font-weight: bold;">
                                    ${product.productName}
                                    <c:if test="${product.pizzaOfTheWeek}">
                                        <span style="color: red;">★</span>
                                    </c:if>
                                </td>
                                <td>${product.description}</td>
                                <td style="font-weight: bold; color: #ff6b6b;">$${product.unitPrice}</td>
                                <td style="text-align: center;">
                                    <c:if test="${not empty product.productImage}">
                                        <img src="${product.productImage}" alt="${product.productName}" width="80" height="80">
                                    </c:if>
                                </td>
                                <td style="text-align: center;">
                                    <a href="MainController?action=viewProductDetail&id=${product.productID}">View</a>
                                    <c:if test="${sessionScope.account != null && !sessionScope.account.staff}">
                                        | <a href="MainController?action=addToCart&productID=${product.productID}&quantity=1">Add to Cart</a>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </table>
                </c:if>
                <c:if test="${empty products}">
                    <p>No products available.</p>
                </c:if>
            </div>
        </div>
    </body>
</html>