-- Melyik tábla melyik Filegroup-ba tartozik?
SELECT o.name, f.name
FROM sys.indexes i
INNER JOIN sys.filegroups f ON i.data_space_id = f.data_space_id
INNER JOIN sys.all_objects o ON i.object_id = o.object_id
WHERE i.data_space_id = f.data_space_id AND o.type = 'U'