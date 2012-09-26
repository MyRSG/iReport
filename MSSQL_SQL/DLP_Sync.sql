CREATE PROCEDURE [dbo].pr_DLP_Sync
AS
BEGIN
DECLARE @name nvarchar(256), @id int

DECLARE c CURSOR FOR 
SELECT SERVERID, LINKEDSERVERNAME FROM ISERVER

OPEN c

FETCH NEXT FROM c INTO @id, @name

WHILE @@FETCH_STATUS = 0
BEGIN	
  BEGIN TRY
    EXEC dbo.pr_AGENT_Sync @svrName=@name, @svrId=@Id
    EXEC dbo.pr_AGENTCONFIGURATION_Sync @svrName=@name, @svrId=@Id
    EXEC dbo.pr_AGENTCONFIGURATIONVERSION_Sync @svrName=@name, @svrId=@Id
    EXEC dbo.pr_AGENTEVENT_Sync @svrName=@name, @svrId=@Id
    EXEC dbo.pr_AGENTSTATUS_Sync @svrName=@name, @svrId=@Id
    EXEC dbo.pr_CONTENTROOT_Sync @svrName=@name, @svrId=@Id
    EXEC dbo.pr_COURSE_Sync @svrName=@name, @svrId=@Id
    EXEC dbo.pr_CUSTOMATTRIBUTEDEFINITION_Sync @svrName=@name, @svrId=@Id
    EXEC dbo.pr_CUSTOMATTRIBUTEGROUP_Sync @svrName=@name, @svrId=@Id
    EXEC dbo.pr_CUSTOMATTRIBUTESRECORD_Sync @svrName=@name, @svrId=@Id
    EXEC dbo.pr_INCIDENT_Sync @svrName=@name, @svrId=@Id
    EXEC dbo.pr_INCIDENTSTATUS_Sync @svrName=@name, @svrId=@Id
    EXEC dbo.pr_INFORMATIONMONITOR_Sync @svrName=@name, @svrId=@Id
    EXEC dbo.pr_POLICY_Sync @svrName=@name, @svrId=@Id
    EXEC dbo.pr_POLICYGROUP_Sync @svrName=@name, @svrId=@Id
  END TRY
  BEGIN CATCH
  END CATCH
  
FETCH NEXT FROM c INTO @id,@name
END

CLOSE c
DEALLOCATE c

END