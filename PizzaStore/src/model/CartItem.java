package model;

public class CartItem {
    private int productID;
    private String productName;
    private double unitPrice;
    private int quantity;
    private String productImage;
    
    public CartItem() {}
    
    public CartItem(int productID, String productName, double unitPrice, int quantity, String productImage) {
        this.productID = productID;
        this.productName = productName;
        this.unitPrice = unitPrice;
        this.quantity = quantity;
        this.productImage = productImage;
    }
    
    // Getters and Setters
    public int getProductID() { return productID; }
    public void setProductID(int productID) { this.productID = productID; }
    
    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }
    
    public double getUnitPrice() { return unitPrice; }
    public void setUnitPrice(double unitPrice) { this.unitPrice = unitPrice; }
    
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    
    public String getProductImage() { return productImage; }
    public void setProductImage(String productImage) { this.productImage = productImage; }
    
    public double getTotalPrice() { return unitPrice * quantity; }
}