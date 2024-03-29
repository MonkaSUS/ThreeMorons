USE [master]
GO
/****** Object:  Database [ThreeMorons]    Script Date: 22.02.2024 8:52:51 ******/
CREATE DATABASE [ThreeMorons]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'ThreeMorons', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\ThreeMorons.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'ThreeMorons_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\ThreeMorons_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [ThreeMorons].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [ThreeMorons] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [ThreeMorons] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [ThreeMorons] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [ThreeMorons] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [ThreeMorons] SET ARITHABORT OFF 
GO
ALTER DATABASE [ThreeMorons] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [ThreeMorons] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [ThreeMorons] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [ThreeMorons] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [ThreeMorons] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [ThreeMorons] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [ThreeMorons] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [ThreeMorons] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [ThreeMorons] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [ThreeMorons] SET  DISABLE_BROKER 
GO
ALTER DATABASE [ThreeMorons] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [ThreeMorons] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [ThreeMorons] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [ThreeMorons] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [ThreeMorons] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [ThreeMorons] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [ThreeMorons] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [ThreeMorons] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [ThreeMorons] SET  MULTI_USER 
GO
ALTER DATABASE [ThreeMorons] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [ThreeMorons] SET DB_CHAINING OFF 
GO
ALTER DATABASE [ThreeMorons] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [ThreeMorons] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [ThreeMorons] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [ThreeMorons] SET QUERY_STORE = OFF
GO
USE [ThreeMorons]
GO
ALTER DATABASE SCOPED CONFIGURATION SET IDENTITY_CACHE = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = PRIMARY;
GO
USE [ThreeMorons]
GO
/****** Object:  Table [dbo].[Group]    Script Date: 22.02.2024 8:52:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Group](
	[GroupName] [nvarchar](10) NOT NULL,
	[GroupCurator] [uniqueidentifier] NOT NULL,
	[Building] [int] NULL,
 CONSTRAINT [PK_Group] PRIMARY KEY CLUSTERED 
(
	[GroupName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Period]    Script Date: 22.02.2024 8:52:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Period](
	[id] [int] NOT NULL,
	[StartTime] [time](2) NOT NULL,
	[EndTime] [time](2) NOT NULL,
 CONSTRAINT [PK_Period] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Session]    Script Date: 22.02.2024 8:52:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Session](
	[id] [uniqueidentifier] NOT NULL,
	[JWTToken] [nvarchar](150) NOT NULL,
	[RefreshToken] [nvarchar](150) NOT NULL,
	[IsValid] [bit] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SkippedClasses]    Script Date: 22.02.2024 8:52:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SkippedClasses](
	[id] [uniqueidentifier] NOT NULL,
	[StudNumber] [nvarchar](5) NOT NULL,
	[DateOfSkip] [date] NOT NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_SkippedClasses] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Student]    Script Date: 22.02.2024 8:52:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Student](
	[StudNumber] [nvarchar](5) NOT NULL,
	[Name] [nvarchar](40) NOT NULL,
	[Surname] [nvarchar](40) NOT NULL,
	[Patronymic] [nvarchar](40) NOT NULL,
	[GroupName] [nvarchar](10) NOT NULL,
	[PhoneNumber] [nvarchar](11) NOT NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_Student] PRIMARY KEY CLUSTERED 
(
	[StudNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StudentDelays]    Script Date: 22.02.2024 8:52:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StudentDelays](
	[id] [uniqueidentifier] NOT NULL,
	[StudNumber] [nvarchar](5) NOT NULL,
	[ClassName] [nvarchar](20) NOT NULL,
	[Delay] [time](2) NOT NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_StudentDelays] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[User]    Script Date: 22.02.2024 8:52:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[User](
	[id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](40) NOT NULL,
	[Surname] [nvarchar](40) NOT NULL,
	[Patronymic] [nvarchar](40) NOT NULL,
	[Login] [nvarchar](20) NOT NULL,
	[Password] [nvarchar](50) NOT NULL,
	[UserClassId] [int] NOT NULL,
	[Salt] [varbinary](20) NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserClass]    Script Date: 22.02.2024 8:52:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserClass](
	[id] [int] NOT NULL,
	[Description] [nvarchar](20) NOT NULL,
 CONSTRAINT [PK_UserClass] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[Group] ([GroupName], [GroupCurator], [Building]) VALUES (N'ИС-44к', N'33cb1964-072e-4a7b-b985-8404cdbea465', 2)
INSERT [dbo].[Student] ([StudNumber], [Name], [Surname], [Patronymic], [GroupName], [PhoneNumber], [IsDeleted]) VALUES (N'26142', N'Павел', N'Петрухин', N'Викторович', N'ИС-44к', N'89995553322', NULL)
INSERT [dbo].[Student] ([StudNumber], [Name], [Surname], [Patronymic], [GroupName], [PhoneNumber], [IsDeleted]) VALUES (N'26143', N'Лев', N'Поваляев', N'Павлович', N'ИС-44к', N'89996055323', NULL)
INSERT [dbo].[User] ([id], [Name], [Surname], [Patronymic], [Login], [Password], [UserClassId], [Salt], [IsDeleted]) VALUES (N'6ff12292-c614-4d02-a9fd-2b2b806d0af7', N'Амонгус', N'тигрилов', N'саваннович', N'sobaka12345', N'GDk9ZL8IKyVXyyb6DDiYJV/t0PYRj5V+ixLYw97fLrw=', 2, 0x1B21BD2AD7BB7B9C8B3D10DCFAFEBAB9, NULL)
INSERT [dbo].[User] ([id], [Name], [Surname], [Patronymic], [Login], [Password], [UserClassId], [Salt], [IsDeleted]) VALUES (N'79bbbf2a-acbf-4bad-80e7-4fef9fc18bd2', N'Ольга', N'Бабченко', N'Сергеевна', N'olga22', N'asd123', 1, NULL, NULL)
INSERT [dbo].[User] ([id], [Name], [Surname], [Patronymic], [Login], [Password], [UserClassId], [Salt], [IsDeleted]) VALUES (N'a8eae84d-f757-49c6-8e02-72d1d50c96e5', N'Амонгус', N'тигрилов', N'саваннович', N'sobaka123456', N'aWx6u3Gf+0fqzPZ/XZZ05d3ilbxubDD5WxUJ4qlsJYc=', 2, 0xDEEBECD2991C39DEC3341AADDEA55B3D, NULL)
INSERT [dbo].[User] ([id], [Name], [Surname], [Patronymic], [Login], [Password], [UserClassId], [Salt], [IsDeleted]) VALUES (N'33cb1964-072e-4a7b-b985-8404cdbea465', N'Иван', N'Руководительный', N'Петрович', N'ivan23', N'asd123', 2, NULL, NULL)
INSERT [dbo].[User] ([id], [Name], [Surname], [Patronymic], [Login], [Password], [UserClassId], [Salt], [IsDeleted]) VALUES (N'27fb5912-4edf-427f-b561-f47fc997c3df', N'Амонгус', N'тигрилов', N'саваннович', N'sobaka1', N'5JDRl3I4Arxs5lwF068ktKH9rOOfpMoILDt4olkvPUI=', 2, 0xC98A3DFFA1D27CA9753457956BBA341C, NULL)
INSERT [dbo].[UserClass] ([id], [Description]) VALUES (1, N'Староста')
INSERT [dbo].[UserClass] ([id], [Description]) VALUES (2, N'Важный')
INSERT [dbo].[UserClass] ([id], [Description]) VALUES (3, N'Сервер')
ALTER TABLE [dbo].[Group]  WITH CHECK ADD  CONSTRAINT [FK_Group_User] FOREIGN KEY([GroupCurator])
REFERENCES [dbo].[User] ([id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Group] CHECK CONSTRAINT [FK_Group_User]
GO
ALTER TABLE [dbo].[SkippedClasses]  WITH CHECK ADD  CONSTRAINT [FK_SkippedClasses_Student] FOREIGN KEY([StudNumber])
REFERENCES [dbo].[Student] ([StudNumber])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[SkippedClasses] CHECK CONSTRAINT [FK_SkippedClasses_Student]
GO
ALTER TABLE [dbo].[Student]  WITH CHECK ADD  CONSTRAINT [FK_Student_Group] FOREIGN KEY([GroupName])
REFERENCES [dbo].[Group] ([GroupName])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Student] CHECK CONSTRAINT [FK_Student_Group]
GO
ALTER TABLE [dbo].[StudentDelays]  WITH CHECK ADD  CONSTRAINT [FK_StudentDelays_Student] FOREIGN KEY([StudNumber])
REFERENCES [dbo].[Student] ([StudNumber])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[StudentDelays] CHECK CONSTRAINT [FK_StudentDelays_Student]
GO
ALTER TABLE [dbo].[User]  WITH CHECK ADD  CONSTRAINT [FK_User_UserClass] FOREIGN KEY([UserClassId])
REFERENCES [dbo].[UserClass] ([id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[User] CHECK CONSTRAINT [FK_User_UserClass]
GO
USE [master]
GO
ALTER DATABASE [ThreeMorons] SET  READ_WRITE 
GO
