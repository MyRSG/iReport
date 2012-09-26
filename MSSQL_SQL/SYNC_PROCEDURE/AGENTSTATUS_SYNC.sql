CREATE PROCEDURE [dbo].pr_AGENTSTATUS_Sync (
@svrName varchar(200),
@svrId int
)
AS
BEGIN
DECLARE @tmpTab TABLE( 
	AGENTSTATUSID int,
	AGENTID int,
	CATEGORYID int,
	STATUS varchar(15),
	CATEGORYSTATUSID int
)

DECLARE @insSQL varchar(MAX)= 'SELECT * FROM '+ dbo.GET_OPENQUERY_SQL(@svrName,'SELECT AGENTSTATUSID,AGENTID,CATEGORYID,STATUS,CATEGORYSTATUSID FROM AGENTSTATUS_LOG WHERE ROWNUM<100 ORDER BY LOGTIME')
INSERT INTO @tmpTab EXEC(@insSQL)

DECLARE @AGENTSTATUSID int,@AGENTID int,@CATEGORYID int,@STATUS varchar(15),@CATEGORYSTATUSID int

DECLARE update_cursor CURSOR FOR 
SELECT AGENTSTATUSID,AGENTID,CATEGORYID,STATUS,CATEGORYSTATUSID FROM @tmpTab

OPEN update_cursor

FETCH NEXT FROM update_cursor
INTO @AGENTSTATUSID,@AGENTID,@CATEGORYID,@STATUS,@CATEGORYSTATUSID

WHILE @@FETCH_STATUS = 0
BEGIN	
	UPDATE AGENTSTATUS SET
		AGENTID=@AGENTID,
		CATEGORYID=@CATEGORYID,
		STATUS=@STATUS,
		CATEGORYSTATUSID=@CATEGORYSTATUSID
	WHERE
		SERVERID = @svrId
	AND AGENTSTATUSID=@AGENTSTATUSID

FETCH NEXT FROM update_cursor
INTO @AGENTSTATUSID,@AGENTID,@CATEGORYID,@STATUS,@CATEGORYSTATUSID

END

DECLARE @delSQL varchar(MAX) = 'DELETE '+ dbo.GET_OPENQUERY_SQL(@svrName,'SELECT * FROM AGENTSTATUS_LOG WHERE ROWNUM < 100')
EXEC(@delSQL)

CLOSE update_cursor
DEALLOCATE update_cursor

END
