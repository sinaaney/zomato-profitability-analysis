CREATE DATABASE zomato_analysis;
USE zomato_analysis;

-- Table 1: Annual segment perfomance --
CREATE TABLE segment_annual (
    year        VARCHAR(4),
    segment     VARCHAR(20),  -- 'food_delivery', 'blinkit', 'hyperpure'
    gov_cr      DECIMAL(10,2),
    revenue_cr  DECIMAL(10,2),
    ebitda_cr   DECIMAL(10,2),
    orders_mn   DECIMAL(10,2),
    aov_inr     DECIMAL(10,2),
    cm_pct_gov  DECIMAL(5,2)
);

-- Table 2: Per order economics
CREATE TABLE per_order (
    year        VARCHAR(4),
    segment     VARCHAR(20),
    aov_inr     DECIMAL(10,2),
    cm_per_order DECIMAL(10,2)
);

-- Table 3: Consolidated financials
CREATE TABLE consolidated (
    year        VARCHAR(4),
    revenue_cr  DECIMAL(10,2),
    ebitda_cr   DECIMAL(10,2),
    pat_cr      DECIMAL(10,2),
    cash_cr     DECIMAL(10,2)
);

-- Segment annual data
INSERT INTO segment_annual VALUES
('FY22','food_delivery',17400,4763,-766,490,398,1.7),
('FY23','food_delivery',26305,6147,-10, 647,407,4.5),
('FY24','food_delivery',32224,7792,912, 753,428,5.2),
('FY23','blinkit',      6462, 1063,-1016,119,543,NULL),
('FY24','blinkit',      12469,2301,-384, 203,614,NULL),
('FY22','hyperpure',    NULL, 192, NULL, NULL,NULL,NULL),
('FY23','hyperpure',    NULL, 1506,NULL, NULL,NULL,NULL),
('FY24','hyperpure',    NULL, 3172,NULL, NULL,NULL,NULL);

-- Per order economics
INSERT INTO per_order VALUES
('FY22','food_delivery',398,  7),
('FY23','food_delivery',407, 18),
('FY24','food_delivery',428, 22),
('FY23','blinkit',      543,-85),
('FY24','blinkit',      614,-19);

-- Consolidated
INSERT INTO consolidated VALUES
('FY22',4192, -1851,-1210, NULL),
('FY23',7079, -783, -971,  7782),
('FY24',12114,372,   351, 12241); 

-- Food delivery profitability journey -- 
SELECT year,
	   gov_cr,
	   orders_mn,
       aov_inr,
       cm_pct_gov,
	   ebitda_cr,
       ROUND((ebitda_cr / orders_mn)* 10, 2) AS ebidta_per_order_inr
FROM segment_annual
WHERE segment = 'food_delivery'
ORDER BY year;

-- Blinkit loss per order trajectory --
SELECT 
    s.year,
    s.gov_cr,
    s.orders_mn,
    s.aov_inr        AS aov_inr,
    s.ebitda_cr,
    p.cm_per_order,
    ROUND((p.cm_per_order / s.aov_inr) * 100, 1) AS cm_pct_aov
FROM segment_annual s
JOIN per_order p ON s.year = p.year 
                AND s.segment = p.segment
WHERE s.segment = 'blinkit'
ORDER BY s.year;

--  Cross subsidy: can food delivery fund Blinkit? --
SELECT f.year,
	   f.ebitda_cr AS food_ebitda,
       b.ebitda_cr AS blinkit_ebitda,
       (f.ebitda_cr + b.ebitda_cr) AS net_combined,
       CASE 
           WHEN  (f.ebitda_cr + b.ebitda_cr) > 0
           THEN 'Food delivery covers Blinkit'
           ELSE  'External funding needed'
      END AS funding_status
FROM segment_annual f
JOIN segment_annual b ON f.year = b.year
WHERE f.segment = 'food_delivery'
 AND  b.segment = 'blinkit';
 
 -- Revenue growth rate year on year --
 SELECT year,
	    revenue_cr,
        LAG(revenue_cr) OVER (ORDER BY year) AS prev_year_rev,
        ROUND((revenue_cr - LAG(revenue_cr) OVER (ORDER BY year)) /
		LAG(revenue_cr) OVER (ORDER BY year) * 100,1
        ) AS yoy_growth_pct
 FROM consolidated;
 
 --  Cash runway check --
SELECT 
     year,
	 cash_cr,
	 ebitda_cr,
     CASE 
        WHEN ebitda_cr < 0 
        THEN ROUND(cash_cr / ABS(ebitda_cr),1)
        ELSE NULL
      END AS years_of_runway,
      CASE
         WHEN ebitda_cr >= 0 
         THEN 'Cash burn stopped'
         ELSE 'Still burning'
      END AS burn_status   
FROM consolidated
ORDER BY year;