<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>PizzaStore - Product Detail</title>
    </head>
    <body>
        <h1>Product Detail</h1>
        
        <div>
            <a href="MainController?action=home">Home</a> | 
            <a href="MainController?action=products">Products</a> | 
            <a href="MainController?action=orders">Orders</a>
            <c:if test="${sessionScope.account != null && !sessionScope.account.staff}">
                | <a href="MainController?action=viewCart">Cart</a>
            </c:if>
            <c:if test="${sessionScope.account != null && sessionScope.account.staff}">
                | <a href="MainController?action=salesReport">Sales Report</a>
            </c:if>
        </div>
        
        <c:if test="${not empty product}">
            <div style="margin-top: 20px;">
                <table border="1" style="width: 100%; max-width: 800px;">
                    <tr>
                        <td rowspan="8" style="width: 300px; text-align: center;">
                            <c:if test="${not empty product.productImage}">
                                <img src="${product.productImage}" alt="${product.productName}" 
                                     style="max-width: 280px; max-height: 280px;">
                            </c:if>
                            <c:if test="${empty product.productImage}">
                                <div style="width: 280px; height: 280px; background-color: #f0f0f0; 
                                           display: flex; align-items: center; justify-content: center;">
                                    No Image
                                </div>
                            </c:if>
                        </td>
                        <td><strong>Product Name:</strong></td>
                        <td>${product.productName}</td>
                    </tr>
                    <tr>
                        <td><strong>Product ID:</strong></td>
                        <td>${product.productID}</td>
                    </tr>
                    <tr>
                        <td><strong>Price:</strong></td>
                        <td style="color: red; font-size: 18px; font-weight: bold;">$${product.unitPrice}</td>
                    </tr>
                    <tr>
                        <td><strong>Category ID:</strong></td>
                        <td>${product.categoryID}</td>
                    </tr>
                    <tr>
                        <td><strong>Supplier ID:</strong></td>
                        <td>${product.supplierID}</td>
                    </tr>
                    <tr>
                        <td><strong>Quantity Per Unit:</strong></td>
                        <td>${product.quantityPerUnit}</td>
                    </tr>
                    <tr>
                        <td><strong>Pizza of the Week:</strong></td>
                        <td>
                            <c:if test="${product.pizzaOfTheWeek}">
                                <span style="color: red; font-weight: bold;">★ YES</span>
                            </c:if>
                            <c:if test="${!product.pizzaOfTheWeek}">
                                No
                            </c:if>
                        </td>
                    </tr>
                    <tr>
                        <td><strong>Description:</strong></td>
                        <td>${product.description}</td>
                    </tr>
                </table>
                
                <c:if test="${sessionScope.account != null && !sessionScope.account.staff}">
                    <div style="margin-top: 20px;">
                        <h3>Add to Cart</h3>
                        <form action="MainController" method="post">
                            <input type="hidden" name="action" value="addToCart">
                            <input type="hidden" name="productID" value="${product.productID}">
                            <label for="quantity">Quantity:</label>
                            <input type="number" name="quantity" value="1" min="1" max="10" required>
                            <input type="submit" value="Add to Cart" style="background-color: #4CAF50; color: white; padding: 10px 20px; border: none; cursor: pointer;">
                        </form>
                    </div>
                </c:if>
                
                <c:if test="${sessionScope.account != null && sessionScope.account.staff}">
                    <div style="margin-top: 20px;">
                        <a href="MainController?action=editProduct&id=${product.productID}" 
                           style="background-color: #2196F3; color: white; padding: 10px 20px; text-decoration: none;">Edit Product</a>
                        <a href="MainController?action=deleteProduct&id=${product.productID}" 
                           onclick="return confirm('Are you sure you want to delete this product?')"
                           style="background-color: #f44336; color: white; padding: 10px 20px; text-decoration: none; margin-left: 10px;">Delete Product</a>
                    </div>
                </c:if>
            </div>
        </c:if>
        
        <c:if test="${empty product}">
            <p>Product not found.</p>
        </c:if>
        
        <div style="margin-top: 20px;">
            <a href="MainController?action=products">← Back to Products</a>
        </div>
    </body>
</html>