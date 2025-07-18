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
        String sql = "SELECT * FROM Orders";
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
        String sql = "SELECT * FROM Orders WHERE CustomerID = ?";
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
    
    public int createOrderFromCart(int accountID, List<model.CartItem> cartItems) {
        String orderSql = "INSERT INTO Orders (CustomerID, OrderDate, RequiredDate, ShippedDate, Freight, ShipAddress) VALUES (?, ?, ?, ?, ?, ?)";
        String detailSql = "INSERT INTO OrderDetails (OrderID, ProductID, UnitPrice, Quantity) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DBContext.getConnection()) {
            conn.setAutoCommit(false);
            
            // Create order
            try (PreparedStatement orderPs = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS)) {
                orderPs.setInt(1, accountID);
                orderPs.setDate(2, new java.sql.Date(System.currentTimeMillis()));
                orderPs.setDate(3, new java.sql.Date(System.currentTimeMillis() + 7 * 24 * 60 * 60 * 1000L));
                orderPs.setDate(4, null);
                orderPs.setDouble(5, 5.0);
                orderPs.setString(6, "Customer Address");
                
                int result = orderPs.executeUpdate();
                if (result > 0) {
                    ResultSet rs = orderPs.getGeneratedKeys();
                    if (rs.next()) {
                        int orderID = rs.getInt(1);
                        
                        // Add order details
                        try (PreparedStatement detailPs = conn.prepareStatement(detailSql)) {
                            for (model.CartItem item : cartItems) {
                                detailPs.setInt(1, orderID);
                                detailPs.setInt(2, item.getProductID());
                                detailPs.setDouble(3, item.getUnitPrice());
                                detailPs.setInt(4, item.getQuantity());
                                detailPs.addBatch();
                            }
                            detailPs.executeBatch();
                        }
                        
                        conn.commit();
                        return orderID;
                    }
                }
            }
            conn.rollback();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
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