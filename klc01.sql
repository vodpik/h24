USE [master]
GO
/****** Object:  Database [klc01]    Script Date: 03.05.2023 9:12:40 ******/
CREATE DATABASE [klc01]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'klc01', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\klc01.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'klc01_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\klc01_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [klc01] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [klc01].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [klc01] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [klc01] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [klc01] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [klc01] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [klc01] SET ARITHABORT OFF 
GO
ALTER DATABASE [klc01] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [klc01] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [klc01] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [klc01] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [klc01] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [klc01] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [klc01] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [klc01] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [klc01] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [klc01] SET  DISABLE_BROKER 
GO
ALTER DATABASE [klc01] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [klc01] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [klc01] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [klc01] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [klc01] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [klc01] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [klc01] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [klc01] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [klc01] SET  MULTI_USER 
GO
ALTER DATABASE [klc01] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [klc01] SET DB_CHAINING OFF 
GO
ALTER DATABASE [klc01] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [klc01] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [klc01] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [klc01] SET QUERY_STORE = OFF
GO
USE [klc01]
GO
/****** Object:  User [sportident]    Script Date: 03.05.2023 9:12:40 ******/
CREATE USER [sportident] FOR LOGIN [sportident] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [sportident]
GO
/****** Object:  UserDefinedFunction [dbo].[time_from_start]    Script Date: 03.05.2023 9:12:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[time_from_start] (
    @start_time DATETIME
   ,@punch_time DATETIME
)
/*
select dbo.time_from_start('2021-01-04 00:00:00.000', '2021-01-04 00:15:43.000')
*/
RETURNS VARCHAR(10)
AS
BEGIN
    -- Declare the return variable here
    DECLARE @diff_seconds INT
    DECLARE @hours AS INT
    DECLARE @minutes AS INT
    DECLARE @sec AS CHAR(2)
    DECLARE @minus AS CHAR(1)
    DECLARE @time_from_start AS VARCHAR(10)

    -- Add the T-SQL statements to compute the return value here	
    SET @diff_seconds = DATEDIFF(s, @start_time, @punch_time)
    IF @diff_seconds < 0
    BEGIN
        SET @diff_seconds = ABS(@diff_seconds)
        SET @minus = '-'
    END
    ELSE
        SET @minus = ''

    SET @hours = @diff_seconds / 3600
    SET @minutes = ((@diff_seconds - @hours * 3600) / 60)
    SET @sec = CAST(@diff_seconds % 60 AS CHAR(2))
    SET @sec = RIGHT('00' + RTRIM(@sec), 2)

    -- Return the result of the function
    SET @time_from_start = @minus + RTRIM(CAST(@hours AS CHAR(2))) + ':' + RIGHT('00' + RTRIM(CAST(@minutes AS CHAR(2))), 2) + ':' + @sec
    RETURN @time_from_start
END
GO
/****** Object:  Table [dbo].[competitors]    Script Date: 03.05.2023 9:12:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[competitors](
	[comp_id] [int] IDENTITY(1,1) NOT NULL,
	[comp_name] [nvarchar](50) NULL,
	[bib] [nvarchar](10) NOT NULL,
	[comp_chip_id] [int] NULL,
	[rented_chip] [bit] NULL,
	[team_id] [int] NULL,
	[rank_order] [int] NOT NULL,
	[comp_withdrawn] [bit] NOT NULL,
	[comp_status] [varchar](10) NULL,
	[comp_valid_flag] [bit] NULL,
	[comp_club] [nvarchar](50) NULL,
	[comp_reg] [nvarchar](10) NULL,
	[comp_country] [varchar](10) NULL,
	[comp_birthday] [datetime] NULL,
	[as_of_date] [datetime] NOT NULL,
	[withdrawn_datetime] [datetime] NULL,
	[comp_id_previous] [int] NULL,
 CONSTRAINT [PK__competit__531653DCEFC42586] PRIMARY KEY NONCLUSTERED 
(
	[comp_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[categories]    Script Date: 03.05.2023 9:12:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[categories](
	[cat_id] [int] IDENTITY(1,1) NOT NULL,
	[cat_name] [nvarchar](50) NOT NULL,
	[first_start_number] [int] NULL,
	[cat_start_time] [datetime] NULL,
	[cat_time_limit] [int] NULL,
	[force_order] [bit] NULL,
	[valid] [bit] NULL,
	[as_of_date] [datetime] NOT NULL,
 CONSTRAINT [PK__categori__DD5DDDBC2286FC7F] PRIMARY KEY NONCLUSTERED 
(
	[cat_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[teams]    Script Date: 03.05.2023 9:12:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[teams](
	[team_id] [int] IDENTITY(1,1) NOT NULL,
	[team_nr] [int] NULL,
	[team_name] [nvarchar](255) NULL,
	[team_abbr] [nvarchar](50) NULL,
	[cat_id] [int] NULL,
	[team_did_start] [bit] NOT NULL,
	[team_status] [varchar](10) NULL,
	[race_end] [datetime] NULL,
	[oris_id] [int] NULL,
	[as_of_date] [datetime] NOT NULL,
 CONSTRAINT [PK__teams__F82DEDBDF3AC913B] PRIMARY KEY NONCLUSTERED 
(
	[team_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[v_comp_teams]    Script Date: 03.05.2023 9:12:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[v_comp_teams]
AS
	SELECT
	t.team_id,
	t.team_nr,
	t.team_name,
	t.team_did_start,
	t.team_status,
	t.race_end,
	c.comp_id,
	c.comp_chip_id,
	c.comp_name,
	c.bib,
	c.rented_chip,
	c.rank_order,
	c.comp_withdrawn,
	c.comp_status,
	c.comp_country,
	c.comp_birthday,
	c.comp_valid_flag,
	c.withdrawn_datetime,
	ca.cat_name,
	ca.cat_start_time,
	ca.cat_time_limit
FROM teams AS t
INNER JOIN competitors AS c
	ON t.team_id = c.team_id
INNER JOIN categories AS ca
	ON t.cat_id = ca.cat_id
GO
/****** Object:  Table [dbo].[_l]    Script Date: 03.05.2023 9:12:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[_l](
	[comp_id] [int] NULL,
	[course_id] [int] NULL,
	[readout_id] [int] NULL,
	[start_dtime] [datetime] NULL,
	[start_time] [varchar](10) NULL,
	[finish_dtime] [datetime] NULL,
	[finish_time] [varchar](10) NULL,
	[leg_status] [varchar](3) NOT NULL,
	[dsk_penalty] [time](7) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[calendar]    Script Date: 03.05.2023 9:12:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[calendar](
	[TheDate] [date] NULL,
	[TheDateTime] [datetime] NULL,
	[TheDay] [int] NULL,
	[TheDayName] [nvarchar](30) NULL,
	[TheWeek] [int] NULL,
	[TheISOWeek] [int] NULL,
	[TheDayOfWeek] [int] NULL,
	[TheMonth] [int] NULL,
	[TheMonthName] [nvarchar](30) NULL,
	[TheQuarter] [int] NULL,
	[TheYear] [int] NULL,
	[TheFirstOfMonth] [date] NULL,
	[TheLastOfYear] [date] NULL,
	[TheDayOfYear] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[controls]    Script Date: 03.05.2023 9:12:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[controls](
	[control_id] [varchar](5) NOT NULL,
	[control_code] [varchar](5) NOT NULL,
	[alt_code] [varchar](5) NULL,
	[time_direction] [char](2) NULL,
	[dif_hour] [int] NULL,
	[dif_min] [int] NULL,
	[dif_sec] [int] NULL,
	[as_of_date] [datetime] NOT NULL,
 CONSTRAINT [controls_PK] PRIMARY KEY NONCLUSTERED 
(
	[control_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[course_codes]    Script Date: 03.05.2023 9:12:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[course_codes](
	[cc_id] [int] IDENTITY(1,1) NOT NULL,
	[course_id] [int] NOT NULL,
	[control_id] [varchar](5) NOT NULL,
	[position] [int] NOT NULL,
	[cc_status] [bit] NULL,
	[as_of_date] [datetime] NOT NULL,
 CONSTRAINT [PK__course_c__9F1E187BD1C5FCE4] PRIMARY KEY CLUSTERED 
(
	[cc_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[courses]    Script Date: 03.05.2023 9:12:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[courses](
	[course_id] [int] IDENTITY(1,1) NOT NULL,
	[course_name] [nvarchar](20) NOT NULL,
	[course_length] [int] NULL,
	[course_climb] [int] NULL,
	[course_type] [nvarchar](100) NULL,
	[control_count] [int] NULL,
	[as_of_date] [datetime] NOT NULL,
 CONSTRAINT [PK__courses__8F1EF7AE2B55AA27] PRIMARY KEY CLUSTERED 
(
	[course_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[entry_competitors]    Script Date: 03.05.2023 9:12:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[entry_competitors](
	[comp_id] [int] IDENTITY(1,1) NOT NULL,
	[comp_name] [nvarchar](50) NULL,
	[comp_chip_id] [int] NULL,
	[rented_chip] [bit] NULL,
	[entry_team_id] [int] NULL,
	[rank_order] [int] NOT NULL,
	[comp_country] [varchar](10) NULL,
	[comp_birthday] [datetime] NULL,
	[as_of_date] [datetime] NOT NULL,
 CONSTRAINT [PK_entry_competitor] PRIMARY KEY NONCLUSTERED 
(
	[comp_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[entry_file]    Script Date: 03.05.2023 9:12:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[entry_file](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[entry] [text] NULL,
	[entry2] [xml] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[entry_teams]    Script Date: 03.05.2023 9:12:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[entry_teams](
	[team_id] [int] IDENTITY(1,1) NOT NULL,
	[team_nr] [int] NULL,
	[team_name] [nvarchar](255) NULL,
	[team_abbr] [nvarchar](50) NULL,
	[class_name] [nvarchar](20) NULL,
	[as_of_date] [datetime] NOT NULL,
 CONSTRAINT [PK_entry_teams] PRIMARY KEY NONCLUSTERED 
(
	[team_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[entry_xml]    Script Date: 03.05.2023 9:12:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[entry_xml](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[oris_team_id] [int] NOT NULL,
	[class_name] [nvarchar](20) NULL,
	[team_name] [nvarchar](50) NULL,
	[team_short_name] [nvarchar](50) NULL,
	[leg] [int] NULL,
	[family] [nvarchar](50) NULL,
	[given] [nvarchar](50) NULL,
	[gender] [nchar](10) NULL,
	[country] [nchar](10) NULL,
	[birth_date] [nvarchar](50) NULL,
	[si_chip] [int] NULL,
	[note] [nvarchar](500) NULL,
 CONSTRAINT [PK_entry_xml] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[legs]    Script Date: 03.05.2023 9:12:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[legs](
	[leg_id] [int] IDENTITY(1,1) NOT NULL,
	[comp_id] [int] NOT NULL,
	[course_id] [int] NULL,
	[readout_id] [int] NULL,
	[start_dtime] [datetime] NULL,
	[start_time] [varchar](20) NULL,
	[finish_dtime] [datetime] NULL,
	[finish_time] [varchar](20) NULL,
	[leg_time] [varchar](20) NULL,
	[leg_status] [nvarchar](10) NULL,
	[dsk_penalty] [time](7) NULL,
	[as_of_date] [datetime] NOT NULL,
	[valid_flag] [bit] NULL,
	[starting_leg] [bit] NULL,
 CONSTRAINT [PK__legs__810CE3C034474519] PRIMARY KEY CLUSTERED 
(
	[leg_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[logs]    Script Date: 03.05.2023 9:12:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[logs](
	[logs_id] [int] IDENTITY(1,1) NOT NULL,
	[logs_time] [datetime] NOT NULL,
	[logs_message] [text] NULL,
	[logs_type] [nvarchar](20) NULL,
	[as_of_date] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[logs_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[results]    Script Date: 03.05.2023 9:12:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[results](
	[res_id] [int] IDENTITY(1,1) NOT NULL,
	[cat_id] [int] NULL,
	[team_name] [nvarchar](255) NULL,
	[team_nr] [int] NOT NULL,
	[team_id] [int] NOT NULL,
	[race_end] [datetime] NULL,
	[comp_name] [nvarchar](50) NULL,
	[bib] [nvarchar](10) NOT NULL,
	[start_time] [varchar](20) NULL,
	[finish_time] [varchar](20) NULL,
	[leg_time] [varchar](20) NULL,
	[leg_status] [nvarchar](10) NULL,
	[course_id] [int] NULL,
	[valid_leg] [int] NOT NULL,
	[sum_legs] [int] NULL,
	[max_finish] [varchar](20) NULL,
 CONSTRAINT [PK_results] PRIMARY KEY CLUSTERED 
(
	[res_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[settings]    Script Date: 03.05.2023 9:12:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[settings](
	[s_id] [int] IDENTITY(1,1) NOT NULL,
	[config_name] [nvarchar](50) NOT NULL,
	[config_value] [nvarchar](1000) NULL,
	[as_of_date] [datetime] NOT NULL,
 CONSTRAINT [PK_settings] PRIMARY KEY CLUSTERED 
(
	[s_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[si_readout]    Script Date: 03.05.2023 9:12:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[si_readout](
	[readout_id] [int] IDENTITY(1,1) NOT NULL,
	[chip_id] [varchar](15) NOT NULL,
	[card_readout_datetime] [datetime] NOT NULL,
	[clear_datetime] [datetime] NULL,
	[start_datetime] [datetime] NULL,
	[check_datetime] [datetime] NULL,
	[finish_datetime] [datetime] NULL,
	[finish_missing] [bit] NULL,
	[punch_count] [int] NULL,
	[as_of_date] [datetime] NOT NULL,
 CONSTRAINT [PK__si_reado__C71FE367F7D92631] PRIMARY KEY CLUSTERED 
(
	[readout_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[si_stamps]    Script Date: 03.05.2023 9:12:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[si_stamps](
	[id_stamp] [int] IDENTITY(1,1) NOT NULL,
	[readout_id] [int] NOT NULL,
	[chip_id] [bigint] NOT NULL,
	[control_code] [varchar](5) NOT NULL,
	[control_mode] [int] NOT NULL,
	[punch_datetime] [datetime] NULL,
	[punch_wday] [varchar](50) NULL,
	[punch_index] [int] NULL,
	[as_of_date] [datetime] NOT NULL,
 CONSTRAINT [PK__si_stamp__12FEB3630A0F9872] PRIMARY KEY CLUSTERED 
(
	[id_stamp] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[slips]    Script Date: 03.05.2023 9:12:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[slips](
	[slip_id] [int] IDENTITY(1,1) NOT NULL,
	[comp_id] [int] NOT NULL,
	[team_id] [int] NULL,
	[course_id] [int] NOT NULL,
	[course_name] [nvarchar](20) NOT NULL,
	[readout_id] [int] NOT NULL,
	[chip_id] [int] NOT NULL,
	[leg_id] [int] NOT NULL,
	[comp_name] [nvarchar](50) NULL,
	[bib] [nvarchar](10) NOT NULL,
	[comp_country] [varchar](10) NULL,
	[rented_chip] [bit] NULL,
	[team_nr] [int] NULL,
	[team_name] [nvarchar](255) NULL,
	[cat_name] [nvarchar](50) NOT NULL,
	[course_length] [int] NULL,
	[course_climb] [int] NULL,
	[start_dtime] [datetime] NULL,
	[clear_dtime] [datetime] NULL,
	[clear_time] [varchar](15) NULL,
	[check_dtime] [datetime] NULL,
	[check_time] [varchar](15) NULL,
	[finish_dtime] [datetime] NULL,
	[leg_time] [varchar](15) NULL,
	[punch_index] [int] NULL,
	[position] [int] NULL,
	[control_code] [varchar](5) NULL,
	[punch_dtime] [datetime] NULL,
	[punch_time] [varchar](15) NULL,
	[lap_dtime] [time](7) NULL,
	[lap_time] [varchar](15) NULL,
	[valid_flag] [bit] NULL,
	[leg_status] [nvarchar](10) NULL,
	[dsk_penalty] [time](7) NULL,
	[team_race_end_zero] [varchar](10) NULL,
	[team_race_end] [datetime] NULL,
	[stamp_readout_dtime] [datetime] NULL,
	[as_of_date] [datetime] NOT NULL,
 CONSTRAINT [PK__slips__43C7142249FC2140] PRIMARY KEY CLUSTERED 
(
	[slip_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[categories] ADD  CONSTRAINT [DF__categorie__as_of__778AC167]  DEFAULT (getdate()) FOR [as_of_date]
GO
ALTER TABLE [dbo].[competitors] ADD  CONSTRAINT [DF__competitors__bib__4BAC3F29]  DEFAULT ('0') FOR [bib]
GO
ALTER TABLE [dbo].[competitors] ADD  CONSTRAINT [DF__competito__rank___4AB81AF0]  DEFAULT ((0)) FOR [rank_order]
GO
ALTER TABLE [dbo].[competitors] ADD  CONSTRAINT [DF_competitors_comp_withdrawn]  DEFAULT ((0)) FOR [comp_withdrawn]
GO
ALTER TABLE [dbo].[competitors] ADD  CONSTRAINT [DF__competito__as_of__787EE5A0]  DEFAULT (getdate()) FOR [as_of_date]
GO
ALTER TABLE [dbo].[controls] ADD  CONSTRAINT [DF__controls__as_of___797309D9]  DEFAULT (getdate()) FOR [as_of_date]
GO
ALTER TABLE [dbo].[course_codes] ADD  CONSTRAINT [DF__course_co__as_of__1332DBDC]  DEFAULT (getdate()) FOR [as_of_date]
GO
ALTER TABLE [dbo].[courses] ADD  CONSTRAINT [DF__courses__as_of_d__14270015]  DEFAULT (getdate()) FOR [as_of_date]
GO
ALTER TABLE [dbo].[entry_competitors] ADD  CONSTRAINT [DF_entry_competitor_rank]  DEFAULT ((0)) FOR [rank_order]
GO
ALTER TABLE [dbo].[entry_competitors] ADD  CONSTRAINT [DF_entry_competitor_as_of]  DEFAULT (getdate()) FOR [as_of_date]
GO
ALTER TABLE [dbo].[entry_teams] ADD  CONSTRAINT [DF_entry_teams_as_of_date]  DEFAULT (getdate()) FOR [as_of_date]
GO
ALTER TABLE [dbo].[legs] ADD  CONSTRAINT [DF__legs__as_of_date__7D439ABD]  DEFAULT (getdate()) FOR [as_of_date]
GO
ALTER TABLE [dbo].[logs] ADD  DEFAULT (getdate()) FOR [as_of_date]
GO
ALTER TABLE [dbo].[settings] ADD  CONSTRAINT [DF__settings__as_of___7F2BE32F]  DEFAULT (getdate()) FOR [as_of_date]
GO
ALTER TABLE [dbo].[si_readout] ADD  CONSTRAINT [DF__si_readou__as_of__00200768]  DEFAULT (getdate()) FOR [as_of_date]
GO
ALTER TABLE [dbo].[si_stamps] ADD  CONSTRAINT [DF__si_stamps__as_of__01142BA1]  DEFAULT (getdate()) FOR [as_of_date]
GO
ALTER TABLE [dbo].[slips] ADD  CONSTRAINT [DF__slips__as_of_dat__42E1EEFE]  DEFAULT (getdate()) FOR [as_of_date]
GO
ALTER TABLE [dbo].[teams] ADD  CONSTRAINT [DF__teams__as_of_dat__70A8B9AE]  DEFAULT (getdate()) FOR [as_of_date]
GO
ALTER TABLE [dbo].[competitors]  WITH CHECK ADD  CONSTRAINT [FK_competitors_teams] FOREIGN KEY([team_id])
REFERENCES [dbo].[teams] ([team_id])
GO
ALTER TABLE [dbo].[competitors] CHECK CONSTRAINT [FK_competitors_teams]
GO
ALTER TABLE [dbo].[course_codes]  WITH CHECK ADD  CONSTRAINT [FK_course_codes_controls] FOREIGN KEY([control_id])
REFERENCES [dbo].[controls] ([control_id])
GO
ALTER TABLE [dbo].[course_codes] CHECK CONSTRAINT [FK_course_codes_controls]
GO
ALTER TABLE [dbo].[course_codes]  WITH CHECK ADD  CONSTRAINT [FK_course_codes_courses] FOREIGN KEY([course_id])
REFERENCES [dbo].[courses] ([course_id])
GO
ALTER TABLE [dbo].[course_codes] CHECK CONSTRAINT [FK_course_codes_courses]
GO
ALTER TABLE [dbo].[legs]  WITH CHECK ADD  CONSTRAINT [FK_legs_competitors] FOREIGN KEY([comp_id])
REFERENCES [dbo].[competitors] ([comp_id])
GO
ALTER TABLE [dbo].[legs] CHECK CONSTRAINT [FK_legs_competitors]
GO
ALTER TABLE [dbo].[legs]  WITH CHECK ADD  CONSTRAINT [FK_legs_courses1] FOREIGN KEY([course_id])
REFERENCES [dbo].[courses] ([course_id])
GO
ALTER TABLE [dbo].[legs] CHECK CONSTRAINT [FK_legs_courses1]
GO
ALTER TABLE [dbo].[si_stamps]  WITH CHECK ADD  CONSTRAINT [FK_si_stamps_si_readout] FOREIGN KEY([readout_id])
REFERENCES [dbo].[si_readout] ([readout_id])
GO
ALTER TABLE [dbo].[si_stamps] CHECK CONSTRAINT [FK_si_stamps_si_readout]
GO
ALTER TABLE [dbo].[teams]  WITH CHECK ADD  CONSTRAINT [FK_teams_categories] FOREIGN KEY([cat_id])
REFERENCES [dbo].[categories] ([cat_id])
GO
ALTER TABLE [dbo].[teams] CHECK CONSTRAINT [FK_teams_categories]
GO
/****** Object:  StoredProcedure [dbo].[get_competitor]    Script Date: 03.05.2023 9:12:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[get_competitor]
	@chip_id INT
AS
-- =============================================
-- Author:		<Author,,Name>
-- Create date: 2021-01-07
-- Description:	returns competitor_id based on chip_id
-- =============================================
/*
declare @chip_id INT = 8914
execute get_competitor
	@chip_id INT
*/
BEGIN
	SET NOCOUNT ON;

	SELECT comp_id FROM dbo.competitors
	WHERE comp_chip_id = @chip_id

END
GO
/****** Object:  StoredProcedure [dbo].[get_one_entry_json]    Script Date: 03.05.2023 9:12:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[get_one_entry_json]
	-- Add the parameters for the stored procedure here
	@team_id int
AS
/*
-- Author:		<Author,,Name>
-- Create date: 2022-07-25
-- Description:	returns entries of one team as json string

execute get_one_entry_json 43
*/
BEGIN
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT
		ca.cat_name,
		--ca.valid,
		t.team_nr,
		t.team_name,
		t.team_id,
		0 as team_wdrn_penalty,
		(
			SELECT
				c.comp_name,
				c.bib AS comp_bib,
				c.comp_chip_id AS siid,
				c.comp_withdrawn,
				c.comp_valid_flag,
				c.rank_order AS team_rank,
				c.team_id
			FROM   competitors AS c
			WHERE c.team_id = t.team_id FOR JSON PATH, INCLUDE_NULL_VALUES
		) AS comp
	FROM categories AS ca
	INNER JOIN teams AS t
		ON ca.cat_id = t.cat_id
	where t.team_id = @team_id
	FOR JSON PATH, INCLUDE_NULL_VALUES

END
GO
/****** Object:  StoredProcedure [dbo].[get_slip_json]    Script Date: 03.05.2023 9:12:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[get_slip_json]
-- Add the parameters for the stored procedure here
	@readout_id INT
AS
/*
Create date: 2022-07-28
Description: get json string of slip
*/
/*
DECLARE @readout_id INT = 1150

EXECUTE dbo.get_slip_json
	@readout_id
*/
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare @ResultJson nvarchar(max)
	set @ResultJson =
	(
	SELECT DISTINCT 
		s.cat_name AS class_name,
		s.team_nr,
		s.team_name,
		s.team_id,
		s.bib AS comp_bib,
		s.course_name as leg_course,
		s.course_length as leg_length,
		s.course_climb as leg_climb,
		s.leg_id,
		s.comp_name, 
		s.chip_id AS siid, 
		s.leg_time,
		FORMAT(s.start_dtime, N'dd.MM.yyyy HH\:mm\:ss') AS leg_start,
		FORMAT(s.finish_dtime, N'dd.MM.yyyy HH\:mm\:ss') AS leg_finish,
		s.leg_status,
		c.rank_order AS team_rank,
	--	0 AS finishtimems,
	--	0 AS timems,
		s.comp_id, 
		s.readout_id,
		s.dsk_penalty,
		s.valid_flag AS leg_valid,
		FORMAT(s.team_race_end, N'dd.MM.yyyy HH\:mm\:ss') AS team_race_end,
		(
			SELECT 
				punch_index,
				position,
				control_code,
				punch_dtime,
				punch_time,
				lap_dtime,
				lap_time,
				leg_time
			FROM dbo.slips		
			WHERE 
				readout_id = s.readout_id
			FOR JSON PATH, 
				INCLUDE_NULL_VALUES
		) AS sp
	FROM dbo.slips AS s
	inner join competitors as c on s.comp_id = c.comp_id
	WHERE s.readout_id = @readout_id
	FOR JSON path
	)
	select @ResultJson
END
GO
/****** Object:  StoredProcedure [dbo].[rpt_results]    Script Date: 03.05.2023 9:12:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[rpt_results]
    @category_id INT = NULL
AS
/*
 Create date: 2022-10-02
 Description:    shows results

 declare @category_id int = 2
 exec rpt_results

*/
    BEGIN
        -- SET NOCOUNT ON added to prevent extra result sets from
        -- interfering with SELECT statements.
        SET NOCOUNT ON;

        -- Insert statements for procedure here
/*        select
            max(a.sum_legs) over (partition by a.team_id) as total_legs
            ,a.team_name
            ,a.team_nr
            ,a.team_id
            ,a.comp_name
            ,a.bib
            ,a.finish_time
            ,a.course_id
            ,a.valid_leg
            ,a.leg_status
            ,a.sum_legs
            ,a.max_finish
            ,a.race_end
        from
        (*/
            SELECT
				t.cat_id,
                t.team_name,
                t.team_nr,
                t.team_id,
                t.race_end,
                c.comp_name,
                c.bib,
                l.start_time,
                l.finish_time,
                l.leg_time,
                l.leg_status,
                l.course_id,
                CASE
                  WHEN l.leg_status = 'OK'
                       AND l.finish_dtime < t.race_end
                  THEN 1
                  ELSE 0
                END AS valid_leg,
                SUM(CASE
                    WHEN l.leg_status = 'OK'
                         AND l.finish_dtime < t.race_end
                    THEN 1
                    ELSE 0
                    END) OVER(PARTITION BY t.team_id ORDER BY l.finish_dtime) AS sum_legs,
                --MAX(l.finish_dtime) OVER(PARTITION BY t.team_id) as max_finish
                MAX(l.finish_time) OVER(PARTITION BY t.team_id) as max_finish
            FROM  dbo.legs AS l
            INNER JOIN dbo.competitors AS c
                ON l.comp_id = c.comp_id
            INNER JOIN dbo.teams AS t
                ON t.team_id = c.team_id
            WHERE t.cat_id = @category_id
                  OR @category_id IS NULL
--        ) as a
    END
GO
/****** Object:  StoredProcedure [dbo].[sp_check_courses]    Script Date: 03.05.2023 9:12:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_check_courses]
AS
/*
	Create date: 2023-01-14
	Description:	checks all courses for intersection with another one

execute dbo.sp_check_courses
*/
BEGIN
	SET NOCOUNT ON;


	DECLARE @same_courses TABLE(
		course_id INT NOT NULL,
		course_name NVARCHAR(20) NOT NULL,
		control_code NVARCHAR(20) NULL,
		course_name1 NVARCHAR(20) NOT NULL
	)

	DECLARE @course_id INT
	DECLARE @course_name NVARCHAR(20)
	
	DECLARE course_cursor CURSOR FOR 
	SELECT 
		course_id,
		course_name
	from dbo.courses

	OPEN course_cursor  
	FETCH NEXT FROM course_cursor INTO @course_id, @course_name

	WHILE @@FETCH_STATUS = 0  
	BEGIN  

		WITH courses_cte AS (
			SELECT
				c.course_id
			   ,c.course_name
			   ,con.control_code
			   ,cc.position
			   ,cc.cc_status
			FROM
				dbo.courses AS c
				INNER JOIN dbo.course_codes AS cc ON c.course_id = cc.course_id
				INNER JOIN dbo.controls AS con ON cc.control_id = con.control_id
			WHERE
				con.control_code NOT IN ('F', 'F1', 'S1', 'S')
		)
		,punches_cte AS (
			SELECT 
				cc.control_id,
				co.control_code,
				cc.position
			FROM course_codes AS cc
			inner join controls AS co ON cc.control_id = co.control_id
			WHERE course_id = @course_id
			and cc.control_id <> 'S1'
		)
		,course_punch AS (
			SELECT
				c.course_id
			   ,c.course_name
			   ,c.control_code
			   ,c.position
			   ,c.cc_status
			   ,p.control_code AS p_control_code
			   ,p.position as punch_index
			FROM
				courses_cte AS c
				LEFT OUTER JOIN punches_cte AS p ON c.control_code = p.control_code
		)
		,all_missing AS (
			SELECT  DISTINCT
					cp.course_id
				   ,cp.course_name
			FROM
					course_punch AS cp
					LEFT OUTER JOIN punches_cte AS pc ON cp.control_code = pc.control_code
														 AND cp.position <= pc.position
			WHERE
					pc.control_code IS NULL
		)
		INSERT INTO @same_courses 
		(
			course_id,
			course_name,
			course_name1
		)
		SELECT  DISTINCT
				@course_id,
				@course_name,
				cp.course_name as course_name1
		FROM
				course_punch AS cp
				LEFT OUTER JOIN all_missing AS am ON cp.course_id = am.course_id
		WHERE
				am.course_id IS NULL
				and cp.course_id <> @course_id

	FETCH NEXT FROM course_cursor INTO @course_id, @course_name
	END 

	CLOSE course_cursor
	DEALLOCATE course_cursor


	SELECT * FROM @same_courses
	ORDER BY course_name, course_name1

END
GO
/****** Object:  StoredProcedure [dbo].[sp_fill_calendar]    Script Date: 03.05.2023 9:12:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_fill_calendar]
	-- Add the parameters for the stored procedure here
	@StartDate  date,
	@years int
AS
-- =============================================
-- Author:		<Author,,Name>
-- Create date: 2023-04-10
-- Description:	fills Calendar table
-- =============================================
/*
execute sp_fill_calendar '2023-01-01', 5
*/
BEGIN
	SET NOCOUNT ON;

	SET DATEFIRST 1;
	truncate table dbo.calendar

	DECLARE @CutoffDate date = DATEADD(DAY, -1, DATEADD(YEAR, @years, @StartDate));

	;WITH seq(n) AS 
	(
	  SELECT 0 UNION ALL SELECT n + 1 FROM seq
	  WHERE n < DATEDIFF(DAY, @StartDate, @CutoffDate)
	),
	d(d) AS 
	(
	  SELECT DATEADD(DAY, n, @StartDate) FROM seq
	),
	src AS
	(
	  SELECT
		TheDate         = CONVERT(date, d),
		TheDateTime = convert(datetime, d),
		TheDay          = DATEPART(DAY,       d),
		TheDayName      = DATENAME(WEEKDAY,   d),
		TheDayOfWeek    = DATEPART(WEEKDAY,   d)
	  FROM d
	)
	insert into dbo.calendar (
		TheDate,
		TheDateTime,
		TheDay,
		TheDayName,
		TheDayOfWeek)
	select
		TheDate,
		TheDateTime,
		TheDay,
		TheDayName,
		TheDayOfWeek
	FROM src
	  ORDER BY TheDate
	  OPTION (MAXRECURSION 0)

END
GO
/****** Object:  StoredProcedure [dbo].[sp_fill_results]    Script Date: 03.05.2023 9:12:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_fill_results]
    @category_id INT = NULL
AS
/*
 Create date: 2022-10-02
 Description: fills results

 declare @category_id int = null
 exec sp_fill_results

*/
    BEGIN
        -- SET NOCOUNT ON added to prevent extra result sets from
        -- interfering with SELECT statements.
        SET NOCOUNT ON;

        -- Insert statements for procedure here

		delete from dbo.results

		insert into dbo.results(
			cat_id,
            team_name,
            team_nr,
            team_id,
            race_end,
            comp_name,
            bib,
            start_time,
            finish_time,
            leg_time,
            leg_status,
            course_id,
            valid_leg,
            sum_legs,
			max_finish
		)
        SELECT
			t.cat_id,
            t.team_name,
            t.team_nr,
            t.team_id,
            t.race_end,
            c.comp_name,
            c.bib,
            l.start_time,
            l.finish_time,
            l.leg_time,
            l.leg_status,
            l.course_id,
            CASE
                WHEN l.leg_status = 'OK'
                    AND l.finish_dtime < t.race_end
                THEN 1
                ELSE 0
            END AS valid_leg,
            SUM(CASE
                WHEN l.leg_status = 'OK'
                        AND l.finish_dtime < t.race_end
                THEN 1
                ELSE 0
                END) OVER(PARTITION BY t.team_id ORDER BY l.finish_dtime) AS sum_legs,
            --MAX(l.finish_dtime) OVER(PARTITION BY t.team_id) as max_finish
            MAX(l.finish_time) OVER(PARTITION BY t.team_id) as max_finish
        FROM  dbo.legs AS l
        INNER JOIN dbo.competitors AS c
            ON l.comp_id = c.comp_id
        INNER JOIN dbo.teams AS t
            ON t.team_id = c.team_id
        WHERE t.cat_id = @category_id
                OR @category_id IS NULL

    END
GO
/****** Object:  StoredProcedure [dbo].[sp_generate_legs]    Script Date: 03.05.2023 9:12:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_generate_legs]
	@prefix varchar(5)
AS
/*
Create date: 2022-06-14
Description: creates records in legs for first relay legs


declare @prefix varchar(3) = 'YZa'
execute sp_generate_legs @prefix
*/
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	INSERT INTO legs(comp_id, course_id, valid_flag)
	SELECT 
		c.comp_id, 
		cr.course_id,
		1
	FROM competitors AS c
	INNER JOIN teams AS t 
		ON c.team_id = t.team_id
	INNER JOIN courses AS cr 
		ON @prefix + CAST(t.team_nr AS NVARCHAR(4)) + '.' + CAST(c.rank_order AS NVARCHAR(4)) = cr.course_name

	SELECT @@ROWCOUNT
END
GO
/****** Object:  StoredProcedure [dbo].[sp_guess_course]    Script Date: 03.05.2023 9:12:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_guess_course]
    @readout_id INT
AS
-- =============================================
-- Author:		<Author,,Name>
-- Create date: 2021-01-07
-- Description:	returns most likely course_id
-- =============================================
/*
DECLARE @readout_id int = 48

EXECUTE dbo.sp_guess_course 
   @readout_id

*/
BEGIN
    SET NOCOUNT ON;

    WITH courses_cte AS (
        SELECT
            c.course_id
           ,c.course_name
           ,con.control_code
           ,cc.position
           ,cc.cc_status
        FROM
            dbo.courses AS c
            INNER JOIN dbo.course_codes AS cc ON c.course_id = cc.course_id
            INNER JOIN dbo.controls AS con ON cc.control_id = con.control_id
        WHERE
            con.control_code NOT IN ('F', 'F1', 'S1', 'S')
    )
        ,punches_cte AS (
        SELECT
            r.readout_id
           ,r.chip_id
           ,CAST(s.control_code AS VARCHAR(5)) AS control_code
           ,s.punch_datetime
           ,s.punch_index
        FROM
            dbo.si_readout AS r
            INNER JOIN dbo.si_stamps AS s ON r.readout_id = s.readout_id
        WHERE
            r.readout_id = @readout_id
    )
    ,course_punch AS (
        SELECT
            c.course_id
           ,c.course_name
           ,c.control_code
           ,c.position
           ,c.cc_status
           ,p.readout_id
           ,p.control_code AS p_control_code
           ,p.punch_index
        FROM
            courses_cte AS c
            LEFT OUTER JOIN punches_cte AS p ON c.control_code = p.control_code
    )
	,all_missing AS (
        SELECT  DISTINCT
                cp.course_id
               ,cp.course_name
        FROM
                course_punch AS cp
                LEFT OUTER JOIN punches_cte AS pc ON cp.control_code = pc.control_code
                                                     AND cp.position <= pc.punch_index
        WHERE
                pc.readout_id IS NULL
    )
    SELECT  DISTINCT
            cp.course_id
    FROM
            course_punch AS cp
            LEFT OUTER JOIN all_missing AS am ON cp.course_id = am.course_id
    WHERE
            am.course_id IS NULL
--ORDER BY
--    cp.course_name
--   ,cp.position

END
GO
/****** Object:  StoredProcedure [dbo].[sp_ins_xml_entries]    Script Date: 03.05.2023 9:12:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_ins_xml_entries]
AS
/*
Create date: 2023-03-20
Description:	inserts competitors and teams from xml
*/
/*
	exec sp_ins_xml_entries
*/

BEGIN
	SET NOCOUNT ON;

    -- Insert statements for procedure here


	DECLARE @cte_max_nr TABLE
	(
		cat_id INT NOT NULL PRIMARY KEY CLUSTERED,
		max_nr INT NULL
	)

	-- insert teams

	INSERT INTO @cte_max_nr
	(
		cat_id,
		max_nr
	)
	SELECT
		a.cat_id,
	(
		SELECT
			MAX(v)
		FROM(VALUES
		(
					a.first_start_number
		),
		(
					a.team_nr
		)) AS value(v)
	) AS max_nr
	FROM
	(
		SELECT
			MAX(c.first_start_number) AS first_start_number,
			MAX(t.team_nr) AS team_nr,
			c.cat_id
		FROM categories AS c
		LEFT OUTER JOIN teams AS t
			ON t.cat_id = c.cat_id
		GROUP BY
			c.cat_id
	) AS a


	INSERT INTO dbo.teams
	(
		team_nr,
		team_name,
		team_abbr,
		team_did_start,
		team_status,
		cat_id,
		oris_id,
		race_end
	)
	SELECT
		RANK() OVER(PARTITION BY e.class_name
		ORDER BY
		e.oris_team_id) + mn.max_nr AS nr,
		e.team_short_name AS team_name,
		e.team_name AS team_abbr,
		1 AS team_start,
		1 AS team_status,
		c.cat_id,
		e.oris_team_id,
		DATEADD(MINUTE,c.cat_time_limit,CAST(s.config_value AS DATETIME)) AS race_end
	FROM  dbo.entry_xml AS e
	LEFT OUTER JOIN dbo.categories AS c
		ON e.class_name = c.cat_name
	INNER JOIN dbo.settings AS s
		ON s.config_name = 'start_time'
	LEFT OUTER JOIN dbo.teams AS t
		ON t.oris_id = e.oris_team_id
	LEFT OUTER JOIN @cte_max_nr AS mn
		ON c.cat_id = mn.cat_id
	WHERE t.oris_id IS NULL
	GROUP BY
		c.cat_id,
		e.class_name,
		e.team_short_name,
		e.team_name,
		oris_team_id,
		c.cat_id,
		c.first_start_number,
		c.cat_time_limit,
		s.config_value,
		mn.max_nr
	ORDER BY
		nr,
		e.class_name,
		e.oris_team_id

	--update

	UPDATE t
	SET
		team_name = e.team_short_name,
		team_abbr = e.team_name,
		cat_id = c.cat_id,
		race_end = DATEADD(MINUTE,c.cat_time_limit,CAST(s.config_value AS DATETIME))
	FROM   dbo.teams AS t
	INNER JOIN dbo.entry_xml AS e
		ON t.oris_id = e.oris_team_id
	INNER JOIN dbo.settings AS s
		ON s.config_name = 'start_time'
	LEFT OUTER JOIN dbo.categories AS c
		ON e.class_name = c.cat_name
	LEFT OUTER JOIN @cte_max_nr AS mn
		ON c.cat_id = mn.cat_id

	--insert cometitors

	;WITH cte_comp_max
		 AS (SELECT
				 MAX(e.leg) AS max_leg,
				 oris_team_id
			 FROM  entry_xml AS e
			 WHERE NOT(e.family = ''
					   AND e.given = ''
					   AND e.gender = ''
					   AND e.si_chip = 0)
			 GROUP BY
				 oris_team_id)
		 INSERT INTO dbo.competitors
		 (
			 comp_name,
			 bib,
			 comp_chip_id,
			 rented_chip,
			 team_id,
			 rank_order,
			 comp_status,
			 comp_valid_flag,
			 comp_country,
			 comp_birthday
		 )
		 SELECT
			 e.family + ' ' + e.given AS comp_name,
			 CAST(t.team_nr AS VARCHAR(3)) + CHAR(64 + e.leg) AS bib,
			 e.si_chip,
			 0 AS rented,
			 t.team_id,
			 e.leg AS rank_order,
			 1 AS comp_status,
			 1 AS valid_fl,
			 e.country,
			 e.birth_date
		 FROM  dbo.entry_xml AS e
		 INNER JOIN cte_comp_max AS cm
			 ON e.oris_team_id = cm.oris_team_id
		 INNER JOIN dbo.teams AS t
			 ON e.oris_team_id = t.oris_id
		 LEFT OUTER JOIN competitors AS c
			 ON CAST(t.team_nr AS VARCHAR(3)) + CHAR(64 + e.leg) = c.bib
		 WHERE e.leg <= cm.max_leg
			   AND c.bib IS NULL

	UPDATE c
	SET
		comp_name = e.family + ' ' + e.given,
		comp_chip_id = e.si_chip,
		rank_order = e.leg,
		comp_country = e.country,
		comp_birthday = e.birth_date
	FROM   dbo.competitors AS c
	INNER JOIN dbo.teams AS t
		ON c.team_id = t.team_id
	INNER JOIN dbo.entry_xml AS e
		ON CAST(t.team_nr AS VARCHAR(3)) + CHAR(64 + e.leg) = c.bib
		   AND t.oris_id = e.oris_team_id

	select @@ROWCOUNT
END
GO
/****** Object:  StoredProcedure [dbo].[sp_insert_slips]    Script Date: 03.05.2023 9:12:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_insert_slips]
	@leg_id INT
AS
/*
	Create date: 2022-02-24
	Description: Inserts records to slips

DECLARE @leg_id INT = 125;
EXEC dbo.sp_insert_slips @leg_id
*/
	BEGIN
		SET NOCOUNT ON

		DECLARE @OutputTbl TABLE (ID INT)

		DELETE FROM slips WHERE leg_id = @leg_id

--DECLARE @leg_id int = 1132;
		
		;WITH cte_pu AS (
			SELECT
				r.readout_id,
				l.leg_id,
				r.chip_id,
				s.control_code,
				s.punch_datetime,
				s.punch_wday,
				r.card_readout_datetime,
				CAST(r.card_readout_datetime AS DATE) AS card_readout_date,
				s.punch_index,
				r.clear_datetime,
				r.check_datetime
			FROM   
				dbo.si_readout AS r
			INNER JOIN dbo.si_stamps AS s
				ON r.readout_id = s.readout_id
			INNER JOIN dbo.legs AS l
				ON l.readout_id = r.readout_id
			WHERE l.leg_id = @leg_id
			AND l.valid_flag = 1
			UNION ALL
			SELECT
				l.readout_id,
				l.leg_id,
				r.chip_id,
				'F' AS control_code,
				CASE WHEN l.finish_time <> '' THEN l.finish_dtime ELSE NULL END AS finish_dtime,
				'NA' AS punch_wday,
				r.card_readout_datetime,
				CAST(r.card_readout_datetime AS DATE) AS card_readout_date,
				999 AS punch_index,
				r.clear_datetime,
				r.check_datetime
			FROM  
				dbo.legs AS l
			INNER JOIN dbo.si_readout AS r
				ON l.readout_id = r.readout_id
			WHERE l.leg_id = @leg_id
			AND l.valid_flag = 1
		)
--		select * from cte_pu
		,cte_pu_dtime AS (
			SELECT
				pu.readout_id,
				pu.leg_id,
				pu.chip_id,
				pu.control_code,
				pu.card_readout_datetime,
				ISNULL(CASE WHEN pu.chip_id < 500000 THEN
					CASE
					WHEN CAST(pu.card_readout_datetime AS TIME) < '12:00:00'
					THEN CASE
							WHEN CAST(pu.punch_datetime AS TIME) <= CAST(pu.card_readout_datetime AS TIME)
							THEN DATEADD(d,0,DATEDIFF(d,0,pu.card_readout_datetime)) + CAST(CAST(pu.punch_datetime AS TIME) AS DATETIME)
							ELSE DATEADD(d,0,DATEDIFF(d,0,pu.card_readout_datetime) - 1) + CAST(DATEADD(HOUR,12,CAST(pu.punch_datetime AS TIME)) AS DATETIME)
							END
					ELSE CASE
							WHEN CAST(pu.punch_datetime AS TIME) <= CAST(DATEADD(HOUR,-12,pu.card_readout_datetime) AS TIME)
							THEN DATEADD(d,0,DATEDIFF(d,0,pu.card_readout_datetime)) + CAST(CAST(DATEADD(HOUR,12,pu.punch_datetime) AS TIME) AS DATETIME)
							WHEN CAST(pu.punch_datetime AS TIME) <= CAST(pu.card_readout_datetime AS TIME)
							THEN DATEADD(d,0,DATEDIFF(d,0,pu.card_readout_datetime)) + CAST(CAST(pu.punch_datetime AS TIME) AS DATETIME)
							ELSE DATEADD(d,0,DATEDIFF(d,0,pu.card_readout_datetime) - 1) + CAST(CAST(pu.punch_datetime AS TIME) AS DATETIME)
							END
					END 
				ELSE
					c.TheDateTime + CAST(CAST(pu.punch_datetime AS TIME) AS DATETIME)
				END, pu.punch_datetime) AS punch_dtime,
				pu.punch_index,
				pu.clear_datetime,
				pu.check_datetime
			FROM cte_pu AS pu
			OUTER APPLY (SELECT TOP 1 TheDateTime FROM dbo.calendar 
			where pu.card_readout_date >= TheDate 
				and pu.punch_wday = TheDayName
			order by TheDate desc) as c
		)
--select * from cte_pu_dtime
		,cte_punches
			 AS (SELECT
					 b.readout_id,
					 b.leg_id,
					 b.chip_id,
					 b.control_code,
					 b.card_readout_datetime,
					 CASE
					   WHEN b.punch_dtime > b.next_punch
					   THEN DATEADD(HOUR,-12,b.punch_dtime)
					   ELSE b.punch_dtime
					 END AS punch_dtime,
					 b.punch_index,
					 b.clear_datetime,
					 b.check_datetime
				 FROM
				 (
					 SELECT
						 a.readout_id,
						 a.leg_id,
						 a.chip_id,
						 a.control_code,
						 a.card_readout_datetime,
						 a.punch_dtime,
						 a.punch_index,
						 LEAD(a.punch_dtime,1,'2990-01-01') OVER(ORDER BY a.readout_id, a.punch_index) AS next_punch,
						 a.clear_datetime,
						 a.check_datetime
					 FROM cte_pu_dtime AS a
				 ) AS b)
--select * from cte_punches
			,cte_legs AS (
				SELECT
					pun.readout_id,
					pun.leg_id,
					pun.chip_id,
					l.comp_id,
					pun.clear_datetime,
					pun.check_datetime,
					l.start_dtime,
					fin.punch_dtime AS finish_dtime,
					pun.card_readout_datetime,
					CONVERT(TIME, fin.punch_dtime - l.start_dtime) AS leg_time,
					l.course_id,
					l.leg_status,
					l.dsk_penalty,
					l.valid_flag
				FROM dbo.legs as l
				INNER JOIN cte_punches AS pun ON l.leg_id = pun.leg_id
				LEFT OUTER JOIN cte_punches AS fin
					 ON fin.control_code = 'F'
				GROUP BY
					pun.readout_id,
					pun.leg_id,
					pun.chip_id,
					l.comp_id,
					fin.punch_dtime,
					pun.card_readout_datetime,
					l.start_dtime,
					pun.clear_datetime,
					pun.check_datetime,
					l.course_id,
					l.leg_status,
					l.dsk_penalty,
					l.valid_flag
			)
--select * from cte_legs
			 ,cte_slip AS (
				SELECT
					 pun.readout_id,
					 pun.leg_id,
					 pun.control_code,
					 pun.punch_dtime,
					 pun.punch_index,
 					 CONVERT(TIME, pun.punch_dtime - 
						CASE WHEN LAG(pun.punch_dtime,1,0) OVER(ORDER BY pun.punch_index) = '1900-01-01' 
							THEN l.start_dtime
							ELSE LAG(pun.punch_dtime,1,0) OVER(ORDER BY pun.punch_index) 
						END) AS split_dtime,
					 CONVERT(TIME, pun.punch_dtime - l.start_dtime) AS punch_time
				 FROM cte_punches AS pun
				 LEFT OUTER JOIN cte_legs as l on pun.readout_id = l.readout_id
					 )
--select * from cte_slip
			,cte_controls AS
			(
				SELECT
					ISNULL(l.readout_id, p.readout_id) as readout_id,
					ISNULL(l.leg_id, p.leg_id) as leg_id,
					p.punch_index,
					cc.position,
					COALESCE(con.control_code, p.control_code, '') AS control_code,
					p.punch_dtime,
					CONVERT(VARCHAR(10), p.punch_time, 120) as punch_time,
					CASE WHEN cc.position IS NULL THEN NULL ELSE p.split_dtime END AS lap_dtime,
					CASE WHEN cc.position IS NULL THEN NULL ELSE CONVERT(VARCHAR(10), p.split_dtime, 120) END AS lap_time
				FROM  
					dbo.legs AS l
				INNER JOIN dbo.courses AS cou
					ON l.course_id = cou.course_id
				INNER JOIN dbo.course_codes AS cc
					ON cou.course_id = cc.course_id
				INNER JOIN dbo.controls AS con
					ON cc.control_id = con.control_id
					and con.control_code <> 'S1'
				FULL OUTER JOIN cte_slip AS p
					ON con.control_code = p.control_code
					AND l.readout_id = p.readout_id
					AND l.leg_id = p.leg_id
				WHERE l.leg_id = @leg_id OR p.leg_id = @leg_id
					AND (l.valid_flag = 1 OR l.valid_flag IS NULL)
			)
--select * from cte_controls
			 INSERT INTO dbo.slips
			 (
				 comp_id,
				 team_id,
				 course_id,
				 course_name,
				 course_length,
				 course_climb,
				 readout_id,
				 chip_id,
				 leg_id,
				 comp_name,
				 bib,
				 comp_country,
				 rented_chip,
				 team_nr,
				 team_name,
				 cat_name,
				 punch_index,
				 position,
				 control_code,
				 punch_dtime,
				 punch_time,
				 lap_dtime,
				 lap_time,
				 valid_flag,
				 clear_dtime,
				 clear_time,
				 check_dtime,
				 check_time,
				 start_dtime,
				 finish_dtime,
				 leg_time,
				 stamp_readout_dtime,
				 leg_status,
				 dsk_penalty,
				 team_race_end_zero,
				 team_race_end
			 )
			 OUTPUT INSERTED.slip_id INTO @OutputTbl(ID)
			SELECT 
				 com.comp_id,
				 com.team_id,
				 l.course_id,
				 cou.course_name,
				 cou.course_length,
				 cou.course_climb,
				 l.readout_id,
				 l.chip_id,
				 l.leg_id,
				 com.comp_name,
				 com.bib,
				 com.comp_country,
				 com.rented_chip,
				 t.team_nr,
				 t.team_name,
				 cat.cat_name,
				 cc.punch_index,
				 cc.position,
				 cc.control_code,
				 cc.punch_dtime,
				 cc.punch_time,
				 cc.lap_dtime,
				 cc.lap_time,
				 CASE WHEN t.race_end > l.finish_dtime AND l.leg_status = 'OK' THEN 1 ELSE 0 END AS valid_flag,
				 l.clear_datetime,
				 NULL AS clear_time,
				 l.check_datetime,
				 NULL AS check_time,
				 l.start_dtime,
				 l.finish_dtime,
				 format(l.leg_time, N'hh\:mm\:ss') AS leg_time,
				 l.card_readout_datetime,
				 l.leg_status,
				 l.dsk_penalty,
				 dbo.time_from_start(cat.cat_start_time, t.race_end) as team_race_end_zero,
				 t.race_end
			FROM cte_controls AS cc
			INNER JOIN cte_legs AS l
				ON cc.leg_id = l.leg_id
			INNER JOIN dbo.competitors AS com
				ON l.comp_id = com.comp_id
			INNER JOIN dbo.teams AS t
				ON com.team_id = t.team_id
			INNER JOIN dbo.categories AS cat
				ON t.cat_id = cat.cat_id
			INNER JOIN dbo.courses AS cou
				ON l.course_id = cou.course_id
			WHERE l.valid_flag = 1
		ORDER BY ISNULL(cc.position, 999), cc.punch_index

		SELECT o.ID FROM @OutputTbl AS o 
	END
GO
/****** Object:  StoredProcedure [dbo].[sp_inset_wdr_slip]    Script Date: 03.05.2023 9:12:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_inset_wdr_slip] 
	@comp_id int
AS
/*
Create date: 2023-04-29
Description: inserts fake slip for withdrawn competitors
*/
/*
declare @comp_id int = 2351
exec sp_inset_wdr_slip @comp_id
*/
BEGIN
	SET NOCOUNT ON;

	declare @wd_course varchar(10)
	select @wd_course = config_value from settings where config_name = 'wdrn_course'

	INSERT INTO [dbo].[slips]
           ([comp_id]
           ,[team_id]
           ,[course_id]
           ,[course_name]
           ,[readout_id]
           ,[chip_id]
           ,[leg_id]
           ,[comp_name]
           ,[bib]
           ,[cat_name]
           ,[start_dtime]
           ,[finish_dtime]
           ,[leg_time]
           ,[valid_flag]
           ,[leg_status]
           ,[dsk_penalty]
           ,[team_race_end_zero]
           ,[team_race_end])
	select 
		l.comp_id,
		c.team_id,
		l.course_id,
		co.course_name,
		r.readout_id,
		r.chip_id,
		l.leg_id,
		c.comp_name,
		c.bib,
		ca.cat_name,
		l.start_dtime,
		l.finish_dtime,
		l.leg_time,
		0 as valid_flag,
		l.leg_status,
		l.dsk_penalty,
		dbo.time_from_start(ca.cat_start_time, t.race_end) as team_race_end_zero,
		t.race_end
	from si_readout as r
	inner join legs as l on r.readout_id = l.readout_id
	inner join competitors as c on l.comp_id = c.comp_id
	inner join courses as co on l.course_id = co.course_id
	inner join teams as t on c.team_id = t.team_id
	inner join categories as ca on t.cat_id = ca.cat_id
	where 
		l.comp_id = @comp_id
		and co.course_name = @wd_course
END
GO
/****** Object:  StoredProcedure [dbo].[sp_search_competitors]    Script Date: 03.05.2023 9:12:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_search_competitors]
	-- Add the parameters for the stored procedure here
	@s nvarchar(50)
AS
/*
Author:		<Author,,Name>
Create date: 2022-05-02
Description:	search competitors
*/
BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	select * from dbo.v_comp_teams
	where team_name like '%'+ @s+ '%'
	or comp_name  like '%'+ @s+ '%'
	or bib  like '%'+ @s+ '%'

END
GO
/****** Object:  StoredProcedure [dbo].[sp_upsert_legs]    Script Date: 03.05.2023 9:12:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_upsert_legs]
	@readout_id INT,
	@competitor_id INT,
	@course_id INT,
	@guessed_course INT,
	@upd char(2)
AS
/*
	Create date: 2022-02-23
	Description:	inserts card to legs, updates if record exists
*/
/*

DECLARE @readout_id INT = 149
DECLARE @competitor_id INT = 1152
DECLARE @course_id INT = 1067
DECLARE @guessed_course INT = 1067
DECLARE @upd char(2) = 'I'

exec dbo.sp_upsert_legs @readout_id, @competitor_id, @course_id, @guessed_course, @upd

*/
BEGIN
/*
DECLARE @readout_id INT = 1150
DECLARE @competitor_id INT = 2160
DECLARE @course_id INT = 1067
DECLARE @guessed_course INT = 1067
DECLARE @upd char(2) = 'U'
*/
	SET NOCOUNT ON;
	DECLARE @cnt INT
	DECLARE @leg_cnt INT
	DECLARE @dsk_penalty INT
	DECLARE @prev_comp INT

	SELECT @dsk_penalty = cast(config_value AS INT) FROM dbo.settings WHERE config_name = 'dsk_penalty_min'

	DECLARE @force_order BIT
	SELECT 
		@force_order = ca.force_order 
	FROM competitors AS co
	INNER JOIN teams AS t 
		ON co.team_id = t.team_id
	INNER JOIN categories AS ca 
		ON t.cat_id = ca.cat_id
	WHERE co.comp_id = @competitor_id

	--DECLARE @readout_id INT = 149
	--declare @competitor_id int = 1156

	DECLARE @as_of_date DATETIME 
	SELECT @as_of_date = card_readout_datetime 
	FROM dbo.si_readout
		WHERE readout_id = @readout_id

	DECLARE @last_comp_id INT 
	SELECT TOP 1 @last_comp_id = c.comp_id 
	FROM competitors AS c
	INNER JOIN competitors as c2 on c.team_id = c2.team_id
	WHERE c.comp_valid_flag = 1
	AND (c.comp_withdrawn = 0 OR c.withdrawn_datetime < @as_of_date)
	AND c2.comp_id = @competitor_id
	ORDER BY c.rank_order desc

	/*SELECT c.comp_id 
	FROM competitors AS c
	INNER JOIN competitors as c2 on c.team_id = c2.team_id
	WHERE c.comp_valid_flag = 1
	AND (c.comp_withdrawn = 0 OR c.withdrawn_datetime < @as_of_date)
	AND c2.comp_id = @competitor_id
	ORDER BY c.rank_order desc*/

	SELECT 
		@prev_comp = p.prev
	FROM
	(
		SELECT  c.comp_id, 
			c.comp_name, 
--TODO add withdrawn
			lag(comp_id, 1, @last_comp_id) OVER (PARTITION BY c.team_id ORDER BY c.rank_order) AS prev
		FROM competitors AS c
	) AS p
	WHERE p.comp_id = @competitor_id
/*print @as_of_date
print @dsk_penalty
print 'last ' + cast(@last_comp_id as varchar(50))
print @prev_comp
*/

	DECLARE @OutputTbl TABLE (ID INT)

	DECLARE @leg TABLE (comp_id INT, course_id INT, readout_id INT, start_dtime DATETIME,
		start_time VARCHAR(10), finish_dtime DATETIME, finish_time VARCHAR(10), leg_time VARCHAR(10), leg_status VARCHAR(3), dsk_penalty TIME(7))

	;WITH start_time_cte AS (
		SELECT
				a.prev_finish,
				a.prev_comp_id,
				config_value AS zero_time,
				1 AS sort_order
			FROM
			(
				SELECT top 1
					lp.finish_dtime AS prev_finish,
					lp.comp_id as prev_comp_id,
					NULL AS config_value
				FROM  dbo.legs AS lp
				INNER JOIN dbo.competitors AS cp
					ON lp.comp_id = cp.comp_id
				INNER JOIN dbo.competitors AS c
					ON c.team_id = cp.team_id
				LEFT OUTER JOIN dbo.legs AS l 
					ON c.comp_id = l.comp_id
					AND l.readout_id = @readout_id
					AND l.valid_flag = 1
				WHERE c.comp_id = @competitor_id
				AND lp.comp_id <> c.comp_id
				AND (lp.finish_dtime < l.finish_dtime OR l.leg_id IS NULL)
				AND lp.valid_flag = 1
				AND lp.readout_id IS NOT NULL
				AND isnull(l.starting_leg, 0) <> 1
				ORDER BY
					lp.finish_dtime DESC
			) AS a
			UNION ALL
				SELECT 
					NULL AS prev_finish,
					NULL AS prev_comp_id,
					ca.cat_start_time,
					2 AS sort_order
				FROM categories AS ca
				INNER JOIN teams AS t ON t.cat_id = ca.cat_id
				INNER JOIN competitors AS co ON co.team_id = t.team_id
				WHERE co.comp_id = @competitor_id
		)
--select * from start_time_cte
		,finish_cte AS (
			SELECT
					CASE
					WHEN CAST(r.card_readout_datetime AS TIME) < '12:00:00'
					THEN CASE
						WHEN CAST(r.finish_datetime AS TIME) <= CAST(r.card_readout_datetime AS TIME)
						THEN DATEADD(d,0,DATEDIFF(d,0,r.card_readout_datetime)) + CAST(CAST(r.finish_datetime AS TIME) AS DATETIME)
						ELSE DATEADD(d,0,DATEDIFF(d,0,r.card_readout_datetime) - 1) + CAST(DATEADD(HOUR,12,CAST(r.finish_datetime AS TIME)) AS DATETIME)
						END
					ELSE CASE
						WHEN CAST(r.finish_datetime AS TIME) <= CAST(DATEADD(HOUR,-12,r.card_readout_datetime) AS TIME)
						THEN DATEADD(d,0,DATEDIFF(d,0,r.card_readout_datetime)) + CAST(CAST(DATEADD(HOUR,12,r.finish_datetime) AS TIME) AS DATETIME)
						WHEN CAST(r.finish_datetime AS TIME) <= CAST(r.card_readout_datetime AS TIME)
						THEN DATEADD(d,0,DATEDIFF(d,0,r.card_readout_datetime)) + CAST(CAST(r.finish_datetime AS TIME) AS DATETIME)
						ELSE DATEADD(d,0,DATEDIFF(d,0,r.card_readout_datetime) - 1) + CAST(CAST(r.finish_datetime AS TIME) AS DATETIME)
						END
					END AS finish_dtime,
					r.finish_missing
				FROM  dbo.si_readout AS r
				WHERE r.readout_id = @readout_id)
--select * from finish_cte
		,start_finish as (
			SELECT 
				MAX(f.finish_dtime) AS finish_dtime,
				MAX(s.prev_comp_id) AS prev_comp_id,
				MAX(s.prev_finish) AS prev_finish,
				MAX(s.zero_time) AS zero_time,
				f.finish_missing
			FROM start_time_cte AS s
			CROSS JOIN finish_cte AS f
			group by finish_missing
		)
--select * from start_finish
--select @prev_comp
--(@course_id <> @guessed_course OR sf.finish_missing = 1) and DATEDIFF(MINUTE, ISNULL(sf.prev_finish, sf.zero_time), sf.finish_dtime ) < @dsk_penalty 
/*
select sf.prev_comp_id,
@prev_comp as prev_comp,
@course_id as course_id,
@guessed_course as guessed_course,
sf.finish_missing
FROM start_finish AS sf
*/
		INSERT INTO @leg(comp_id, course_id, readout_id, start_dtime, start_time, finish_dtime, finish_time, leg_time, leg_status , dsk_penalty)
		SELECT
			@competitor_id AS comp_id,
			@course_id AS course_id,
			@readout_id AS readout_id,
			ISNULL(sf.prev_finish, sf.zero_time) AS start_dtime,
			dbo.time_from_start(sf.zero_time, ISNULL(sf.prev_finish, sf.zero_time)) AS start_time,
			sf.finish_dtime,
			CASE WHEN sf.finish_missing = 1 THEN '' ELSE dbo.time_from_start(sf.zero_time, sf.finish_dtime) END AS finish_time,
			CASE WHEN sf.finish_missing = 1 THEN '' ELSE dbo.time_from_start(ISNULL(sf.prev_finish, sf.zero_time), sf.finish_dtime) END AS leg_time,
			CASE WHEN @course_id <> @guessed_course OR sf.finish_missing = 1
				THEN 'DSK'
				ELSE 'OK' END AS leg_status,
			CASE 
				WHEN (sf.prev_comp_id <> @prev_comp AND sf.prev_comp_id IS NOT NULL AND @force_order = 1) THEN
					CAST(DATEADD(MINUTE, @dsk_penalty, 0) as time)
--					CAST('0:30:00' AS TIME) 
--					@dsk_penalty
				WHEN (@course_id <> @guessed_course OR sf.finish_missing = 1) and DATEDIFF(MINUTE, ISNULL(sf.prev_finish, sf.zero_time), sf.finish_dtime ) < @dsk_penalty 
			THEN --CAST('0:30:00' AS TIME)
				CAST(DATEADD(SECOND, @dsk_penalty * 60 - DATEDIFF(SECOND, ISNULL(sf.prev_finish, sf.zero_time), sf.finish_dtime), 0) AS TIME)
			ELSE 
				CAST('0:00:00' AS TIME) 
			END AS dsk_penalty
		FROM start_finish AS sf

--select * from @leg


	SELECT
		@cnt = COUNT(1)
	FROM  legs
	WHERE (comp_id = @competitor_id
			and readout_id is null
			and @upd = 'I')
		OR (comp_id = @competitor_id
			and readout_id = @readout_id
			and @upd = 'U')
--select @cnt
		IF @cnt > 0
			BEGIN
				-- update;
						UPDATE l
						SET
							l.course_id = @course_id,
							l.readout_id = @readout_id,
							l.finish_dtime = lg.finish_dtime,
							l.finish_time = lg.finish_time,
							l.start_dtime = lg.start_dtime,
							l.start_time = lg.start_time,
							l.dsk_penalty = lg.dsk_penalty,
							l.leg_status = lg.leg_status,
							l.leg_time = lg.leg_time,
							l.as_of_date = GETDATE()
						OUTPUT INSERTED.leg_id INTO @OutputTbl(ID)
						FROM   legs AS l
						CROSS JOIN @leg as lg 
						WHERE 1 = 1
							and l.comp_id = @competitor_id
							AND (l.readout_id = @readout_id 
								OR (l.readout_id is null and @upd = 'I'))
--select * from legs where leg_id = 107
		END
		ELSE
		BEGIN
			--insert;
			INSERT INTO dbo.legs
			(
				comp_id,
				course_id,
				readout_id,
				start_dtime,
				start_time,
				finish_dtime,
				finish_time,
				leg_status,
				dsk_penalty,
				valid_flag
			)
			OUTPUT INSERTED.leg_id INTO @OutputTbl(ID)
			SELECT
				@competitor_id AS comp_id,
				@course_id AS course_id,
				@readout_id AS readout_id,
				lg.start_dtime,
				lg.start_time,
				lg.finish_dtime,
				lg.finish_time,
				lg.leg_status,
				lg.dsk_penalty,
				1
			FROM @leg AS lg
		END
		SELECT isnull(o.ID, 0) FROM @OutputTbl AS o 
	END
GO
/****** Object:  StoredProcedure [dbo].[update_team_race_end]    Script Date: 03.05.2023 9:12:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[update_team_race_end]
	@comp_id int
AS
/*
Create date: 2022-06-22
Description:	updates teams race_end based on disk penalities

DECLARE @comp_id int = 2201
execute dbo.update_team_race_end @comp_id
*/
BEGIN

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	;WITH cte_dsk AS (
		SELECT 
			d.team_id,
			SUM(d.e * d.penalty_seconds) AS dsk_seconds
		FROM ( 	
			SELECT 
				l.leg_id,
				c.team_id,
				CASE WHEN DATEADD(second, -SUM(DATEDIFF(SECOND, 0, l.dsk_penalty)) over(order by l.start_dtime ), DATEADD(MINUTE, ca.cat_time_limit, ca.cat_start_time)) < l.start_dtime 
				THEN 0 
				ELSE 1 
				END AS e,
				l.dsk_penalty,
				DATEDIFF(SECOND, 0, l.dsk_penalty) AS penalty_seconds
			FROM competitors AS c
			INNER JOIN competitors AS cp ON c.team_id = cp.team_id
			INNER JOIN legs AS l ON cp.comp_id = l.comp_id
			inner join teams as t on c.team_id = t.team_id
			INNER JOIN categories AS ca ON t.cat_id = ca.cat_id
			WHERE c.comp_id = @comp_id
		) AS d
		GROUP BY d.team_id
	)
	UPDATE teams
		SET race_end = DATEADD(SECOND, -s.dsk_seconds, DATEADD(MINUTE, c.cat_time_limit, c.cat_start_time))
	FROM 
		teams AS t
	INNER JOIN categories AS c ON t.cat_id = c.cat_id
	INNER JOIN cte_dsk AS s ON s.team_id = t.team_id

	select @@ROWCOUNT
END
GO
/****** Object:  StoredProcedure [dbo].[x_sp_fill_legs]    Script Date: 03.05.2023 9:12:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[x_sp_fill_legs]
    @id_card INT
   ,@course_id INT
   ,@comp_id INT
AS
/*
	declare @id_card INT = 1
	declare @course_id INT = 1
	declare @comp_id INT = 1

	execute dbo.sp_fill_legs
		@id_card
	   ,@course_id
	   ,@comp_id
*/
    BEGIN
        INSERT INTO dbo.legs (comp_id, course_id, finish_dtime, finish_time, as_of_date)
        SELECT
            @comp_id
           ,@course_id
           ,r.finish_datetime
           ,NULL AS finish_time
           ,GETDATE()
        FROM
            dbo.si_readout AS r
        WHERE
            r.id_card = @id_card

    END
GO
/****** Object:  StoredProcedure [dbo].[x_sp_fill_runs]    Script Date: 03.05.2023 9:12:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[x_sp_fill_runs]
AS
/*
	execute sp_fill_runs
*/
BEGIN
	SET NOCOUNT ON;

	INSERT INTO dbo.runs (comp_id, comp_chip_id, as_of_date, team_rank)
SELECT
    c.comp_id
   ,c.comp_chip_id
   ,GETDATE()
   ,ROW_NUMBER() OVER (PARTITION BY c.team_id ORDER BY n.n, c.rank_order) AS rnk
FROM
    dbo.competitors AS c
    CROSS JOIN (
        SELECT  TOP (100)
                CONVERT(INT, ROW_NUMBER() OVER (ORDER BY s1.object_id)) AS n
        FROM
                sys.all_objects AS s1
                CROSS JOIN sys.all_objects AS s2
    ) AS n
END
GO
/****** Object:  StoredProcedure [dbo].[x_sp_stamp2punches]    Script Date: 03.05.2023 9:12:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[x_sp_stamp2punches]
    @id_card INT
AS
BEGIN
    IF ISNULL(@id_card, 0) <> 0
    BEGIN
        SET NOCOUNT ON;
        SET DATEFIRST 1;

		DECLARE @event_id INT
		--config
		SELECT @event_id = CAST(config_value AS INT)
		FROM dbo.settings AS s
		WHERE s.config_name = 'event_id'

        DELETE FROM
        dbo.punches
        WHERE
            id_card = @id_card

        DECLARE
            @start AS DATETIME
           ,@num INT
           ,@stamp_punch_last DATETIME
           ,@stamp_punch_last_orig DATETIME
           ,@exc_dtime DATETIME
           ,@exc_time VARCHAR(15)
           ,@exc_del BIT;
        DECLARE
            @stamp_card_id INT
           ,@control_code VARCHAR(5)
           ,@control_mode INT
           ,@punch_time VARCHAR(20)
           ,@stamp_punch_datetime DATETIME
           ,@stamp_readout_datetime DATETIME
           ,@stamp_punch_timesi INT
           ,@stamp_punch_wday INT
           ,@stamp_punch_index INT
           ,@stamp_punch_count INT
           ,@cat_start_time DATETIME
           ,@time_direction CHAR
           ,@dif_hour INT
           ,@dif_min INT
           ,@dif_sec INT
           ,@dif_hour_s INT
           ,@dif_min_s INT
           ,@dif_sec_s INT;

        BEGIN TRAN

        SELECT
            @stamp_card_id = s.stamp_card_id
           ,@control_code = s.stamp_control_code
           ,@control_mode = s.stamp_control_mode
           ,@stamp_readout_datetime = s.stamp_readout_datetime
           ,@stamp_punch_timesi = s.stamp_punch_timesi
           ,@stamp_punch_datetime = s.stamp_punch_datetime
           ,@stamp_punch_wday = s.stamp_punch_wday
           ,@stamp_punch_index = s.stamp_punch_index
           ,@stamp_punch_count = s.stamp_punch_count
        FROM
            dbo.stamps AS s
			INNER JOIN dbo.lccard_link_stamps AS ls ON ls.id_stamp = s.id_stamp
        WHERE
			ls.id_card = @id_card --243

		-- first possible start - events or previous competitor from same team
/*SELECT MAX(r.start_dtime) FROM dbo.competitors AS c
INNER JOIN dbo.runs AS r ON c.comp_id = r.comp_id
--INNER JOIN dbo.punches AS p ON r.run_id = p.run_id
WHERE c.comp_chip_id = @stamp_card_id

SELECT event_date FROM dbo.events WHERE 
SELECT top 10000 * FROM dbo.punches
SELECT top 10000 * FROM dbo.runs
*/
        SELECT
            @start = MIN(ca.cat_start_time)
        FROM
            dbo.competitors AS co
            LEFT OUTER JOIN dbo.teams AS te ON te.team_id = co.team_id
            LEFT OUTER JOIN dbo.categories AS ca ON ca.cat_id = te.cat_id
                                                    AND ca.valid = 1
        WHERE
            co.comp_chip_id = @stamp_card_id;

        IF @start IS NULL
        BEGIN
            SELECT
                @start = MIN(cat_start_time)
            FROM
                dbo.categories
            WHERE
                valid = 1;
        END
        PRINT '@chip_id ' + CAST(@stamp_card_id AS VARCHAR)
        PRINT 'start: ' + CONVERT(VARCHAR, @start)

        --ver prior 6
        IF @stamp_card_id < 500000
        BEGIN
            DECLARE new_punches_cursor CURSOR FOR
                SELECT
                    stamp_card_id
                   ,CASE WHEN stamp_control_mode = 3
                              THEN 'S'
                    WHEN stamp_control_mode = 4
                         THEN 'F'
                    WHEN stamp_control_mode = 7
                         THEN 'X'
                    WHEN stamp_control_mode = 10
                         THEN 'C'
                    ELSE CAST(stamp_control_code AS NVARCHAR(3))END AS control_code
                   ,stamp_punch_datetime
                   ,MIN(stamp_readout_datetime) AS stamp_readout_datetime
                FROM
                    dbo.stamps
                WHERE
                    stamp_card_id = @stamp_card_id
                GROUP BY
                    stamp_card_id
                   ,stamp_control_mode
                   ,stamp_control_code
                   ,stamp_punch_datetime
                ORDER BY
                    MIN(id_stamp)

            OPEN new_punches_cursor;

            FETCH NEXT FROM new_punches_cursor
            INTO
                @stamp_card_id
               ,@control_code
               ,@stamp_punch_datetime
               ,@stamp_readout_datetime;

            SET @stamp_punch_last = DATEADD(MINUTE, -60, @start)
            SET @stamp_punch_last_orig = DATEADD(MINUTE, -60, @start)

            WHILE @@FETCH_STATUS = 0
            BEGIN
                PRINT '@stamp_card_id ' + CAST(@stamp_card_id AS VARCHAR)
                PRINT '@stamp_punch_last ' + CONVERT(VARCHAR, @stamp_punch_last, 113)
                PRINT '@stamp_punch_datetime: ' + CONVERT(VARCHAR, @stamp_punch_datetime, 113)
                PRINT '@stamp_punch_last_orig ' + CONVERT(VARCHAR, @stamp_punch_last_orig, 113)
                PRINT '@control_code ' + CAST(@control_code AS VARCHAR)
                PRINT 'dif ' + CAST(DATEDIFF(SECOND, @stamp_punch_last_orig, @stamp_punch_datetime) AS VARCHAR)
                --while datediff(second, @stamp_punch_last_orig, @stamp_punch_datetime) < -86400
                --begin
                --	set @stamp_punch_datetime = dateadd(hh, 12, @stamp_punch_datetime)
                --end

                IF DATEDIFF(SECOND, @stamp_punch_last_orig, @stamp_punch_datetime) > 0
                   OR   DATEDIFF(SECOND, @stamp_punch_last_orig, @stamp_punch_datetime) < -1 --between -43200 and -1
                BEGIN
                    PRINT 'rozdilne'
                    SET @stamp_punch_last_orig = @stamp_punch_datetime
                    SELECT
                        @num = COUNT(*)
                    FROM
                        dbo.exceptions
                    WHERE
                        chip_id = @stamp_card_id
                        AND control_code = @control_code;
                    IF @num > 0
                    BEGIN
                        PRINT 'vyjimka'
                        --vyjimka
                        SELECT
                            @exc_dtime = exc_dtime
                           ,@exc_time = exc_time
                           ,@exc_del = exc_del
                        FROM
                            dbo.exceptions
                        WHERE
                            chip_id = @stamp_card_id
                            AND control_code = @control_code;
                        IF @exc_del = 1
                        BEGIN
                            PRINT '@exc_del = 1'
                            PRINT 'nic do punches nevkladam'
                        --insert into punches (chip_id, control_code, punch_dtime, punch_time, valid_flag, stamp_readout_datetime)
                        --values (@stamp_card_id, @control_code, cast(@exc_dtime as datetime), @exc_time, 0, @stamp_readout_datetime);
                        END
                        ELSE
                        BEGIN
                            PRINT 'ins ' + CAST(@stamp_card_id AS VARCHAR) + ', ' + CAST(@control_code AS VARCHAR) + ', ' + CAST(@exc_dtime AS VARCHAR) + ',' + CAST(@exc_time AS VARCHAR)
                            INSERT INTO dbo.punches (
                                chip_id
                               ,control_code
                               ,punch_dtime
                               ,punch_time
                               ,valid_flag
                               ,stamp_readout_datetime
                            )
                            VALUES (
                                @stamp_card_id, @control_code, CAST(@exc_dtime AS DATETIME), @exc_time, 1, @stamp_readout_datetime
                            );
                            --					insert into punches (chip_id, control_code, punch_time, valid_flag, stamp_readout_datetime)
                            --					values (@stamp_card_id, @control_code, @exc_time, 1, @stamp_readout_datetime);
                            SET @stamp_punch_last = @exc_dtime
                        END
                    END
                    ELSE
                    BEGIN
                        PRINT 'normalni '
                        --neni vyjimka, vkladam normalni...
                        IF @control_code NOT IN ('C', 'S', 'X')
                        BEGIN
                            PRINT 'x'
                            SELECT
                                @num = COUNT(*)
                            FROM
                                dbo.controls
                            WHERE
                                control_code = @control_code
                                AND time_direction <> ''
                            --posun casu
                            IF @num > 0
                            BEGIN
                                PRINT 'time_diff '
                                SELECT
                                    @time_direction = time_direction
                                   ,@dif_hour = dif_hour
                                   ,@dif_min = dif_min
                                   ,@dif_sec = dif_sec
                                FROM
                                    dbo.controls
                                WHERE
                                    control_code = @control_code

                                SET @dif_hour = (CASE WHEN @time_direction = '-'
                                                           THEN -COALESCE(@dif_hour, 0)
                                                 ELSE      COALESCE(@dif_hour, 0)END
                                                )
                                SET @dif_min = (CASE WHEN @time_direction = '-'
                                                          THEN -COALESCE(@dif_min, 0)
                                                ELSE      COALESCE(@dif_min, 0)END
                                               )
                                SET @dif_sec = (CASE WHEN @time_direction = '-'
                                                          THEN -COALESCE(@dif_sec, 0)
                                                ELSE      COALESCE(@dif_sec, 0)END
                                               )
                                PRINT '@time_direction ' + CONVERT(VARCHAR, @dif_hour) + ' ' + CONVERT(VARCHAR, @dif_min) + ' ' + CONVERT(VARCHAR, @dif_sec)
                                PRINT '@stamp_punch_datetime ' + CONVERT(VARCHAR, @stamp_punch_datetime, 113)
                                SET @stamp_punch_datetime = DATEADD(SECOND, @dif_sec, DATEADD(MINUTE, @dif_min, DATEADD(HOUR, @dif_hour, @stamp_punch_datetime)))
                            END

                            PRINT '@stamp_punch_last ' + CONVERT(VARCHAR, @stamp_punch_last, 113)
                            PRINT '@stamp_punch_datetime ' + CONVERT(VARCHAR, @stamp_punch_datetime, 113)
                            --prechod pres pulnoc
                            IF ABS(DATEDIFF(SECOND, @stamp_punch_datetime, @stamp_punch_last)) > 43200
                            BEGIN
                                SET @stamp_punch_datetime = DATEADD(DAY, DATEDIFF(DAY, @stamp_punch_datetime, @stamp_punch_last), @stamp_punch_datetime)
                                PRINT '@stamp_punch_datetime ' + CONVERT(VARCHAR, @stamp_punch_datetime, 113)
                            END
                            PRINT '@stamp_punch_datetime ' + CONVERT(VARCHAR, @stamp_punch_datetime, 113)
                            PRINT DATEDIFF(HOUR, @stamp_punch_last, @stamp_punch_datetime)
                            PRINT DATEDIFF(MINUTE, @stamp_punch_last, @stamp_punch_datetime)
                            --first control same day as start -> force shift
                            PRINT '@stamp_punch_last: pred mene ' + CONVERT(VARCHAR, @stamp_punch_last, 113)
                            PRINT '@stamp_punch_datetime: pred mene ' + CONVERT(VARCHAR, @stamp_punch_datetime, 113)
                            WHILE (DATEDIFF(SECOND, @stamp_punch_last, @stamp_punch_datetime) > 43200)
                            BEGIN
                                SET @stamp_punch_datetime = DATEADD(hh, -12, @stamp_punch_datetime)
                                PRINT '@stamp_punch_datetime: mene ' + CONVERT(VARCHAR, @stamp_punch_datetime, 113)
                            END

                            --date moret than 12 hours -> substract 12 h
                            WHILE @stamp_punch_datetime <= @stamp_punch_last
                            BEGIN
                                SET @stamp_punch_datetime = DATEADD(hh, 12, @stamp_punch_datetime)

                                PRINT '@stamp_punch_datetime: vice ' + CONVERT(VARCHAR, @stamp_punch_datetime, 113)
                            END
                            SET @stamp_punch_last = @stamp_punch_datetime
                            PRINT '@stamp_punch_datetime-final: ' + CONVERT(VARCHAR, @stamp_punch_datetime, 113)
                        END
                        PRINT 'insert'
                        SET @punch_time = dbo.time_from_start(@start, @stamp_punch_datetime)
                        --				insert into punches (chip_id, control_code, punch_time, valid_flag, stamp_readout_datetime)
                        --				values (@stamp_card_id, @control_code, @stamp_punch_datetime, 1, @stamp_readout_datetime);
                        PRINT 'ins ' + CAST(COALESCE(@stamp_card_id, '') AS VARCHAR) + ', ' + CAST(COALESCE(@control_code, '') AS VARCHAR) + ', ' + CAST(COALESCE(@stamp_punch_datetime, '') AS VARCHAR) + ', ' + CAST(COALESCE(@punch_time, '') AS VARCHAR) + ', 1, ' + CAST(COALESCE(@stamp_readout_datetime, '') AS VARCHAR)
                        INSERT INTO dbo.punches (
                            chip_id
                           ,control_code
                           ,punch_dtime
                           ,punch_time
                           ,valid_flag
                           ,stamp_readout_datetime
                        )
                        VALUES (
                            @stamp_card_id, @control_code, @stamp_punch_datetime, @punch_time, 1, @stamp_readout_datetime
                        );
                    END
                END
                ELSE
                    PRINT 'stejne'

                FETCH NEXT FROM new_punches_cursor
                INTO
                    @stamp_card_id
                   ,@control_code
                   ,@stamp_punch_datetime
                   ,@stamp_readout_datetime;
            END --end while
            CLOSE new_punches_cursor;
            DEALLOCATE new_punches_cursor;
        END
        ELSE
        BEGIN
            --SI6 and higher
            --	declare new_punches_cursor cursor for
            --print 'ins ' + cast(coalesce(@stamp_card_id,'') as varchar)+ ', ' + cast(coalesce(@control_code,'') as varchar)+', '+ cast(coalesce(@stamp_punch_datetime,'') as varchar)+', '+cast(coalesce(@punch_time,'') as varchar)+', 1, '+ cast(coalesce(@stamp_readout_datetime,'') as varchar)
            INSERT INTO dbo.punches (
                chip_id
               ,control_code
               ,punch_dtime
               ,punch_time
               ,valid_flag
               ,stamp_readout_datetime
            )
            SELECT
                s.stamp_card_id
               ,CASE WHEN s.stamp_control_mode = 3
                          THEN 'S'
                WHEN s.stamp_control_mode = 4
                     THEN 'F'
                WHEN s.stamp_control_mode = 7
                     THEN 'X'
                WHEN s.stamp_control_mode = 10
                     THEN 'C'
                ELSE COALESCE(c.control_code, CAST(s.stamp_control_code AS NVARCHAR(3)))END AS control_code
               --s.stamp_punch_datetime,
               ,DATEADD(SECOND, DATEPART(HOUR, CONVERT(TIME, s.stamp_punch_datetime)) * 3600 + DATEPART(MINUTE, CONVERT(TIME, s.stamp_punch_datetime)) * 60 + DATEPART(SECOND, CONVERT(TIME, s.stamp_punch_datetime)), DATEADD(DAY, CASE WHEN s.stamp_punch_wday = 0 THEN 7 ELSE s.stamp_punch_wday END, DATEADD(WEEK, DATEDIFF(WEEK, 0, @start), 0) - 1)) AS t
               ,dbo.time_from_start(ca.cat_start_time, DATEADD(SECOND, DATEPART(HOUR, CONVERT(TIME, s.stamp_punch_datetime)) * 3600 + DATEPART(MINUTE, CONVERT(TIME, s.stamp_punch_datetime)) * 60 + DATEPART(SECOND, CONVERT(TIME, s.stamp_punch_datetime)), DATEADD(DAY, CASE WHEN s.stamp_punch_wday = 0 THEN 7 ELSE s.stamp_punch_wday END, DATEADD(WEEK, DATEDIFF(WEEK, 0, @start), 0) - 1))) AS punch_time
               ,1 AS valid
               ,s.stamp_readout_datetime
            FROM
                dbo.stamps AS s
                INNER JOIN dbo.competitors AS com ON s.stamp_card_id = com.comp_chip_id
                INNER JOIN dbo.teams AS t ON com.team_id = t.team_id
                INNER JOIN dbo.categories AS ca ON t.cat_id = ca.cat_id
                LEFT OUTER JOIN dbo.controls AS c ON s.stamp_control_code = c.control_id
            WHERE
                s.stamp_card_id = @stamp_card_id
                AND s.stamp_control_mode NOT IN (10, 3, 7)
            ORDER BY
                s.stamp_punch_datetime

            /*	OPEN new_punches_cursor;
			
			FETCH NEXT FROM new_punches_cursor
			INTO
			@stamp_card_id,
			@control_code,
			@punch_time,
			@stamp_punch_datetime,
			@stamp_readout_datetime;
			
			WHILE @@FETCH_STATUS = 0
			BEGIN
			if @control_code not in('C', 'S', 'X')
			begin
			insert into punches (chip_id, control_code, punch_dtime, punch_time, valid_flag, stamp_readout_datetime)
			values (@stamp_card_id, @control_code, @stamp_punch_datetime, @punch_time, 1, @stamp_readout_datetime);
			end
			FETCH NEXT FROM new_punches_cursor
			INTO
			@stamp_card_id,
			@control_code,
			@punch_time,
			@stamp_punch_datetime,
			@stamp_readout_datetime;
			end --end while
			CLOSE new_punches_cursor;
			DEALLOCATE new_punches_cursor;
			*/
            --exceptions
            DECLARE exceptions_cursor CURSOR FOR
                SELECT
                    e.control_code
                   ,e.exc_dtime
                   ,e.exc_del
                   ,dbo.time_from_start(ca.cat_start_time, e.exc_dtime) AS exc_time
                FROM
                    dbo.exceptions AS e
                    INNER JOIN dbo.competitors AS co ON co.comp_chip_id = e.chip_id
                    INNER JOIN dbo.teams AS t ON t.team_id = co.team_id
                    INNER JOIN dbo.categories AS ca ON t.cat_id = ca.cat_id
                WHERE
                    e.chip_id = @stamp_card_id

            OPEN exceptions_cursor;
            PRINT 'exceptions'
            FETCH NEXT FROM exceptions_cursor
            INTO
                @control_code
               ,@exc_dtime
               ,@exc_del
               ,@exc_time;

            WHILE @@FETCH_STATUS = 0
            BEGIN
                IF @exc_del = 1
                BEGIN
                    PRINT 'delete ' + @control_code
                    UPDATE
                        dbo.punches
                    SET
                        valid_flag = 0
                    WHERE
                        chip_id = @stamp_card_id
                        AND control_code = @control_code
                END
                ELSE
                BEGIN
                    PRINT 'insert_update'
                    --insert or update
                    UPDATE
                        dbo.punches
                    SET
                        punch_dtime = @exc_dtime
                       ,punch_time = @exc_time
                       ,valid_flag = 1
                    WHERE
                        chip_id = @stamp_card_id
                        AND control_code = @control_code
                    IF @@rowcount = 0
                    BEGIN
                        PRINT 'insert'
                        INSERT INTO dbo.punches (chip_id, control_code, punch_time, punch_dtime, valid_flag)
                        SELECT
                            CAST(@stamp_card_id AS VARCHAR(50))
                           ,@control_code
                           ,@exc_time
                           ,@exc_dtime
                           ,1
                        WHERE
                            NOT EXISTS (
                            SELECT
                                punch_id
                            FROM
                                dbo.punches
                            WHERE
                                chip_id = @stamp_card_id
                                AND control_code = @control_code
                        )
                    END
                END
                FETCH NEXT FROM exceptions_cursor
                INTO
                    @control_code
                   ,@exc_dtime
                   ,@exc_del
                   ,@exc_time;
            END --end while
            CLOSE exceptions_cursor
            DEALLOCATE exceptions_cursor
        END
        --rollback
        COMMIT
    END
END
GO
/****** Object:  StoredProcedure [dbo].[x_sp_stamp2punches2]    Script Date: 03.05.2023 9:12:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[x_sp_stamp2punches2]
    @id_card INT
AS
/*

DECLARE @RC int
DECLARE @id_card int = 243

EXECUTE @RC = dbo.sp_stamp2punches2 
   @id_card

*/
BEGIN
--DECLARE @id_card int = 243
    IF ISNULL(@id_card, 0) <> 0
    BEGIN

        SET NOCOUNT ON;
        SET DATEFIRST 1;

        DECLARE @event_id INT
        --config
        SELECT
            @event_id = CAST(s.config_value AS INT)
        FROM
            dbo.settings AS s
        WHERE
            s.config_name = 'event_id'

        DELETE  FROM
        dbo.punches
        WHERE
            id_card = @id_card

        --do I know this chip?

        DECLARE @comp_id INT

        SELECT
            @comp_id = co.comp_id
        FROM
            dbo.competitors AS co
            INNER JOIN dbo.lccards AS lc ON co.comp_chip_id = lc.card_id
        WHERE
            lc.id_card = 243 --@id_card

        IF ISNULL(@comp_id, -1) = -1
        BEGIN
PRINT 'chip known'


--            RETURN 1
        END
        ELSE
		BEGIN
PRINT 'no chip known'			
--            RETURN 0
		end
    END



END
GO
USE [master]
GO
ALTER DATABASE [klc01] SET  READ_WRITE 
GO
