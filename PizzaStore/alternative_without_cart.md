# Alternative Implementation: No Cart Table

## Method 1: Using Orders with Status

### Database Schema:
```sql
-- Add Status column to Orders table
ALTER TABLE Orders ADD Status NVARCHAR(20) DEFAULT 'PENDING';
-- Status values: 'PENDING' = Cart, 'COMPLETED' = Actual Order

-- Add AccountID to OrderDetails for cart tracking
ALTER TABLE OrderDetails ADD AccountID INT;
ALTER TABLE OrderDetails ADD FOREIGN KEY (AccountID) REFERENCES Account(AccountID);
```

### Java Implementation:

#### Modified OrderDAO.java:
```java
public class OrderDAO {
    
    // Get cart items (pending orders)
    public List<OrderDetail> getCartItems(int accountID) {
        List<OrderDetail> cartItems = new ArrayList<>();
        String sql = "SELECT od.*, p.ProductName, p.ProductImage " +
                     "FROM OrderDetails od " +
                     "JOIN Orders o ON od.OrderID = o.OrderID " +
                     "JOIN Products p ON od.ProductID = p.ProductID " +
                     "WHERE o.CustomerID = ? AND o.Status = 'PENDING'";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, accountID);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                OrderDetail detail = new OrderDetail();
                detail.setOrderID(rs.getInt("OrderID"));
                detail.setProductID(rs.getInt("ProductID"));
                detail.setUnitPrice(rs.getDouble("UnitPrice"));
                detail.setQuantity(rs.getInt("Quantity"));
                // Add product info
                detail.setProductName(rs.getString("ProductName"));
                detail.setProductImage(rs.getString("ProductImage"));
                cartItems.add(detail);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return cartItems;
    }
    
    // Add to cart (create pending order)
    public boolean addToCart(int accountID, int productID, double unitPrice, int quantity) {
        // Check if user has pending order
        int pendingOrderID = getPendingOrderID(accountID);
        
        if (pendingOrderID == -1) {
            // Create new pending order
            pendingOrderID = createPendingOrder(accountID);
        }
        
        // Add item to order details
        String sql = "INSERT INTO OrderDetails (OrderID, ProductID, UnitPrice, Quantity, AccountID) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, pendingOrderID);
            ps.setInt(2, productID);
            ps.setDouble(3, unitPrice);
            ps.setInt(4, quantity);
            ps.setInt(5, accountID);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Get or create pending order
    private int getPendingOrderID(int accountID) {
        String sql = "SELECT OrderID FROM Orders WHERE CustomerID = ? AND Status = 'PENDING'";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, accountID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("OrderID");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }
    
    private int createPendingOrder(int accountID) {
        String sql = "INSERT INTO Orders (CustomerID, OrderDate, Status) VALUES (?, ?, 'PENDING')";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, accountID);
            ps.setDate(2, new java.sql.Date(System.currentTimeMillis()));
            
            int result = ps.executeUpdate();
            if (result > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }
    
    // Checkout: Convert pending order to completed
    public boolean checkout(int accountID) {
        String sql = "UPDATE Orders SET Status = 'COMPLETED', RequiredDate = ?, Freight = ?, ShipAddress = ? WHERE CustomerID = ? AND Status = 'PENDING'";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDate(1, new java.sql.Date(System.currentTimeMillis() + 7 * 24 * 60 * 60 * 1000L));
            ps.setDouble(2, 5.0);
            ps.setString(3, "Customer Address");
            ps.setInt(4, accountID);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
```

## Method 2: Using Session + Database on Checkout

### Java Implementation:
```java
public class SessionCartManager {
    
    // Add to session cart
    @SuppressWarnings("unchecked")
    public static void addToCart(HttpSession session, int productID, String productName, 
                                double unitPrice, int quantity, String productImage) {
        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new HashMap<>();
        }
        
        CartItem existingItem = cart.get(productID);
        if (existingItem != null) {
            existingItem.setQuantity(existingItem.getQuantity() + quantity);
        } else {
            CartItem newItem = new CartItem(productID, productName, unitPrice, quantity, productImage);
            cart.put(productID, newItem);
        }
        
        session.setAttribute("cart", cart);
    }
    
    // Convert session cart to database order
    @SuppressWarnings("unchecked")
    public static boolean checkout(HttpSession session, int accountID, OrderDAO orderDAO) {
        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
            return false;
        }
        
        // Create order
        Order order = new Order();
        order.setCustomerID(accountID);
        order.setOrderDate(new Date());
        order.setRequiredDate(new Date(System.currentTimeMillis() + 7 * 24 * 60 * 60 * 1000L));
        order.setFreight(5.0);
        order.setShipAddress("Customer Address");
        
        int orderID = orderDAO.createOrder(order);
        if (orderID > 0) {
            // Add order details
            for (CartItem item : cart.values()) {
                OrderDetail detail = new OrderDetail();
                detail.setOrderID(orderID);
                detail.setProductID(item.getProductID());
                detail.setUnitPrice(item.getUnitPrice());
                detail.setQuantity(item.getQuantity());
                orderDAO.addOrderDetail(detail);
            }
            
            // Clear cart
            session.removeAttribute("cart");
            return true;
        }
        return false;
    }
}
```

## Method 3: Using Browser LocalStorage

### JavaScript Implementation:
```javascript
// Cart management in browser
class CartManager {
    static addToCart(productID, productName, unitPrice, quantity, productImage) {
        let cart = JSON.parse(localStorage.getItem('cart')) || {};
        
        if (cart[productID]) {
            cart[productID].quantity += quantity;
        } else {
            cart[productID] = {
                productID: productID,
                productName: productName,
                unitPrice: unitPrice,
                quantity: quantity,
                productImage: productImage
            };
        }
        
        localStorage.setItem('cart', JSON.stringify(cart));
        this.updateCartDisplay();
    }
    
    static checkout() {
        let cart = JSON.parse(localStorage.getItem('cart')) || {};
        let cartItems = Object.values(cart);
        
        // Send to server
        fetch('MainController?action=checkoutFromBrowser', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(cartItems)
        }).then(response => {
            if (response.ok) {
                localStorage.removeItem('cart');
                window.location.href = 'MainController?action=orders';
            }
        });
    }
}
```

## Comparison:

| Method | Persistence | Complexity | Performance | Scalability |
|--------|------------|------------|-------------|-------------|
| Session Only | No | Low | High | Low |
| Orders+Status | Yes | Medium | Medium | High |
| LocalStorage | Yes | Low | High | Medium |
| Cookies | Limited | Low | Medium | Low |

## Recommendation:
- **For simple apps**: Session storage
- **For persistent cart**: Orders with Status (Method 1)
- **For offline capability**: LocalStorage + Server sync
- **For enterprise**: Dedicated Cart table (current implementation)