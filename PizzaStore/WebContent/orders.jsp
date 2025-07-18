<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>PizzaStore - Orders</title>
    </head>
    <body>
        <h1>Orders Management</h1>
        
        <div>
            <a href="MainController?action=home">Home</a> | 
            <a href="MainController?action=products">Products</a> | 
            <a href="MainController?action=orders">Orders</a>
            <c:if test="${sessionScope.account != null && sessionScope.account.staff}">
                | <a href="MainController?action=salesReport">Sales Report</a>
            </c:if>
        </div>
        
        <c:if test="${sessionScope.account == null}">
            <p>Please <a href="MainController?action=login">login</a> to view orders.</p>
        </c:if>
        
        <c:if test="${sessionScope.account != null}">
            <div>
                <h2>
                    <c:if test="${sessionScope.account.staff}">All Orders</c:if>
                    <c:if test="${!sessionScope.account.staff}">My Orders</c:if>
                </h2>
                
                <c:if test="${not empty orders}">
                    <table border="1">
                        <tr>
                            <th>Order ID</th>
                            <th>Customer ID</th>
                            <th>Order Date</th>
                            <th>Required Date</th>
                            <th>Shipped Date</th>
                            <th>Freight</th>
                            <th>Ship Address</th>
                            <c:if test="${sessionScope.account.staff}">
                                <th>Actions</th>
                            </c:if>
                        </tr>
                        <c:forEach var="order" items="${orders}">
                            <tr>
                                <td>${order.orderID}</td>
                                <td>${order.customerID}</td>
                                <td><fmt:formatDate value="${order.orderDate}" pattern="yyyy-MM-dd"/></td>
                                <td><fmt:formatDate value="${order.requiredDate}" pattern="yyyy-MM-dd"/></td>
                                <td>
                                    <c:if test="${order.shippedDate != null}">
                                        <fmt:formatDate value="${order.shippedDate}" pattern="yyyy-MM-dd"/>
                                    </c:if>
                                    <c:if test="${order.shippedDate == null}">
                                        Not shipped
                                    </c:if>
                                </td>
                                <td>$${order.freight}</td>
                                <td>${order.shipAddress}</td>
                                <c:if test="${sessionScope.account.staff}">
                                    <td>
                                        <a href="MainController?action=editOrder&id=${order.orderID}">Edit</a> |
                                        <a href="MainController?action=deleteOrder&id=${order.orderID}" 
                                           onclick="return confirm('Are you sure you want to delete this order?')">Delete</a>
                                    </td>
                                </c:if>
                            </tr>
                        </c:forEach>
                    </table>
                </c:if>
                
                <c:if test="${empty orders}">
                    <p>No orders found.</p>
                </c:if>
            </div>
        </c:if>
    </body>
</html>