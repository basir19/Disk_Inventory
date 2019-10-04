/*
		Name				Date				Project
		Basir Qurbani		10/03/2019			SWDV-220 Project 2
*/
USE master
GO

if DB_ID('MyMusicDB') is not null
	DROP DATABASE MyMusicDB
	GO

CREATE DATABASE MyMusicDB;
GO

USE MyMusicDB;

--Genre, dist status and dist type Tables
CREATE TABLE Genre(
	GenreID			int					not null IDENTITY	PRIMARY KEY,
	GenreDesciption	varchar(255)		not null
);

CREATE TABLE DiskStatus(
	StatusID			int				not null IDENTITY	PRIMARY KEY,
	StatusDescription	varchar(255)	not null
);

CREATE TABLE DiskType(
	TypeID				int				not null IDENTITY	PRIMARY KEY,
	TypeDescription		varchar(255)	not null
);

--Disk table
CREATE TABLE CD_DVD(
	DiskID				int				not null IDENTITY	PRIMARY KEY,
	DiskName			varchar(100)	not null,
	DiskReleaseDate		date			not null,
	TypeID				int				not null REFERENCES	DiskType(TypeID),
	StatusID			int				not null REFERENCES	DiskStatus(StatusID),
	GenreID				int				not null REFERENCES	Genre(GenreID)
);

--Artist Table
CREATE TABLE ArtistType(
	ArtistTypeID		int				not null IDENTITY	PRIMARY KEY,
	ArtistDesciption	varchar(255)	not null
);

CREATE TABLE Artist(
	ArtistID			int				not null IDENTITY	PRIMARY KEY,
	ArtistFirstName		varchar(50)		not null,
	ArtistLastName		varchar(50)		not null,
	ArtistTypeID		int				not null REFERENCES ArtistType(ArtistTypeID)
);

--Artist_Disk table that joins the artist and cd tables
CREATE TABLE Artist_Disk(
	ArtistID			int				not null REFERENCES Artist(ArtistID),
	DiskID				int				not null REFERENCES CD_DVD(DiskID),
	PRIMARY KEY(ArtistID, DiskID)
);

--table that stores information about disk borrowers
CREATE TABLE Borrower(
	BorrowerID			int				not null IDENTITY	PRIMARY KEY,
	BorrowerFirstName	varchar(50)		not null,
	BorrowerLastName	varchar(50)		not null,
	BorrowerPhoneNum	varchar(16)		not null
);

--Borrower_Disk table joins the Disk table and Borrower table
CREATE TABLE Borrower_Disk(
	DiskID				int				not null REFERENCES	CD_DVD(DiskID),
	BorrowerID			int				not null REFERENCES Borrower(BorrowerID),
	BorrowDate			date			not null,
	BorrowReturnDate	date			null,
	PRIMARY KEY(DiskID, BorrowerID, BorrowDate)
);


--create login user for disk table
IF SUSER_ID('diskUser') is null
	CREATE LOGIN diskUser WITH PASSWORD = 'Pa$$w0rd',
	DEFAULT_DATABASE = MyMusicDB;

--Create user 
IF USER_ID('diskUser') is null
	CREATE USER diskUser;


ALTER ROLE db_datareader ADD member diskUser;
GO