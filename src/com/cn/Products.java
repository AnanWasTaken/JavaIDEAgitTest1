package com.cn;

public class Products {
    private int productID;        // 对应 ProductID（自增主键）
    private String productName;   // 对应 ProductName
    private String category;   // 对应 Category
    private float price;         // 匹配 DECIMAL(18,2) → double
    private int stock;            // 对应 Stock
    private int categoryID;       // 外键 CategoryID
    private int merchantID;       // 外键 MerchantID


    // 标准Getter/Setter（属性名与数据库列名一致）
    public int getProductID() {
        return productID;
    }
    public void setProductID(int productID) {
        this.productID = productID;
    }
    public String getProductName() {
        return productName;
    }
    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public float getPrice() {
        return price;
    }

    public void setPrice(float price) {
        this.price = price;
    }

    public int getStock() {
        return stock;
    }

    public void setStock(int stock) {
        this.stock = stock;
    }

    public int getCategoryID() {
        return categoryID;
    }

    public void setCategoryID(int categoryID) {
        this.categoryID = categoryID;
    }

    public int getMerchantID() {
        return merchantID;
    }

    public void setMerchantID(int merchantID) {
        this.merchantID = merchantID;
    }
}
