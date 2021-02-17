-- 8. feladat
---  .Scripts\VendorsFullBackup.sql ---
BACKUP DATABASE [Vendors] TO  DISK = N'C:\VendorDB\Backup\VendorFullBackup.bak' WITH NOFORMAT, INIT,  NAME = N'Vendors-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10, CHECKSUM
GO
declare @backupSetId as int
select @backupSetId = position from msdb..backupset where database_name=N'Vendors' and backup_set_id=(select max(backup_set_id) from msdb..backupset where database_name=N'Vendors' )
if @backupSetId is null begin raiserror(N'Verify failed. Backup information for database ''Vendors'' not found.', 16, 1) end
RESTORE VERIFYONLY FROM  DISK = N'C:\VendorDB\Backup\VendorFullBackup.bak' WITH  FILE = @backupSetId,  NOUNLOAD,  NOREWIND
GO
