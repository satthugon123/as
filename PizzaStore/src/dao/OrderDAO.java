package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Order;
import model.OrderDetail;
import utils.DBContext;

public class OrderDAO {
    
    public List<Order> getAllOrders() {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM Orders WHERE Status = 'COMPLETED'";
        try (Connection conn = DBContext.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Order order = new Order();
                order.setOrderID(rs.getInt("OrderID"));
                order.setCustomerID(rs.getInt("CustomerID"));
                order.setOrderDate(rs.getDate("OrderDate"));
                order.setRequiredDate(rs.getDate("RequiredDate"));
                order.setShippedDate(rs.getDate("ShippedDate"));
                order.setFreight(rs.getDouble("Freight"));
                order.setShipAddress(rs.getString("ShipAddress"));
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }
    
    public List<Order> getOrdersByCustomer(int customerID) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM Orders WHERE CustomerID = ? AND Status = 'COMPLETED'";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, customerID);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Order order = new Order();
                order.setOrderID(rs.getInt("OrderID"));
                order.setCustomerID(rs.getInt("CustomerID"));
                order.setOrderDate(rs.getDate("OrderDate"));
                order.setRequiredDate(rs.getDate("RequiredDate"));
                order.setShippedDate(rs.getDate("ShippedDate"));
                order.setFreight(rs.getDouble("Freight"));
                order.setShipAddress(rs.getString("ShipAddress"));
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }
    
    public boolean addOrder(Order order) {
        String sql = "INSERT INTO Orders (CustomerID, OrderDate, RequiredDate, ShippedDate, Freight, ShipAddress) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, order.getCustomerID());
            ps.setDate(2, new java.sql.Date(order.getOrderDate().getTime()));
            ps.setDate(3, new java.sql.Date(order.getRequiredDate().getTime()));
            ps.setDate(4, order.getShippedDate() != null ? new java.sql.Date(order.getShippedDate().getTime()) : null);
            ps.setDouble(5, order.getFreight());
            ps.setString(6, order.getShipAddress());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    

    
    // Cart operations using Orders table
    public boolean addToCart(int accountID, int productID, double unitPrice, int quantity) {
        // Get or create pending order (cart)
        int pendingOrderID = getPendingOrderID(accountID);
        
        if (pendingOrderID == -1) {
            // Create new pending order
            pendingOrderID = createPendingOrder(accountID);
        }
        
        if (pendingOrderID > 0) {
            // Check if product already exists in cart
            if (updateExistingCartItem(pendingOrderID, productID, quantity)) {
                return true;
            } else {
                // Add new item to cart
                return addNewCartItem(pendingOrderID, productID, unitPrice, quantity);
            }
        }
        return false;
    }
    
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
    
    private boolean updateExistingCartItem(int orderID, int productID, int additionalQuantity) {
        String checkSql = "SELECT Quantity FROM OrderDetails WHERE OrderID = ? AND ProductID = ?";
        String updateSql = "UPDATE OrderDetails SET Quantity = Quantity + ? WHERE OrderID = ? AND ProductID = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement checkPs = conn.prepareStatement(checkSql)) {
            checkPs.setInt(1, orderID);
            checkPs.setInt(2, productID);
            ResultSet rs = checkPs.executeQuery();
            
            if (rs.next()) {
                // Item exists, update quantity
                try (PreparedStatement updatePs = conn.prepareStatement(updateSql)) {
                    updatePs.setInt(1, additionalQuantity);
                    updatePs.setInt(2, orderID);
                    updatePs.setInt(3, productID);
                    return updatePs.executeUpdate() > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    private boolean addNewCartItem(int orderID, int productID, double unitPrice, int quantity) {
        String sql = "INSERT INTO OrderDetails (OrderID, ProductID, UnitPrice, Quantity) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderID);
            ps.setInt(2, productID);
            ps.setDouble(3, unitPrice);
            ps.setInt(4, quantity);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Get cart items (pending order details)
    public List<model.CartItem> getCartItems(int accountID) {
        List<model.CartItem> cartItems = new ArrayList<>();
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
                model.CartItem item = new model.CartItem();
                item.setProductID(rs.getInt("ProductID"));
                item.setProductName(rs.getString("ProductName"));
                item.setUnitPrice(rs.getDouble("UnitPrice"));
                item.setQuantity(rs.getInt("Quantity"));
                item.setProductImage(rs.getString("ProductImage"));
                cartItems.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return cartItems;
    }
    
    // Update cart item quantity
    public boolean updateCartItem(int accountID, int productID, int quantity) {
        if (quantity <= 0) {
            return removeCartItem(accountID, productID);
        }
        
        String sql = "UPDATE od SET Quantity = ? " +
                     "FROM OrderDetails od " +
                     "JOIN Orders o ON od.OrderID = o.OrderID " +
                     "WHERE o.CustomerID = ? AND o.Status = 'PENDING' AND od.ProductID = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quantity);
            ps.setInt(2, accountID);
            ps.setInt(3, productID);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Remove item from cart
    public boolean removeCartItem(int accountID, int productID) {
        String sql = "DELETE od FROM OrderDetails od " +
                     "JOIN Orders o ON od.OrderID = o.OrderID " +
                     "WHERE o.CustomerID = ? AND o.Status = 'PENDING' AND od.ProductID = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, accountID);
            ps.setInt(2, productID);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Get cart total
    public double getCartTotal(int accountID) {
        String sql = "SELECT SUM(od.UnitPrice * od.Quantity) as Total " +
                     "FROM OrderDetails od " +
                     "JOIN Orders o ON od.OrderID = o.OrderID " +
                     "WHERE o.CustomerID = ? AND o.Status = 'PENDING'";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, accountID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getDouble("Total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }
    
    // Checkout: Convert pending order to completed
    public boolean checkoutCart(int accountID) {
        String sql = "UPDATE Orders SET Status = 'COMPLETED', RequiredDate = ?, Freight = ?, ShipAddress = ? " +
                     "WHERE CustomerID = ? AND Status = 'PENDING'";
        
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
    

    
    public boolean updateOrder(Order order) {
        String sql = "UPDATE Orders SET CustomerID = ?, OrderDate = ?, RequiredDate = ?, ShippedDate = ?, Freight = ?, ShipAddress = ? WHERE OrderID = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, order.getCustomerID());
            ps.setDate(2, new java.sql.Date(order.getOrderDate().getTime()));
            ps.setDate(3, new java.sql.Date(order.getRequiredDate().getTime()));
            ps.setDate(4, order.getShippedDate() != null ? new java.sql.Date(order.getShippedDate().getTime()) : null);
            ps.setDouble(5, order.getFreight());
            ps.setString(6, order.getShipAddress());
            ps.setInt(7, order.getOrderID());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean deleteOrder(int orderID) {
        String sql = "DELETE FROM Orders WHERE OrderID = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, orderID);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public List<OrderDetail> getOrderDetails(int orderID) {
        List<OrderDetail> details = new ArrayList<>();
        String sql = "SELECT * FROM OrderDetails WHERE OrderID = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, orderID);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                OrderDetail detail = new OrderDetail();
                detail.setOrderID(rs.getInt("OrderID"));
                detail.setProductID(rs.getInt("ProductID"));
                detail.setUnitPrice(rs.getDouble("UnitPrice"));
                detail.setQuantity(rs.getInt("Quantity"));
                details.add(detail);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return details;
    }
    
    public List<Object[]> getSalesReport(String startDate, String endDate) {
        List<Object[]> report = new ArrayList<>();
        String sql = "SELECT o.OrderID, o.OrderDate, od.ProductID, p.ProductName, od.Quantity, od.UnitPrice, " +
                     "(od.Quantity * od.UnitPrice) as TotalAmount " +
                     "FROM Orders o " +
                     "JOIN OrderDetails od ON o.OrderID = od.OrderID " +
                     "JOIN Products p ON od.ProductID = p.ProductID " +
                     "WHERE o.OrderDate BETWEEN ? AND ? " +
                     "ORDER BY TotalAmount DESC";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, startDate);
            ps.setString(2, endDate);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Object[] row = new Object[7];
                row[0] = rs.getInt("OrderID");
                row[1] = rs.getDate("OrderDate");
                row[2] = rs.getInt("ProductID");
                row[3] = rs.getString("ProductName");
                row[4] = rs.getInt("Quantity");
                row[5] = rs.getDouble("UnitPrice");
                row[6] = rs.getDouble("TotalAmount");
                report.add(row);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return report;
    }
}