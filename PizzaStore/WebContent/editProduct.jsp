<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>PizzaStore - Edit Product</title>
    </head>
    <body>
        <h1>Edit Product</h1>
        
        <div>
            <a href="MainController?action=home">Home</a> | 
            <a href="MainController?action=products">Products</a> | 
            <a href="MainController?action=orders">Orders</a>
        </div>
        
        <c:if test="${not empty error}">
            <div style="color: red;">
                <p>${error}</p>
            </div>
        </c:if>
        
        <c:if test="${not empty product}">
            <form action="MainController" method="post">
                <input type="hidden" name="action" value="doEditProduct">
                <input type="hidden" name="productID" value="${product.productID}">
                <table>
                    <tr>
                        <td>Product ID:</td>
                        <td>${product.productID}</td>
                    </tr>
                    <tr>
                        <td>Product Name:</td>
                        <td><input type="text" name="productName" value="${product.productName}" required></td>
                    </tr>
                    <tr>
                        <td>Supplier ID:</td>
                        <td><input type="number" name="supplierID" value="${product.supplierID}" required></td>
                    </tr>
                    <tr>
                        <td>Category ID:</td>
                        <td><input type="number" name="categoryID" value="${product.categoryID}" required></td>
                    </tr>
                    <tr>
                        <td>Quantity Per Unit:</td>
                        <td><input type="number" name="quantityPerUnit" value="${product.quantityPerUnit}" required></td>
                    </tr>
                    <tr>
                        <td>Unit Price:</td>
                        <td><input type="number" step="0.01" name="unitPrice" value="${product.unitPrice}" required></td>
                    </tr>
                    <tr>
                        <td>Product Image URL:</td>
                        <td><input type="text" name="productImage" value="${product.productImage}"></td>
                    </tr>
                    <tr>
                        <td>Description:</td>
                        <td><textarea name="description" rows="3" cols="50">${product.description}</textarea></td>
                    </tr>
                    <tr>
                        <td>Pizza of the Week:</td>
                        <td><input type="checkbox" name="isPizzaOfTheWeek" value="true" ${product.pizzaOfTheWeek ? 'checked' : ''}></td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <input type="submit" value="Update Product">
                            <a href="MainController?action=products">Cancel</a>
                        </td>
                    </tr>
                </table>
            </form>
        </c:if>
        
        <c:if test="${empty product}">
            <p>Product not found.</p>
            <a href="MainController?action=products">Back to Products</a>
        </c:if>
    </body>
</html>