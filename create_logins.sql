CREATE LOGIN lre WITH PASSWORD = 'mercurypw', CHECK_EXPIRATION = OFF, CHECK_POLICY = OFF;
CREATE LOGIN lre_db_admin WITH PASSWORD = 'mercurypw', CHECK_EXPIRATION = OFF, CHECK_POLICY = OFF;
EXEC sp_addsrvrolemember 'lre_db_admin', 'dbcreator';
GO