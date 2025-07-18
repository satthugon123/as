<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>PizzaStore - Register</title>
    </head>
    <body>
        <h1>Register for PizzaStore</h1>
        
        <div>
            <a href="MainController?action=home">Home</a> | 
            <a href="MainController?action=login">Login</a>
        </div>
        
        <c:if test="${not empty error}">
            <div style="color: red;">
                <p>${error}</p>
            </div>
        </c:if>
        
        <form action="MainController" method="post">
            <input type="hidden" name="action" value="doRegister">
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
                    <td>Full Name:</td>
                    <td><input type="text" name="fullName" required></td>
                </tr>
                <tr>
                    <td>Account Type:</td>
                    <td>
                        <select name="type" required>
                            <option value="2">Normal User</option>
                            <option value="1">Staff</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <input type="submit" value="Register">
                    </td>
                </tr>
            </table>
        </form>
        
        <p>Already have an account? <a href="MainController?action=login">Login here</a></p>
    </body>
</html>