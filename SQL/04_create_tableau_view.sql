-- ============================================================================
-- Purpose: Creates a reporting view for Tableau with dynamic BP derivation & risk scoring
-- Target DB: HospitalReadmissionsDB
-- ============================================================================

USE ClinicalRecs;
GO

-- Drop view if it already exists
IF OBJECT_ID('vw_PatientRiskForTableau', 'V') IS NOT NULL
    DROP VIEW vw_PatientRiskForTableau;
GO

CREATE VIEW vw_PatientRiskForTableau AS
WITH DerivedHypertension AS (
    -- Step 1: Dynamically classify Hypertension Stage from Systolic & Diastolic BP
    SELECT 
          patient_age
        , Systolic_bp
        , Diastolic_bp
        , Primary_Diagnosis
        , Medication_Adherence
        , Readmission_30_Days
        , CASE 
            WHEN Systolic_bp >= 140 OR Diastolic_bp >= 90 THEN 'Stage 2'
            WHEN (Systolic_bp BETWEEN 130 AND 139) OR (Diastolic_bp BETWEEN 80 AND 89) THEN 'Stage 1'
            ELSE 'Normal/Elevated'
          END AS HypertensionStage
    FROM dbo.healthcare_patients
),
ScoredPatients AS (
    -- Step 2: Calculate the 0-9 point risk score using the validated predictors
    SELECT 
          patient_age
        , systolic_bp
        , diastolic_bp
        , HypertensionStage
        , primary_diagnosis
        , medication_adherence
        , readmission_30_days
        , (
            CASE WHEN medication_adherence = 'Low' THEN 3 ELSE 0 END +
            CASE WHEN HypertensionStage = 'Stage 2' THEN 2 ELSE 0 END +
            CASE WHEN primary_diagnosis = 'Orthopedics' THEN 2 ELSE 0 END +
            CASE WHEN patient_age > 65 THEN 2 ELSE 0 END
          ) AS RiskScore
    FROM DerivedHypertension
)
-- Step 3: Assign Risk Tiers and output final dataset for Tableau
SELECT 
      patient_age
    , systolic_bp
    , diastolic_bp
    , HypertensionStage
    , primary_diagnosis
    , medication_adherence
    , readmission_30_days
    , RiskScore
    , CASE 
        WHEN RiskScore BETWEEN 0 AND 2 THEN 'Low Risk (5%)'
        WHEN RiskScore BETWEEN 3 AND 5 THEN 'Medium Risk (13%)'
        ELSE 'High Risk (29%)'
      END AS RiskTier
FROM ScoredPatients;
GO