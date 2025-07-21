CREATE VIEW dbo.project_cost_summary AS
SELECT
    p.project_id,
    p.project_name,
    d.region,
    DATEPART(YEAR, p.start_date) AS start_year,
    ISNULL(SUM(f.estimated_cost), 0) AS total_estimated_cost,
    ISNULL(SUM(f.actual_cost), 0) AS total_actual_cost,
    CASE 
        WHEN SUM(f.actual_cost) > SUM(f.estimated_cost) THEN 'Over Budget'
        WHEN SUM(f.actual_cost) = SUM(f.estimated_cost) THEN 'On Budget'
        ELSE 'Under Budget'
    END AS budget_status
FROM dbo.projects p
LEFT JOIN dbo.forecasts f ON p.project_id = f.project_id
LEFT JOIN dbo.dim_regions d ON p.region_id = d.region_id
GROUP BY
    p.project_id,
    p.project_name,
    d.region,
    DATEPART(YEAR, p.start_date);
