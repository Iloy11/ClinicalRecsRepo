-- ============================================================================
-- Purpose: Creates a reporting view for Tableau with BP derivation & risk scoring
-- ============================================================================

USE ClinicalRecs;
GO

-- Drop view if it already exists
IF OBJECT_ID('vw_PatientRiskForTableau', 'V') IS NOT NULL
    DROP VIEW vw_PatientRiskForTableau;
GO

CREATE VIEW vw_PatientRiskForTableau AS
WITH DerivedHypertension AS (
    -- Step 1: Classify Hypertension Stage from Systolic & Diastolic BP
    SELECT 
          patient_age
        , Systolic_bp
        , Diastolic_bp
        , Primary_Diagnosis
        , Medication_Adherence
        , Readmission_30_Days
        , CASE 
            WHEN (systolic_bp >= 180) OR (diastolic_bp >= 120) THEN 'Hypertensive Crisis'
            WHEN (systolic_bp >= 140) OR (diastolic_bp >= 90) THEN 'Stage 2 Hypertension'
            WHEN (systolic_bp BETWEEN 130 AND 139) OR (diastolic_bp BETWEEN 80 AND 89) THEN 'Stage 1 Hypertension'
            WHEN (systolic_bp BETWEEN 120 AND 129) AND (diastolic_bp < 80) THEN 'Elevated'
            ELSE 'Normal'
          END AS HypertensionStage
    FROM dbo.healthcare_patients
),
ScoredPatients AS (
    -- Step 2: Calculate the 0-7 point risk score using the validated predictors
    SELECT 
          patient_age
        , systolic_bp
        , diastolic_bp
        , HypertensionStage
        , primary_diagnosis
        , medication_adherence
        , readmission_30_days
        , (
            CASE 
                WHEN LOWER(medication_adherence) = 'low' THEN 3
                WHEN LOWER(medication_adherence) = 'medium' THEN 2
                ELSE 0 
            END +
            CASE 
                WHEN HypertensionStage = 'Stage 2 Hypertension' THEN 2 
                WHEN HypertensionStage = 'Hypertensive Crisis' THEN 1
                ELSE 0 
            END +
            CASE 
                WHEN primary_diagnosis = 'Orthopedics' THEN 1 
                ELSE 0 
            END +
            CASE 
                WHEN patient_age > 65 THEN 1 ELSE 0 
            END
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