<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>PizzaStore - All User Carts</title>
    </head>
    <body>
        <h1>All User Carts Management</h1>
        
        <div>
            <a href="MainController?action=home">Home</a> | 
            <a href="MainController?action=products">Products</a> | 
            <a href="MainController?action=orders">Orders</a> | 
            <a href="MainController?action=viewAllCarts">All Carts</a> | 
            <a href="MainController?action=salesReport">Sales Report</a>
        </div>
        
        <c:if test="${sessionScope.account == null || !sessionScope.account.staff}">
            <p>Access denied. Only staff members can view all carts.</p>
            <a href="MainController?action=login">Login</a>
        </c:if>
        
        <c:if test="${sessionScope.account != null && sessionScope.account.staff}">
            <div style="margin-top: 20px;">
                <h2>User Shopping Carts Overview</h2>
                
                <c:set var="hasActiveCarts" value="false"/>
                <c:forEach var="account" items="${accounts}">
                    <c:if test="${!account.staff}">
                        <c:set var="userCartItems" value="${allCarts[account.accountID]}"/>
                        <c:set var="userCartTotal" value="${cartTotals[account.accountID]}"/>
                        
                        <c:if test="${not empty userCartItems && userCartItems.size() > 0}">
                            <c:set var="hasActiveCarts" value="true"/>
                            <div style="border: 1px solid #ddd; margin: 20px 0; padding: 15px; border-radius: 5px;">
                                <h3 style="color: #333; margin-top: 0;">
                                    User: ${account.fullName} (${account.userName})
                                    <span style="color: #666; font-size: 14px;">- Account ID: ${account.accountID}</span>
                                </h3>
                                
                                <table border="1" style="width: 100%; margin-top: 10px;">
                                    <tr style="background-color: #f0f0f0;">
                                        <th>Product Image</th>
                                        <th>Product Name</th>
                                        <th>Unit Price</th>
                                        <th>Quantity</th>
                                        <th>Total Price</th>
                                    </tr>
                                    <c:forEach var="item" items="${userCartItems}">
                                        <tr>
                                            <td style="text-align: center;">
                                                <c:if test="${not empty item.productImage}">
                                                    <img src="${item.productImage}" alt="${item.productName}" 
                                                         width="50" height="50">
                                                </c:if>
                                            </td>
                                            <td>${item.productName}</td>
                                            <td>$<fmt:formatNumber value="${item.unitPrice}" pattern="#,##0.00"/></td>
                                            <td style="text-align: center; font-weight: bold;">${item.quantity}</td>
                                            <td style="text-align: right; font-weight: bold;">
                                                $<fmt:formatNumber value="${item.totalPrice}" pattern="#,##0.00"/>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <tr style="background-color: #e8f5e8; font-weight: bold;">
                                        <td colspan="4" style="text-align: right; padding: 10px;">
                                            Cart Total:
                                        </td>
                                        <td style="text-align: right; padding: 10px; color: #2e7d32;">
                                            $<fmt:formatNumber value="${userCartTotal}" pattern="#,##0.00"/>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </c:if>
                    </c:if>
                </c:forEach>
                
                <c:if test="${!hasActiveCarts}">
                    <div style="text-align: center; margin-top: 50px; padding: 30px; background-color: #f9f9f9; border-radius: 10px;">
                        <h3 style="color: #666;">No Active Carts</h3>
                        <p>Currently, no users have items in their shopping carts.</p>
                    </div>
                </c:if>
                
                <c:if test="${hasActiveCarts}">
                    <div style="margin-top: 30px; padding: 20px; background-color: #e3f2fd; border-radius: 10px;">
                        <h3 style="color: #1976d2; margin-top: 0;">Cart Summary</h3>
                        <c:set var="grandTotal" value="0"/>
                        <c:set var="totalUsers" value="0"/>
                        <c:set var="totalItems" value="0"/>
                        
                        <c:forEach var="account" items="${accounts}">
                            <c:if test="${!account.staff}">
                                <c:set var="userCartItems" value="${allCarts[account.accountID]}"/>
                                <c:set var="userCartTotal" value="${cartTotals[account.accountID]}"/>
                                
                                <c:if test="${not empty userCartItems && userCartItems.size() > 0}">
                                    <c:set var="totalUsers" value="${totalUsers + 1}"/>
                                    <c:set var="grandTotal" value="${grandTotal + userCartTotal}"/>
                                    <c:forEach var="item" items="${userCartItems}">
                                        <c:set var="totalItems" value="${totalItems + item.quantity}"/>
                                    </c:forEach>
                                </c:if>
                            </c:if>
                        </c:forEach>
                        
                        <table style="width: 100%; font-size: 16px;">
                            <tr>
                                <td style="padding: 5px;"><strong>Users with Active Carts:</strong></td>
                                <td style="text-align: right; padding: 5px;">${totalUsers}</td>
                            </tr>
                            <tr>
                                <td style="padding: 5px;"><strong>Total Items in All Carts:</strong></td>
                                <td style="text-align: right; padding: 5px;">${totalItems}</td>
                            </tr>
                            <tr style="border-top: 2px solid #1976d2;">
                                <td style="padding: 10px; font-size: 18px;"><strong>Grand Total Value:</strong></td>
                                <td style="text-align: right; padding: 10px; font-size: 18px; color: #1976d2;">
                                    <strong>$<fmt:formatNumber value="${grandTotal}" pattern="#,##0.00"/></strong>
                                </td>
                            </tr>
                        </table>
                    </div>
                </c:if>
            </div>
        </c:if>
    </body>
</html>