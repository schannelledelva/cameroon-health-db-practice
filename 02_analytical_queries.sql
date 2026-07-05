USE CameroonHealthDB;
GO

-- ============================================================================
-- Q1. Calculating regional average costs
-- Build a query that returns the RegionName and the average Cost_CFA for each 
-- region. Sort the final output from highest cost to lowest.
-- ============================================================================
SELECT 
    r.RegionName, 
    AVG(f.Cost_CFA) AS Avg_Consultation_Cost
FROM Dim_Regions r
JOIN Dim_Patients p ON r.RegionID = p.HomeRegionID
JOIN Fact_Consultations f ON p.PatientID = f.PatientID
GROUP BY r.RegionName
ORDER BY Avg_Consultation_Cost DESC;


-- ============================================================================
-- Q2. Top 3 reported symptoms
-- Write a query to find the top 3 most frequently reported symptoms across all 
-- clinic visits. Display only the SymptomName and the total count.
-- ============================================================================
SELECT TOP 3 
    s.SymptomName, 
    COUNT(*) AS Report_Count
FROM Dim_Symptoms s
JOIN Bridge_Consultation_Symptoms bs ON s.SymptomID = bs.SymptomID
GROUP BY s.SymptomName
ORDER BY Report_Count DESC;


-- ============================================================================
-- Q3. Cost variance per facility using window functions
-- Create a CTE that calculates the average malaria test cost for each facility. 
-- Then, query the CTE to show the cost difference for each individual visit.
-- ============================================================================
WITH FacilityAverages AS (
    SELECT 
        df.FacilityName, 
        fc.ConsultationID, 
        fc.Cost_CFA,
        AVG(fc.Cost_CFA) OVER(PARTITION BY df.FacilityName) AS Avg_Cost   
    FROM Fact_Consultations fc
    JOIN Dim_Facilities df ON fc.FacilityID = df.FacilityID
    WHERE fc.LabTestPerformed = 'Malaria Rapid/Smear'
)
SELECT 
    FacilityName,
    ConsultationID,
    Cost_CFA,
    Avg_Cost AS Facility_Average_Cost,
    (Cost_CFA - Avg_Cost) AS Cost_Variance
FROM FacilityAverages
ORDER BY Cost_Variance DESC;


-- ============================================================================
-- Q4. Handling NULL diagnostic names
-- Write a query using COALESCE to display all consultations. If LabTestPerformed 
-- is blank (NULL), replace it with the text 'Test Name Not Recorded'.
-- ============================================================================
SELECT 
    ConsultationID, 
    LabResult, 
    COALESCE(LabTestPerformed, 'Test Name Not Recorded') AS Cleaned_Test_Name
FROM Fact_Consultations;


-- ============================================================================
-- Q5. Finding total consultations per facility using LEFT JOIN
-- Write a query to display all FacilityNames from Dim_Facilities alongside the 
-- total count of consultations recorded for each. Use COALESCE to display 0 
-- instead of NULL if a facility has no records.
-- ============================================================================
SELECT 
    df.FacilityName,
    COALESCE(COUNT(fc.ConsultationID), 0) AS Total_Consultations
FROM Dim_Facilities df
LEFT JOIN Fact_Consultations fc ON df.FacilityID = fc.FacilityID
GROUP BY df.FacilityName
ORDER BY Total_Consultations ASC;
