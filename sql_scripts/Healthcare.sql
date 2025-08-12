CREATE DATABASE Healthcare;

ALTER TABLE Appointments
ADD CONSTRAINT FK_Appointments_Patients
FOREIGN KEY (PatientID) REFERENCES Patients(PatientID);
ALTER TABLE Appointments
ADD CONSTRAINT FK_Appointments_Doctors
FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID);

--------------------------------------------Business questions----------------------------------------------------------
--Q1) Medical Center KPI Overview ?
SELECT 
    (SELECT COUNT(*) FROM Appointments) AS TotalAppointments,
    (SELECT SUM(Revenue) FROM Revenues) AS TotalRevenues,
    (SELECT SUM(Amount) FROM Expenses) AS TotalExpenses,
    (SELECT COUNT(*) FROM Patients) AS TotalPatients,
    (SELECT COUNT(*) FROM Doctors) AS TotalDoctors,
    (SELECT SUM(Revenue) FROM Revenues) - (SELECT SUM(Amount) FROM Expenses) AS NetProfit
--------------------------------------------------------------------------------------------------------------------------
--Q2)  No-shows Rate ?
SELECT 
    ROUND(
        SUM(CASE WHEN Status = 'No-Show' THEN 1 ELSE 0 END) * 100.0 
        / NULLIF(COUNT(*), 0),
    2) AS NoShowRate
FROM Appointments;
--------------------------------------------------------------------------------------------------------------------------
 --Q3) Patient Attendance ? 
 SELECT 
    ROUND(
        SUM(CASE WHEN Status = 'Show' THEN 1 ELSE 0 END) * 100.0
        / NULLIF(COUNT(*), 0),
    2) AS AttendanceRate
FROM Appointments;
--------------------------------------------------------------------------------------------------------------------------
 --Q4) Busy Doctors ?
 SELECT 
    d.DoctorName,
    COUNT(*) AS TotalAppointments
FROM Appointments a
JOIN Doctors d ON a.DoctorID = d.DoctorID
GROUP BY d.DoctorName
ORDER BY TotalAppointments DESC;
--------------------------------------------------------------------------------------------------------------------------
 --Q5) Revenue Trends ?
SELECT 
    FORMAT([Date], 'yyyy-MM') AS YearMonth,  
    SUM(Revenue) AS TotalRevenue
FROM Revenues
GROUP BY FORMAT([Date], 'yyyy-MM')
ORDER BY YearMonth;
--------------------------------------------------------------------------------------------------------------------------
--Q6) Expense Trends ?
SELECT 
    FORMAT(Date, 'yyyy-MM') AS YearMonth,
    SUM(Amount) AS TotalExpenses
FROM Expenses
GROUP BY FORMAT(Date, 'yyyy-MM')
ORDER BY YearMonth;
--------------------------------------------------------------------------------------------------------------------------
 --Q7)  Returning Patients ?
SELECT 
    p.PatientID,
    p.[Name],
    COUNT(*) AS VisitCount
FROM Appointments a
JOIN Patients p ON a.PatientID = p.PatientID
GROUP BY p.PatientID, p.[Name]
HAVING COUNT(*) > 1
ORDER BY VisitCount DESC;
--------------------------------------------------------------------------------------------------------------------------
 --Q8) Specialty Performance ?
SELECT 
  a.Specialty,
  a.AppointmentCount,
  COALESCE(r.TotalRevenue, 0) AS TotalRevenue
FROM (
  SELECT Specialty, COUNT(*) AS AppointmentCount
  FROM Appointments
  GROUP BY Specialty
) AS a
LEFT JOIN (
  SELECT Specialty, SUM(Revenue) AS TotalRevenue
  FROM Revenues
  GROUP BY Specialty
) AS r
  ON a.Specialty = r.Specialty
ORDER BY TotalRevenue DESC;
--------------------------------------------------------------------------------------------------------------------------
 --Q9) Appointment Volume ?
 SELECT 
    FORMAT([Date], 'yyyy-MM') AS YearMonth,
    COUNT(*) AS AppointmentCount
FROM Appointments
GROUP BY FORMAT([Date], 'yyyy-MM')
ORDER BY YearMonth;
--------------------------------------------------------------------------------------------------------------------------
 --Q10) Patient Distribution by City ?
 SELECT 
    City,
    COUNT(*) AS PatientCount
FROM Patients
GROUP BY City
ORDER BY PatientCount DESC;
--------------------------------------------------------------------------------------------------------------------------
 --Q11) Major Expenses ?
 SELECT 
    Type,
    SUM(Amount) AS TotalExpenses
FROM Expenses
GROUP BY Type
ORDER BY TotalExpenses DESC;
--------------------------------------------------------------------------------------------------------------------------
 --Q12) Gender Distribution of Patients ?
SELECT 
    Gender,
    COUNT(*) AS NumberOfPatients
FROM Patients
GROUP BY Gender;
--------------------------------------------------------------------------------------------------------------------------
--Q13) Patient Distribution by Age Group ?
SELECT
  CASE
    WHEN Age < 20 THEN '<20'
    WHEN Age BETWEEN 20 AND 40 THEN '20-40'
    ELSE '40+'
  END AS AgeGroup,
  COUNT(*) AS PatientCount
FROM Patients
GROUP BY
  CASE
    WHEN Age < 20 THEN '<20'
    WHEN Age BETWEEN 20 AND 40 THEN '20-40'
    ELSE '40+'
  END;
--------------------------------------------------------------------------------------------------------------------------













