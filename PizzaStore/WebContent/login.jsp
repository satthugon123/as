<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>PizzaStore - Login</title>
    </head>
    <body>
        <h1>Login to PizzaStore</h1>
        
        <div>
            <a href="MainController?action=home">Home</a> | 
            <a href="MainController?action=register">Register</a>
        </div>
        
        <c:if test="${not empty error}">
            <div style="color: red;">
                <p>${error}</p>
            </div>
        </c:if>
        
        <form action="MainController" method="post">
            <input type="hidden" name="action" value="doLogin">
            <table>
                <tr>
                    <td>Username:</td>
                    <td><input type="text" name="username" required></td>
                </tr>
                <tr>
                    <td>Password:</td>
                    <td><input type="password" name="password" required></td>
                </tr>
                <tr>
                    <td colspan="2">
                        <input type="submit" value="Login">
                    </td>
                </tr>
            </table>
        </form>
        
        <p>Don't have an account? <a href="MainController?action=register">Register here</a></p>
    </body>
</html>