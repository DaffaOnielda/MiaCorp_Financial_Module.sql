# MiaCorp ERP System: Financial Module (Cost Center & Ledger)

**How do you manage financial accountability for a colony on Mars?** This project is part of a massive, collaborative Enterprise Resource Planning (ERP) system built for "MiaCorp," a simulated organization managing a Martian colony. The overarching system integrates CRM, Supply Chain, HR, and Financial modules into a single centralized lifeline.

## My Focus: The Financial Pipeline
My team is responsible for building the entire Financial architecture, my specific role was engineering the **Database Backend for the Cost Center Module** within the Financial (FIN) Module. 

The goal was to create a relational schema that could track departmental budgets across different planets (Earth vs. Mars) and write the analytical queries needed to merge this metadata with the actual financial transactions.

## Tech Stack
* **Database:** MySQL
* **Database Management:** DBeaver
* **Frontend UI:** Retool (Low-code internal tool)

## What I Built (The Technical Stuff)
1. **Cost Center Schema Design:** Built the `sCOST_CENTERS` table from scratch, enforcing data integrity and setting up **Foreign Key** relationships to ensure it could properly communicate with the team's ledger table.
2. **Cross-Table Joins & Data Cleaning:** Financial data can be messy when merged. I wrote SQL Views that `JOIN` the ledger transactions with their respective cost centers, utilizing `COALESCE` to elegantly handle NULL values in debit/credit columns for accurate, combined reporting.
3. **Automated Business Logic:** Used `DATEDIFF` and `CASE` statements to dynamically calculate operational durations and flag departments for ledger allocation based on their active status.
4. **Dashboard Integration:** Connected my Cost Center backend seamlessly to Retool, allowing users to execute real-time CRUD operations and view the joined ledger data without writing SQL.

## 📂 Inside this Repository
* `FINAL PROJECT - Cost Center ID SQL.sql`: My complete database script (Table creations, Data seeding, and the Analytical View).
* `ERPs_Documentation.pdf`: The full MiaCorp system documentation, detailing the ERDs and architecture of all 4 modules.
* `Screenshots/`: UI captures showing the functional Retool dashboards connected to this database.
