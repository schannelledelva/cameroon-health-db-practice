USE CameroonHealthDB;
GO

CREATE PROCEDURE sp_GetRegionalPeakTraffic 
    @TargetRegionName VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    WITH MonthlyRevenue AS (
        SELECT 
            df.FacilityName AS HospitalName, 
            dr.RegionName,
            MONTH(fc.ConsultationDate) AS MonthNumber, 
            COUNT(fc.ConsultationID) AS TotalVisits,
            SUM(fc.Cost_CFA) AS TotalRevenue   
        FROM Fact_Consultations fc
        JOIN Dim_Facilities df ON fc.FacilityID = df.FacilityID
        JOIN Dim_Regions dr ON df.RegionID = dr.RegionID
        WHERE dr.RegionName = @TargetRegionName
        GROUP BY df.FacilityName, dr.RegionName, MONTH(fc.ConsultationDate)
    ),
    RankedMonths AS (
        SELECT *,
               ROW_NUMBER() OVER(PARTITION BY HospitalName ORDER BY TotalRevenue DESC) AS TrafficRank
        FROM MonthlyRevenue
    )
    SELECT HospitalName, RegionName, MonthNumber, TotalVisits, TotalRevenue
    FROM RankedMonths
    WHERE TrafficRank = 1;
END;
GO
