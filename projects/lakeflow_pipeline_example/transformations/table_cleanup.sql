-- This file defines a sample transformation.
-- Edit the sample below or add new transformations
-- using "+ Add" in the file browser.

CREATE MATERIALIZED VIEW gshen_catalog.enb_projects_workshop.cleaned_actuals_sap
(
  project_id STRING,
  month DATE,
  vendor STRING,
  material_cost DOUBLE,
  labor_cost DOUBLE,
  last_updated DATE,
  CONSTRAINT labor_cost_below_28000 EXPECT (labor_cost < 28000)
)
COMMENT 'Cleaned SAP actuals data with standardized columns and labor cost constraint'
AS
SELECT
  `Project ID` as project_id,
  `Month` as month,
  `Vendor` as vendor,
  `Material Cost ($)` as material_cost,
  `Labor Cost ($)` as labor_cost,
  `Last Updated` as last_updated
FROM gshen_catalog.enb_projects_workshop.actuals_sap;

CREATE MATERIALIZED VIEW gshen_catalog.enb_projects_workshop.cleaned_change_orders
AS SELECT 
  `Project ID` as project_id,
  `Change Description` as change_description,
  `Reason` as reason,
  `Cost Impact ($)` as cost_impact,
  `Last Updated` as last_updated
FROM gshen_catalog.enb_projects_workshop.change_orders;

CREATE MATERIALIZED VIEW gshen_catalog.enb_projects_workshop.cleaned_forecasts
AS SELECT
`Project ID` as project_id,
`Estimate to Complete ($)` as estimate_to_complete,
`Estimate at Completion ($)` as estimate_at_completion,
`Risk Flag` as risk_flag,
`Historical Risk Outcome` as historical_risk_outcome,
`Last Updated` as last_updated
FROM gshen_catalog.enb_projects_workshop.forecasts;

CREATE MATERIALIZED VIEW gshen_catalog.enb_projects_workshop.cleaned_contractor_performance
AS SELECT
`Project ID` as project_id,
`Safety Incidents` as safety_incidents,
`Quality Rating (1-5)` as quality_rating,
`Delays (Days)` as delays,
`Incident Report` as incident_report,
`Last Updated` as last_updated
FROM gshen_catalog.enb_projects_workshop.contractor_performance;

CREATE MATERIALIZED VIEW gshen_catalog.enb_projects_workshop.cleaned_forecast_snapshots
AS SELECT
`Project ID` as project_id,
`Snapshot Month` as snapshot_month,
`Estimate to Complete ($)` as estimate_to_complete,
`Risk Flag` as risk_flag,
`Historical Risk Flag` as historical_risk_flag
FROM gshen_catalog.enb_projects_workshop.forecast_snapshots;

CREATE MATERIALIZED VIEW gshen_catalog.enb_projects_workshop.cleaned_project_master
AS SELECT
`Project ID` as project_id,
`Project Name` as project_name,
`Start Date` as start_date,
`End Date` as end_date,
`Total Budget (Million $)` as total_budget,
`Region` as region,
`Project Manager` as project_manager,
`Project Update` as project_update
FROM gshen_catalog.enb_projects_workshop.project_master;

-- Let's see if we can adjust these queries to add a description of each table?
-- Let's also add a constraint to make sure project_id is not null for each table?
