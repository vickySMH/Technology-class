USE library;

-- table 1
DROP TABLE IF EXISTS `tauthor`;
CREATE TABLE IF NOT EXISTS `tauthor` (
    `nAuthorID` int(11) NOT NULL AUTO_INCREMENT,
    `cName` varchar(40) NOT NULL,
    `cSurname` varchar(60) DEFAULT NULL,
    PRIMARY KEY (`nAuthorID`)
    ) ENGINE=InnoDB AUTO_INCREMENT=512 DEFAULT CHARSET=latin1;

-- table 2
DROP TABLE IF EXISTS `tauthorship`;
CREATE TABLE IF NOT EXISTS `tauthorship` (
    `nBookID` int(11) NOT NULL,
    `nAuthorID` int(11) NOT NULL,
    PRIMARY KEY (`nBookID`,`nAuthorID`)
    ) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- table 3
DROP TABLE IF EXISTS `tbook`;
CREATE TABLE IF NOT EXISTS `tbook` (
    `nBookID` int(11) NOT NULL AUTO_INCREMENT,
    `cTitle` varchar(255) NOT NULL,
    `nPublishingYear` decimal(4,0) DEFAULT NULL,
    `nPublishingCompanyID` int(11) NOT NULL,
    PRIMARY KEY (`nBookID`)
    ) ENGINE=InnoDB AUTO_INCREMENT=2000 DEFAULT CHARSET=latin1;

-- table 4
DROP TABLE IF EXISTS `tbookcopy`;
CREATE TABLE IF NOT EXISTS `tbookcopy` (
    `cSignature` varchar(15) NOT NULL,
    `nBookID` int(11) NOT NULL,
    PRIMARY KEY (`cSignature`)
    ) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- table 5
DROP TABLE IF EXISTS `tbooktheme`;
CREATE TABLE IF NOT EXISTS `tbooktheme` (
    `nBookID` int(11) NOT NULL,
    `nThemeID` smallint(6) NOT NULL,
    PRIMARY KEY (`nBookID`,`nThemeID`)
    ) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- table 6
DROP TABLE IF EXISTS `tcountry`;
CREATE TABLE IF NOT EXISTS `tcountry` (
                                          `nCountryID` decimal(3,0) NOT NULL,
    `cName` varchar(60) NOT NULL,
    PRIMARY KEY (`nCountryID`)
    ) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- table 7
DROP TABLE IF EXISTS `tloan`;
CREATE TABLE IF NOT EXISTS `tloan` (
    `cSignature` varchar(15) NOT NULL,
    `cCPR` char(10) NOT NULL,
    `dLoan` date NOT NULL,
    PRIMARY KEY (`cSignature`,`cCPR`,`dLoan`)
    ) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- table 8
DROP TABLE IF EXISTS `tmember`;
CREATE TABLE IF NOT EXISTS `tmember` (
    `cCPR` char(10) NOT NULL,
    `cName` varchar(30) NOT NULL,
    `cSurname` varchar(60) NOT NULL,
    `cAddress` varchar(100) DEFAULT NULL,
    `cPhoneNo` char(12) NOT NULL,
    `dBirth` date NOT NULL,
    `dNewMember` date NOT NULL,
    PRIMARY KEY (`cCPR`)
    ) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- table 9
DROP TABLE IF EXISTS `tnationality`;
CREATE TABLE IF NOT EXISTS `tnationality` (
    `nAuthorID` int(11) NOT NULL,
    `nCountryID` decimal(3,0) NOT NULL,
    PRIMARY KEY (`nAuthorID`,`nCountryID`)
    ) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- table 10
DROP TABLE IF EXISTS `tpublishingcompany`;
CREATE TABLE IF NOT EXISTS `tpublishingcompany` (
    `nPublishingCompanyID` int(11) NOT NULL AUTO_INCREMENT,
    `cName` varchar(40) NOT NULL,
    `nCountryID` decimal(3,0) NOT NULL,
    PRIMARY KEY (`nPublishingCompanyID`)
    ) ENGINE=InnoDB AUTO_INCREMENT=158 DEFAULT CHARSET=latin1;

-- table 11
DROP TABLE IF EXISTS `ttheme`;
CREATE TABLE IF NOT EXISTS `ttheme` (
    `nThemeID` smallint(6) NOT NULL AUTO_INCREMENT,
    `cName` varchar(30) NOT NULL,
    PRIMARY KEY (`nThemeID`)
    ) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;