
SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
IF EXISTS (SELECT * FROM tempdb..sysobjects WHERE id=OBJECT_ID('tempdb..#tmpErrors')) DROP TABLE #tmpErrors
GO
CREATE TABLE #tmpErrors (Error int)
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
GO
BEGIN TRANSACTION
GO
/* */
PRINT N'Dropping foreign keys from [dbo].[Series]'
GO
ALTER TABLE [dbo].[Series] DROP
CONSTRAINT [FK_Series_Study]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
/* */
PRINT N'Dropping constraints from [dbo].[Study]'
GO
ALTER TABLE [dbo].[Study] DROP CONSTRAINT [PK_Study]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
/* */
PRINT N'Dropping index [IX_Study_StudyDate] from [dbo].[Study]'
GO
DROP INDEX [IX_Study_StudyDate] ON [dbo].[Study]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
/* */
PRINT N'Dropping index [IX_WorkQueue_ScheduledTime] from [dbo].[WorkQueue]'
GO
DROP INDEX [IX_WorkQueue_ScheduledTime] ON [dbo].[WorkQueue]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
/* */
PRINT N'Dropping index [IX_WorkQueue_StudyHistoryGUID] from [dbo].[WorkQueue]'
GO
DROP INDEX [IX_WorkQueue_StudyHistoryGUID] ON [dbo].[WorkQueue]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
/* */
PRINT N'Dropping index [IX_WorkQueue_WorkQueuePriorityEnum] from [dbo].[WorkQueue]'
GO
DROP INDEX [IX_WorkQueue_WorkQueuePriorityEnum] ON [dbo].[WorkQueue]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
/* */
PRINT N'Dropping index [IX_WorkQueue_GroupID] from [dbo].[WorkQueue]'
GO
DROP INDEX [IX_WorkQueue_GroupID] ON [dbo].[WorkQueue]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
/* */
PRINT N'Creating index [IX_WorkQueue_GroupID] from [dbo].[WorkQueue]'
GO
CREATE NONCLUSTERED INDEX [IX_WorkQueue_GroupID] ON [dbo].[WorkQueue] 
(
	[GroupID] ASC
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [INDEXES]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO

/* */
PRINT N'Creating [dbo].[DeviceTypeEnum]'
GO
CREATE TABLE [dbo].[DeviceTypeEnum]
(
[GUID] [uniqueidentifier] NOT NULL ROWGUIDCOL CONSTRAINT [DF_DeviceTypeEnum_GUID] DEFAULT (newid()),
[Enum] [smallint] NOT NULL,
[Lookup] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [nvarchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LongDescription] [nvarchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [STATIC]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
/* */
PRINT N'Creating primary key [PK_DeviceTypeEnum] on [dbo].[DeviceTypeEnum]'
GO
ALTER TABLE [dbo].[DeviceTypeEnum] ADD CONSTRAINT [PK_DeviceTypeEnum] PRIMARY KEY CLUSTERED  ([Enum])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
/* */
PRINT N'Inserting rows into on [dbo].[DeviceTypeEnum]'
GO
INSERT INTO [dbo].[DeviceTypeEnum] ([GUID],[Enum],[Lookup],[Description],[LongDescription])
     VALUES (newid(),100,'Workstation','Workstation','Workstation')
INSERT INTO [dbo].[DeviceTypeEnum] ([GUID],[Enum],[Lookup],[Description],[LongDescription])
     VALUES (newid(),101,'Modality','Modality','Modality')
INSERT INTO [dbo].[DeviceTypeEnum] ([GUID],[Enum],[Lookup],[Description],[LongDescription])
     VALUES (newid(),102,'Server','Server','Server')
INSERT INTO [dbo].[DeviceTypeEnum] ([GUID],[Enum],[Lookup],[Description],[LongDescription])
     VALUES (newid(),103,'Broker','Broker','Broker')
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
/* */
PRINT N'Creating [dbo].[WorkQueueTypeProperties]'
GO
CREATE TABLE [dbo].[WorkQueueTypeProperties]
(
[GUID] [uniqueidentifier] NOT NULL ROWGUIDCOL CONSTRAINT [DF_WorkQueueTypeProperties_GUID] DEFAULT (newid()),
[WorkQueueTypeEnum] [smallint] NOT NULL,
[WorkQueuePriorityEnum] [smallint] NOT NULL,
[MemoryLimited] [bit] NOT NULL,
[AlertFailedWorkQueue] [bit] NOT NULL,
[MaxFailureCount] [int] NOT NULL,
[ProcessDelaySeconds] [int] NOT NULL,
[FailureDelaySeconds] [int] NOT NULL,
[DeleteDelaySeconds] [int] NOT NULL,
[PostponeDelaySeconds] [int] NOT NULL,
[ExpireDelaySeconds] [int] NOT NULL,
[MaxBatchSize] [int] NOT NULL,
[QueueStudyStateEnum] [smallint] NULL,
[QueueStudyStateOrder] [smallint] NULL,
[ReadLock] [bit] NOT NULL CONSTRAINT [DF_WorkQueueTypeProperties_ReadLock] DEFAULT ((0)),
[WriteLock] [bit] NOT NULL CONSTRAINT [DF_WorkQueueTypeProperties_WriteLock] DEFAULT ((1))
) ON [STATIC]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
/* */
PRINT N'Creating primary key [PK_WorkQueueTypeProperties] on [dbo].[WorkQueueTypeProperties]'
GO
ALTER TABLE [dbo].[WorkQueueTypeProperties] ADD CONSTRAINT [PK_WorkQueueTypeProperties] PRIMARY KEY CLUSTERED  ([GUID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
/* */
PRINT N'Creating index [IX_WorkQueueTypeProperties] on [dbo].[WorkQueueTypeProperties]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_WorkQueueTypeProperties] ON [dbo].[WorkQueueTypeProperties] ([WorkQueueTypeEnum])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
/* */
PRINT N'Creating index [IX_WorkQueueTypeProperties_QueueStudyStateEnum] on [dbo].[WorkQueueTypeProperties]'
GO
CREATE NONCLUSTERED INDEX [IX_WorkQueueTypeProperties_QueueStudyStateEnum] ON [dbo].[WorkQueueTypeProperties] ([QueueStudyStateEnum]) ON [INDEXES]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
/* */
PRINT N'Creating index [IX_WorkQueueTypeProperties_QueueStudyStateOrder] on [dbo].[WorkQueueTypeProperties]'
GO
CREATE NONCLUSTERED INDEX [IX_WorkQueueTypeProperties_QueueStudyStateOrder] ON [dbo].[WorkQueueTypeProperties] ([QueueStudyStateOrder]) ON [INDEXES]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
/* */
PRINT N'Altering [dbo].[WorkQueue], adding [LastUpdatedTime]'
GO
ALTER TABLE [dbo].[WorkQueue] ADD
[LastUpdatedTime] [datetime] NULL
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
/* */
PRINT N'Creating index [IX_WorkQueue_DeviceGUID] on [dbo].[WorkQueue]'
GO
CREATE NONCLUSTERED INDEX [IX_WorkQueue_DeviceGUID] ON [dbo].[WorkQueue] ([DeviceGUID]) ON [INDEXES]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
/* */
PRINT N'Creating index [IX_WorkQueue_ScheduledTime] on [dbo].[WorkQueue]'
GO
CREATE NONCLUSTERED INDEX [IX_WorkQueue_ScheduledTime] ON [dbo].[WorkQueue] ([ScheduledTime], [WorkQueueStatusEnum], [WorkQueueTypeEnum]) INCLUDE ([StudyStorageGUID], [WorkQueuePriorityEnum]) ON [INDEXES]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
/* */
PRINT N'Altering [dbo].[StudyStorage], Adding [ReadLock], renaming [Lock] to [WriteLock]'
GO
ALTER TABLE [dbo].[StudyStorage] ADD
[ReadLock] [smallint] NOT NULL CONSTRAINT [DF_StudyStorage_ReadLock] DEFAULT ((0))
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
EXEC sp_rename N'[dbo].[StudyStorage].[Lock]', N'WriteLock', 'COLUMN'
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
/* */
PRINT N'Altering [dbo].[StudyIntegrityQueue]'
GO
EXEC sp_rename N'[dbo].[StudyIntegrityQueue].[QueueData]', N'Details', 'COLUMN'
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
/* */
PRINT N'Altering [dbo].[Study], adding [StudySizeInKB] column'
GO
ALTER TABLE [dbo].[Study] ADD
[StudySizeInKB] [decimal] (18, 0) NULL
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
/* */
PRINT N'Creating index [IXC_Study_StudyDate] on [dbo].[Study]'
GO
CREATE CLUSTERED INDEX [IXC_Study_StudyDate] ON [dbo].[Study] ([StudyDate])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
/* */
PRINT N'Creating primary key [PK_Study] on [dbo].[Study]'
GO
ALTER TABLE [dbo].[Study] ADD CONSTRAINT [PK_Study] PRIMARY KEY NONCLUSTERED  ([GUID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
/* */
PRINT N'Altering [dbo].[Device]'
GO
ALTER TABLE [dbo].[Device] ADD
[AcceptKOPR] [bit] NOT NULL CONSTRAINT [DF_Device_AcceptKOPRFlag] DEFAULT ((0)),
[LastAccessedTime] [datetime] NOT NULL CONSTRAINT [DF_Device_LastAccessedTime] DEFAULT (getdate()),
[DeviceTypeEnum] [smallint] NOT NULL CONSTRAINT [DF_Device_DeviceTypeEnum] DEFAULT ((100))
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
/* */
PRINT N'Creating index [IX_Device_ServerPartitionGUID_AeTitle] on [dbo].[Device]'
GO
CREATE NONCLUSTERED INDEX [IX_Device_ServerPartitionGUID_AeTitle] ON [dbo].[Device] ([ServerPartitionGUID], [AeTitle])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
/* */
PRINT N'Adding foreign keys to [dbo].[Device]'
GO
ALTER TABLE [dbo].[Device] ADD
CONSTRAINT [FK_Device_DeviceTypeEnum] FOREIGN KEY ([DeviceTypeEnum]) REFERENCES [dbo].[DeviceTypeEnum] ([Enum])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
/* */
PRINT N'Adding foreign keys to [dbo].[WorkQueueTypeProperties]'
GO
ALTER TABLE [dbo].[WorkQueueTypeProperties] ADD
CONSTRAINT [FK_WorkQueueTypeProperties_WorkQueueTypeEnum] FOREIGN KEY ([WorkQueueTypeEnum]) REFERENCES [dbo].[WorkQueueTypeEnum] ([Enum]),
CONSTRAINT [FK_WorkQueueTypeProperties_WorkQueuePriorityEnum] FOREIGN KEY ([WorkQueuePriorityEnum]) REFERENCES [dbo].[WorkQueuePriorityEnum] ([Enum])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
/* */
PRINT N'Adding foreign keys to [dbo].[Series]'
GO
ALTER TABLE [dbo].[Series] ADD
CONSTRAINT [FK_Series_Study] FOREIGN KEY ([StudyGUID]) REFERENCES [dbo].[Study] ([GUID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
/* */
PRINT N'Dropping index [IX_CannedText_Name] from [dbo].[CannedText]'
GO
DROP INDEX [IX_CannedText_Name] ON [dbo].[CannedText]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
/* */
PRINT N'Creating index [IX_CannedText_Name] from [dbo].[CannedText]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_CannedText] ON [dbo].[CannedText] 
(
	[Label] ASC,
	[Category] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
/* */
PRINT N'Adding new rows to [dbo].[WorkQueueTypeEnum]'
GO
INSERT INTO [dbo].[WorkQueueTypeEnum] ([GUID],[Enum],[Lookup],[Description],[LongDescription])
     VALUES (newid(),115,'CleanupDuplicate','Cleanup Duplicate','Cleanup failed ProcessDuplicate entry.')
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
/* */
PRINT N'Adding new rows to [dbo].[WorkQueuePriorityEnum]'
GO
INSERT INTO [dbo].WorkQueuePriorityEnum ([GUID],[Enum],[Lookup],[Description],[LongDescription])
     VALUES (newid(),400,'Stat','Stat','Stat priority')
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
/* */
PRINT N'Adding new rows to [dbo].[WorkQueueTypeProperties]'
GO
  -- StudyProcess
INSERT INTO [dbo].[WorkQueueTypeProperties]
           ([WorkQueueTypeEnum],[WorkQueuePriorityEnum],[MemoryLimited],[AlertFailedWorkQueue],
           [MaxFailureCount],[ProcessDelaySeconds],[FailureDelaySeconds],[DeleteDelaySeconds],
           [PostponeDelaySeconds],[ExpireDelaySeconds],[MaxBatchSize], [QueueStudyStateEnum], [QueueStudyStateOrder],
           [ReadLock],[WriteLock])
     VALUES
           (100,300,1,1,3,10,180,60,120,120,3000,105,5,0,1)
GO
  -- AutoRoute
INSERT INTO [dbo].[WorkQueueTypeProperties]
           ([WorkQueueTypeEnum],[WorkQueuePriorityEnum],[MemoryLimited],[AlertFailedWorkQueue],
           [MaxFailureCount],[ProcessDelaySeconds],[FailureDelaySeconds],[DeleteDelaySeconds],
           [PostponeDelaySeconds],[ExpireDelaySeconds],[MaxBatchSize], [QueueStudyStateEnum], [QueueStudyStateOrder],
           [ReadLock],[WriteLock])
     VALUES
           (101,300,1,1,3,10,180,60,120,120,-1,101,0,1,0)
GO
  -- DeleteStudy
INSERT INTO [dbo].[WorkQueueTypeProperties]
           ([WorkQueueTypeEnum],[WorkQueuePriorityEnum],[MemoryLimited],[AlertFailedWorkQueue],
           [MaxFailureCount],[ProcessDelaySeconds],[FailureDelaySeconds],[DeleteDelaySeconds],
           [PostponeDelaySeconds],[ExpireDelaySeconds],[MaxBatchSize], [QueueStudyStateEnum], [QueueStudyStateOrder],
           [ReadLock],[WriteLock])
     VALUES
           (102,200,0,1,3,30,180,60,120,15,-1,102,6,0,1)
GO
  -- WebDeleteStudy
INSERT INTO [dbo].[WorkQueueTypeProperties]
           ([WorkQueueTypeEnum],[WorkQueuePriorityEnum],[MemoryLimited],[AlertFailedWorkQueue],
           [MaxFailureCount],[ProcessDelaySeconds],[FailureDelaySeconds],[DeleteDelaySeconds],
           [PostponeDelaySeconds],[ExpireDelaySeconds],[MaxBatchSize], [QueueStudyStateEnum], [QueueStudyStateOrder],
           [ReadLock],[WriteLock])
     VALUES
           (103,200,0,1,3,30,180,60,120,15,-1,103,6,0,1) 
GO

  -- WebEditStudy
INSERT INTO [dbo].[WorkQueueTypeProperties]
           ([WorkQueueTypeEnum],[WorkQueuePriorityEnum],[MemoryLimited],[AlertFailedWorkQueue],
           [MaxFailureCount],[ProcessDelaySeconds],[FailureDelaySeconds],[DeleteDelaySeconds],
           [PostponeDelaySeconds],[ExpireDelaySeconds],[MaxBatchSize], [QueueStudyStateEnum], [QueueStudyStateOrder],
           [ReadLock],[WriteLock])
     VALUES
           (105,200,1,1,3,30,180,60,120,15,-1,104,3,0,1)
GO

  -- WebMoveStudy
INSERT INTO [dbo].[WorkQueueTypeProperties]
           ([WorkQueueTypeEnum],[WorkQueuePriorityEnum],[MemoryLimited],[AlertFailedWorkQueue],
           [MaxFailureCount],[ProcessDelaySeconds],[FailureDelaySeconds],[DeleteDelaySeconds],
           [PostponeDelaySeconds],[ExpireDelaySeconds],[MaxBatchSize], [QueueStudyStateEnum], [QueueStudyStateOrder],
           [ReadLock],[WriteLock])
     VALUES
           (104,200,1,1,3,30,180,60,120,15,-1,101,0,1,0)
GO

  -- CleanupStudy
INSERT INTO [dbo].[WorkQueueTypeProperties]
           ([WorkQueueTypeEnum],[WorkQueuePriorityEnum],[MemoryLimited],[AlertFailedWorkQueue],
           [MaxFailureCount],[ProcessDelaySeconds],[FailureDelaySeconds],[DeleteDelaySeconds],
           [PostponeDelaySeconds],[ExpireDelaySeconds],[MaxBatchSize], [QueueStudyStateEnum], [QueueStudyStateOrder],
           [ReadLock],[WriteLock])
     VALUES
           (106,200,0,1,3,60,180,60,120,15,-1,109,2,0,1)
GO

  -- CompressStudy
INSERT INTO [dbo].[WorkQueueTypeProperties]
           ([WorkQueueTypeEnum],[WorkQueuePriorityEnum],[MemoryLimited],[AlertFailedWorkQueue],
           [MaxFailureCount],[ProcessDelaySeconds],[FailureDelaySeconds],[DeleteDelaySeconds],
           [PostponeDelaySeconds],[ExpireDelaySeconds],[MaxBatchSize], [QueueStudyStateEnum], [QueueStudyStateOrder],
           [ReadLock],[WriteLock])
     VALUES
           (107,200,1,1,2,30,180,60,120,120,300,110,2,0,1)
GO
  -- MigrateStudy
INSERT INTO [dbo].[WorkQueueTypeProperties]
           ([WorkQueueTypeEnum],[WorkQueuePriorityEnum],[MemoryLimited],[AlertFailedWorkQueue],
           [MaxFailureCount],[ProcessDelaySeconds],[FailureDelaySeconds],[DeleteDelaySeconds],
           [PostponeDelaySeconds],[ExpireDelaySeconds],[MaxBatchSize], [QueueStudyStateEnum], [QueueStudyStateOrder],
           [ReadLock],[WriteLock])
     VALUES
           (108,100,0,1,3,60,180,60,120,15,300,111,1,0,1)
GO
  -- PurgeStudy
INSERT INTO [dbo].[WorkQueueTypeProperties]
           ([WorkQueueTypeEnum],[WorkQueuePriorityEnum],[MemoryLimited],[AlertFailedWorkQueue],
           [MaxFailureCount],[ProcessDelaySeconds],[FailureDelaySeconds],[DeleteDelaySeconds],
           [PostponeDelaySeconds],[ExpireDelaySeconds],[MaxBatchSize], [QueueStudyStateEnum], [QueueStudyStateOrder],
           [ReadLock],[WriteLock])
     VALUES
           (109,200,0,1,3,60,180,60,120,15,300,106,1,0,1)
GO
  -- ReprocessStudy
INSERT INTO [dbo].[WorkQueueTypeProperties]
           ([WorkQueueTypeEnum],[WorkQueuePriorityEnum],[MemoryLimited],[AlertFailedWorkQueue],
           [MaxFailureCount],[ProcessDelaySeconds],[FailureDelaySeconds],[DeleteDelaySeconds],
           [PostponeDelaySeconds],[ExpireDelaySeconds],[MaxBatchSize], [QueueStudyStateEnum], [QueueStudyStateOrder],
           [ReadLock],[WriteLock])
     VALUES
           (110,200,1,1,3,60,180,60,120,15,300,112,10,0,1)
GO
  -- ReconcileStudy
INSERT INTO [dbo].[WorkQueueTypeProperties]
           ([WorkQueueTypeEnum],[WorkQueuePriorityEnum],[MemoryLimited],[AlertFailedWorkQueue],
           [MaxFailureCount],[ProcessDelaySeconds],[FailureDelaySeconds],[DeleteDelaySeconds],
           [PostponeDelaySeconds],[ExpireDelaySeconds],[MaxBatchSize], [QueueStudyStateEnum], [QueueStudyStateOrder],
           [ReadLock],[WriteLock])
     VALUES
           (111,200,1,1,3,60,180,60,120,15,300,107,4,0,1)
GO
  -- ReconcileCleanup
INSERT INTO [dbo].[WorkQueueTypeProperties]
           ([WorkQueueTypeEnum],[WorkQueuePriorityEnum],[MemoryLimited],[AlertFailedWorkQueue],
           [MaxFailureCount],[ProcessDelaySeconds],[FailureDelaySeconds],[DeleteDelaySeconds],
           [PostponeDelaySeconds],[ExpireDelaySeconds],[MaxBatchSize], [QueueStudyStateEnum], [QueueStudyStateOrder],
           [ReadLock],[WriteLock])
     VALUES
           (112,200,1,1,3,60,180,60,120,15,300,107,3,0,1)
GO
  -- ReconcilePostProcess
INSERT INTO [dbo].[WorkQueueTypeProperties]
           ([WorkQueueTypeEnum],[WorkQueuePriorityEnum],[MemoryLimited],[AlertFailedWorkQueue],
           [MaxFailureCount],[ProcessDelaySeconds],[FailureDelaySeconds],[DeleteDelaySeconds],
           [PostponeDelaySeconds],[ExpireDelaySeconds],[MaxBatchSize], [QueueStudyStateEnum], [QueueStudyStateOrder],
           [ReadLock],[WriteLock])
     VALUES
           (113,200,1,1,3,60,180,60,120,15,300,107,4,0,1)
GO
  -- ProcessDuplicate
INSERT INTO [dbo].[WorkQueueTypeProperties]
           ([WorkQueueTypeEnum],[WorkQueuePriorityEnum],[MemoryLimited],[AlertFailedWorkQueue],
           [MaxFailureCount],[ProcessDelaySeconds],[FailureDelaySeconds],[DeleteDelaySeconds],
           [PostponeDelaySeconds],[ExpireDelaySeconds],[MaxBatchSize], [QueueStudyStateEnum], [QueueStudyStateOrder],
           [ReadLock],[WriteLock])
     VALUES
           (114,200,1,1,3,60,180,60,120,120,300,107,4,0,1)
GO
  -- CleanupDuplicate
INSERT INTO [dbo].[WorkQueueTypeProperties]
           ([WorkQueueTypeEnum],[WorkQueuePriorityEnum],[MemoryLimited],[AlertFailedWorkQueue],
           [MaxFailureCount],[ProcessDelaySeconds],[FailureDelaySeconds],[DeleteDelaySeconds],
           [PostponeDelaySeconds],[ExpireDelaySeconds],[MaxBatchSize], [QueueStudyStateEnum], [QueueStudyStateOrder],
           [ReadLock],[WriteLock])
     VALUES
           (115,200,1,0,3,60,180,60,120,120,300,105,4,0,1)
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
/* */
PRINT N'Adding new rows to [dbo].[ServerRuleApplyTimeEnum]'
GO
INSERT INTO [dbo].[ServerRuleApplyTimeEnum] ([GUID],[Enum],[Lookup],[Description],[LongDescription])
     VALUES (newid(),106,'SopEdited','SOP Edited','Apply rule when a SOP Instance is edited')
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
/* */
PRINT N'Adding new rows to [dbo].[StudyHistoryTypeEnum]'
GO
INSERT INTO [dbo].[StudyHistoryTypeEnum] ([GUID],[Enum],[Lookup],[Description],[LongDescription])
     VALUES (newid(),203,'SeriesDeleted','One or more series was deleted','One or more series was deleted manually.')
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
/* */
PRINT N'Adding new rows  in [dbo].[CannedText]'
GO
INSERT INTO [dbo].[CannedText]([GUID],[Label],[Category],[Text])
     VALUES(newid(), 'Corrupted series', 'DeleteSeriesReason', 'Series is corrupted.')
INSERT INTO [dbo].[CannedText]([GUID],[Label],[Category],[Text])
     VALUES(newid(), 'Invalid series data', 'DeleteSeriesReason', 'Series contains some invalid data.')          
INSERT INTO [dbo].[CannedText]([GUID],[Label],[Category],[Text])
     VALUES(newid(), 'Data is incorrect', 'EditStudyReason', 'Data is incorrect.')
INSERT INTO [dbo].[CannedText]([GUID],[Label],[Category],[Text])
     VALUES(newid(), 'Data is missing', 'EditStudyReason', 'Data is missing.')               
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
/* */
PRINT N'Checking for existing rows in [dbo].[CannedText]'
GO
if (NOT EXISTS(SELECT * FROM [dbo].[CannedText] WHERE Label='Corrupted study' and Category='DeleteStudyReason'))
BEGIN
	INSERT INTO [ImageServer].[dbo].[CannedText]([GUID],[Label],[Category],[Text])
		 VALUES(newid(), 'Corrupted study', 'DeleteStudyReason', 'Study is corrupted.')
END
if (NOT EXISTS(SELECT * FROM [dbo].[CannedText] WHERE Label='Invalid data' and Category='DeleteStudyReason'))
BEGIN
	INSERT INTO [ImageServer].[dbo].[CannedText]([GUID],[Label],[Category],[Text])
		 VALUES(newid(), 'Invalid data', 'DeleteStudyReason', 'Study contains some invalid data.')
END
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
/* */
IF EXISTS (SELECT * FROM #tmpErrors) ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT>0 BEGIN
PRINT 'The database update succeeded'
COMMIT TRANSACTION
END
ELSE PRINT 'The database update failed'
GO
DROP TABLE #tmpErrors
GO