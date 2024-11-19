# Walmart Sales Analysis

## Overview
This project performs a detailed analysis of Walmart's sales data to uncover insights that can help improve business performance. The analysis covers several key aspects, such as sales growth, customer segmentation, payment preferences, and product profitability. The following SQL queries and tasks are executed to achieve this:

- Identifying top-performing branches by sales growth.
- Finding the most profitable product lines for each branch.
- Segmenting customers based on their spending behavior.
- Detecting anomalies in sales transactions.
- Analyzing the most popular payment methods by city.
- Understanding the sales distribution between male and female customers.
- Identifying the best product line for each customer type.
- Detecting repeat customers who made purchases within a short timeframe.
- Analyzing top customers by sales volume.
- Investigating sales trends based on the day of the week.

## Table Schema
The dataset used for the analysis is stored in the `WalmartSalesData` table with the following columns:

| Column Name              | Data Type        | Description                                           |
|--------------------------|------------------|-------------------------------------------------------|
| `InvoiceID`              | VARCHAR(20)      | Unique identifier for each sale transaction.          |
| `Branch`                 | VARCHAR(5)       | The branch where the sale occurred.                   |
| `City`                   | VARCHAR(50)      | The city where the branch is located.                 |
| `CustomerType`           | VARCHAR(20)      | Type of customer (e.g., Member, Normal).              |
| `Gender`                 | VARCHAR(10)      | Gender of the customer.                               |
| `ProductLine`            | VARCHAR(100)     | The product line of the sold item.                    |
| `UnitPrice`              | DECIMAL(10, 2)   | Price of a single unit of the product.                |
| `Quantity`               | INT              | Quantity of the product sold.                         |
| `Tax5Percent`            | DECIMAL(10, 2)   | Tax applied at 5% rate.                               |
| `Total`                  | DECIMAL(15, 2)   | Total sales amount including tax.                      |
| `SaleDate`               | DATE             | Date when the sale occurred.                          |
| `SaleTime`               | TIME             | Time when the sale occurred.                          |
| `Payment`                | VARCHAR(20)      | Payment method used by the customer.                  |
| `COGS`                   | DECIMAL(15, 2)   | Cost of Goods Sold.                                   |
| `GrossMarginPercentage`  | DECIMAL(5, 2)    | Gross margin percentage.                              |
| `GrossIncome`            | DECIMAL(15, 2)   | Gross income from the sale.                           |
| `Rating`                 | DECIMAL(10, 2)   | Rating of the product by the customer.                |

## SQL Queries and Analysis Tasks

### Task 1: Identifying the Top Branch by Sales Growth Rate
This query calculates the sales growth rate for each branch over time and identifies the branch with the highest sales growth.

### Task 2: Finding the Most Profitable Product Line for Each Branch
Identifies which product line contributes the highest profit to each branch based on the difference between gross income and COGS.

### Task 3: Analyzing Customer Segmentation Based on Spending
Classifies customers into three tiers (High, Medium, and Low spenders) based on their total spending.

### Task 4: Detecting Anomalies in Sales Transactions
Identifies anomalies in sales transactions by calculating the Z-score for each sale, flagging transactions that are significantly higher or lower than the average for a product line.

### Task 5: Most Popular Payment Method by City
Determines the most popular payment method in each city based on the frequency of each payment method.

### Task 6: Monthly Sales Distribution by Gender
Analyzes sales by gender on a monthly basis to understand sales trends across male and female customers.

### Task 7: Best Product Line by Customer Type
Identifies the most preferred product lines for different customer types (e.g., Member vs. Normal).

### Task 8: Identifying Repeat Customers
Detects customers who made repeat purchases within a specific timeframe (30 days).

### Task 9: Finding Top 5 Customers by Sales Volume
Identifies the top 5 customers who have generated the most sales revenue.

### Task 10: Analyzing Sales Trends by Day of the Week
Analyzes sales patterns to determine which day of the week generates the highest sales.

## How to Run the Queries

1. **Set up the Database**: First, create the `WalmartSalesData` table and populate it with the relevant data.
2. **Run the SQL Queries**: Execute each query individually in your SQL environment to generate the results for each task.

## Prerequisites
- A PostgreSQL database environment.
- The `WalmartSalesData` dataset populated with sales data.

## Conclusion
This project provides key insights into Walmart's sales performance, customer behavior, and trends across various dimensions. The analysis can help guide strategic decisions to improve business outcomes such as product offerings, marketing strategies, and customer engagement.

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
