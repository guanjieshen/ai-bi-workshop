-- 1. Base Model with Project Master
CREATE TEMPORARY LIVE VIEW project_base AS
SELECT
  project_id,
  project_name,
  start_date,
  end_date,
  total_budget,
  region,
  project_manager
FROM cleaned_project_master;

-- 2. Aggregate Actuals
CREATE TEMPORARY LIVE VIEW project_costs AS
SELECT
  a.project_id,
  a.month,
  SUM(material_cost + labor_cost) AS total_actual_cost
FROM cleaned_actuals_sap a
GROUP BY a.project_id, a.month;

-- Step 3: Latest Forecasts
CREATE TEMPORARY LIVE VIEW project_forecast AS
SELECT
  project_id,
  estimate_to_complete,
  estimate_at_completion,
  risk_flag,
  historical_risk_outcome
FROM cleaned_forecasts;


-- Step 4. Change Orders Aggregated
CREATE TEMPORARY LIVE VIEW  project_change_orders AS
SELECT
  project_id,
  COUNT(*) AS num_changes,
  SUM(cost_impact) AS total_change_cost,
  COLLECT_SET(reason) AS change_reasons
FROM cleaned_change_orders
GROUP BY project_id;

-- -- Step 5. Contractor Performance Summary
CREATE TEMPORARY LIVE VIEW project_performance AS
SELECT
  project_id,
  SUM(safety_incidents) AS total_safety_incidents,
  ROUND(AVG(quality_rating), 2) AS avg_quality_rating,
  SUM(delays) AS total_delays
FROM cleaned_contractor_performance
GROUP BY project_id;

-- Step 6. Create a unified data model
CREATE MATERIALIZED VIEW gshen_catalog.enb_projects_workshop.unified_project_report AS
SELECT
  p.project_id,
  p.project_name,
  p.start_date,
  p.end_date,
  p.total_budget,
  p.region,
  p.project_manager,
  f.estimate_to_complete,
  f.estimate_at_completion,
  f.risk_flag,
  f.historical_risk_outcome,
  c.total_actual_cost,
  co.total_change_cost,
  co.num_changes,
  co.change_reasons,
  perf.total_safety_incidents,
  perf.avg_quality_rating,
  perf.total_delays

FROM project_base p
LEFT JOIN project_forecast f ON f.project_id = p.project_id
LEFT JOIN (
  SELECT project_id, MAX(month) AS latest_month
  FROM project_costs GROUP BY project_id
) latest ON latest.project_id = p.project_id
LEFT JOIN project_costs c ON c.project_id = p.project_id AND c.month = latest.latest_month
LEFT JOIN project_change_orders co ON co.project_id = p.project_id
LEFT JOIN project_performance perf ON perf.project_id = p.project_id;