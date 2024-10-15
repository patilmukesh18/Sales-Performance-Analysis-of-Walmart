CREATE TABLE WalmartSalesData (
    InvoiceID VARCHAR(20),                
    Branch VARCHAR(5),                    
    City VARCHAR(50),                     
    CustomerType VARCHAR(20),             
    Gender VARCHAR(10),                   
    ProductLine VARCHAR(100),             
    UnitPrice DECIMAL(10, 2),             
    Quantity INT,                         
    Tax5Percent DECIMAL(10, 2),           
    Total DECIMAL(15, 2),                 
    SaleDate DATE,                        
    SaleTime TIME,                        
    Payment VARCHAR(20),                  
    COGS DECIMAL(15, 2),                  
    GrossMarginPercentage DECIMAL(5, 2),  
    GrossIncome DECIMAL(15, 2),           
    Rating DECIMAL(10, 2)                  
);

select * from WalmartSalesData;
select count(*) from WalmartSalesData;


-- Task 1: Identifying the Top Branch by Sales Growth Rate (6 Marks)
-- Walmart wants to identify which branch has exhibited the highest sales growth over time. Analyze the total sales
-- for each branch and compare the growth rate across months to find the top performer.

WITH SalesByPeriod AS (
    SELECT 
        branch,
        DATE_TRUNC('month', saleDate) AS SaleMonth, 
        SUM(total) AS TotalSales
    FROM 
        WalmartSalesData
    GROUP BY 
        Branch, DATE_TRUNC('month', SaleDate)
),
SalesGrowth AS (
    SELECT 
        Branch,
        SaleMonth,
        TotalSales,
        LAG(TotalSales) OVER (PARTITION BY Branch ORDER BY SaleMonth) AS PreviousMonthSales
    FROM 
        SalesByPeriod
),
GrowthRates AS (
    SELECT 
        Branch,
        SaleMonth,
        TotalSales,
        (TotalSales - PreviousMonthSales) / PreviousMonthSales * 100 AS SalesGrowthRate
    FROM 
        SalesGrowth
    WHERE 
        PreviousMonthSales IS NOT NULL
)
SELECT 
    Branch,
    MAX(SalesGrowthRate) AS MaxGrowthRate
FROM 
    GrowthRates
GROUP BY 
    Branch
ORDER BY 
    MaxGrowthRate DESC
LIMIT 1;  

-- Task 2: Finding the Most Profitable Product Line for Each Branch (6 Marks)
-- Walmart needs to determine which product line contributes the highest profit to each branch.The profit margin
-- should be calculated based on the difference between the gross income and cost of goods sold.
WITH ProfitData AS (
    SELECT 
        Branch,
        ProductLine,
        SUM(GrossIncome) AS Profit,
        ROW_NUMBER() OVER (PARTITION BY Branch ORDER BY SUM(GrossIncome - COGS) DESC) AS rn
    FROM 
        WalmartSalesData
    GROUP BY 
        Branch, ProductLine
)
SELECT 
    Branch,
    ProductLine,
    Profit
FROM 
    ProfitData
WHERE rn = 1;
-- Task 3: Analyzing Customer Segmentation Based on Spending (6 Marks)
-- Walmart wants to segment customers based on their average spending behavior. Classify customers into three
-- tiers: High, Medium, and Low spenders based on their total purchase amounts.
WITH CustomerSpending AS (
    SELECT 
        InvoiceID,  
        SUM(Total) AS TotalSpending
    FROM 
        WalmartSalesData
    GROUP BY 
        InvoiceID
),
SpendingPercentile AS (
    SELECT 
        InvoiceID,
        TotalSpending,
        NTILE(4) OVER (ORDER BY TotalSpending DESC) AS SpendingTier 
    FROM 
        CustomerSpending
)
SELECT 
    InvoiceID,
    TotalSpending,
    CASE 
        WHEN SpendingTier = 1 THEN 'High Spender'
        WHEN SpendingTier = 2 OR SpendingTier = 3 THEN 'Medium Spender'
        ELSE 'Low Spender'
    END AS CustomerTier
FROM 
    SpendingPercentile;

-- Task 4: Detecting Anomalies in Sales Transactions (6 Marks)
-- Walmart suspects that some transactions have unusually high or low sales compared to the average for the
-- product line. Identify these anomalies.

WITH ProductLineStats AS (
    SELECT 
        ProductLine,
        AVG(Total) AS AvgTotal,
        STDDEV(Total) AS StdDevTotal
    FROM 
        WalmartSalesData
    GROUP BY 
        ProductLine
),
SalesWithZScore AS (
    SELECT 
        w.InvoiceID,
        w.Branch,
        w.ProductLine,
        w.Total,
        p.AvgTotal,
        p.StdDevTotal,
        (w.Total - p.AvgTotal) / p.StdDevTotal AS ZScore
    FROM 
        WalmartSalesData w
    JOIN 
        ProductLineStats p
    ON 
        w.ProductLine = p.ProductLine
)
SELECT 
    InvoiceID,
    Branch,
    ProductLine,
    Total,
    ZScore
FROM 
    SalesWithZScore
WHERE 
    ABS(ZScore) > 3;  -- Anomalies with Z-score > 3 or < -3

-- Task 5: Most Popular Payment Method by City (6 Marks)
-- Walmart needs to determine the most popular payment method in each city to tailor marketing strategies.
WITH PaymentCounts AS (
    SELECT 
        City,
        Payment,
        COUNT(*) AS PaymentCount
    FROM 
        WalmartSalesData
    GROUP BY 
        City, Payment
),
RankedPayments AS (
    SELECT 
        City,
        Payment,
        PaymentCount,
        ROW_NUMBER() OVER (PARTITION BY City ORDER BY PaymentCount DESC) AS rn
    FROM 
        PaymentCounts
)
SELECT 
    City,
    Payment AS MostPopularPaymentMethod,
    PaymentCount
FROM 
    RankedPayments
WHERE 
    rn = 1;

-- Task 6: Monthly Sales Distribution by Gender (6 Marks)
-- Walmart wants to understand the sales distribution between male and female customers on a monthly basis.
SELECT
    EXTRACT(YEAR FROM SaleDate) AS Year,
    EXTRACT(MONTH FROM SaleDate) AS Month,
    Gender,
    SUM(Total) AS TotalSales
FROM
    WalmartSalesData
GROUP BY
    EXTRACT(YEAR FROM SaleDate), 
    EXTRACT(MONTH FROM SaleDate),
    Gender
ORDER BY
    Year, Month, Gender;

-- Task 7: Best Product Line by Customer Type (6 Marks)
-- Walmart wants to know which product lines are preferred by different customer types(Member vs. Normal).
WITH ProductLineSales AS (
    SELECT 
        CustomerType,
        ProductLine,
        SUM(Total) AS TotalSales
    FROM 
        WalmartSalesData
    GROUP BY 
        CustomerType, ProductLine
),
RankedProductLines AS (
    SELECT 
        CustomerType,
        ProductLine,
        TotalSales,
        ROW_NUMBER() OVER (PARTITION BY CustomerType ORDER BY TotalSales DESC) AS rn
    FROM 
        ProductLineSales
)
SELECT 
    CustomerType,
    ProductLine AS BestProductLine,
    TotalSales
FROM 
    RankedProductLines
WHERE 
    rn = 1;

-- Task 8: Identifying Repeat Customers (6 Marks)
-- Walmart needs to identify customers who made repeat purchases within a specific time frame (e.g., within 30
-- days).
WITH CustomerPurchases AS (
    SELECT 
        InvoiceID,      
        SaleDate,
        ROW_NUMBER() OVER (PARTITION BY InvoiceID ORDER BY SaleDate) AS PurchaseOrder
    FROM 
        WalmartSalesData
),
RepeatCustomers AS (
    SELECT 
        c1.InvoiceID,
        c1.SaleDate AS FirstPurchaseDate,
        c2.SaleDate AS NextPurchaseDate,
        (c2.SaleDate - c1.SaleDate) AS DaysBetweenPurchases  -- Subtracting dates in PostgreSQL
    FROM 
        CustomerPurchases c1
    JOIN 
        CustomerPurchases c2
    ON 
        c1.InvoiceID = c2.InvoiceID
        AND c2.PurchaseOrder = c1.PurchaseOrder + 1  -- Compare consecutive purchases
)
SELECT 
    InvoiceID,
    FirstPurchaseDate,
    NextPurchaseDate,
    DaysBetweenPurchases
FROM 
    RepeatCustomers
WHERE 
    DaysBetweenPurchases <= 30;

-- Task 9: Finding Top 5 Customers by Sales Volume (6 Marks)
-- Walmart wants to reward its top 5 customers who have generated the most sales Revenue.

WITH CustomerSales AS (
    SELECT 
        InvoiceID,  
        SUM(Total) AS TotalSales
    FROM 
        WalmartSalesData
    GROUP BY 
        InvoiceID
)
SELECT 
    InvoiceID,
    TotalSales
FROM 
    CustomerSales
ORDER BY 
    TotalSales DESC
LIMIT 5;

-- Task 10: Analyzing Sales Trends by Day of the Week (6 Marks)
-- Walmart wants to analyze the sales patterns to determine which day of the week
-- brings the highest sales.
SELECT 
    TO_CHAR(SaleDate, 'Day') AS DayOfWeek, 
    SUM(Total) AS TotalSales
FROM 
    WalmartSalesData
GROUP BY 
    DayOfWeek
ORDER BY 
    TotalSales DESC;