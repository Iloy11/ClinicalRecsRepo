SELECT *
FROM healthcare_patients
WHERE readmission_30_days = 'Yes';

SELECT AVG(bmi) AS BMI_Avg, AVG(systolic_bp) AS Sys_AVG, AVG(diastolic_bp) AS dias_Avg
FROM healthcare_patients
WHERE readmission_30_days = 'Yes';

SELECT AVG(cholesterol_mg_dl) AS Chol_Avg, AVG(fasting_blood_sugar) AS Sug_Avg, AVG(heart_rate_bpm) AS Bpm_Avg
FROM healthcare_patients
WHERE readmission_30_days = 'Yes';

SELECT AVG(length_of_stay_days) AS Stay_Avg
FROM healthcare_patients
WHERE readmission_30_days = 'Yes';

SELECT AVG(length_of_stay_days) AS Stay_Avg
FROM healthcare_patients
WHERE readmission_30_days = 'No';

SELECT AVG(previous_admissions) AS Prevadm_Avg
FROM healthcare_patients
WHERE readmission_30_days = 'Yes';

SELECT previous_admissions
FROM healthcare_patients
WHERE readmission_30_days = 'Yes';

SELECT COUNT(admission_type) AS Adm_Count, admission_type
FROM healthcare_patients
WHERE readmission_30_days = 'Yes'
GROUP BY admission_type;

SELECT AVG(bmi) AS BMI_Avg, AVG(systolic_bp) AS Sys_AVG, AVG(diastolic_bp) AS dias_Avg
FROM healthcare_patients
WHERE readmission_30_days = 'No';

SELECT AVG(cholesterol_mg_dl) AS Chol_Avg, AVG(fasting_blood_sugar) AS Sug_Avg, AVG(heart_rate_bpm) AS Bpm_Avg
FROM healthcare_patients
WHERE readmission_30_days = 'No';

SELECT AVG(length_of_stay_days) AS Stay_Avg
FROM healthcare_patients
WHERE readmission_30_days = 'No';

SELECT AVG(previous_admissions) AS Prevadm_Avg
FROM healthcare_patients
WHERE readmission_30_days = 'No';

SELECT COUNT(admission_type) AS Adm_Count, admission_type
FROM healthcare_patients
WHERE readmission_30_days = 'No'
GROUP BY admission_type;

SELECT
	readmission_30_days, 
	COUNT(bmi) AS n, 
	AVG(bmi) AS mean_bmi, 
	STDEV(bmi) AS std_dev, 
	VAR(bmi) AS variance_bmi
FROM
	healthcare_patients
WHERE
	bmi IS NOT NULL
GROUP BY 
	readmission_30_days;

SELECT
	readmission_30_days, 
	COUNT(cholesterol_mg_dl) AS n, 
	AVG(cholesterol_mg_dl) AS mean_chol, 
	STDEV(cholesterol_mg_dl) AS std_dev, 
	VAR(cholesterol_mg_dl) AS variance_chol
FROM
	healthcare_patients
WHERE
	cholesterol_mg_dl IS NOT NULL
GROUP BY 
	readmission_30_days;

SELECT
	readmission_30_days, 
	COUNT(fasting_blood_sugar) AS n, 
	AVG(fasting_blood_sugar) AS mean_sugar, 
	STDEV(fasting_blood_sugar) AS std_dev, 
	VAR(fasting_blood_sugar) AS variance_sugar
FROM
	healthcare_patients
WHERE
	fasting_blood_sugar IS NOT NULL
GROUP BY 
	readmission_30_days;

SELECT
	readmission_30_days, 
	COUNT(previous_admissions) AS n, 
	AVG(previous_admissions) AS mean_prevadm, 
	STDEV(previous_admissions) AS std_dev, 
	VAR(previous_admissions) AS variance_prevadm
FROM
	healthcare_patients
WHERE
	previous_admissions IS NOT NULL
GROUP BY 
	readmission_30_days;

SELECT
	readmission_30_days, 
	COUNT(heart_rate_bpm) AS n, 
	AVG(heart_rate_bpm) AS mean_hr, 
	STDEV(heart_rate_bpm) AS std_dev, 
	VAR(heart_rate_bpm) AS variance_hr
FROM
	healthcare_patients
WHERE
	bmi IS NOT NULL
GROUP BY 
	readmission_30_days;

SELECT
	readmission_30_days, 
	COUNT(length_of_stay_days) AS n, 
	AVG(length_of_stay_days) AS mean_stay, 
	STDEV(length_of_stay_days) AS std_dev, 
	VAR(length_of_stay_days) AS variance_stay
FROM
	healthcare_patients
WHERE
	length_of_stay_days IS NOT NULL
GROUP BY 
	readmission_30_days;

SELECT
	readmission_30_days, 
	COUNT(patient_age) AS n, 
	AVG(patient_age) AS mean_age, 
	STDEV(patient_age) AS std_dev, 
	VAR(patient_age) AS variance_age
FROM
	healthcare_patients
WHERE
	patient_age IS NOT NULL
GROUP BY 
	readmission_30_days;

SELECT
	readmission_30_days, 
	COUNT(treatment_cost_usd) AS n, 
	AVG(treatment_cost_usd) AS mean_cost, 
	STDEV(treatment_cost_usd) AS std_dev, 
	VAR(treatment_cost_usd) AS variance_cost
FROM
	healthcare_patients
WHERE
	treatment_cost_usd IS NOT NULL
GROUP BY 
	readmission_30_days;

SELECT 
    gender,
    readmission_30_days, 
    COUNT(*) AS patient_count, 
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY gender), 2) AS percentage_within_gender
FROM
    healthcare_patients
WHERE
    gender IS NOT NULL 
    AND readmission_30_days IS NOT NULL
GROUP BY 
    gender, 
    readmission_30_days
ORDER BY 
    gender, 
    readmission_30_days;

SELECT 
    primary_diagnosis,
    readmission_30_days, 
    COUNT(*) AS patient_count, 
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY primary_diagnosis), 2) AS percentage_within_diagnosis
FROM
    healthcare_patients
WHERE
    primary_diagnosis IS NOT NULL 
    AND readmission_30_days IS NOT NULL
GROUP BY 
    primary_diagnosis, 
    readmission_30_days
ORDER BY 
    primary_diagnosis, 
    readmission_30_days;

SELECT 
    admission_type,
    readmission_30_days, 
    COUNT(*) AS patient_count, 
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY admission_type), 2) AS percentage_within_admtype
FROM
    healthcare_patients
WHERE
    admission_type IS NOT NULL 
    AND readmission_30_days IS NOT NULL
GROUP BY 
    admission_type, 
    readmission_30_days
ORDER BY 
    admission_type, 
    readmission_30_days;

SELECT 
    medication_adherence,
    readmission_30_days, 
    COUNT(*) AS patient_count, 
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY medication_adherence), 2) AS percentage_within_medadh
FROM
    healthcare_patients
WHERE
    medication_adherence IS NOT NULL 
    AND readmission_30_days IS NOT NULL
GROUP BY 
    medication_adherence, 
    readmission_30_days
ORDER BY 
    medication_adherence, 
    readmission_30_days;

SELECT 
    CASE 
        WHEN systolic_bp >= 180 OR diastolic_bp >= 120 THEN 'Hypertensive Crisis'
        WHEN systolic_bp >= 140 OR diastolic_bp >= 90 THEN 'Stage 2 Hypertension'
        WHEN systolic_bp >= 130 OR diastolic_bp >= 80 THEN 'Stage 1 Hypertension'
        WHEN systolic_bp >= 120 AND diastolic_bp < 80 THEN 'Elevated'
        ELSE 'Normal'
    END AS bp_category,
    COUNT(*) AS total_patients,
    SUM(CASE WHEN readmission_30_days = 'Yes' THEN 1 ELSE 0 END) AS readmitted_count,
    ROUND(
        SUM(CASE WHEN readmission_30_days = 'Yes' THEN 1.0 ELSE 0.0 END) * 100.0 / COUNT(*), 
        2
    ) AS readmission_rate_pct
FROM 
    healthcare_patients
WHERE 
    systolic_bp IS NOT NULL AND diastolic_bp IS NOT NULL
GROUP BY 
    CASE 
        WHEN systolic_bp >= 180 OR diastolic_bp >= 120 THEN 'Hypertensive Crisis'
        WHEN systolic_bp >= 140 OR diastolic_bp >= 90 THEN 'Stage 2 Hypertension'
        WHEN systolic_bp >= 130 OR diastolic_bp >= 80 THEN 'Stage 1 Hypertension'
        WHEN systolic_bp >= 120 AND diastolic_bp < 80 THEN 'Elevated'
        ELSE 'Normal'
    END;

WITH patient_scores AS (
    SELECT
        readmission_30_days,
        (
            -- Medication Adherence Points (Max 3)
            CASE 
                WHEN LOWER(medication_adherence) = 'low' THEN 3
                WHEN LOWER(medication_adherence) = 'medium' THEN 2
                ELSE 0 
            END +
            -- Blood Pressure Points (Max 2)
            CASE 
                WHEN systolic_bp >= 140 OR diastolic_bp >= 90 THEN 2
                WHEN systolic_bp >= 130 OR diastolic_bp >= 80 THEN 1
                ELSE 0 
            END +
            -- Primary Diagnosis Points (Max 1)
            CASE 
                WHEN LOWER(primary_diagnosis) = 'orthopedics' THEN 1 
                ELSE 0 
            END +
            -- Age Points (Max 1)
            CASE 
                WHEN patient_age >= 65 THEN 1 
                ELSE 0 
            END
        ) AS risk_score
    FROM 
        healthcare_patients
)
SELECT 
    CASE 
        WHEN risk_score BETWEEN 0 AND 2 THEN 'Low Risk (0-2 pts)'
        WHEN risk_score BETWEEN 3 AND 5 THEN 'Medium Risk (3-5 pts)'
        ELSE 'High Risk (6-7 pts)'
    END AS risk_tier,
    COUNT(*) AS total_patients,
    SUM(CASE WHEN readmission_30_days = 'Yes' THEN 1 ELSE 0 END) AS readmitted_patients,
    ROUND(
        SUM(CASE WHEN readmission_30_days = 'Yes' THEN 1.0 ELSE 0.0 END) * 100.0 / COUNT(*), 
        2
    ) AS readmission_rate_pct
FROM 
    patient_scores
GROUP BY 
    CASE 
        WHEN risk_score BETWEEN 0 AND 2 THEN 'Low Risk (0-2 pts)'
        WHEN risk_score BETWEEN 3 AND 5 THEN 'Medium Risk (3-5 pts)'
        ELSE 'High Risk (6-7 pts)'
    END
ORDER BY 
    MIN(risk_score);