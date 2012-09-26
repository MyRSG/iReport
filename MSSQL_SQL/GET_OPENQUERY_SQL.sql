USE [iDLP];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

CREATE FUNCTION [dbo].[GET_OPENQUERY_SQL]
(@server varchar(50), @plsql varchar(MAX))
RETURNS varchar(MAX)
WITH EXEC AS CALLER
AS
BEGIN
RETURN 'openquery('+@server+','''+@plsql+''')';
END
GO