package controller;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.AccountDAO;
import dao.ProductDAO;
import dao.OrderDAO;
import model.Account;
import model.Product;
import model.Order;

@WebServlet(name = "MainController", urlPatterns = {"/MainController"})
public class MainController extends HttpServlet {
    
    private AccountDAO accountDAO = new AccountDAO();
    private ProductDAO productDAO = new ProductDAO();
    private OrderDAO orderDAO = new OrderDAO();
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        String action = request.getParameter("action");
        if (action == null) {
            action = "home";
        }
        
        switch (action) {
            case "home":
                showHome(request, response);
                break;
            case "login":
                showLogin(request, response);
                break;
            case "doLogin":
                doLogin(request, response);
                break;
            case "register":
                showRegister(request, response);
                break;
            case "doRegister":
                doRegister(request, response);
                break;
            case "logout":
                doLogout(request, response);
                break;
            case "products":
                showProducts(request, response);
                break;
            case "searchProducts":
                searchProducts(request, response);
                break;
            case "addProduct":
                showAddProduct(request, response);
                break;
            case "doAddProduct":
                doAddProduct(request, response);
                break;
            case "editProduct":
                showEditProduct(request, response);
                break;
            case "doEditProduct":
                doEditProduct(request, response);
                break;
            case "deleteProduct":
                doDeleteProduct(request, response);
                break;
            case "orders":
                showOrders(request, response);
                break;
            case "salesReport":
                showSalesReport(request, response);
                break;
            default:
                showHome(request, response);
                break;
        }
    }
    
    private void showHome(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Product> products = productDAO.getAllProducts();
        request.setAttribute("products", products);
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }
    
    private void showLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }
    
    private void doLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        Account account = accountDAO.login(username, password);
        if (account != null) {
            HttpSession session = request.getSession();
            session.setAttribute("account", account);
            response.sendRedirect("MainController?action=home");
        } else {
            request.setAttribute("error", "Invalid username or password");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
    
    private void showRegister(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }
    
    private void doRegister(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String fullName = request.getParameter("fullName");
        int type = Integer.parseInt(request.getParameter("type"));
        
        Account account = new Account(0, username, password, fullName, type);
        if (accountDAO.register(account)) {
            response.sendRedirect("MainController?action=login");
        } else {
            request.setAttribute("error", "Registration failed");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
    
    private void doLogout(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        session.invalidate();
        response.sendRedirect("MainController?action=home");
    }
    
    private void showProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Product> products = productDAO.getAllProducts();
        request.setAttribute("products", products);
        request.getRequestDispatcher("products.jsp").forward(request, response);
    }
    
    private void searchProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        String minPriceStr = request.getParameter("minPrice");
        String maxPriceStr = request.getParameter("maxPrice");
        
        Double minPrice = null;
        Double maxPrice = null;
        
        if (minPriceStr != null && !minPriceStr.trim().isEmpty()) {
            try {
                minPrice = Double.parseDouble(minPriceStr);
            } catch (NumberFormatException e) {
                // ignore
            }
        }
        
        if (maxPriceStr != null && !maxPriceStr.trim().isEmpty()) {
            try {
                maxPrice = Double.parseDouble(maxPriceStr);
            } catch (NumberFormatException e) {
                // ignore
            }
        }
        
        List<Product> products = productDAO.searchProducts(keyword, minPrice, maxPrice);
        request.setAttribute("products", products);
        request.setAttribute("keyword", keyword);
        request.setAttribute("minPrice", minPriceStr);
        request.setAttribute("maxPrice", maxPriceStr);
        request.getRequestDispatcher("products.jsp").forward(request, response);
    }
    
    private void showAddProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("addProduct.jsp").forward(request, response);
    }
    
    private void doAddProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String productName = request.getParameter("productName");
        int supplierID = Integer.parseInt(request.getParameter("supplierID"));
        int categoryID = Integer.parseInt(request.getParameter("categoryID"));
        int quantityPerUnit = Integer.parseInt(request.getParameter("quantityPerUnit"));
        double unitPrice = Double.parseDouble(request.getParameter("unitPrice"));
        String productImage = request.getParameter("productImage");
        
        Product product = new Product(0, productName, supplierID, categoryID, quantityPerUnit, unitPrice, productImage);
        if (productDAO.addProduct(product)) {
            response.sendRedirect("MainController?action=products");
        } else {
            request.setAttribute("error", "Failed to add product");
            request.getRequestDispatcher("addProduct.jsp").forward(request, response);
        }
    }
    
    private void showEditProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int productID = Integer.parseInt(request.getParameter("id"));
        Product product = productDAO.getProductById(productID);
        request.setAttribute("product", product);
        request.getRequestDispatcher("editProduct.jsp").forward(request, response);
    }
    
    private void doEditProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int productID = Integer.parseInt(request.getParameter("productID"));
        String productName = request.getParameter("productName");
        int supplierID = Integer.parseInt(request.getParameter("supplierID"));
        int categoryID = Integer.parseInt(request.getParameter("categoryID"));
        int quantityPerUnit = Integer.parseInt(request.getParameter("quantityPerUnit"));
        double unitPrice = Double.parseDouble(request.getParameter("unitPrice"));
        String productImage = request.getParameter("productImage");
        
        Product product = new Product(productID, productName, supplierID, categoryID, quantityPerUnit, unitPrice, productImage);
        if (productDAO.updateProduct(product)) {
            response.sendRedirect("MainController?action=products");
        } else {
            request.setAttribute("error", "Failed to update product");
            request.setAttribute("product", product);
            request.getRequestDispatcher("editProduct.jsp").forward(request, response);
        }
    }
    
    private void doDeleteProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int productID = Integer.parseInt(request.getParameter("id"));
        productDAO.deleteProduct(productID);
        response.sendRedirect("MainController?action=products");
    }
    
    private void showOrders(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");
        
        List<Order> orders;
        if (account != null && account.isStaff()) {
            orders = orderDAO.getAllOrders();
        } else if (account != null) {
            orders = orderDAO.getOrdersByCustomer(account.getAccountID());
        } else {
            orders = null;
        }
        
        request.setAttribute("orders", orders);
        request.getRequestDispatcher("orders.jsp").forward(request, response);
    }
    
    private void showSalesReport(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        
        if (startDate != null && endDate != null) {
            List<Object[]> report = orderDAO.getSalesReport(startDate, endDate);
            request.setAttribute("report", report);
        }
        
        request.setAttribute("startDate", startDate);
        request.setAttribute("endDate", endDate);
        request.getRequestDispatcher("salesReport.jsp").forward(request, response);
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
    
    @Override
    public String getServletInfo() {
        return "Main Controller for PizzaStore";
    }
}