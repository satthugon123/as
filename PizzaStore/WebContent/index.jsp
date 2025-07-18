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
            <c:if test="${sessionScope.account != null && sessionScope.account.staff}">
                | <a href="MainController?action=salesReport">Sales Report</a>
            </c:if>
        </div>
        
        <div>
            <h2>Featured Pizzas</h2>
            <c:if test="${not empty products}">
                <table border="1">
                    <tr>
                        <th>Product ID</th>
                        <th>Product Name</th>
                        <th>Unit Price</th>
                        <th>Image</th>
                    </tr>
                    <c:forEach var="product" items="${products}">
                        <tr>
                            <td>${product.productID}</td>
                            <td>${product.productName}</td>
                            <td>$${product.unitPrice}</td>
                            <td>
                                <c:if test="${not empty product.productImage}">
                                    <img src="${product.productImage}" alt="${product.productName}" width="100" height="100">
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
    </body>
</html>