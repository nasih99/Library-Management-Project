# Library Management System (SQL Project)

## 📚 Project Overview

The **Library Management System** is a SQL-based project designed to efficiently manage book inventory, member records, book issuance, returns, fines, and branch performance. This project demonstrates the use of **DDL, DML, Stored Procedures, Joins, CTAS, Grouping, Aggregate Functions, and Advanced SQL Concepts** to build a real-world database system.

## 🚀 Key Features

* **Branch & Employee Management**
* **Book Inventory Control (Status: Available/Issued)**
* **Member Registration & Tracking**
* **Issue & Return Status Logging**
* **Stored Procedures for Automation**
* **Performance Reports & Fine Calculation**
* **CTAS for Summary Tables & Insights**

## 🛠️ Technologies Used

* **Database:** MySQL
* **Techniques:** Joins, CTAS, Views, Stored Procedures, Aggregate Functions

## 📂 Database Schema

* **branch** – Stores branch and manager details
* **employees** – Employee information linked to branches
* **books** – Book metadata and availability
* **members** – Registered library users
* **issued_status** – Issued book records
* **return_status** – Return records with book quality

## ✅ Major SQL Tasks Implemented

### 🔹 CRUD Operations

* Add new books
* Update member details
* Delete issued records

### 🔹 Data Analysis Queries

* Most issued books
* Income by category
* Active members in last 2 months
* Top-performing employees
* Overdue books and fine calculation

### 🔹 CTAS (Create Table As Select)

* `book_issued_cnt`: Count of books issued per title
* `branch_report`: Revenue and performance summary
* `active_members`: Members active in last 2 months

### 🔹 Stored Procedures

**1. issue_book** – Checks availability and issues books automatically
**2. add_return_records** – Updates book status upon return and logs quality

## 📊 Sample Reports

| Report             | Details Included                    |
| ------------------ | ----------------------------------- |
| Branch Performance | Issued books, returns, revenue      |
| Overdue Books      | Member, book, issued days overdue   |
| High-Risk Books    | Members who frequently damage books |

## 💡 Highlights

* Real-world library workflows automated using SQL
* Accurate tracking of issued and returned books
* Fine calculation for overdue books at **$0.50 per day**
* Proper relational integrity using foreign keys

## 📌 Future Enhancements

* User roles (Admin, Member)
* Integration with a web interface
* Email reminder system for overdue books

## 🧑‍💻 How to Use

1. Run the SQL scripts sequentially
2. Populate tables with sample data
3. Call stored procedures to test functionality
4. Use CTAS queries to generate analytical reports

---

### 📞 Contact & Contribution

For any suggestions or improvements, feel free to contribute or contact the developer.

**This project is an excellent demonstration of SQL competency and real-world database design.**

