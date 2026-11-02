# 30-Day Hospital Readmission Risk Stratification Model

## 📌 Project Overview

This project presents a data-driven risk-stratification model developed from a **10,000-patient dataset** to identify key clinical and demographic predictors of **30-day hospital readmissions**.

Through univariate and bivariate statistical screening, candidate features were evaluated using Welch's $t$-tests, Cohen's $d$ effect sizes, and Chi-Square ($\chi^2$) tests of independence. Significant factors were synthesized into a weighted point-scoring matrix directly in SQL, effectively stratifying patients into distinct operational risk tiers.

## 🛠️ Tech Stack & Tools

* **Database & Data Processing:** **SQL Server (T-SQL)** — Used for exploratory statistical queries, aggregating patient metrics, feature binning, and building CTE-based risk-scoring models.
* **Data Visualization & Analytics:** **Tableau** — Used for interactive dashboards, patient risk distribution profiling, and executive reporting.
* **Statistical Modeling & Analysis:** Hypothesis testing ($\chi^2$ independence, Welch's $t$-test), effect size calculation ($d$), and weighted risk stratification.

## 📊 Key Findings & Feature Screening

Each variable in the dataset was systematically tested to filter out statistical noise and isolate true clinical risk drivers.

### 1. Primary Risk Drivers (Confirmed Predictors)

| Feature | Statistical Test | Test Statistic | $p$-value / Effect Size | Operational Takeaway | 
| ----- | ----- | ----- | ----- | ----- | 
| **Medication Adherence** | Chi-Square ($\chi^2$) | $\chi^2 = 638.87$ | $p < 0.0001$ | **Primary Driver:** Low adherence yields a 27% readmission rate (vs. 5% for high adherence). | 
| **Hypertension Stage** | Chi-Square ($\chi^2$) | $\chi^2 = 33.39$ | $p = 9.94 \times 10^{-7}$ | **Secondary Driver:** Stage 2 Hypertension reaches a 15% readmission rate (vs. 10% baseline). | 
| **Primary Diagnosis** | Chi-Square ($\chi^2$) | $\chi^2 = 12.32$ | $p = 0.0064$ | **Specialty Concentration:** Orthopedics represents the highest-risk cohort (14% readmission rate). | 
| **Age** | Welch's $t$-test | $t = 6.76$ | $d = 0.20$ | **Demographic Factor:** Readmitted patients are systematically older ($\mu = 67$ vs. $64$ years). | 

### 2. Discarded Predictors (No Meaningful Impact)

* **Body Mass Index (BMI):** Retained null hypothesis ($d = 0.03$, not clinically or statistically significant).
* **Fasting Blood Sugar:** Retained null hypothesis (no independent correlation with 30-day readmissions).
* **Gender:** Retained null hypothesis (no statistically significant divergence in readmission rates).
* **Length of Stay (LOS):** Retained null hypothesis (overridden by behavioral/adherence factors).
* **Prior Admissions:** Retained null hypothesis (showed no independent univariate predictive value).
* **Serum Cholesterol:** Weak signal ($t = 2.71, d = 0.08$); excluded due to minimal clinical effect size.

## ⚙️ Risk-Scoring Methodology

Weights were assigned to significant features proportional to their effect sizes ($\chi^2$ magnitudes and percentage risk steps):

$$
\text{Risk Score} = \text{Adherence Points} + \text{Hypertension Points} + \text{Diagnosis Points} + \text{Age Points}
$$

* **Medication Adherence:** Low (+5 pts), Medium (+2 pts), High (0 pts)
* **Hypertension Stage:** Stage 2 / Crisis (+2 pts), Stage 1 (+1 pt), Normal / Elevated (0 pts)
* **Primary Diagnosis:** Orthopedics (+1 pt), Other Specialties (0 pts)
* **Age:** Age $\ge 65$ (+1 pt), Age < 65 (0 pts)

## 💻 SQL Server Implementation & Validation

The weighted scoring algorithm was executed using T-SQL query logic:

```sql
WITH patient_scores AS (
    SELECT 
        readmission_30_days,
        (
            -- Medication Adherence Points (Max 5)
            CASE 
                WHEN LOWER(medication_adherence) = 'low' THEN 5
                WHEN LOWER(medication_adherence) = 'medium' THEN 2
                ELSE 0 
            END +
            -- Blood Pressure Points (Max 2)
            CASE 
                WHEN systolic >= 140 OR diastolic >= 90 THEN 2
                WHEN systolic >= 130 OR diastolic >= 80 THEN 1
                ELSE 0 
            END +
            -- Primary Diagnosis Points (Max 1)
            CASE 
                WHEN LOWER(primary_diagnosis) = 'orthopedics' THEN 1 
                ELSE 0 
            END +
            -- Age Points (Max 1)
            CASE 
                WHEN age >= 65 THEN 1 
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
        ELSE 'High Risk (6-9 pts)'
    END AS risk_tier,
    COUNT(*) AS total_patients,
    SUM(CASE WHEN readmission_30_days = 1 THEN 1 ELSE 0 END) AS readmitted_patients,
    ROUND(
        SUM(CASE WHEN readmission_30_days = 1 THEN 1.0 ELSE 0.0 END) * 100.0 / COUNT(*), 
        2
    ) AS readmission_rate_pct
FROM 
    patient_scores
GROUP BY 
    CASE 
        WHEN risk_score BETWEEN 0 AND 2 THEN 'Low Risk (0-2 pts)'
        WHEN risk_score BETWEEN 3 AND 5 THEN 'Medium Risk (3-5 pts)'
        ELSE 'High Risk (6-9 pts)'
    END
ORDER BY 
    MIN(risk_score);
```

## 🎯 Validation Results & Operational Impact

The model demonstrates strong predictive performance with clear separation across risk tiers:

```
+------------------------+------------------+-----------------------+----------------------+
| Risk Tier              | Score Range      | Readmission Rate (%)  | Operational Profile  |
+------------------------+------------------+-----------------------+----------------------+
| Low Risk               | 0 - 2 pts        | 5.0%                  | Standard Discharge   |
| Medium Risk            | 3 - 5 pts        | 13.0%                 | 7-Day Follow-Up      |
| High Risk              | 6 - 9 pts        | 29.0%                 | Targeted Care Plan   |
+------------------------+------------------+-----------------------+----------------------+
```

### Key Highlights:

* **Nearly $6\times$ Risk Gradient:** Patients in the High Risk tier are almost **6 times more likely** to be readmitted compared to those in the Low Risk tier (29% vs. 5%).
* **Actionable Resource Allocation:** Clinical staff can automatically prioritize high-touch post-discharge interventions (e.g., bedside pharmacy delivery, home health visits) specifically for patients scoring $\ge 6$ points.
