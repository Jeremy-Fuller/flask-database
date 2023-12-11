Drop Database IF EXISTS videogames;
Create Database videogames;

USE videogames;

DROP USER IF EXISTS 'flask_user'@'localhost';

CREATE USER 'flask_user'@'localhost' 
IDENTIFIED BY 'secure_password_123';

GRANT SELECT, INSERT, UPDATE, DELETE ON videogames.* to flask_user@localhost;

DROP TABLE IF EXISTS platform;

CREATE TABLE platform(
    platformID SMALLINT UNSIGNED AUTO_INCREMENT,
    platformName VARCHAR(35),
    PRIMARY KEY (platformID)
);

DROP TABLE IF EXISTS console; 

CREATE TABLE console(
    consoleID SMALLINT UNSIGNED AUTO_INCREMENT,
    consoleName VARCHAR(35),
    releaseYear YEAR,
    platformID SMALLINT UNSIGNED,
    PRIMARY KEY (consoleID),
    CONSTRAINT fk_platformID FOREIGN KEY (platformID) REFERENCES platform (platformID)
    ON UPDATE CASCADE
    ON DELETE SET NULL
);

DROP TABLE IF EXISTS game; 

CREATE TABLE game(
    gameID SMALLINT UNSIGNED AUTO_INCREMENT,
    gameName VARCHAR(100),
    releaseYear YEAR,
    playerRating VARCHAR(1),
    PRIMARY KEY (gameID)
);

DROP TABLE IF EXISTS console_game; 

CREATE TABLE console_game (
    consoleID SMALLINT UNSIGNED,
    gameID SMALLINT UNSIGNED,
    PRIMARY KEY (consoleID, gameID),
    CONSTRAINT fk_consoleID FOREIGN KEY (consoleID) REFERENCES console(consoleID)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
    CONSTRAINT fk_gameID FOREIGN KEY (gameID) REFERENCES game(gameID)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);


INSERT INTO platform(platformName) VALUES
('Sony'),
('Sega'),
('Nintendo'),
('Microsoft'); 

INSERT INTO console(consoleName, platformID, releaseYear) VALUES 
('Nintendo 64', 3, 1996),
('Gamecube', 3, 2001),
('Switch', 3, 2017),
('Genesis', 2, 1989),
('Playstation 2', 1, 2000),
('Playstation 4', 1, 2013),
('Playstation 5', 1, 2020),
('Xbox', 4, 2001),
('Xbox 360', 4, 2005),
('Xbox One', 4, 2013);

INSERT INTO game(gameName, releaseYear, playerRating) VALUES 
('Super Mario 64', 1996, 'E'),
('Super Mario Strikers', 2005, 'E'),
('Super Mario Wonder', 2023, 'E'),
('NHL 94', 1993, 'E'),
('Twisted Metal', 2001, 'M'),
('Doom Eternal', 2020, 'T'),
('Stray', 2022, 'E'),
('Halo', 2001, 'M'),
('Grand Theft Auto 4', 2008, 'M'),
('Metroid Prime', 2002, 'T'),
('Sonic The Hedgehog 2', 1992, 'E');


INSERT INTO console_game (consoleID, gameID) VALUES
(1,1),
(2,2),
(3,3),
(4,4),
(5,5),
(6,6),
(7,6),
(6,7),
(7,7),
(10,7),
(8,7),
(9,9),
(10,9),
(2,11),
(3,10),
(4,11);