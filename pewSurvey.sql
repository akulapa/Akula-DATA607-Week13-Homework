DROP SCHEMA `pewData`;

CREATE SCHEMA IF NOT EXISTS `pewData` DEFAULT CHARACTER SET utf8 ;
USE `pewData` ;

CREATE TABLE IF NOT EXISTS `pewData`.`Question` (
  `idQuestion` INT NOT NULL,
  `questionShortName` VARCHAR(20) NULL,
  `questionDesc` NVARCHAR(4000) NULL,
  PRIMARY KEY (`idQuestion`))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `pewData`.`Answer` (
  `idAnswer` INT NOT NULL,
  `answerDesc` VARCHAR(500) NULL,
  PRIMARY KEY (`idAnswer`))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `pewData`.`QuestionAnswer` (
  `idQuestion` INT NOT NULL,
  `idAnswer` INT NOT NULL,
  `pewAnswerId` INT NOT NULL,
  CONSTRAINT `qaf2`
    FOREIGN KEY (`idQuestion`)
    REFERENCES `pewData`.`Question` (`idQuestion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `qaf3`
    FOREIGN KEY (`idAnswer`)
    REFERENCES `pewData`.`Answer` (`idAnswer`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `pewData`.`Gender` (
  `idGender` INT NOT NULL,
  `genderDesc` VARCHAR(10) NULL,
  PRIMARY KEY (`idGender`))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `pewData`.`Employment` (
  `idEmployment` INT NOT NULL,
  `EmploymentDesc` VARCHAR(100) NULL,
  PRIMARY KEY (`idEmployment`))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `pewData`.`Age` (
  `idAge` INT NOT NULL,
  `low` INT NULL, 
  `high` INT NULL,
  `ageDesc` VARCHAR(30) NULL,
  PRIMARY KEY (`idAge`))
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `pewData`.`Education` (
  `idEducation` INT NOT NULL,
  `educationDesc` VARCHAR(100) NULL,
  PRIMARY KEY (`idEducation`))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `pewData`.`Race_Ethnicity` (
  `idRace_Ethnicity` INT NOT NULL,
  `race_EthnicityDesc` VARCHAR(50) NULL,
  PRIMARY KEY (`idRace_Ethnicity`))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `pewData`.`Income` (
  `idIncome` INT NOT NULL,
  `incomeDesc` VARCHAR(50) NULL,
  PRIMARY KEY (`idIncome`))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `pewData`.`Political_Party` (
  `idPolitical_Party` INT NOT NULL,
  `political_PartyDesc` VARCHAR(20) NULL,
  PRIMARY KEY (`idPolitical_Party`))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `pewData`.`Region` (
  `idRegion` INT NOT NULL,
  `regionDesc` VARCHAR(20) NULL,
  PRIMARY KEY (`idRegion`))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `pewData`.`Respondent` (
  `idRespondent` INT NOT NULL,
  `idGender` INT NOT NULL,
  `idEmployment` INT NOT NULL,
  `idAge` INT NOT NULL,
  `idEducation` INT NOT NULL,
  `idRace_Ethnicity` INT NOT NULL,
  `idIncome` INT NOT NULL,
  `idPolitical_Party` INT NOT NULL,
  `idRegion` INT NOT NULL,
  `surveyDate` DATETIME NOT NULL,
  PRIMARY KEY (`idRespondent`),
  CONSTRAINT `gf2`
	FOREIGN KEY (`idGender`)
	REFERENCES `pewData`.`Gender` (`idGender`)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION,
  CONSTRAINT `ef2`
	FOREIGN KEY (`idEmployment`)
	REFERENCES `pewData`.`Employment` (`idEmployment`)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION,
  CONSTRAINT `edf2`
	FOREIGN KEY (`idEducation`)
	REFERENCES `pewData`.`Education` (`idEducation`)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION,
  CONSTRAINT `ref2`
	FOREIGN KEY (`idRace_Ethnicity`)
	REFERENCES `pewData`.`Race_Ethnicity` (`idRace_Ethnicity`)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION,
  CONSTRAINT `if2`
	FOREIGN KEY (`idIncome`)
	REFERENCES `pewData`.`Income` (`idIncome`)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION,
  CONSTRAINT `pf2`
	FOREIGN KEY (`idPolitical_Party`)
	REFERENCES `pewData`.`Political_Party` (`idPolitical_Party`)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION,
  CONSTRAINT `rf2`
	FOREIGN KEY (`idRegion`)
	REFERENCES `pewData`.`Region` (`idRegion`)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `pewData`.`Survey` (
  `idRespondent` INT NOT NULL,
  `idQuestion` INT NOT NULL,
  `idAnswer` INT NOT NULL,
  CONSTRAINT `psrf2`
    FOREIGN KEY (`idRespondent`)
    REFERENCES `pewData`.`Respondent` (`idRespondent`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `psqf2`
    FOREIGN KEY (`idQuestion`)
    REFERENCES `pewData`.`Question` (`idQuestion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `psa2`
    FOREIGN KEY (`idAnswer`)
    REFERENCES `pewData`.`Answer` (`idAnswer`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


CREATE VIEW `pewData`.`vwSurveyMain` AS
SELECT 
     R.idRespondent AS `respondent`,
     R.surveyDate AS `surveyDate`,
     RI.regionDesc AS `region`,
     G.genderDesc AS `gender`,
     R.idAge AS `age`,
     Edu.educationDesc AS `education`,
     Emp.employmentDesc AS `employment`,
     I.IncomeDesc AS `Income`,
     RE.race_EthnicityDesc AS `ethnicity`,
     P.political_PartyDesc AS `politicalParty`
FROM `pewData`.`Respondent` AS R
JOIN `pewData`.`Gender` AS G ON R.idGender = G.idGender
JOIN `pewData`.`Education` AS Edu ON R.idEducation = Edu.idEducation
JOIN `pewData`.`Employment` AS Emp ON R.idEmployment = Emp.idEmployment
JOIN `pewData`.`Income` AS I ON R.idIncome = I.idIncome
JOIN `pewData`.`Race_Ethnicity` AS RE ON R.idRace_Ethnicity = RE.idRace_Ethnicity
JOIN `pewData`.`Political_Party` AS P ON R.idPolitical_Party = P.idPolitical_Party
JOIN `pewData`.`Region` AS RI ON R.idRegion = RI.idRegion;

CREATE VIEW `pewData`.`vwSurveySub` AS
SELECT
     S.idRespondent AS `respondent`,
     Q.questionDesc AS `question`,
     A.answerDesc AS `answer`
FROM `pewData`.`Survey` AS S
JOIN `pewData`.`Question` Q ON S.idQuestion = Q.idQuestion 
JOIN `pewData`.`Answer` A ON S.idAnswer = A.idAnswer;

CREATE VIEW `pewData`.`vwQA` AS
SELECT
     Q.questionDesc AS `question`,
     A.answerDesc AS `answer`,
     QA.pewAnswerId AS `aId`
FROM `pewData`.`QuestionAnswer` AS QA
JOIN `pewData`.`Question` Q ON QA.idQuestion = Q.idQuestion 
JOIN `pewData`.`Answer` A ON QA.idAnswer = A.idAnswer
ORDER BY QA.idQuestion,QA.pewAnswerId;


