### Supply Chain Data Analysis Project

This project focuses on analyzing a supply chain system using the **Supply Chain CEL dataset**, which contains orders from January and February 2017. The dataset includes two CSV files: `canceled_test.csv` (for canceled orders) and `sales_test.csv` (for completed orders). The goal of this project is to perform data analysis to understand key aspects of the supply chain, such as order volume, cancellations, service levels, and ABC classification.

![banner-supply-chain-management-vector-illustration-concept-icon-with-management-analysis-plan-product-procurement-logistic-distribution-2RBW8J0_enhanced](https://github.com/user-attachments/assets/17740f6b-ecbe-4ff9-8d56-511350b47e77)

#### Dataset Overview
- **canceled_test.csv**: Contains information on canceled orders.
  - **Columns**: `ORDER_NO`, `DATE`, `LINE`, `CUSTOMER_NO`, `ITEM`, `NC_ORDER`, `NC_SHIP`
- **sales_test.csv**: Contains information on successfully fulfilled orders.
  - **Columns**: `ORDER_NO`, `DATE`, `LINE`, `CUSTOMER_NO`, `ITEM`, `NS_ORDER`, `NS_SHIP`
 
#### Original Dataset
I downloaded the dataset from Kaggle.
https://www.kaggle.com/datasets/annelee1/supply-chain-cel-dataset


#### Objectives
1. **Order Volume Analysis**: Analyze total orders and cancellations, both by volume and by time period.
2. **Service Level Calculation**: Calculate service levels for different customers based on the percentage of shipped items versus ordered items.
3. **ABC Classification**: Classify items into categories (A, B, C) based on their contribution to total sales.
4. **Customer Insights**: Understand customer behavior, including top customers, order trends, and cancellations.
5. **Cancellation Patterns**: Explore trends and patterns in order cancellations, such as cancellations by day of the week.

#### Analysis Techniques
- **SQL Queries**: Used to analyze and summarize the data, covering basic descriptive statistics, intermediate joins, and advanced analytics such as ABC classification and service level calculation.
  
#### Key Findings
- Understanding how frequently orders are canceled and which items are more likely to be canceled.
- Determining service level performance for different customers and identifying top performers.
- Performing an ABC classification to prioritize items based on sales volume.
- Identifying peak sales and cancellation days, helping the business make informed operational decisions.

#### Tools Used
- **SQL**: For querying and analyzing the dataset.
    
This project provides insights into supply chain performance and helps identify key areas for optimization in order management and customer service.
