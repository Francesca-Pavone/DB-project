-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema pizzeriaDB
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `pizzeriaDB` ;

-- -----------------------------------------------------
-- Schema pizzeriaDB
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `pizzeriaDB` ;
USE `pizzeriaDB` ;

-- -----------------------------------------------------
-- Table `pizzeriaDB`.`Ingredienti`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pizzeriaDB`.`Ingredienti` ;

CREATE TABLE IF NOT EXISTS `pizzeriaDB`.`Ingredienti` (
  `Nome` VARCHAR(45) NOT NULL,
  `Quantita` INT UNSIGNED NOT NULL DEFAULT 0,
  `Prezzo` DECIMAL(3,2) NOT NULL DEFAULT 1,
  PRIMARY KEY (`Nome`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeriaDB`.`Pizze`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pizzeriaDB`.`Pizze` ;

CREATE TABLE IF NOT EXISTS `pizzeriaDB`.`Pizze` (
  `Nome` VARCHAR(45) NOT NULL,
  `Prezzo` DECIMAL(4,2) NOT NULL,
  PRIMARY KEY (`Nome`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeriaDB`.`Bevande`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pizzeriaDB`.`Bevande` ;

CREATE TABLE IF NOT EXISTS `pizzeriaDB`.`Bevande` (
  `Nome` VARCHAR(45) NOT NULL,
  `Quantita` INT UNSIGNED NOT NULL DEFAULT 0,
  `Prezzo` DECIMAL(5,2) NOT NULL,
  PRIMARY KEY (`Nome`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeriaDB`.`Turni`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pizzeriaDB`.`Turni` ;

CREATE TABLE IF NOT EXISTS `pizzeriaDB`.`Turni` (
  `Nome` VARCHAR(45) NOT NULL,
  `OraInizio` TIME NOT NULL,
  `OraFine` TIME NOT NULL,
  PRIMARY KEY (`Nome`),
  UNIQUE INDEX `FasciaOraria_UNIQUE` (`OraInizio` ASC, `OraFine` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeriaDB`.`Camerieri`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pizzeriaDB`.`Camerieri` ;

CREATE TABLE IF NOT EXISTS `pizzeriaDB`.`Camerieri` (
  `Nome` VARCHAR(45) NOT NULL,
  `Cognome` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Nome`, `Cognome`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeriaDB`.`Tavoli`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pizzeriaDB`.`Tavoli` ;

CREATE TABLE IF NOT EXISTS `pizzeriaDB`.`Tavoli` (
  `NumeroTavolo` INT UNSIGNED NOT NULL,
  `NumeroPosti` INT UNSIGNED NOT NULL,
  `Disponibilita` TINYINT(1) UNSIGNED NOT NULL DEFAULT 1,
  `NomeC` VARCHAR(45) NULL DEFAULT NULL,
  `CognomeC` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`NumeroTavolo`),
  INDEX `fk_Tavoli_Cameriere_idx` (`NomeC` ASC, `CognomeC` ASC) VISIBLE,
  CONSTRAINT `fk_Tavoli_Cameriere`
    FOREIGN KEY (`NomeC` , `CognomeC`)
    REFERENCES `pizzeriaDB`.`Camerieri` (`Nome` , `Cognome`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeriaDB`.`Comande`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pizzeriaDB`.`Comande` ;

CREATE TABLE IF NOT EXISTS `pizzeriaDB`.`Comande` (
  `Numero` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Tavolo` INT UNSIGNED NOT NULL,
  `Prezzo` DECIMAL(6,2) NOT NULL DEFAULT 0,
  `Servita` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`Numero`),
  UNIQUE INDEX `Tavolo_UNIQUE` (`Tavolo` ASC) VISIBLE,
  CONSTRAINT `fk_Comande_Tavolo`
    FOREIGN KEY (`Tavolo`)
    REFERENCES `pizzeriaDB`.`Tavoli` (`NumeroTavolo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeriaDB`.`Scontrini`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pizzeriaDB`.`Scontrini` ;

CREATE TABLE IF NOT EXISTS `pizzeriaDB`.`Scontrini` (
  `DataOra` DATETIME NOT NULL,
  `Prezzo` DECIMAL(6,2) NOT NULL,
  `Pagato` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
  `Tavolo` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`DataOra`),
  INDEX `fk_Scontrini_Tavolo_idx` (`Tavolo` ASC) VISIBLE,
  CONSTRAINT `fk_Scontrini_Tavolo`
    FOREIGN KEY (`Tavolo`)
    REFERENCES `pizzeriaDB`.`Tavoli` (`NumeroTavolo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeriaDB`.`Pizze_effettive`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pizzeriaDB`.`Pizze_effettive` ;

CREATE TABLE IF NOT EXISTS `pizzeriaDB`.`Pizze_effettive` (
  `Id` INT UNSIGNED NOT NULL,
  `Comanda` INT UNSIGNED NOT NULL,
  `NomePizza` VARCHAR(45) NOT NULL,
  `Stato` TINYINT(1) UNSIGNED NULL DEFAULT NULL,
  PRIMARY KEY (`Id`, `Comanda`),
  INDEX `fk_PizzeEffettive_Comanda_idx` (`Comanda` ASC) VISIBLE,
  INDEX `fk_PizzeEffettive_Pizza_idx` (`NomePizza` ASC) VISIBLE,
  CONSTRAINT `fk_PizzeEffettive_Comanda`
    FOREIGN KEY (`Comanda`)
    REFERENCES `pizzeriaDB`.`Comande` (`Numero`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PizzeEffettive_Pizza`
    FOREIGN KEY (`NomePizza`)
    REFERENCES `pizzeriaDB`.`Pizze` (`Nome`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeriaDB`.`Bevande_effettive`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pizzeriaDB`.`Bevande_effettive` ;

CREATE TABLE IF NOT EXISTS `pizzeriaDB`.`Bevande_effettive` (
  `Id` INT UNSIGNED NOT NULL,
  `Comanda` INT UNSIGNED NOT NULL,
  `NomeBevanda` VARCHAR(45) NOT NULL,
  `Stato` TINYINT(1) UNSIGNED NOT NULL DEFAULT '0',
  PRIMARY KEY (`Id`, `Comanda`),
  INDEX `fk_BevandeEffettiva_Comanda_idx` (`Comanda` ASC) VISIBLE,
  INDEX `fk_BevandeEffettiva_Bevanda_idx` (`NomeBevanda` ASC) VISIBLE,
  CONSTRAINT `fk_BevandeEffettiva_Comanda`
    FOREIGN KEY (`Comanda`)
    REFERENCES `pizzeriaDB`.`Comande` (`Numero`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_BevandeEffettiva_Bevanda`
    FOREIGN KEY (`NomeBevanda`)
    REFERENCES `pizzeriaDB`.`Bevande` (`Nome`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeriaDB`.`Clienti`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pizzeriaDB`.`Clienti` ;

CREATE TABLE IF NOT EXISTS `pizzeriaDB`.`Clienti` (
  `Nome` VARCHAR(45) NOT NULL,
  `Cognome` VARCHAR(45) NOT NULL,
  `Tavolo` INT UNSIGNED NOT NULL,
  `NumeroCommensali` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`Nome`, `Cognome`, `Tavolo`),
  UNIQUE INDEX `Tavolo_UNIQUE` (`Tavolo` ASC) VISIBLE,
  CONSTRAINT `fk_Clienti`
    FOREIGN KEY (`Tavolo`)
    REFERENCES `pizzeriaDB`.`Tavoli` (`NumeroTavolo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeriaDB`.`Turni_Tavoli`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pizzeriaDB`.`Turni_Tavoli` ;

CREATE TABLE IF NOT EXISTS `pizzeriaDB`.`Turni_Tavoli` (
  `Tavolo` INT UNSIGNED NOT NULL,
  `Turno` VARCHAR(45) NOT NULL,
  `Data` DATE NOT NULL,
  PRIMARY KEY (`Tavolo`, `Data`, `Turno`),
  INDEX `fk_TurniT_Turno_idx` (`Turno` ASC) VISIBLE,
  INDEX `fk_TurniT_Tavolo_idx` (`Tavolo` ASC) VISIBLE,
  CONSTRAINT `fk_TurniT_Tavolo`
    FOREIGN KEY (`Tavolo`)
    REFERENCES `pizzeriaDB`.`Tavoli` (`NumeroTavolo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_TurniT_Turno`
    FOREIGN KEY (`Turno`)
    REFERENCES `pizzeriaDB`.`Turni` (`Nome`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeriaDB`.`Turni_Camerieri`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pizzeriaDB`.`Turni_Camerieri` ;

CREATE TABLE IF NOT EXISTS `pizzeriaDB`.`Turni_Camerieri` (
  `NomeC` VARCHAR(45) NOT NULL,
  `CognomeC` VARCHAR(45) NOT NULL,
  `Turno` VARCHAR(45) NOT NULL,
  `Data` DATE NOT NULL,
  PRIMARY KEY (`NomeC`, `CognomeC`, `Data`),
  INDEX `fk_TurniC_Turno_idx` (`Turno` ASC) VISIBLE,
  INDEX `fk_TurniC_Cameriere_idx` (`NomeC` ASC, `CognomeC` ASC) VISIBLE,
  CONSTRAINT `fk_TurniC_Cameriere`
    FOREIGN KEY (`NomeC` , `CognomeC`)
    REFERENCES `pizzeriaDB`.`Camerieri` (`Nome` , `Cognome`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_TurniC_Turno`
    FOREIGN KEY (`Turno`)
    REFERENCES `pizzeriaDB`.`Turni` (`Nome`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeriaDB`.`Condimenti`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pizzeriaDB`.`Condimenti` ;

CREATE TABLE IF NOT EXISTS `pizzeriaDB`.`Condimenti` (
  `Pizza` VARCHAR(45) NOT NULL,
  `Ingrediente` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Pizza`, `Ingrediente`),
  INDEX `fk_Condimenti_Ingrediente_idx` (`Ingrediente` ASC) VISIBLE,
  INDEX `fk_Condimenti_Pizza_idx` (`Pizza` ASC) VISIBLE,
  CONSTRAINT `fk_Condimenti_Ingrediente`
    FOREIGN KEY (`Ingrediente`)
    REFERENCES `pizzeriaDB`.`Ingredienti` (`Nome`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Condimenti_Pizza`
    FOREIGN KEY (`Pizza`)
    REFERENCES `pizzeriaDB`.`Pizze` (`Nome`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeriaDB`.`Aggiunte`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pizzeriaDB`.`Aggiunte` ;

CREATE TABLE IF NOT EXISTS `pizzeriaDB`.`Aggiunte` (
  `IdPizza` INT UNSIGNED NOT NULL,
  `Comanda` INT UNSIGNED NOT NULL,
  `Ingrediente` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`IdPizza`, `Comanda`, `Ingrediente`),
  INDEX `fk_Aggiunta_Ingrediente_idx` (`Ingrediente` ASC) VISIBLE,
  INDEX `fk_Aggiunta_IdPizza_idx` (`IdPizza` ASC, `Comanda` ASC) VISIBLE,
  CONSTRAINT `fk_Aggiunta_IdPizza`
    FOREIGN KEY (`IdPizza` , `Comanda`)
    REFERENCES `pizzeriaDB`.`Pizze_effettive` (`Id` , `Comanda`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Aggiunta_Ingrediente`
    FOREIGN KEY (`Ingrediente`)
    REFERENCES `pizzeriaDB`.`Ingredienti` (`Nome`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeriaDB`.`Utenti`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pizzeriaDB`.`Utenti` ;

CREATE TABLE IF NOT EXISTS `pizzeriaDB`.`Utenti` (
  `Username` VARCHAR(91) NOT NULL,
  `Password` CHAR(32) NOT NULL,
  `Ruolo` ENUM('Manager', 'Cameriere', 'Pizzaiolo', 'Barista') NOT NULL,
  PRIMARY KEY (`Username`))
ENGINE = InnoDB;

USE `pizzeriaDB` ;

-- -----------------------------------------------------
-- procedure login
-- -----------------------------------------------------

USE `pizzeriaDB`;
DROP procedure IF EXISTS `pizzeriaDB`.`login`;

DELIMITER $$
USE `pizzeriaDB`$$
CREATE PROCEDURE `login` (in var_username varchar(91), in var_password varchar(45), out var_ruolo int)
BEGIN
	declare var_ruolo_utente ENUM('Manager', 'Cameriere', 'Pizzaiolo', 'Barista');
    
	SELECT Ruolo
	FROM Utenti
	WHERE Username = var_username
		AND Password = MD5(var_password) INTO var_ruolo_utente;
        
		if var_ruolo_utente = 'Manager' then
			set var_ruolo = 1;
		elseif var_ruolo_utente = 'Cameriere' then
			set var_ruolo = 2;
		elseif var_ruolo_utente = 'Pizzaiolo' then
			set var_ruolo = 3;
		elseif var_ruolo_utente = 'Barista' then
			set var_ruolo = 4;
		else
			set var_ruolo = 5;
		end if;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure registra_cliente
-- -----------------------------------------------------

USE `pizzeriaDB`;
DROP procedure IF EXISTS `pizzeriaDB`.`registra_cliente`;

DELIMITER $$
USE `pizzeriaDB`$$
CREATE PROCEDURE `registra_cliente` (in var_nomeCliente varchar(45), in var_cognomeCliente varchar(45), in var_numeroCommensali int unsigned, out var_numeroTavolo int unsigned)
BEGIN
	declare exit handler for sqlexception
    begin
		rollback;	#rollback any changes made in the transaction
        resignal;	#raise again the sql exception to the caller 
	end;
    set transaction isolation level read uncommitted; 
    start transaction;
		
	SELECT NumTavolo
	FROM tavoli_da_assegnare_a_clienti
	WHERE var_numeroCommensali <= NumPosti
	LIMIT 1 INTO var_numeroTavolo;
    
    insert into Clienti 
		values (var_nomeCliente, var_cognomeCliente, var_numeroTavolo, var_numeroCommensali);
    
	commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure crea_turno
-- -----------------------------------------------------

USE `pizzeriaDB`;
DROP procedure IF EXISTS `pizzeriaDB`.`crea_turno`;

DELIMITER $$
USE `pizzeriaDB`$$
CREATE PROCEDURE `crea_turno` (in var_nomeTurno VARCHAR(45), in var_oraInizio TIME, in var_oraFine TIME)
BEGIN
	insert into Turni values(var_nomeTurno, var_oraInizio, var_oraFine);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure crea_turno_cameriere
-- -----------------------------------------------------

USE `pizzeriaDB`;
DROP procedure IF EXISTS `pizzeriaDB`.`crea_turno_cameriere`;

DELIMITER $$
USE `pizzeriaDB`$$
CREATE PROCEDURE `crea_turno_cameriere` (in var_nomeCameriere varchar(45), in var_cognomeCameriere varchar(45), in var_turno varchar(45), in var_data date)
BEGIN
	insert into Turni_Camerieri 
		values(var_nomeCameriere, var_cognomeCameriere, var_turno, var_data);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure crea_turno_tavolo
-- -----------------------------------------------------

USE `pizzeriaDB`;
DROP procedure IF EXISTS `pizzeriaDB`.`crea_turno_tavolo`;

DELIMITER $$
USE `pizzeriaDB`$$
CREATE PROCEDURE `crea_turno_tavolo` (in var_tavolo int unsigned, in var_turno varchar(45), in var_data date)
BEGIN
	insert into Turni_Tavoli 
		values (var_tavolo, var_turno, var_data);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure inserisci_pizza_menu
-- -----------------------------------------------------

USE `pizzeriaDB`;
DROP procedure IF EXISTS `pizzeriaDB`.`inserisci_pizza_menu`;

DELIMITER $$
USE `pizzeriaDB`$$
CREATE PROCEDURE `inserisci_pizza_menu` (in var_nomePizza varchar(45), in var_prezzo decimal(4,2))
BEGIN
	insert into Pizze(Nome, Prezzo) 
		values (var_nomePizza, var_prezzo);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure inserisci_condimento_pizza
-- -----------------------------------------------------

USE `pizzeriaDB`;
DROP procedure IF EXISTS `pizzeriaDB`.`inserisci_condimento_pizza`;

DELIMITER $$
USE `pizzeriaDB`$$
CREATE PROCEDURE `inserisci_condimento_pizza` (in var_pizza varchar(45), in var_ingrediente varchar(45))
BEGIN
	insert into Condimenti 
		values (var_pizza, var_ingrediente);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure inserisci_ingrediente_menu
-- -----------------------------------------------------

USE `pizzeriaDB`;
DROP procedure IF EXISTS `pizzeriaDB`.`inserisci_ingrediente_menu`;

DELIMITER $$
USE `pizzeriaDB`$$
CREATE PROCEDURE `inserisci_ingrediente_menu` (in var_nomeIngrediente varchar(45), in var_prezzo decimal(3,2))
BEGIN
	insert into Ingredienti(Nome, Prezzo) 
		values (var_nomeIngrediente, var_prezzo);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure inserisci_bevanda_menu
-- -----------------------------------------------------

USE `pizzeriaDB`;
DROP procedure IF EXISTS `pizzeriaDB`.`inserisci_bevanda_menu`;

DELIMITER $$
USE `pizzeriaDB`$$
CREATE PROCEDURE `inserisci_bevanda_menu` (in var_nomeBevanda varchar(45), in var_prezzo decimal(5,2))
BEGIN
	insert into Bevande(Nome, Prezzo)
		values (var_nomeBevanda, var_prezzo);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure aggiorna_quantita_ingrediente
-- -----------------------------------------------------

USE `pizzeriaDB`;
DROP procedure IF EXISTS `pizzeriaDB`.`aggiorna_quantita_ingrediente`;

DELIMITER $$
USE `pizzeriaDB`$$
CREATE PROCEDURE `aggiorna_quantita_ingrediente` (in var_ingrediente varchar(45), in var_rifornimento int unsigned)
BEGIN
	declare exit handler for sqlexception
    begin
		rollback;	
        resignal;	
	end;
    set transaction isolation level read committed; 
    start transaction;
        
    if not exists (select * from Ingredienti where Nome = var_ingrediente) then
		signal sqlstate '45010' set message_text = 'ingrediente non presente nel sistema';
	end if;    
    
	UPDATE Ingredienti 
	SET Quantita = Quantita + var_rifornimento
	WHERE Nome = var_ingrediente;

    commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure aggiorna_quantita_bevanda
-- -----------------------------------------------------

USE `pizzeriaDB`;
DROP procedure IF EXISTS `pizzeriaDB`.`aggiorna_quantita_bevanda`;

DELIMITER $$
USE `pizzeriaDB`$$
CREATE PROCEDURE `aggiorna_quantita_bevanda` (in var_bevanda varchar(45), in var_rifornimento int unsigned)
BEGIN
	declare exit handler for sqlexception
	begin
		rollback;	
		resignal;	
	end;
	set transaction isolation level read committed; 
	start transaction;

	if not exists (select * from Bevande where Nome = var_bevanda) then
		signal sqlstate '45009' set message_text = 'bevanda non presente nel sistema';
	end if;
    
	UPDATE Bevande 
	SET Quantita = Quantita + var_rifornimento
	WHERE Nome = var_bevanda;
	
    commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure visualizza_tavoli_occupati
-- -----------------------------------------------------

USE `pizzeriaDB`;
DROP procedure IF EXISTS `pizzeriaDB`.`visualizza_tavoli_occupati`;

DELIMITER $$
USE `pizzeriaDB`$$
CREATE PROCEDURE `visualizza_tavoli_occupati` (in var_username varchar(91))
BEGIN
	declare exit handler for sqlexception
	begin
		rollback;	
		resignal;
	end;
	set transaction isolation level read committed; 
    set transaction read only;
	start transaction;

	SELECT NumeroTavolo
	FROM Tavoli
	WHERE Disponibilita = 0
		AND NomeC = TROVA_NOME_UTENTE(var_username)
		AND CognomeC = TROVA_COGNOME_UTENTE(var_username);
	
    commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function trova_nome_utente
-- -----------------------------------------------------

USE `pizzeriaDB`;
DROP function IF EXISTS `pizzeriaDB`.`trova_nome_utente`;

DELIMITER $$
USE `pizzeriaDB`$$
CREATE FUNCTION `trova_nome_utente`(username varchar(91)) 
RETURNS varchar(45)
DETERMINISTIC
BEGIN
	declare nomeUtente varchar(45);
    select substring_index(username, '_', 1) into nomeUtente;
return nomeUtente;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function trova_cognome_utente
-- -----------------------------------------------------

USE `pizzeriaDB`;
DROP function IF EXISTS `pizzeriaDB`.`trova_cognome_utente`;

DELIMITER $$
USE `pizzeriaDB`$$
CREATE FUNCTION `trova_cognome_utente`(username varchar(91)) 
RETURNS varchar(45) 
DETERMINISTIC
BEGIN
	declare cognomeUtente varchar(45);
    select substring_index(username, '_', -1) into cognomeUtente;
return cognomeUtente;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure stampa_scontrino
-- -----------------------------------------------------

USE `pizzeriaDB`;
DROP procedure IF EXISTS `pizzeriaDB`.`stampa_scontrino`;

DELIMITER $$
USE `pizzeriaDB`$$
CREATE PROCEDURE `stampa_scontrino` (in var_tavolo int unsigned, out var_prezzo decimal(6,2), out var_dataOra datetime)
BEGIN
    declare exit handler for sqlexception
	begin
		rollback;	
		resignal;	
	end;
	set transaction isolation level repeatable read; 
	start transaction;
    
	SELECT Prezzo
	FROM Comande
	WHERE Tavolo = var_tavolo 
    INTO var_prezzo;
    
    if var_prezzo = 0 then
		signal sqlstate '45021' set message_text = 'nessuna pizza/bevanda ordinata';
	end if;
		
	set var_dataOra = current_timestamp();
    
	insert into Scontrini(DataOra, Prezzo, Tavolo) 
		value (var_dataOra, var_prezzo, var_tavolo);
        
    commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure visualizza_entrata_giornaliera
-- -----------------------------------------------------

USE `pizzeriaDB`;
DROP procedure IF EXISTS `pizzeriaDB`.`visualizza_entrata_giornaliera`;

DELIMITER $$
USE `pizzeriaDB`$$
CREATE PROCEDURE `visualizza_entrata_giornaliera` (in var_giorno date, out var_entrata_giornaliera decimal(8,2))
BEGIN     
	SELECT 
		CASE
			WHEN SUM(Prezzo) IS NULL THEN 0
			ELSE SUM(Prezzo)
		END
	FROM Scontrini
	WHERE DATE(DataOra) = var_giorno AND Pagato = 1
    INTO var_entrata_giornaliera;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure visualizza_entrata_mensile
-- -----------------------------------------------------

USE `pizzeriaDB`;
DROP procedure IF EXISTS `pizzeriaDB`.`visualizza_entrata_mensile`;

DELIMITER $$
USE `pizzeriaDB`$$
CREATE PROCEDURE `visualizza_entrata_mensile` (in var_anno year, in var_mese int, out var_entrata_mensile decimal(9,2))
BEGIN   
	SELECT 
		CASE
			WHEN SUM(Prezzo) IS NULL THEN 0
			ELSE SUM(Prezzo)
		END
	FROM Scontrini
	WHERE YEAR(DataOra) = var_anno 
		AND MONTH(DataOra) = var_mese 
        AND Pagato = 1
    INTO var_entrata_mensile;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure associa_cameriere_tavolo
-- -----------------------------------------------------

USE `pizzeriaDB`;
DROP procedure IF EXISTS `pizzeriaDB`.`associa_cameriere_tavolo`;

DELIMITER $$
USE `pizzeriaDB`$$
CREATE PROCEDURE `associa_cameriere_tavolo` (in var_tavolo int unsigned, in var_nomeC varchar(45), in var_cognomeC varchar(45))
BEGIN
	declare exit handler for sqlexception
	begin
		rollback;	
		resignal;	
	end;
	set transaction isolation level serializable; 
	start transaction;

	if not exists (select * from Tavoli where NumeroTavolo = var_tavolo) then 
		signal sqlstate '45011' set message_text = 'tavolo non presente nel sistema';
        
	elseif not exists (select * from Camerieri where Nome = var_nomeC and Cognome = var_cognomeC) then 
		signal sqlstate '45011' set message_text = 'cameriere non presente nel sistema';		
	end if;
    
	UPDATE Tavoli 
	SET NomeC = var_nomeC, CognomeC = var_cognomeC
	WHERE NumeroTavolo = var_tavolo;
    
    commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure togli_cameriere_tavolo
-- -----------------------------------------------------

USE `pizzeriaDB`;
DROP procedure IF EXISTS `pizzeriaDB`.`togli_cameriere_tavolo`;

DELIMITER $$
USE `pizzeriaDB`$$
CREATE PROCEDURE `togli_cameriere_tavolo` (in var_tavolo int unsigned, in var_nomeC varchar(45), in var_cognomeC varchar(45))
BEGIN
	declare exit handler for sqlexception
	begin
		rollback;	
		resignal;	
	end;
	set transaction isolation level serializable; 
	start transaction;
    
	if not exists (select * from Tavoli where NumeroTavolo = var_tavolo) then 
		signal sqlstate '45022' set message_text = 'tavolo non presente nel sistema';
	elseif not exists (select * from Camerieri where Nome = var_nomeC and Cognome = var_cognomeC) then 
		signal sqlstate '45022' set message_text = 'cameriere non presente nel sistema';		
	elseif not exists (select * from Tavoli where NumeroTavolo = var_tavolo and NomeC = var_nomeC and CognomeC = var_cognomeC) then
			signal sqlstate '45022' set message_text = 'questo cameriere non era associato a questo tavolo';
	end if;
    
	UPDATE Tavoli 
	SET NomeC = NULL, CognomeC = NULL
	WHERE NumeroTavolo = var_tavolo
		AND NomeC = var_nomeC
		AND CognomeC = var_cognomeC;
	commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure registra_pagamento_scontrino
-- -----------------------------------------------------

USE `pizzeriaDB`;
DROP procedure IF EXISTS `pizzeriaDB`.`registra_pagamento_scontrino`;

DELIMITER $$
USE `pizzeriaDB`$$
CREATE PROCEDURE `registra_pagamento_scontrino` (in var_scontrino datetime)
BEGIN    
	declare var_pagato tinyint(1);
    
	declare exit handler for sqlexception
	begin
		rollback;		
		resignal;		
	end;
	set transaction isolation level serializable; 
	start transaction;

	SELECT Pagato 
    FROM Scontrini 
    WHERE DataOra = var_scontrino 
    INTO var_pagato;
    
    if (var_pagato = 1) or var_pagato is null then 
		signal sqlstate '45016' set message_text = 'non esiste uno scontrino da pagare per questo tavolo';
	end if;
		
	UPDATE Scontrini 
    SET Pagato = 1 
    WHERE DataOra = var_scontrino;
    
    commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure visualizza_tavoli_comande_servite
-- -----------------------------------------------------

USE `pizzeriaDB`;
DROP procedure IF EXISTS `pizzeriaDB`.`visualizza_tavoli_comande_servite`;

DELIMITER $$
USE `pizzeriaDB`$$
CREATE PROCEDURE `visualizza_tavoli_comande_servite` (in var_username varchar(91))
BEGIN
	
	declare exit handler for sqlexception
	begin
		rollback;	
		resignal;	
	end;
	set transaction isolation level serializable; 
    set transaction read only;
	start transaction;
    
	SELECT NumeroTavolo
    FROM Tavoli JOIN Comande ON Tavoli.NumeroTavolo = Comande.Tavolo
    WHERE Comande.Servita = 1
		AND NomeC = TROVA_NOME_UTENTE(var_username)
		AND CognomeC = TROVA_COGNOME_UTENTE(var_username);
        
	commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure registra_comanda
-- -----------------------------------------------------

USE `pizzeriaDB`;
DROP procedure IF EXISTS `pizzeriaDB`.`registra_comanda`;

DELIMITER $$
USE `pizzeriaDB`$$
CREATE PROCEDURE `registra_comanda` (in var_tavolo int unsigned, out var_numeroComanda int unsigned, in var_username varchar(91))
BEGIN
	declare exit handler for sqlexception
    begin
        rollback;
        resignal;
    end;

	set transaction isolation level serializable;
    start transaction;
    
	if (verifica_cameriere(var_username, var_tavolo) = 0 ) then
		signal sqlstate '45015' set message_text = 'non sei il cameriere associato al tavolo quindi non puoi registrare la comanda';	
	end if;
    
    insert into Comande(Tavolo) 
		value (var_tavolo);
        
	commit;
    
    set var_numeroComanda = last_insert_id();
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure visualizza_cosa_e_dove_servire
-- -----------------------------------------------------

USE `pizzeriaDB`;
DROP procedure IF EXISTS `pizzeriaDB`.`visualizza_cosa_e_dove_servire`;

DELIMITER $$
USE `pizzeriaDB`$$
CREATE PROCEDURE `visualizza_cosa_e_dove_servire`(in var_username varchar(91))
BEGIN
	declare done int default false;
	declare var_comanda int unsigned;
    declare cur cursor for
			SELECT DISTINCT Comanda
			FROM cosa_servire;
	declare exit handler for sqlexception
    begin
		rollback;	
        resignal;	
	end;
	declare continue handler for not found set done = true;
	
    set transaction isolation level repeatable read;
    set transaction read only;
    start transaction;
        
	SELECT Numero, Tavolo
	FROM Comande
	WHERE Numero IN (SELECT Comanda
					 FROM cosa_servire);
            
	open cur;
	set done = false;
	read_loop: loop
		fetch cur into var_comanda;
		if done then
			leave read_loop;
		end if;
        
		SELECT Id, NomeProdotto
		FROM cosa_servire
		WHERE Comanda = var_comanda;
	end loop;
    close cur;
commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure ordina_pizza
-- -----------------------------------------------------

USE `pizzeriaDB`;
DROP procedure IF EXISTS `pizzeriaDB`.`ordina_pizza`;

DELIMITER $$
USE `pizzeriaDB`$$
CREATE PROCEDURE `ordina_pizza` (in var_pizza varchar(45), in var_comanda int unsigned, in var_username varchar(91), out var_idPizza int unsigned)
BEGIN	
    declare exit handler for sqlexception
	begin
		rollback;
		resignal;	
	end;
	set transaction isolation level read committed; 
	start transaction;
    
    if(verifica_cameriere_ordinazione(var_username, var_comanda) = 0) then
		signal sqlstate '45014' set message_text = 'non sei il cameriere associato al tavolo quindi non puoi prendere ordinazioni per questa comanda';
	end if;
    
	SELECT 
		CASE
			WHEN MAX(Id) IS NULL THEN 1
			ELSE MAX(id) + 1
		END
	FROM Pizze_effettive
	WHERE Comanda = var_comanda INTO var_idPizza;
    
    insert into Pizze_effettive(Id, NomePizza, Comanda) 
		values (var_idPizza, var_pizza, var_comanda);
	    
    commit;    
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure inserisci_aggiunta_pizza
-- -----------------------------------------------------

USE `pizzeriaDB`;
DROP procedure IF EXISTS `pizzeriaDB`.`inserisci_aggiunta_pizza`;

DELIMITER $$
USE `pizzeriaDB`$$
CREATE PROCEDURE `inserisci_aggiunta_pizza` (in var_idPizza int unsigned, in var_comanda int unsigned, in var_ingrediente varchar(45))
BEGIN
	declare exit handler for sqlexception
	begin
		rollback;		
		resignal;		
	end;
	set transaction isolation level read committed; 
	start transaction;
    
	insert into Aggiunte 
		values (var_idPizza, var_comanda, var_ingrediente);

    commit;    
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure ordina_bevanda
-- -----------------------------------------------------

USE `pizzeriaDB`;
DROP procedure IF EXISTS `pizzeriaDB`.`ordina_bevanda`;

DELIMITER $$
USE `pizzeriaDB`$$
CREATE PROCEDURE `ordina_bevanda` (in var_bevanda varchar(45), in var_comanda int unsigned, in var_username varchar(91))
BEGIN
    declare var_idBevanda int unsigned;
    
	declare exit handler for sqlexception
	begin
		rollback;		
		resignal;		
	end;
    
    set transaction isolation level read committed; 
	start transaction;
    
    if(verifica_cameriere_ordinazione(var_username, var_comanda) = 0) then
		signal sqlstate '45013' set message_text = 'non sei il cameriere associato al tavolo quindi non puoi prendere ordinazioni per questa comanda';
	end if;
    
	SELECT 
		CASE 
			WHEN MAX(Id) IS NULL THEN 1
			ELSE MAX(id) + 1
		END
	FROM Bevande_effettive
	WHERE Comanda = var_comanda INTO var_idBevanda;
    
    insert into Bevande_effettive(Id, NomeBevanda, Comanda) 
		values (var_idBevanda, var_bevanda, var_comanda);
    
    commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure segna_pizza_ordinata
-- -----------------------------------------------------

USE `pizzeriaDB`;
DROP procedure IF EXISTS `pizzeriaDB`.`segna_pizza_ordinata`;

DELIMITER $$
USE `pizzeriaDB`$$
CREATE PROCEDURE `segna_pizza_ordinata` (in var_idPizza int unsigned, in var_comanda int unsigned)
BEGIN
	UPDATE Pizze_effettive 
	SET Stato = 0
	WHERE Id = var_idPizza
		AND Comanda = var_comanda;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure segna_pizza_servita
-- -----------------------------------------------------

USE `pizzeriaDB`;
DROP procedure IF EXISTS `pizzeriaDB`.`segna_pizza_servita`;

DELIMITER $$
USE `pizzeriaDB`$$
CREATE PROCEDURE `segna_pizza_servita` (in var_idPizza int unsigned, in var_comanda int unsigned, in var_username varchar(91))
BEGIN
	declare exit handler for sqlexception
	begin
		rollback;		
		resignal;		
	end;
	set transaction isolation level repeatable read; 
	start transaction;
    
   	if(verifica_cameriere_ordinazione(var_username, var_comanda) = 0) then
		signal sqlstate '45020' set message_text = 'non sei il cameriere associato al tavolo quindi non puoi apportare quetsa modifica allo stato della pizza';
	end if;
    
	if not exists (select * from Pizze_effettive where Id = var_idPizza and Comanda = var_comanda) then
		signal sqlstate '45020' set message_text = 'non esiste questa pizza in questa comanda';
	end if;
    
	UPDATE Pizze_effettive 
	SET Stato = 3
	WHERE Id = var_idPizza
		AND Comanda = var_comanda;

    commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure segna_bevanda_servita
-- -----------------------------------------------------

USE `pizzeriaDB`;
DROP procedure IF EXISTS `pizzeriaDB`.`segna_bevanda_servita`;

DELIMITER $$
USE `pizzeriaDB`$$
CREATE PROCEDURE `segna_bevanda_servita` (in var_idBevanda int unsigned, in var_comanda int unsigned, in var_username varchar(91))
BEGIN
	declare exit handler for sqlexception
	begin
		rollback;		
		resignal;		
	end;
	set transaction isolation level repeatable read; 
	start transaction;
    
	if(verifica_cameriere_ordinazione(var_username, var_comanda) = 0) then
		signal sqlstate '45018' set message_text = 'non sei il cameriere associato al tavolo quindi non puoi apportare quetsa modifica allo stato della pizza';
	end if;
    
	if not exists (select * from Bevande_effettive where Id = var_idBevanda and Comanda = var_comanda) then
		signal sqlstate '45018' set message_text = 'non esiste questa bevanda in questa comanda';
	end if;
    
	UPDATE Bevande_effettive 
	SET Stato = 3
	WHERE Id = var_idBevanda
		AND Comanda = var_comanda;

    commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure visualizza_pizze_da_preparare
-- -----------------------------------------------------

USE `pizzeriaDB`;
DROP procedure IF EXISTS `pizzeriaDB`.`visualizza_pizze_da_preparare`;

DELIMITER $$
USE `pizzeriaDB`$$
CREATE PROCEDURE `visualizza_pizze_da_preparare`()
BEGIN
	declare done int default false;

	declare var_comanda int unsigned;
	declare var_idPizza int unsigned;
    
	declare cur cursor for
			SELECT Comanda,	Id
			FROM Pizze_effettive 
			WHERE Stato = 0  
			ORDER BY Comanda, Id;
		
	declare exit handler for sqlexception
	begin
		rollback;	
		resignal;	
	end;
    
	declare continue handler for not found set done = true;
	
	set transaction isolation level repeatable read;
	start transaction;

	SELECT Comanda,	Id, NomePizza
	FROM Pizze_effettive 
	WHERE Stato = 0  
	ORDER BY Comanda, Id;
        
	open cur;
    set done = false;
	read_loop: loop
		fetch cur into var_comanda, var_idPizza;
		if done then
			leave read_loop;
		end if;

		SELECT Ingrediente
		FROM Aggiunte
		WHERE Comanda = var_comanda AND IdPizza = var_idPizza;
	end loop;
	close cur;
    
	open cur;
    set done = false;
	read_loop: loop
		fetch cur into var_comanda, var_idPizza;
		if done then
			leave read_loop;
		end if;
    		UPDATE Pizze_effettive 
			SET Stato = 1
			WHERE Id = var_idPizza AND Comanda = var_comanda;
	end loop;
	close cur;
commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure segna_pizza_pronta
-- -----------------------------------------------------

USE `pizzeriaDB`;
DROP procedure IF EXISTS `pizzeriaDB`.`segna_pizza_pronta`;

DELIMITER $$
USE `pizzeriaDB`$$
CREATE PROCEDURE `segna_pizza_pronta` (in var_idPizza int unsigned, in var_comanda int unsigned)
BEGIN
	declare exit handler for sqlexception
	begin
		rollback;
		resignal; 
	end;
	set transaction isolation level repeatable read; 
	start transaction;
    
	if not exists (select * from Pizze_effettive where Id = var_idPizza and Comanda = var_comanda) then
		signal sqlstate '45019' set message_text = 'non esiste questa pizza in questa comanda';
	end if;
    
	UPDATE Pizze_effettive 
	SET Stato = 2
	WHERE Id = var_idPizza
		AND Comanda = var_comanda;
        
	commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure visualizza_bevande_da_preparare
-- -----------------------------------------------------

USE `pizzeriaDB`;
DROP procedure IF EXISTS `pizzeriaDB`.`visualizza_bevande_da_preparare`;

DELIMITER $$
USE `pizzeriaDB`$$
CREATE PROCEDURE `visualizza_bevande_da_preparare`()
BEGIN
	declare done int default false;
    
	declare var_comanda int unsigned;
	declare var_idBevanda int unsigned;
	
    declare cur cursor for		
		SELECT Comanda, Id
		FROM Bevande_effettive
		WHERE Stato = 0
		ORDER BY Comanda;
        
	declare exit handler for sqlexception
	begin
		rollback;	
		resignal;	
	end;
    
	declare continue handler for not found set done = true;
	
	set transaction isolation level repeatable read;
	start transaction;

    SELECT Comanda, Id, NomeBevanda
	FROM Bevande_effettive
	WHERE Stato = 0
	ORDER BY Comanda;

	open cur;
	read_loop: loop
		fetch cur into var_comanda, var_idBevanda;
		if done then
			leave read_loop;
		end if;
		UPDATE Bevande_effettive
		SET Stato = 1
		WHERE Id = var_idBevanda AND Comanda = var_comanda;
	end loop;
	close cur;
commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure segna_bevanda_pronta
-- -----------------------------------------------------

USE `pizzeriaDB`;
DROP procedure IF EXISTS `pizzeriaDB`.`segna_bevanda_pronta`;

DELIMITER $$
USE `pizzeriaDB`$$
CREATE PROCEDURE `segna_bevanda_pronta` (in var_idBevanda int unsigned, in var_comanda int unsigned)
BEGIN
	declare exit handler for sqlexception
	begin
		rollback;		
		resignal;		
	end;
	set transaction isolation level read committed; 
	start transaction;
    
	if not exists (select * from Bevande_effettive where Id = var_idBevanda and Comanda = var_comanda) then
		signal sqlstate '45017' set message_text = 'non esiste questa bevanda in questa comanda';
	end if;
    
	UPDATE Bevande_effettive 
	SET Stato = 2
	WHERE Id = var_idBevanda
		AND Comanda = var_comanda;
        
	commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function verifica_cameriere
-- -----------------------------------------------------

USE `pizzeriaDB`;
DROP function IF EXISTS `pizzeriaDB`.`verifica_cameriere`;

DELIMITER $$
USE `pizzeriaDB`$$
CREATE FUNCTION `verifica_cameriere` (username varchar(91), tavolo int unsigned) 
RETURNS TINYINT(1)
BEGIN
	declare var_nomeUtente varchar(45);
	declare var_cognomeUtente varchar(45);
	declare var_nomeC varchar(45);       
    declare var_cognomeC varchar(45);
	set var_nomeUtente = trova_nome_utente(username);
	set var_cognomeUtente = trova_cognome_utente(username);
	
    SELECT NomeC, CognomeC
	FROM Tavoli
	WHERE NumeroTavolo = tavolo
    INTO var_nomeC, var_cognomeC;
    
	if (var_nomeUtente, var_cognomeUtente) <> (var_nomeC, var_cognomeC) or (var_nomeC is null and var_cognomeC is null) then
		return 0;
	else
		return 1;
	end if;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function verifica_cameriere_ordinazione
-- -----------------------------------------------------

USE `pizzeriaDB`;
DROP function IF EXISTS `pizzeriaDB`.`verifica_cameriere_ordinazione`;

DELIMITER $$
USE `pizzeriaDB`$$
CREATE FUNCTION `verifica_cameriere_ordinazione` (username varchar(91), comanda int unsigned) 
RETURNS TINYINT(1)
BEGIN
	declare var_nomeUtente varchar(45);
	declare var_cognomeUtente varchar(45);
	
	set var_nomeUtente = trova_nome_utente(username);
    set var_cognomeUtente = trova_cognome_utente(username);
			
	if (var_nomeUtente, var_cognomeUtente) <> (SELECT NomeC, CognomeC
												FROM Tavoli JOIN Comande 
													ON Tavoli.NumeroTavolo = Comande.Tavolo
												WHERE Comande.Numero = comanda) then 
		return 0;
	else
		return 1;
	end if;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure inserisci_cameriere
-- -----------------------------------------------------

USE `pizzeriaDB`;
DROP procedure IF EXISTS `pizzeriaDB`.`inserisci_cameriere`;

DELIMITER $$
USE `pizzeriaDB`$$
CREATE PROCEDURE `inserisci_cameriere` (in var_nomeC varchar(45), in var_cognomeC varchar(45))
BEGIN
	insert into Camerieri 
		values (var_nomeC, var_cognomeC);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure inserisci_tavolo
-- -----------------------------------------------------

USE `pizzeriaDB`;
DROP procedure IF EXISTS `pizzeriaDB`.`inserisci_tavolo`;

DELIMITER $$
USE `pizzeriaDB`$$
CREATE PROCEDURE `inserisci_tavolo` (in var_numeroTavolo int unsigned, in var_numeroPosti int unsigned)
BEGIN
	insert into Tavoli(NumeroTavolo, NumeroPosti) 
		values (var_numeroTavolo, var_numeroPosti);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure cancella_turno_cameriere
-- -----------------------------------------------------

USE `pizzeriaDB`;
DROP procedure IF EXISTS `pizzeriaDB`.`cancella_turno_cameriere`;

DELIMITER $$
USE `pizzeriaDB`$$
CREATE PROCEDURE `cancella_turno_cameriere` (in var_nomeC varchar(45), in var_cognomeC varchar(45), in var_turno varchar(45), in var_data date)
BEGIN
	if exists (SELECT *
				FROM Turni_Camerieri
				WHERE NomeC = var_nomeC
					AND CognomeC = var_cognomeC
					AND Turno = var_turno
					AND Data = var_data) then
                    
		DELETE FROM Turni_Camerieri 
		WHERE NomeC = var_nomeC
			AND CognomeC = var_cognomeC
			AND Turno = var_turno
			AND Data = var_data;
	else 
		signal sqlstate '45012' set message_text = 'Non esiste questo turno tra i turni dei camerieri';
	end if;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- View `pizzeriaDB`.`tavoli_da_assegnare_a_clienti`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `pizzeriaDB`.`tavoli_da_assegnare_a_clienti` ;
USE `pizzeriaDB`;
CREATE  OR REPLACE VIEW `tavoli_da_assegnare_a_clienti` AS
    SELECT 
        NumeroTavolo AS NumTavolo,
		NumeroPosti AS NumPosti
    FROM
        Tavoli
    WHERE
        Disponibilita = 1
		AND pizzeriaDB.Tavoli.NumeroTavolo IN (
				SELECT Tavolo
				FROM Turni_Tavoli JOIN Turni 
					ON Turni_Tavoli.Turno = Turni.Nome
				WHERE
					curtime() BETWEEN OraInizio AND OraFine);

-- -----------------------------------------------------
-- View `pizzeriaDB`.`cosa_servire`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `pizzeriaDB`.`cosa_servire` ;
USE `pizzeriaDB`;
CREATE  OR REPLACE VIEW `cosa_servire` AS

	SELECT Comanda, Id, NomePizza AS NomeProdotto
	FROM Pizze_effettive
	WHERE Stato = 2 
    
	UNION 
	
    SELECT Comanda, Id, NomeBevanda AS NomeProdotto
	FROM Bevande_effettive
	WHERE Stato = 2;
USE `pizzeriaDB`;

DELIMITER $$

USE `pizzeriaDB`$$
DROP TRIGGER IF EXISTS `pizzeriaDB`.`ore_di_lavoro` $$
USE `pizzeriaDB`$$
CREATE DEFINER = CURRENT_USER TRIGGER `pizzeriaDB`.`ore_di_lavoro` BEFORE INSERT ON `Turni` FOR EACH ROW
BEGIN
	if new.OraFine > new.OraInizio + interval 8 hour then
		signal sqlstate '45007' set message_text = 'Gli orari inseriti non sono validi, i turni devono essere al massimo di 8 ore';
	end if;
END$$


USE `pizzeriaDB`$$
DROP TRIGGER IF EXISTS `pizzeriaDB`.`modifica_cameriere` $$
USE `pizzeriaDB`$$
CREATE DEFINER = CURRENT_USER TRIGGER `pizzeriaDB`.`modifica_cameriere` BEFORE UPDATE ON `Tavoli` FOR EACH ROW
BEGIN
	if old.Disponibilita = new.Disponibilita then
		if exists (
			SELECT *
			FROM Comande
			WHERE Tavolo = new.NumeroTavolo) then
        
			signal sqlstate '45006' set message_text = 'sono presenti comande attive per questo tavolo';
        
		elseif exists (
				SELECT *
				FROM Scontrini
				WHERE Tavolo = new.NumeroTavolo AND Pagato = 0) then

			signal sqlstate '45006' set message_text = 'deve ancora essere pagato lo scontrino per questo tavolo';
		
        elseif new.NomeC is not null AND new.CognomeC is not null then 
			if not exists (
				SELECT *
				FROM Turni_Camerieri INNER JOIN Turni ON Turni_Camerieri.Turno = Turni.Nome 
				WHERE NomeC = new.NomeC AND CognomeC = new.CognomeC
					AND current_date = Turni_Camerieri.Data 
					AND current_time between Turni.OraInizio AND Turni.OraFine ) then 
				signal sqlstate '45006' set message_text = 'cameriere non di turno';
		
			elseif not exists (
				SELECT *
				FROM Turni_Tavoli INNER JOIN Turni ON Turni_Tavoli.Turno = Turni.Nome 
				WHERE Tavolo = new.NumeroTavolo 
					AND current_date = Turni_Tavoli.Data 
					AND current_time between Turni.OraInizio AND Turni.OraFine) then 
				signal sqlstate '45006' set message_text = 'tavolo non in uso';
			end if;
		end if;
	end if;
END$$


USE `pizzeriaDB`$$
DROP TRIGGER IF EXISTS `pizzeriaDB`.`nuova_comanda` $$
USE `pizzeriaDB`$$
CREATE DEFINER = CURRENT_USER TRIGGER `pizzeriaDB`.`nuova_comanda` BEFORE INSERT ON `Comande` FOR EACH ROW
BEGIN
	if not exists (
				SELECT *
				FROM Clienti
				WHERE Tavolo = new.Tavolo) then
		signal sqlstate '45002' set message_text = 'tavolo non assegnato ad alcun cliente';
	end if;
END$$


USE `pizzeriaDB`$$
DROP TRIGGER IF EXISTS `pizzeriaDB`.`comanda_servita` $$
USE `pizzeriaDB`$$
CREATE DEFINER = CURRENT_USER TRIGGER `pizzeriaDB`.`comanda_servita` BEFORE INSERT ON `Scontrini` FOR EACH ROW
BEGIN
	declare var_servita tinyint(1);
    declare msg varchar(100);
    
	SELECT Servita
	FROM Comande
	WHERE Tavolo = new.Tavolo INTO var_servita;
    
    if var_servita = 0 then 
		set msg = concat('comanda ancora attiva, impossibile stampare lo scontrino del tavolo: ', new.Tavolo);
		signal sqlstate '45004' set message_text = msg;
    end if;
END$$


USE `pizzeriaDB`$$
DROP TRIGGER IF EXISTS `pizzeriaDB`.`cancellazione_comanda` $$
USE `pizzeriaDB`$$
CREATE DEFINER = CURRENT_USER TRIGGER `pizzeriaDB`.`cancellazione_comanda` AFTER INSERT ON `Scontrini` FOR EACH ROW
BEGIN
   	delete from Comande where Tavolo = new.Tavolo;
END$$


USE `pizzeriaDB`$$
DROP TRIGGER IF EXISTS `pizzeriaDB`.`scontrini_da_pagare` $$
USE `pizzeriaDB`$$
CREATE DEFINER = CURRENT_USER TRIGGER `pizzeriaDB`.`scontrini_da_pagare` BEFORE UPDATE ON `Scontrini` FOR EACH ROW
BEGIN
	if (SELECT Pagato
		FROM Scontrini
		WHERE DataOra = new.DataOra) then
        
		signal sqlstate '45005' set message_text = "Lo stato di questo scontrino e': PAGATO";
	end if;
END$$


USE `pizzeriaDB`$$
DROP TRIGGER IF EXISTS `pizzeriaDB`.`pagamento_scontrino` $$
USE `pizzeriaDB`$$
CREATE DEFINER = CURRENT_USER TRIGGER `pizzeriaDB`.`pagamento_scontrino` AFTER UPDATE ON `Scontrini` FOR EACH ROW
BEGIN
	if not exists (
				SELECT *
				FROM Scontrini
				WHERE Tavolo = new.Tavolo AND Pagato = 0) 
			and not exists (
				SELECT *
				FROM Comande
				WHERE Tavolo = new.Tavolo) then
                
		delete from Clienti where Tavolo = new.Tavolo;  

		UPDATE Tavoli 
		SET Disponibilita = 1 
		WHERE NumeroTavolo = new.Tavolo;
		
		if not exists (	SELECT *
						FROM Turni_Camerieri INNER JOIN Turni ON Turno = Nome
						WHERE Data = CURDATE()
							AND CURTIME() BETWEEN OraInizio AND OraFine
							AND (NomeC, CognomeC) = (
									SELECT NomeC, CognomeC
									FROM Tavoli
									WHERE NumeroTavolo = new.Tavolo)) then
				UPDATE Tavoli 
				SET NomeC = NULL, CognomeC = NULL
				WHERE NumeroTavolo = new.Tavolo;
		end if;
	end if;
END$$


USE `pizzeriaDB`$$
DROP TRIGGER IF EXISTS `pizzeriaDB`.`decremento_ingredienti_c` $$
USE `pizzeriaDB`$$
CREATE DEFINER = CURRENT_USER TRIGGER `pizzeriaDB`.`decremento_ingredienti_c` BEFORE INSERT ON `Pizze_effettive` FOR EACH ROW
BEGIN
    UPDATE Ingredienti 
	SET Quantita = Quantita - 1
	WHERE Nome IN ( 
					SELECT Ingrediente
					FROM Condimenti
					WHERE Pizza = new.NomePizza);
END$$


USE `pizzeriaDB`$$
DROP TRIGGER IF EXISTS `pizzeriaDB`.`aggiornamento_stato_comanda_p` $$
USE `pizzeriaDB`$$
CREATE DEFINER = CURRENT_USER TRIGGER `pizzeriaDB`.`aggiornamento_stato_comanda_p` AFTER INSERT ON `Pizze_effettive` FOR EACH ROW
BEGIN
	UPDATE Comande 
	SET Prezzo = Prezzo + (select Prezzo from Pizze where Nome = new.NomePizza)
	WHERE Numero = new.Comanda;
        
    if (SELECT Servita
		FROM Comande
		WHERE Numero = new.Comanda) then
            
		UPDATE Comande 
		SET Servita = 0
		WHERE Numero = new.Comanda;
        
	end if;
END$$


USE `pizzeriaDB`$$
DROP TRIGGER IF EXISTS `pizzeriaDB`.`verifica_stato_pizza` $$
USE `pizzeriaDB`$$
CREATE DEFINER = CURRENT_USER TRIGGER `pizzeriaDB`.`verifica_stato_pizza` BEFORE UPDATE ON `Pizze_effettive` FOR EACH ROW
BEGIN
    if new.Stato = 0 and old.Stato is not null then
		signal sqlstate '45003' set message_text = 'solo pizze in fase di ordinazione possono essere portate allo stato ORDINATA';
	elseif new.Stato = 1 and (old.Stato <> 0 or old.Stato is null) then 
		signal sqlstate '45003' set message_text = 'solo pizze nello stato ORDINATA possono essere portate allo stato IN PRPEARAZIONE ';  
	elseif new.Stato = 2 and  (old.Stato <> 1 or old.Stato is null) then 
		signal sqlstate '45003' set message_text = 'solo pizze nello stato IN PREPARAZIONE possono essere portate allo stato PRONTA'; 
	elseif new.Stato = 3 and  (old.Stato <> 2 or old.Stato is null) then 
		signal sqlstate '45003' set message_text = 'solo pizze nello stato PRONTA possono essere portate allo stato SERVITA '; 
	end if;
END$$


USE `pizzeriaDB`$$
DROP TRIGGER IF EXISTS `pizzeriaDB`.`verifica_stato_comanda_p` $$
USE `pizzeriaDB`$$
CREATE DEFINER = CURRENT_USER TRIGGER `pizzeriaDB`.`verifica_stato_comanda_p` AFTER UPDATE ON `Pizze_effettive` FOR EACH ROW
BEGIN
	if new.Stato = 3 then
		if not exists (select * from Pizze_effettive where Comanda = new.Comanda and Stato != 3)
				and not exists (select * from Bevande_effettive where Comanda = new.Comanda and Stato != 3) then
			update Comande set Servita = 1 where Numero = new.Comanda;
		end if;
	end if;
END$$


USE `pizzeriaDB`$$
DROP TRIGGER IF EXISTS `pizzeriaDB`.`decremento_bevanda` $$
USE `pizzeriaDB`$$
CREATE DEFINER = CURRENT_USER TRIGGER `pizzeriaDB`.`decremento_bevanda` BEFORE INSERT ON `Bevande_effettive` FOR EACH ROW
BEGIN
	UPDATE Bevande 
	SET Quantita = Quantita-1
	WHERE Nome = new.NomeBevanda;
END$$


USE `pizzeriaDB`$$
DROP TRIGGER IF EXISTS `pizzeriaDB`.`aggiorna_stato_comanda_b` $$
USE `pizzeriaDB`$$
CREATE DEFINER = CURRENT_USER TRIGGER `pizzeriaDB`.`aggiorna_stato_comanda_b` AFTER INSERT ON `Bevande_effettive` FOR EACH ROW
BEGIN
	UPDATE Comande 
	SET Prezzo = Prezzo + (select Prezzo from Bevande where Nome = new.NomeBevanda)
	WHERE Numero = new.Comanda;
        
    if (SELECT Servita
		FROM Comande
		WHERE Numero = new.Comanda) then
            
		UPDATE Comande 
		SET Servita = 0
		WHERE Numero = new.Comanda;
        
	end if;
END$$


USE `pizzeriaDB`$$
DROP TRIGGER IF EXISTS `pizzeriaDB`.`verifica_stato_bevanda` $$
USE `pizzeriaDB`$$
CREATE DEFINER = CURRENT_USER TRIGGER `pizzeriaDB`.`verifica_stato_bevanda` BEFORE UPDATE ON `Bevande_effettive` FOR EACH ROW
BEGIN
	if new.Stato = 1 and old.Stato <> 0 then 
		signal sqlstate '45001' set message_text = 'solo bevande nello stato ORDINATA possono essere portate allo stato IN PREPARAZIONE ';  
	elseif new.Stato = 2 and  old.Stato <> 1 then 
		signal sqlstate '45001' set message_text = 'solo bevande nello stato IN PREPARAZIONE possono essere portate allo stato PRONTA '; 
    elseif new.Stato = 3 and  old.Stato <> 2 then 
		signal sqlstate '45001' set message_text = 'solo bevande nello stato PRONTA possono essere portate allo stato SERVITA '; 
	end if;
END$$


USE `pizzeriaDB`$$
DROP TRIGGER IF EXISTS `pizzeriaDB`.`verifica_stato_comanda_b` $$
USE `pizzeriaDB`$$
CREATE DEFINER = CURRENT_USER TRIGGER `pizzeriaDB`.`verifica_stato_comanda_b` AFTER UPDATE ON `Bevande_effettive` FOR EACH ROW
BEGIN
	if new.Stato = 3 then
		if not exists (select * from Pizze_effettive where Comanda = new.Comanda and Stato != 3)
				and not exists (select * from Bevande_effettive where Comanda = new.Comanda and Stato != 3) then
			update Comande set Servita = 1 where Numero = new.Comanda;
		end if;
	end if;
END$$


USE `pizzeriaDB`$$
DROP TRIGGER IF EXISTS `pizzeriaDB`.`aggiorna_disponibilita_tavolo` $$
USE `pizzeriaDB`$$
CREATE DEFINER = CURRENT_USER TRIGGER `pizzeriaDB`.`aggiorna_disponibilita_tavolo` AFTER INSERT ON `Clienti` FOR EACH ROW
BEGIN
	UPDATE Tavoli 
	SET Disponibilita = 0
	WHERE NumeroTavolo = new.Tavolo;
END$$


USE `pizzeriaDB`$$
DROP TRIGGER IF EXISTS `pizzeriaDB`.`verifica_fase_ordinazione` $$
USE `pizzeriaDB`$$
CREATE DEFINER = CURRENT_USER TRIGGER `pizzeriaDB`.`verifica_fase_ordinazione` BEFORE INSERT ON `Aggiunte` FOR EACH ROW
BEGIN
	if (SELECT Stato
		FROM Pizze_effettive
		WHERE Id = new.IdPizza
			AND Comanda = new.Comanda) is not null then
		signal sqlstate '45000' set message_text = 'pizza non in fase di ordinazione';
	end if;
END$$


USE `pizzeriaDB`$$
DROP TRIGGER IF EXISTS `pizzeriaDB`.`decremento_ingrediente_a` $$
USE `pizzeriaDB`$$
CREATE DEFINER = CURRENT_USER TRIGGER `pizzeriaDB`.`decremento_ingrediente_a` BEFORE INSERT ON `Aggiunte` FOR EACH ROW
BEGIN
	UPDATE Ingredienti 
	SET Quantita = Quantita-1
	WHERE Nome = new.Ingrediente;
END$$


USE `pizzeriaDB`$$
DROP TRIGGER IF EXISTS `pizzeriaDB`.`aggiorna_stato_comanda_a` $$
USE `pizzeriaDB`$$
CREATE DEFINER = CURRENT_USER TRIGGER `pizzeriaDB`.`aggiorna_stato_comanda_a` AFTER INSERT ON `Aggiunte` FOR EACH ROW
BEGIN
	UPDATE Comande 
	SET Prezzo = Prezzo + (select Prezzo from Ingredienti where Nome = new.Ingrediente)
	WHERE Numero = new.Comanda;
END$$


DELIMITER ;
SET SQL_MODE = '';
DROP USER IF EXISTS Login;
SET SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
CREATE USER 'Login' IDENTIFIED BY 'Login';

GRANT EXECUTE ON procedure `pizzeriaDB`.`login` TO 'Login';
SET SQL_MODE = '';
DROP USER IF EXISTS Manager;
SET SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
CREATE USER 'Manager' IDENTIFIED BY 'Manager';

GRANT EXECUTE ON procedure `pizzeriaDB`.`registra_cliente` TO 'Manager';
GRANT EXECUTE ON procedure `pizzeriaDB`.`crea_turno` TO 'Manager';
GRANT EXECUTE ON procedure `pizzeriaDB`.`crea_turno_cameriere` TO 'Manager';
GRANT EXECUTE ON procedure `pizzeriaDB`.`crea_turno_tavolo` TO 'Manager';
GRANT EXECUTE ON procedure `pizzeriaDB`.`inserisci_pizza_menu` TO 'Manager';
GRANT EXECUTE ON procedure `pizzeriaDB`.`inserisci_ingrediente_menu` TO 'Manager';
GRANT EXECUTE ON procedure `pizzeriaDB`.`inserisci_condimento_pizza` TO 'Manager';
GRANT EXECUTE ON procedure `pizzeriaDB`.`inserisci_bevanda_menu` TO 'Manager';
GRANT EXECUTE ON procedure `pizzeriaDB`.`aggiorna_quantita_ingrediente` TO 'Manager';
GRANT EXECUTE ON procedure `pizzeriaDB`.`aggiorna_quantita_bevanda` TO 'Manager';
GRANT EXECUTE ON procedure `pizzeriaDB`.`stampa_scontrino` TO 'Manager';
GRANT EXECUTE ON procedure `pizzeriaDB`.`visualizza_entrata_giornaliera` TO 'Manager';
GRANT EXECUTE ON procedure `pizzeriaDB`.`visualizza_entrata_mensile` TO 'Manager';
GRANT EXECUTE ON procedure `pizzeriaDB`.`associa_cameriere_tavolo` TO 'Manager';
GRANT EXECUTE ON procedure `pizzeriaDB`.`togli_cameriere_tavolo` TO 'Manager';
GRANT EXECUTE ON procedure `pizzeriaDB`.`registra_pagamento_scontrino` TO 'Manager';
GRANT EXECUTE ON procedure `pizzeriaDB`.`inserisci_cameriere` TO 'Manager';
GRANT EXECUTE ON procedure `pizzeriaDB`.`inserisci_tavolo` TO 'Manager';
GRANT EXECUTE ON procedure `pizzeriaDB`.`cancella_turno_cameriere` TO 'Manager';
SET SQL_MODE = '';
DROP USER IF EXISTS Pizzaiolo;
SET SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
CREATE USER 'Pizzaiolo' IDENTIFIED BY 'Pizzaiolo';

GRANT EXECUTE ON procedure `pizzeriaDB`.`visualizza_pizze_da_preparare` TO 'Pizzaiolo';
GRANT EXECUTE ON procedure `pizzeriaDB`.`segna_pizza_pronta` TO 'Pizzaiolo';
SET SQL_MODE = '';
DROP USER IF EXISTS Barista;
SET SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
CREATE USER 'Barista' IDENTIFIED BY 'Barista';

GRANT EXECUTE ON procedure `pizzeriaDB`.`visualizza_bevande_da_preparare` TO 'Barista';
GRANT EXECUTE ON procedure `pizzeriaDB`.`segna_bevanda_pronta` TO 'Barista';
SET SQL_MODE = '';
DROP USER IF EXISTS Cameriere;
SET SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
CREATE USER 'Cameriere' IDENTIFIED BY 'Cameriere';

GRANT EXECUTE ON procedure `pizzeriaDB`.`visualizza_tavoli_occupati` TO 'Cameriere';
GRANT EXECUTE ON procedure `pizzeriaDB`.`visualizza_tavoli_comande_servite` TO 'Cameriere';
GRANT EXECUTE ON procedure `pizzeriaDB`.`registra_comanda` TO 'Cameriere';
GRANT EXECUTE ON procedure `pizzeriaDB`.`visualizza_cosa_e_dove_servire` TO 'Cameriere';
GRANT EXECUTE ON procedure `pizzeriaDB`.`ordina_pizza` TO 'Cameriere';
GRANT EXECUTE ON procedure `pizzeriaDB`.`inserisci_aggiunta_pizza` TO 'Cameriere';
GRANT EXECUTE ON procedure `pizzeriaDB`.`ordina_bevanda` TO 'Cameriere';
GRANT EXECUTE ON procedure `pizzeriaDB`.`segna_pizza_ordinata` TO 'Cameriere';
GRANT EXECUTE ON procedure `pizzeriaDB`.`segna_pizza_servita` TO 'Cameriere';
GRANT EXECUTE ON procedure `pizzeriaDB`.`segna_bevanda_servita` TO 'Cameriere';

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
