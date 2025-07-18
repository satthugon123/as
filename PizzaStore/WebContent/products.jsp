<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>PizzaStore - Products</title>
    </head>
    <body>
        <h1>Products Management</h1>
        
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
        
        <div>
            <h2>Search Products</h2>
            <form action="MainController" method="get">
                <input type="hidden" name="action" value="searchProducts">
                <table>
                    <tr>
                        <td>Product Name:</td>
                        <td><input type="text" name="keyword" value="${keyword}"></td>
                    </tr>
                    <tr>
                        <td>Min Price:</td>
                        <td><input type="number" step="0.01" name="minPrice" value="${minPrice}"></td>
                    </tr>
                    <tr>
                        <td>Max Price:</td>
                        <td><input type="number" step="0.01" name="maxPrice" value="${maxPrice}"></td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <input type="submit" value="Search">
                            <a href="MainController?action=products">Clear</a>
                        </td>
                    </tr>
                </table>
            </form>
        </div>
        
        <c:if test="${sessionScope.account != null && sessionScope.account.staff}">
            <div>
                <h2>Product Management</h2>
                <a href="MainController?action=addProduct">Add New Product</a>
            </div>
        </c:if>
        
        <div>
            <h2>Product List</h2>
            <c:if test="${not empty products}">
                <table border="1">
                    <tr>
                        <th>Product ID</th>
                        <th>Product Name</th>
                        <th>Supplier ID</th>
                        <th>Category ID</th>
                        <th>Quantity Per Unit</th>
                        <th>Unit Price</th>
                        <th>Description</th>
                        <th>Pizza of Week</th>
                        <th>Product Image</th>
                        <th>Actions</th>
                    </tr>
                    <c:forEach var="product" items="${products}">
                        <tr>
                            <td>${product.productID}</td>
                            <td>${product.productName}</td>
                            <td>${product.supplierID}</td>
                            <td>${product.categoryID}</td>
                            <td>${product.quantityPerUnit}</td>
                            <td>$${product.unitPrice}</td>
                            <td>${product.description}</td>
                            <td>
                                <c:if test="${product.pizzaOfTheWeek}">
                                    <span style="color: red; font-weight: bold;">★ YES</span>
                                </c:if>
                                <c:if test="${!product.pizzaOfTheWeek}">
                                    No
                                </c:if>
                            </td>
                            <td>
                                <c:if test="${not empty product.productImage}">
                                    <img src="${product.productImage}" alt="${product.productName}" width="50" height="50">
                                </c:if>
                            </td>
                            <td>
                                <a href="MainController?action=viewProductDetail&id=${product.productID}">View</a>
                                <c:if test="${sessionScope.account != null && !sessionScope.account.staff}">
                                    | <a href="MainController?action=addToCart&productID=${product.productID}&quantity=1">Add to Cart</a>
                                </c:if>
                                <c:if test="${sessionScope.account != null && sessionScope.account.staff}">
                                    | <a href="MainController?action=editProduct&id=${product.productID}">Edit</a>
                                    | <a href="MainController?action=deleteProduct&id=${product.productID}" 
                                       onclick="return confirm('Are you sure you want to delete this product?')">Delete</a>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </table>
            </c:if>
            <c:if test="${empty products}">
                <p>No products found.</p>
            </c:if>
        </div>
    </body>
</html>