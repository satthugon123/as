package model;

public class Customer {
    private int customerID;
    private String password;
    private String contactName;
    private String address;
    private String phone;
    
    public Customer() {}
    
    public Customer(int customerID, String password, String contactName, String address, String phone) {
        this.customerID = customerID;
        this.password = password;
        this.contactName = contactName;
        this.address = address;
        this.phone = phone;
    }
    
    // Getters and Setters
    public int getCustomerID() { return customerID; }
    public void setCustomerID(int customerID) { this.customerID = customerID; }
    
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    
    public String getContactName() { return contactName; }
    public void setContactName(String contactName) { this.contactName = contactName; }
    
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
}