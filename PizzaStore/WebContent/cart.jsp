<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>PizzaStore - Shopping Cart</title>
    </head>
    <body>
        <h1>Shopping Cart</h1>
        
        <div>
            <a href="MainController?action=home">Home</a> | 
            <a href="MainController?action=products">Products</a> | 
            <a href="MainController?action=orders">Orders</a> | 
            <a href="MainController?action=viewCart">Cart</a>
        </div>
        
        <c:if test="${sessionScope.account == null}">
            <p>Please <a href="MainController?action=login">login</a> to view your cart.</p>
        </c:if>
        
        <c:if test="${sessionScope.account != null}">
            <div style="margin-top: 20px;">
                <c:if test="${not empty cart && cart.size() > 0}">
                    <table border="1" style="width: 100%;">
                        <tr>
                            <th>Product Image</th>
                            <th>Product Name</th>
                            <th>Unit Price</th>
                            <th>Quantity</th>
                            <th>Total Price</th>
                            <th>Actions</th>
                        </tr>
                        <c:forEach var="item" items="${cart}">
                            <tr>
                                <td style="text-align: center;">
                                    <c:if test="${not empty item.value.productImage}">
                                        <img src="${item.value.productImage}" alt="${item.value.productName}" 
                                             width="60" height="60">
                                    </c:if>
                                </td>
                                <td>${item.value.productName}</td>
                                <td>$<fmt:formatNumber value="${item.value.unitPrice}" pattern="#,##0.00"/></td>
                                <td>
                                    <form action="MainController" method="post" style="display: inline;">
                                        <input type="hidden" name="action" value="updateCart">
                                        <input type="hidden" name="productID" value="${item.value.productID}">
                                        <input type="number" name="quantity" value="${item.value.quantity}" 
                                               min="1" max="10" style="width: 60px;">
                                        <input type="submit" value="Update" style="padding: 5px 10px;">
                                    </form>
                                </td>
                                <td>$<fmt:formatNumber value="${item.value.totalPrice}" pattern="#,##0.00"/></td>
                                <td>
                                    <a href="MainController?action=removeFromCart&productID=${item.value.productID}" 
                                       onclick="return confirm('Are you sure you want to remove this item?')"
                                       style="color: red; text-decoration: none;">Remove</a>
                                </td>
                            </tr>
                        </c:forEach>
                        <tr style="font-weight: bold; background-color: #f0f0f0;">
                            <td colspan="4" style="text-align: right;">Total Amount:</td>
                            <td>$<fmt:formatNumber value="${totalAmount}" pattern="#,##0.00"/></td>
                            <td></td>
                        </tr>
                    </table>
                    
                    <div style="margin-top: 20px;">
                        <a href="MainController?action=products" 
                           style="background-color: #2196F3; color: white; padding: 10px 20px; text-decoration: none; margin-right: 10px;">Continue Shopping</a>
                        <a href="MainController?action=checkout" 
                           style="background-color: #4CAF50; color: white; padding: 10px 20px; text-decoration: none;"
                           onclick="return confirm('Are you sure you want to place this order?')">Checkout</a>
                    </div>
                </c:if>
                
                <c:if test="${empty cart || cart.size() == 0}">
                    <div style="text-align: center; margin-top: 50px;">
                        <h2>Your cart is empty</h2>
                        <p>Add some delicious pizzas to your cart!</p>
                        <a href="MainController?action=products" 
                           style="background-color: #4CAF50; color: white; padding: 15px 30px; text-decoration: none; font-size: 16px;">Browse Products</a>
                    </div>
                </c:if>
            </div>
        </c:if>
        
        <c:if test="${not empty message}">
            <div style="color: green; margin-top: 20px; padding: 10px; border: 1px solid green; background-color: #e8f5e8;">
                ${message}
            </div>
        </c:if>
        
        <c:if test="${not empty error}">
            <div style="color: red; margin-top: 20px; padding: 10px; border: 1px solid red; background-color: #fde8e8;">
                ${error}
            </div>
        </c:if>
    </body>
</html>