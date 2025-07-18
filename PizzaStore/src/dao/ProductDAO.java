package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Product;
import utils.DBContext;

public class ProductDAO {
    
    public List<Product> getAllProducts() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM Products";
        try (Connection conn = DBContext.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Product product = new Product();
                product.setProductID(rs.getInt("ProductID"));
                product.setProductName(rs.getString("ProductName"));
                product.setSupplierID(rs.getInt("SupplierID"));
                product.setCategoryID(rs.getInt("CategoryID"));
                product.setQuantityPerUnit(rs.getInt("QuantityPerUnit"));
                product.setUnitPrice(rs.getDouble("UnitPrice"));
                product.setProductImage(rs.getString("ProductImage"));
                product.setDescription(rs.getString("Description"));
                product.setPizzaOfTheWeek(rs.getBoolean("IsPizzaOfTheWeek"));
                products.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }
    
    public Product getProductById(int productID) {
        String sql = "SELECT * FROM Products WHERE ProductID = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, productID);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Product product = new Product();
                product.setProductID(rs.getInt("ProductID"));
                product.setProductName(rs.getString("ProductName"));
                product.setSupplierID(rs.getInt("SupplierID"));
                product.setCategoryID(rs.getInt("CategoryID"));
                product.setQuantityPerUnit(rs.getInt("QuantityPerUnit"));
                product.setUnitPrice(rs.getDouble("UnitPrice"));
                product.setProductImage(rs.getString("ProductImage"));
                product.setDescription(rs.getString("Description"));
                product.setPizzaOfTheWeek(rs.getBoolean("IsPizzaOfTheWeek"));
                return product;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public List<Product> searchProducts(String keyword, Double minPrice, Double maxPrice) {
        List<Product> products = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM Products WHERE 1=1");
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND LOWER(ProductName) LIKE LOWER(?)");
        }
        if (minPrice != null) {
            sql.append(" AND UnitPrice >= ?");
        }
        if (maxPrice != null) {
            sql.append(" AND UnitPrice <= ?");
        }
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            int paramIndex = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setString(paramIndex++, "%" + keyword + "%");
            }
            if (minPrice != null) {
                ps.setDouble(paramIndex++, minPrice);
            }
            if (maxPrice != null) {
                ps.setDouble(paramIndex++, maxPrice);
            }
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Product product = new Product();
                product.setProductID(rs.getInt("ProductID"));
                product.setProductName(rs.getString("ProductName"));
                product.setSupplierID(rs.getInt("SupplierID"));
                product.setCategoryID(rs.getInt("CategoryID"));
                product.setQuantityPerUnit(rs.getInt("QuantityPerUnit"));
                product.setUnitPrice(rs.getDouble("UnitPrice"));
                product.setProductImage(rs.getString("ProductImage"));
                product.setDescription(rs.getString("Description"));
                product.setPizzaOfTheWeek(rs.getBoolean("IsPizzaOfTheWeek"));
                products.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }
    
    public boolean addProduct(Product product) {
        String sql = "INSERT INTO Products (ProductName, SupplierID, CategoryID, QuantityPerUnit, UnitPrice, ProductImage, Description, IsPizzaOfTheWeek) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, product.getProductName());
            ps.setInt(2, product.getSupplierID());
            ps.setInt(3, product.getCategoryID());
            ps.setInt(4, product.getQuantityPerUnit());
            ps.setDouble(5, product.getUnitPrice());
            ps.setString(6, product.getProductImage());
            ps.setString(7, product.getDescription());
            ps.setBoolean(8, product.isPizzaOfTheWeek());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean updateProduct(Product product) {
        String sql = "UPDATE Products SET ProductName = ?, SupplierID = ?, CategoryID = ?, QuantityPerUnit = ?, UnitPrice = ?, ProductImage = ?, Description = ?, IsPizzaOfTheWeek = ? WHERE ProductID = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, product.getProductName());
            ps.setInt(2, product.getSupplierID());
            ps.setInt(3, product.getCategoryID());
            ps.setInt(4, product.getQuantityPerUnit());
            ps.setDouble(5, product.getUnitPrice());
            ps.setString(6, product.getProductImage());
            ps.setString(7, product.getDescription());
            ps.setBoolean(8, product.isPizzaOfTheWeek());
            ps.setInt(9, product.getProductID());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean deleteProduct(int productID) {
        String sql = "DELETE FROM Products WHERE ProductID = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, productID);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}