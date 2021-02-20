---  .Scripts\AdminV (9).sql
-- FullBackup JOB
USE [msdb]
GO
DECLARE @jobId BINARY(16)
EXEC  msdb.dbo.sp_add_job @job_name=N'VendorsFullBackup', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_page=2, 
		@delete_level=0, 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'SAJT-PC\Tulajdonos', @job_id = @jobId OUTPUT
select @jobId
GO
EXEC msdb.dbo.sp_add_jobserver @job_name=N'VendorsFullBackup', @server_name = N'SAJT-PC'
GO
USE [msdb]
GO
EXEC msdb.dbo.sp_add_jobstep @job_name=N'VendorsFullBackup', @step_name=N'FullBackup', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_fail_action=1, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'-- 8. feladat
---  .Scripts\VendorsFullBackup.sql ---
BACKUP DATABASE [Vendors] TO  DISK = N''C:\VendorDB\Backup\VendorFullBackup.bak'' WITH NOFORMAT, INIT,  NAME = N''Vendors-Full Database Backup'', SKIP, NOREWIND, NOUNLOAD,  STATS = 10, CHECKSUM
GO
declare @backupSetId as int
select @backupSetId = position from msdb..backupset where database_name=N''Vendors'' and backup_set_id=(select max(backup_set_id) from msdb..backupset where database_name=N''Vendors'' )
if @backupSetId is null begin raiserror(N''Verify failed. Backup information for database ''''Vendors'''' not found.'', 16, 1) end
RESTORE VERIFYONLY FROM  DISK = N''C:\VendorDB\Backup\VendorFullBackup.bak'' WITH  FILE = @backupSetId,  NOUNLOAD,  NOREWIND
GO
', 
		@database_name=N'Vendors', 
		@database_user_name=N'dbo', 
		@output_file_name=N'C:\VendorDB\Backup\FullBackup.log', 
		@flags=0
GO
USE [msdb]
GO
EXEC msdb.dbo.sp_update_job @job_name=N'VendorsFullBackup', 
		@enabled=1, 
		@start_step_id=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_page=2, 
		@delete_level=0, 
		@description=N'', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'SAJT-PC\Tulajdonos', 
		@notify_email_operator_name=N'', 
		@notify_page_operator_name=N''
GO
USE [msdb]
GO
DECLARE @schedule_id int
EXEC msdb.dbo.sp_add_jobschedule @job_name=N'VendorsFullBackup', @name=N'FullBackup', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20210220, 
		@active_end_date=99991231, 
		@active_start_time=20000, 
		@active_end_time=235959, @schedule_id = @schedule_id OUTPUT
select @schedule_id
GO

-- DiffBackup JOB
USE [msdb]
GO
DECLARE @jobId BINARY(16)
EXEC  msdb.dbo.sp_add_job @job_name=N'VendorsDiffBackup', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_page=2, 
		@delete_level=0, 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'SAJT-PC\Tulajdonos', @job_id = @jobId OUTPUT
select @jobId
GO
EXEC msdb.dbo.sp_add_jobserver @job_name=N'VendorsDiffBackup', @server_name = N'SAJT-PC'
GO
USE [msdb]
GO
EXEC msdb.dbo.sp_add_jobstep @job_name=N'VendorsDiffBackup', @step_name=N'VendorsDiffBackup', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_fail_action=1, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'---  .Scripts\VendorsDiffBackup.sql ---
BACKUP DATABASE [Vendors] TO  DISK = N''C:\VendorDB\Backup\VendorDiffBackup.bak'' WITH  DIFFERENTIAL , NOFORMAT, NOINIT,  NAME = N''Vendors-Full Database Backup'', SKIP, NOREWIND, NOUNLOAD,  STATS = 10, CHECKSUM
GO
declare @backupSetId as int
select @backupSetId = position from msdb..backupset where database_name=N''Vendors'' and backup_set_id=(select max(backup_set_id) from msdb..backupset where database_name=N''Vendors'' )
if @backupSetId is null begin raiserror(N''Verify failed. Backup information for database ''''Vendors'''' not found.'', 16, 1) end
RESTORE VERIFYONLY FROM  DISK = N''C:\VendorDB\Backup\VendorDiffBackup.bak'' WITH  FILE = @backupSetId,  NOUNLOAD,  NOREWIND
GO', 
		@database_name=N'Vendors', 
		@database_user_name=N'dbo', 
		@output_file_name=N'C:\VendorDB\Backup\DiffBackup.log', 
		@flags=0
GO
USE [msdb]
GO
EXEC msdb.dbo.sp_update_job @job_name=N'VendorsDiffBackup', 
		@enabled=1, 
		@start_step_id=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_page=2, 
		@delete_level=0, 
		@description=N'', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'SAJT-PC\Tulajdonos', 
		@notify_email_operator_name=N'', 
		@notify_page_operator_name=N''
GO
USE [msdb]
GO
DECLARE @schedule_id int
EXEC msdb.dbo.sp_add_jobschedule @job_name=N'VendorsDiffBackup', @name=N'VendorsDiffBackup', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20210220, 
		@active_end_date=99991231, 
		@active_start_time=90000, 
		@active_end_time=235959, @schedule_id = @schedule_id OUTPUT
select @schedule_id
GO
USE [msdb]
GO
DECLARE @schedule_id int
EXEC msdb.dbo.sp_add_jobschedule @job_name=N'VendorsDiffBackup', @name=N'VendorsDiffBackup', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20210220, 
		@active_end_date=99991231, 
		@active_start_time=130000, 
		@active_end_time=235959, @schedule_id = @schedule_id OUTPUT
select @schedule_id
GO
USE [msdb]
GO
DECLARE @schedule_id int
EXEC msdb.dbo.sp_add_jobschedule @job_name=N'VendorsDiffBackup', @name=N'VendorsDiffBackup', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20210220, 
		@active_end_date=99991231, 
		@active_start_time=170000, 
		@active_end_time=235959, @schedule_id = @schedule_id OUTPUT
select @schedule_id
GO

-- LogBackup JOB
USE [msdb]
GO
DECLARE @jobId BINARY(16)
EXEC  msdb.dbo.sp_add_job @job_name=N'VendorsLogBackup', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_page=2, 
		@delete_level=0, 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'SAJT-PC\Tulajdonos', @job_id = @jobId OUTPUT
select @jobId
GO
EXEC msdb.dbo.sp_add_jobserver @job_name=N'VendorsLogBackup', @server_name = N'SAJT-PC'
GO
USE [msdb]
GO
EXEC msdb.dbo.sp_add_jobstep @job_name=N'VendorsLogBackup', @step_name=N'VendorsLogBackup', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_fail_action=2, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'---  .Scripts\VendorsLogBackup.sql ---
BACKUP LOG [Vendors] TO  DISK = N''C:\VendorDB\Backup\VendorLogBackup.bak'' WITH NOFORMAT, NOINIT,  NAME = N''Vendors-Full Database Backup'', SKIP, NOREWIND, NOUNLOAD,  STATS = 10, CHECKSUM
GO
declare @backupSetId as int
select @backupSetId = position from msdb..backupset where database_name=N''Vendors'' and backup_set_id=(select max(backup_set_id) from msdb..backupset where database_name=N''Vendors'' )
if @backupSetId is null begin raiserror(N''Verify failed. Backup information for database ''''Vendors'''' not found.'', 16, 1) end
RESTORE VERIFYONLY FROM  DISK = N''C:\VendorDB\Backup\VendorLogBackup.bak'' WITH  FILE = @backupSetId,  NOUNLOAD,  NOREWIND
GO
', 
		@database_name=N'Vendors', 
		@database_user_name=N'dbo', 
		@output_file_name=N'C:\VendorDB\Backup\LogBackup.log', 
		@flags=0
GO
USE [msdb]
GO
EXEC msdb.dbo.sp_update_job @job_name=N'VendorsLogBackup', 
		@enabled=1, 
		@start_step_id=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_page=2, 
		@delete_level=0, 
		@description=N'', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'SAJT-PC\Tulajdonos', 
		@notify_email_operator_name=N'', 
		@notify_page_operator_name=N''
GO
USE [msdb]
GO
DECLARE @schedule_id int
EXEC msdb.dbo.sp_add_jobschedule @job_name=N'VendorsLogBackup', @name=N'VendorsLogBackup', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=8, 
		@freq_subday_interval=2, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20210220, 
		@active_end_date=99991231, 
		@active_start_time=80000, 
		@active_end_time=180100, @schedule_id = @schedule_id OUTPUT
select @schedule_id
GO
USE [msdb]
GO
DECLARE @schedule_id int
EXEC msdb.dbo.sp_add_jobschedule @job_name=N'VendorsLogBackup', @name=N'VendorsLogBackup', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=8, 
		@freq_subday_interval=4, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20210220, 
		@active_end_date=99991231, 
		@active_start_time=110000, 
		@active_end_time=190100, @schedule_id = @schedule_id OUTPUT
select @schedule_id
GO

