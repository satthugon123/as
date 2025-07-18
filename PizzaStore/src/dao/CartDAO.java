package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.CartItem;
import utils.DBContext;

public class CartDAO {
    
    public List<CartItem> getCartByUser(int accountID) {
        List<CartItem> cartItems = new ArrayList<>();
        String sql = "SELECT c.*, p.ProductName, p.ProductImage FROM Cart c " +
                     "JOIN Products p ON c.ProductID = p.ProductID " +
                     "WHERE c.AccountID = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, accountID);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                CartItem item = new CartItem();
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
    
    public boolean addToCart(int accountID, int productID, double unitPrice, int quantity) {
        // Check if item already exists
        String checkSql = "SELECT Quantity FROM Cart WHERE AccountID = ? AND ProductID = ?";
        String updateSql = "UPDATE Cart SET Quantity = Quantity + ? WHERE AccountID = ? AND ProductID = ?";
        String insertSql = "INSERT INTO Cart (AccountID, ProductID, UnitPrice, Quantity) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DBContext.getConnection()) {
            // Check if item exists
            try (PreparedStatement checkPs = conn.prepareStatement(checkSql)) {
                checkPs.setInt(1, accountID);
                checkPs.setInt(2, productID);
                ResultSet rs = checkPs.executeQuery();
                
                if (rs.next()) {
                    // Update existing item
                    try (PreparedStatement updatePs = conn.prepareStatement(updateSql)) {
                        updatePs.setInt(1, quantity);
                        updatePs.setInt(2, accountID);
                        updatePs.setInt(3, productID);
                        return updatePs.executeUpdate() > 0;
                    }
                } else {
                    // Insert new item
                    try (PreparedStatement insertPs = conn.prepareStatement(insertSql)) {
                        insertPs.setInt(1, accountID);
                        insertPs.setInt(2, productID);
                        insertPs.setDouble(3, unitPrice);
                        insertPs.setInt(4, quantity);
                        return insertPs.executeUpdate() > 0;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean updateCartItem(int accountID, int productID, int quantity) {
        if (quantity <= 0) {
            return removeFromCart(accountID, productID);
        }
        
        String sql = "UPDATE Cart SET Quantity = ? WHERE AccountID = ? AND ProductID = ?";
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
    
    public boolean removeFromCart(int accountID, int productID) {
        String sql = "DELETE FROM Cart WHERE AccountID = ? AND ProductID = ?";
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
    
    public boolean clearCart(int accountID) {
        String sql = "DELETE FROM Cart WHERE AccountID = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, accountID);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public double getCartTotal(int accountID) {
        String sql = "SELECT SUM(UnitPrice * Quantity) as Total FROM Cart WHERE AccountID = ?";
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
    
    public int getCartItemCount(int accountID) {
        String sql = "SELECT COUNT(*) as ItemCount FROM Cart WHERE AccountID = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, accountID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("ItemCount");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}