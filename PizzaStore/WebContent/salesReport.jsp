<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>PizzaStore - Sales Report</title>
    </head>
    <body>
        <h1>Sales Report</h1>
        
        <div>
            <a href="MainController?action=home">Home</a> | 
            <a href="MainController?action=products">Products</a> | 
            <a href="MainController?action=orders">Orders</a> | 
            <a href="MainController?action=salesReport">Sales Report</a>
        </div>
        
        <c:if test="${sessionScope.account == null || !sessionScope.account.staff}">
            <p>Access denied. Only staff members can view sales reports.</p>
            <a href="MainController?action=login">Login</a>
        </c:if>
        
        <c:if test="${sessionScope.account != null && sessionScope.account.staff}">
            <div>
                <h2>Generate Sales Report</h2>
                <form action="MainController" method="get">
                    <input type="hidden" name="action" value="salesReport">
                    <table>
                        <tr>
                            <td>Start Date:</td>
                            <td><input type="date" name="startDate" value="${startDate}" required></td>
                        </tr>
                        <tr>
                            <td>End Date:</td>
                            <td><input type="date" name="endDate" value="${endDate}" required></td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <input type="submit" value="Generate Report">
                            </td>
                        </tr>
                    </table>
                </form>
            </div>
            
            <c:if test="${not empty report}">
                <div>
                    <h2>Sales Report Results</h2>
                    <p>Period: ${startDate} to ${endDate}</p>
                    
                    <table border="1">
                        <tr>
                            <th>Order ID</th>
                            <th>Order Date</th>
                            <th>Product ID</th>
                            <th>Product Name</th>
                            <th>Quantity</th>
                            <th>Unit Price</th>
                            <th>Total Amount</th>
                        </tr>
                        <c:set var="grandTotal" value="0"/>
                        <c:forEach var="row" items="${report}">
                            <tr>
                                <td>${row[0]}</td>
                                <td><fmt:formatDate value="${row[1]}" pattern="yyyy-MM-dd"/></td>
                                <td>${row[2]}</td>
                                <td>${row[3]}</td>
                                <td>${row[4]}</td>
                                <td>$${row[5]}</td>
                                <td>$${row[6]}</td>
                            </tr>
                            <c:set var="grandTotal" value="${grandTotal + row[6]}"/>
                        </c:forEach>
                        <tr style="font-weight: bold;">
                            <td colspan="6">Grand Total:</td>
                            <td>$<fmt:formatNumber value="${grandTotal}" pattern="#,##0.00"/></td>
                        </tr>
                    </table>
                </div>
            </c:if>
            
            <c:if test="${empty report && not empty startDate && not empty endDate}">
                <div>
                    <h2>No Sales Data Found</h2>
                    <p>No sales data found for the period ${startDate} to ${endDate}.</p>
                </div>
            </c:if>
        </c:if>
    </body>
</html>