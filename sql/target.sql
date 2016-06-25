/* MySQL ... LinkMove source */

DROP DATABASE IF EXISTS website;
CREATE DATABASE website DEFAULT CHARACTER SET 'UTF8';

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

ALTER SCHEMA `website`  DEFAULT COLLATE utf8_bin ;

CREATE TABLE IF NOT EXISTS `website`.`w_game` (
  `id` INT(11) NOT NULL COMMENT '',
  `home_team_id` INT(11) NOT NULL COMMENT '',
  `visiting_team_id` INT(11) NOT NULL COMMENT '',
  `date_time` DATETIME NOT NULL COMMENT '',
  `arena` VARCHAR(45) NOT NULL COMMENT '',
  `home_score` INT(11) NOT NULL COMMENT '',
  `away_score` INT(11) NOT NULL COMMENT '',
  PRIMARY KEY (`id`)  COMMENT '',
  INDEX `fk_w_game_w_team_idx` (`home_team_id` ASC)  COMMENT '',
  INDEX `fk_w_game_w_team1_idx` (`visiting_team_id` ASC)  COMMENT '',
  CONSTRAINT `fk_w_game_w_team`
    FOREIGN KEY (`home_team_id`)
    REFERENCES `website`.`w_team` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_w_game_w_team1`
    FOREIGN KEY (`visiting_team_id`)
    REFERENCES `website`.`w_team` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_bin;

CREATE TABLE IF NOT EXISTS `website`.`w_team` (
  `id` INT(11) NOT NULL COMMENT '',
  `name` VARCHAR(45) NOT NULL COMMENT '',
  PRIMARY KEY (`id`)  COMMENT '')
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_bin;

CREATE TABLE IF NOT EXISTS `website`.`w_game_event` (
  `id` INT(11) NOT NULL COMMENT '',
  `game_id` INT(11) NOT NULL COMMENT '',
  `type` VARCHAR(45) NOT NULL COMMENT '',
  `period` INT(11) NOT NULL COMMENT '',
  `time_in_period` VARCHAR(45) NOT NULL COMMENT '',
  PRIMARY KEY (`id`)  COMMENT '',
  INDEX `fk_w_game_event_w_game1_idx` (`game_id` ASC)  COMMENT '',
  CONSTRAINT `fk_w_game_event_w_game1`
    FOREIGN KEY (`game_id`)
    REFERENCES `website`.`w_game` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_bin;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;



