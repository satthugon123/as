package model;

import java.util.Date;

public class Order {
    private int orderID;
    private int customerID;
    private Date orderDate;
    private Date requiredDate;
    private Date shippedDate;
    private double freight;
    private String shipAddress;
    
    public Order() {}
    
    public Order(int orderID, int customerID, Date orderDate, Date requiredDate, 
                 Date shippedDate, double freight, String shipAddress) {
        this.orderID = orderID;
        this.customerID = customerID;
        this.orderDate = orderDate;
        this.requiredDate = requiredDate;
        this.shippedDate = shippedDate;
        this.freight = freight;
        this.shipAddress = shipAddress;
    }
    
    // Getters and Setters
    public int getOrderID() { return orderID; }
    public void setOrderID(int orderID) { this.orderID = orderID; }
    
    public int getCustomerID() { return customerID; }
    public void setCustomerID(int customerID) { this.customerID = customerID; }
    
    public Date getOrderDate() { return orderDate; }
    public void setOrderDate(Date orderDate) { this.orderDate = orderDate; }
    
    public Date getRequiredDate() { return requiredDate; }
    public void setRequiredDate(Date requiredDate) { this.requiredDate = requiredDate; }
    
    public Date getShippedDate() { return shippedDate; }
    public void setShippedDate(Date shippedDate) { this.shippedDate = shippedDate; }
    
    public double getFreight() { return freight; }
    public void setFreight(double freight) { this.freight = freight; }
    
    public String getShipAddress() { return shipAddress; }
    public void setShipAddress(String shipAddress) { this.shipAddress = shipAddress; }
}