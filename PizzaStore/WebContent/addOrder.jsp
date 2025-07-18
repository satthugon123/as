<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>PizzaStore - Create Order</title>
        <script>
            function addProductRow() {
                const table = document.getElementById('productTable');
                const row = table.insertRow(-1);
                
                row.innerHTML = `
                    <td>
                        <select name="productID" required>
                            <option value="">Select Product</option>
                            <c:forEach var="product" items="${products}">
                                <option value="${product.productID}" data-price="${product.unitPrice}">
                                    ${product.productName} - $<fmt:formatNumber value="${product.unitPrice}" pattern="#,##0.00"/>
                                </option>
                            </c:forEach>
                        </select>
                    </td>
                    <td>
                        <input type="number" name="quantity" min="1" value="1" required onchange="updatePrice(this)">
                    </td>
                    <td>
                        <input type="number" name="unitPrice" step="0.01" readonly>
                    </td>
                    <td>
                        <span class="totalPrice">$0.00</span>
                    </td>
                    <td>
                        <button type="button" onclick="removeRow(this)">Remove</button>
                    </td>
                `;
                
                // Add event listener to product select
                const select = row.querySelector('select[name="productID"]');
                select.addEventListener('change', function() {
                    const price = this.options[this.selectedIndex].getAttribute('data-price');
                    const unitPriceInput = row.querySelector('input[name="unitPrice"]');
                    unitPriceInput.value = price || 0;
                    updatePrice(row.querySelector('input[name="quantity"]'));
                });
            }
            
            function removeRow(button) {
                button.closest('tr').remove();
                updateGrandTotal();
            }
            
            function updatePrice(quantityInput) {
                const row = quantityInput.closest('tr');
                const unitPrice = parseFloat(row.querySelector('input[name="unitPrice"]').value) || 0;
                const quantity = parseInt(quantityInput.value) || 0;
                const total = unitPrice * quantity;
                
                row.querySelector('.totalPrice').textContent = '$' + total.toFixed(2);
                updateGrandTotal();
            }
            
            function updateGrandTotal() {
                const totalElements = document.querySelectorAll('.totalPrice');
                let grandTotal = 0;
                
                totalElements.forEach(element => {
                    const value = parseFloat(element.textContent.replace('$', '').replace(',', '')) || 0;
                    grandTotal += value;
                });
                
                document.getElementById('grandTotal').textContent = '$' + grandTotal.toFixed(2);
            }
        </script>
    </head>
    <body>
        <h1>Create New Order</h1>
        
        <div>
            <a href="MainController?action=home">Home</a> | 
            <a href="MainController?action=products">Products</a> | 
            <a href="MainController?action=orders">Orders</a> | 
            <a href="MainController?action=viewCart">Cart</a>
        </div>
        
        <c:if test="${not empty sessionScope.message}">
            <div style="color: green; margin: 10px 0;">
                ${sessionScope.message}
                <c:remove var="message" scope="session"/>
            </div>
        </c:if>
        
        <c:if test="${not empty sessionScope.error}">
            <div style="color: red; margin: 10px 0;">
                ${sessionScope.error}
                <c:remove var="error" scope="session"/>
            </div>
        </c:if>
        
        <form action="MainController" method="post" style="margin-top: 20px;">
            <input type="hidden" name="action" value="doAddOrder">
            
            <div style="margin-bottom: 20px;">
                <h3>Create Order for: ${sessionScope.account.fullName}</h3>
                <p>You can create a direct order without using the cart.</p>
            </div>
            
            <div style="margin-bottom: 20px;">
                <h3>Order Items</h3>
                <table id="productTable" border="1" style="width: 100%;">
                    <thead>
                        <tr>
                            <th>Product</th>
                            <th>Quantity</th>
                            <th>Unit Price</th>
                            <th>Total Price</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>
                                <select name="productID" required>
                                    <option value="">Select Product</option>
                                    <c:forEach var="product" items="${products}">
                                        <option value="${product.productID}" data-price="${product.unitPrice}">
                                            ${product.productName} - $<fmt:formatNumber value="${product.unitPrice}" pattern="#,##0.00"/>
                                        </option>
                                    </c:forEach>
                                </select>
                            </td>
                            <td>
                                <input type="number" name="quantity" min="1" value="1" required onchange="updatePrice(this)">
                            </td>
                            <td>
                                <input type="number" name="unitPrice" step="0.01" readonly>
                            </td>
                            <td>
                                <span class="totalPrice">$0.00</span>
                            </td>
                            <td>
                                <button type="button" onclick="removeRow(this)">Remove</button>
                            </td>
                        </tr>
                    </tbody>
                </table>
                
                <div style="margin-top: 10px;">
                    <button type="button" onclick="addProductRow()">Add Product</button>
                </div>
                
                <div style="margin-top: 20px; text-align: right;">
                    <h3>Grand Total: <span id="grandTotal">$0.00</span></h3>
                </div>
            </div>
            
            <div>
                <button type="submit">Create Order</button>
                <button type="button" onclick="window.location.href='MainController?action=orders'">Cancel</button>
            </div>
        </form>
        
        <script>
            // Add event listeners to existing select elements
            document.querySelectorAll('select[name="productID"]').forEach(select => {
                select.addEventListener('change', function() {
                    const row = this.closest('tr');
                    const price = this.options[this.selectedIndex].getAttribute('data-price');
                    const unitPriceInput = row.querySelector('input[name="unitPrice"]');
                    unitPriceInput.value = price || 0;
                    updatePrice(row.querySelector('input[name="quantity"]'));
                });
            });
        </script>
    </body>
</html>