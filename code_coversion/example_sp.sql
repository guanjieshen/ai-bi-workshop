CREATE OR ALTER PROCEDURE dbo.append_forecast_snapshot
  @snapshot_date DATE  -- Input parameter
AS
BEGIN
  SET NOCOUNT ON;

  INSERT INTO dbo.forecast_snapshots (
    [Project ID],
    [Snapshot Month],
    [Estimate to Complete ($)],
    [Risk Flag],
    [Historical Risk Flag],
    [_rescued_data]
  )
  SELECT
    [Project ID],
    @snapshot_date AS [Snapshot Month],
    [Estimate to Complete ($)],
    [Risk Flag],
    [Historical Risk Outcome] AS [Historical Risk Flag],
    NULL AS [_rescued_data]
  FROM dbo.forecasts;
END;