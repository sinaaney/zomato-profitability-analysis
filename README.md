# Zomato Profitability Deep Dive (FY22–FY24)

**A consulting-style business analysis using SQL, Python, and Power BI to evaluate whether Zomato’s Blinkit expansion is a strategic growth driver or a profitability risk.**

---

## 🚀 Key Result (TL;DR)
- Food delivery turned profitable and now generates **₹912 Cr EBITDA**
- Blinkit losses reduced **78% per order**
- Food delivery fully funds Blinkit with **₹528 Cr surplus**
- Cash reserves increased to **₹12,241 Cr** (no liquidity risk)

👉 **Conclusion:** Blinkit is a **self-funded growth engine**, not a drag on profitability.

---

## 📊 Dashboard Preview
![Dashboard](/output/dashboard_preview.png.png)

---

## 💡 What Makes This Analysis Different

Unlike basic financial analysis, this project:
- Breaks down **unit economics (per-order profitability)**
- Identifies **cross-subsidy between business segments**
- Uses **SQL to validate financial hypotheses**
- Translates data into **clear strategic business recommendations**

---

## 🎯 Central Business Question

**Is Blinkit a justified long-term growth investment, or is it delaying Zomato’s profitability?**

---

## 🧱 Project Workflow

### 1. Problem Framing
- Analyzed Zomato’s business model (Food Delivery, Blinkit, Hyperpure)
- Built hypothesis on Blinkit’s impact on profitability

### 2. Data Collection
- Extracted data from Zomato Annual Reports (FY22–FY24)
- Structured datasets:
  - Segment-level metrics
  - Per-order economics
  - Consolidated financials

### 3. SQL Analysis
Key analyses performed:
- Profitability turnaround (food delivery)
- Blinkit unit economics trend
- Cross-subsidy validation
- Cash runway analysis

### 4. Python Analysis
- Data cleaning and transformation using **Pandas**
- Visualizations using **Matplotlib**:
  - EBITDA trends
  - Contribution per order
  - Revenue growth

### 5. Power BI Dashboard
Built an interactive dashboard to visualize:
- Profitability trends
- Unit economics
- Cross-subsidy structure
- Revenue growth

---

## 📈 Key Insights

### 1. Food Delivery Turnaround
- EBITDA: **₹-766 Cr → ₹+912 Cr**
- Contribution margin improved significantly

### 2. Blinkit Unit Economics Improving
- Loss per order: **₹-85 → ₹-19**
- Strong trajectory toward profitability

### 3. Self-Funding Business Model
- Food delivery EBITDA: **₹+912 Cr**
- Blinkit loss: **₹-384 Cr**
- Net surplus: **₹+528 Cr**

👉 Zomato does **not require external funding** to scale Blinkit

### 4. Strong Cash Position
- Cash reserves increased:
  - ₹7,782 Cr → ₹12,241 Cr

---

## 📈 Business Impact

This analysis provides actionable strategic insights:

- Supports **continued Blinkit expansion**
- Identifies **food delivery as the core profit engine**
- Highlights **risk of margin erosion**
- Suggests new revenue opportunities:
  - Advertising monetization
  - Supply chain optimization


## Repository Structure

zomato-profitability-analysis/
│
├── README.md
├── dashboard_preview.png
│
├── data/
│   ├── segment_annual.csv
│   ├── per_order.csv
│   ├── consolidated.csv
│
├── sql/
│   └── zomato_analysis.sql
│
├── python/
│   └── zomato_charts.ipynb
│
├── dashboard/
│   └── Zomato_Profitability_Analysis.pbix
│
└── report/
    └── zomato_case_study.pdf    

## Data Source
Zomato Annual Reports FY2022, FY2023, FY2024
(publicly available at investors.zomato.com)

## Author
Muhammed Sinan PT
- GitHub: github.com/sinaaney
- LinkedIn: linkedin.com/in/muhammed-sinan-pt


---

## 🧾 Sample SQL Insight

 ```sql
 SELECT 
    year,
    cash_cr,
    ebitda_cr,
    CASE
        WHEN ebitda_cr < 0 
        THEN ROUND(cash_cr / ABS(ebitda_cr), 1)
        ELSE NULL
    END AS years_of_runway
 FROM consolidated
 ORDER BY year;

 