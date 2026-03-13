-- ==============================================================================
-- Project: MiaCorp ERP - Financial Module
-- Developer: M. Daffa AO
-- Tech Stack: MySQL, DBeaver, Retool
-- Description: Relational database schema linking Cost Centers with the 
--              General Ledger, including transaction mapping and analytical JOINs.
-- ==============================================================================

-- 1. CLEANUP (Drop in reverse order of dependencies)
DROP VIEW IF EXISTS vw_cost_center_ledger_summary;
DROP TABLE IF EXISTS sGENERAL_LEDGER;
DROP TABLE IF EXISTS sCOST_CENTERS;

-- 2. MASTER TABLE: COST CENTERS
CREATE TABLE sCOST_CENTERS (
    COST_CENTER_ID INT PRIMARY KEY,
    COST_CENTER_CODE VARCHAR(20) NOT NULL,
    NAME VARCHAR(100) NOT NULL,
    PLANET_LOCATION VARCHAR(50),
    STATUS VARCHAR(20),
    BUDGET_CURRENCY VARCHAR(10),
    EFFECTIVE_START_DATE DATE,
    EFFECTIVE_END_DATE DATE
);

INSERT INTO sCOST_CENTERS VALUES
(1, 'CC001', 'Earth Logistics', 'Earth', 'Active', 'USD', '2025-01-05', '2025-07-20'),
(2, 'CC002', 'Mars Ops Alpha', 'Mars', 'Active', 'BTC', '2025-01-05', '2025-07-20'),
(3, 'CC003', 'Orbital Research Lab', 'Orbit', 'Active', 'USD', '2025-01-05', '2025-07-20'),
(4, 'CC004', 'Mars Mining Support', 'Mars', 'Inactive', 'BTC', '2025-01-05', '2025-07-20'),
(5, 'CC005', 'Earth Admin Center', 'Earth', 'Active', 'USD', '2025-01-05', '2025-07-20');

-- 3. TRANSACTION TABLE: GENERAL LEDGER (With Foreign Key)
CREATE TABLE sGENERAL_LEDGER (
    GL_ENTRY_ID INT PRIMARY KEY,
    ENTRY_DATE DATE,
    ACCOUNT_ID INT,
    COST_CENTER_ID INT,
    DEBIT_AMOUNT DECIMAL(15, 2),
    CREDIT_AMOUNT DECIMAL(15, 2),
    CURRENCY_CODE VARCHAR(10),
    EXCHANGE_RATE DECIMAL(10, 2),
    TRANSACTION_TYPE VARCHAR(50),
    TRANSACTION_ID INT,
    FISCAL_YEAR INT,
    FOREIGN KEY (COST_CENTER_ID) REFERENCES sCOST_CENTERS(COST_CENTER_ID)
);

-- Data matching your Retool General Ledger screenshot
INSERT INTO sGENERAL_LEDGER VALUES
(1020, '2025-07-20', 2300, 3, NULL, 25000.00, 'USD', 100, 'LoanPay', 9801, 2025),
(1019, '2025-07-08', 3200, 1, 1200.00, NULL, 'EUR', 108, 'FX Adj', 9701, 2025),
(1018, '2025-07-01', 5500, 5, 4000.00, NULL, 'USD', 100, 'Depreciation', 9601, 2025),
(1017, '2025-06-15', 4200, 1, NULL, 8200.00, 'USD', 100, 'Chargeback', 9501, 2025);

-- 4. ANALYTICAL VIEW 
-- This view merges both tables so the Finance team can see exactly 
-- which planet and department is spending what money.
CREATE VIEW vw_cost_center_ledger_summary AS
SELECT 
    gl.GL_ENTRY_ID,
    gl.ENTRY_DATE,
    cc.NAME AS DEPARTMENT_NAME,
    cc.PLANET_LOCATION,
    gl.TRANSACTION_TYPE,
    -- COALESCE turns NULLs into 0.00 for cleaner financial reporting
    COALESCE(gl.DEBIT_AMOUNT, 0.00) AS DEBIT,
    COALESCE(gl.CREDIT_AMOUNT, 0.00) AS CREDIT,
    gl.CURRENCY_CODE
FROM sGENERAL_LEDGER gl
JOIN sCOST_CENTERS cc ON gl.COST_CENTER_ID = cc.COST_CENTER_ID;