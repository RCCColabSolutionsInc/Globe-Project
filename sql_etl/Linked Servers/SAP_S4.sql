USE [master]
GO

/****** Object:  LinkedServer [SAP_S4]    Script Date: 5/5/2026 12:51:08 PM ******/
EXEC master.dbo.sp_addlinkedserver @server = N'SAP_S4', @srvproduct=N'SAP S/4HANA', @provider=N'MSDASQL', @datasrc=N'GlobeHanaAws_64bit', @provstr=N'DSN=GlobeHanaAws_64bit;UID=SAPPRD;Pwd=xxxxx;Port=30015'
 /* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'SAP_S4',@useself=N'False',@locallogin=NULL,@rmtuser=NULL,@rmtpassword=NULL
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'SAP_S4',@useself=N'False',@locallogin=N'GlobeDM',@rmtuser=N'SAPPRD',@rmtpassword='########'
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'SAP_S4',@useself=N'False',@locallogin=N'VMDACDPD01\sqldbo',@rmtuser=N'SAPPRD',@rmtpassword='########'

GO

EXEC master.dbo.sp_serveroption @server=N'SAP_S4', @optname=N'collation compatible', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'SAP_S4', @optname=N'data access', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'SAP_S4', @optname=N'dist', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'SAP_S4', @optname=N'pub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'SAP_S4', @optname=N'rpc', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'SAP_S4', @optname=N'rpc out', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'SAP_S4', @optname=N'sub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'SAP_S4', @optname=N'connect timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'SAP_S4', @optname=N'collation name', @optvalue=null
GO

EXEC master.dbo.sp_serveroption @server=N'SAP_S4', @optname=N'lazy schema validation', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'SAP_S4', @optname=N'query timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'SAP_S4', @optname=N'use remote collation', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'SAP_S4', @optname=N'remote proc transaction promotion', @optvalue=N'true'
GO


