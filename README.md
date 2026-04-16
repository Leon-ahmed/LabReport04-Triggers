# Faculty Trigger Lab (MySQL)

## Overview

This project demonstrates the use of **MySQL triggers** to automate salary updates and maintain a log of salary changes. It uses two tables: `EMPLOYEE` and `SALARY_LOG`.

---

## Database Setup

* Database Name: `faculty_trigger_lab`
* Tables:

  * `EMPLOYEE`
  * `SALARY_LOG`

---

## Table Description

### EMPLOYEE

Stores employee information and salary details.

* `EmpID` – Primary Key
* `EmpName` – Employee name
* `BasicSalary` – Original salary
* `StartDate` – Joining date
* `NoOfPub` – Number of publications
* `IncrementRate` – Percentage increase applied
* `UpdatedSalary` – Final salary after increment

---

### SALARY_LOG

Stores records of salary updates.

* `LogID` – Primary Key (Auto Increment)
* `EmpID` – Foreign Key
* `OldSalary` – Previous salary
* `NewSalary` – Updated salary
* `ChangedAt` – Timestamp of change
* `Note` – Description of update

---

## Trigger Logic

### Salary Update Policy

Salary is updated automatically based on:

* **20% increase** → if duration > 1 year and publications > 4
* **10% increase** → if duration > 1 year and publications = 2 or 3
* **5% increase** → if duration > 1 year and publications = 1
* **0% increase** → otherwise

---

### Triggers Used

1. **BEFORE UPDATE Trigger**

   * Calculates job duration
   * Sets `IncrementRate`
   * Updates `UpdatedSalary`

2. **AFTER UPDATE Trigger**

   * Detects salary changes
   * Stores old and new salary in `SALARY_LOG`

---

## Sample Data

At least 8 employee records are inserted to test different conditions of the policy.

---

## Testing

Updates are performed on multiple employees to verify:

* All increment cases (20%, 10%, 5%, 0%)
* Proper logging of salary changes

---

## How to Run

1. Open MySQL (XAMPP/phpMyAdmin or CLI)
2. Run the SQL script step by step:

   * Create database and tables
   * Insert data
   * Create triggers
   * Run update queries
3. Execute:

   ```sql
   SELECT * FROM EMPLOYEE;
   SELECT * FROM SALARY_LOG;
   ```

---

## Expected Outcome

* Salaries are updated automatically based on defined rules
* Every salary change is recorded in `SALARY_LOG` with timestamp

---
