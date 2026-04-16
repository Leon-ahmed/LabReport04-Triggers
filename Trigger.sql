DROP DATABASE  IF EXISTS faculty_trigger_lab;
CREATE DATABASE faculty_trigger_lab;
USE faculty_trigger_lab;

CREATE TABLE EMPLOYEE (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(100) NOT NULL,
    BasicSalary DECIMAL(10,2) NOT NULL,
    StartDate DATE NOT NULL,
    NoOfPub INT NOT NULL CHECK (NoOfPub >= 0),
    IncrementRate DECIMAL(5,2) DEFAULT 0,
    UpdatedSalary DECIMAL(10,2)
);

CREATE TABLE SALARY_LOG (
    LogID INT AUTO_INCREMENT PRIMARY KEY,
    EmpID INT,
    OldSalary DECIMAL(10,2),
    NewSalary DECIMAL(10,2),
    ChangedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    Note VARCHAR(100),
    FOREIGN KEY (EmpID) REFERENCES EMPLOYEE(EmpID)
);



INSERT INTO EMPLOYEE (EmpID, EmpName, BasicSalary, StartDate, NoOfPub)
VALUES
(1, 'Rahim', 30000, '2022-01-10', 5),
(2, 'Karim', 28000, '2023-02-15', 3),
(3, 'Jamal', 25000, '2024-06-01', 1),
(4, 'Sumi', 32000, '2021-03-20', 0),
(5, 'Nadia', 27000, '2022-07-11', 2),
(6, 'Hasan', 35000, '2020-05-25', 6),
(7, 'Tania', 26000, '2025-01-01', 1),
(8, 'Rafi', 29000, '2023-08-18', 4);




DELIMITER $$

CREATE TRIGGER trg_before_update_salary
BEFORE UPDATE ON EMPLOYEE
FOR EACH ROW
BEGIN
    DECLARE duration INT;

    SET duration = TIMESTAMPDIFF(YEAR, NEW.StartDate, CURDATE());

    IF duration > 1 AND NEW.NoOfPub > 4 THEN
        SET NEW.IncrementRate = 20;
    ELSEIF duration > 1 AND NEW.NoOfPub IN (2,3) THEN
        SET NEW.IncrementRate = 10;
    ELSEIF duration > 1 AND NEW.NoOfPub = 1 THEN
        SET NEW.IncrementRate = 5;
    ELSE
        SET NEW.IncrementRate = 0;
    END IF;

    SET NEW.UpdatedSalary = NEW.BasicSalary + (NEW.BasicSalary * NEW.IncrementRate / 100);
END$$

DELIMITER ;


DELIMITER $$

CREATE TRIGGER trg_after_update_salary
AFTER UPDATE ON EMPLOYEE
FOR EACH ROW
BEGIN
    IF OLD.UpdatedSalary <> NEW.UpdatedSalary THEN
        INSERT INTO SALARY_LOG (EmpID, OldSalary, NewSalary, Note)
        VALUES (
            NEW.EmpID,
            OLD.UpdatedSalary,
            NEW.UpdatedSalary,
            'Salary updated based on policy'
        );
    END IF;
END$$

DELIMITER ;


UPDATE EMPLOYEE SET NoOfPub = 5 WHERE EmpID = 1; -- 20%
UPDATE EMPLOYEE SET NoOfPub = 3 WHERE EmpID = 2; -- 10%
UPDATE EMPLOYEE SET NoOfPub = 1 WHERE EmpID = 3; -- 5%
UPDATE EMPLOYEE SET NoOfPub = 0 WHERE EmpID = 4; -- 0%




SELECT * FROM EMPLOYEE;

SELECT * FROM SALARY_LOG;