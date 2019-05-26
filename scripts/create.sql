CREATE DATABASE IF NOT EXISTS a_game_of_thrones;
USE a_game_of_thrones

-- Create kingdom
CREATE TABLE IF NOT EXISTS kingdoms (
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  PRIMARY KEY(id)
);

-- Create region
CREATE TABLE IF NOT EXISTS regions (
  id INT NOT NULL AUTO_INCREMENT,
  kingdom_id INT NOT NULL,
  name VARCHAR(255) NOT NULL,
  climate VARCHAR(516),
  stretch INT,
  PRIMARY KEY (id),
  CONSTRAINT fk_region_kingdom FOREIGN KEY (kingdom_id)
  REFERENCES kingdoms(id)
);

-- Create person
CREATE TABLE IF NOT EXISTS people (
  id INT NOT NULL AUTO_INCREMENT,
  mother_id INT,
  father_id INT,
  region_id INT,
  name VARCHAR(255) NOT NULL,
  birth_date DATE,
  death_date DATE,
  is_alive BOOLEAN NOT NULL DEFAULT 1,
  gender CHARACTER NOT NULL,
  biography LONGTEXT,
  PRIMARY KEY(id),
  CONSTRAINT fk_person_mother FOREIGN KEY (mother_id)
  REFERENCES people(id),
  CONSTRAINT fk_person_father FOREIGN KEY (father_id)
  REFERENCES people(id),
  CONSTRAINT fk_person_region FOREIGN KEY (region_id)
  REFERENCES regions(id)
);

-- Create noble
CREATE TABLE IF NOT EXISTS nobles (
  id INT NOT NULL AUTO_INCREMENT,
  person_id INT NOT NULL,
  PRIMARY KEY(id),
  CONSTRAINT fk_noble_person FOREIGN KEY (person_id)
  REFERENCES people(id)
);

CREATE UNIQUE INDEX noble_person
ON nobles(person_id);

-- Create knight
CREATE TABLE IF NOT EXISTS knights (
  id INT NOT NULL AUTO_INCREMENT,
  person_id INT NOT NULL,
  sworn_to INT,
  PRIMARY KEY(id),
  CONSTRAINT fk_knight_person FOREIGN KEY (person_id)
  REFERENCES people(id),
  CONSTRAINT fk_knight_noble FOREIGN KEY (sworn_to)
  REFERENCES nobles(id)
);

CREATE UNIQUE INDEX knight_person
ON knights(person_id);

-- Create house
CREATE TABLE IF NOT EXISTS houses (
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  symbol VARCHAR(255) NOT NULL,
  colors VARCHAR(255) NOT NULL,
  words VARCHAR(255) NOT NULL,
  PRIMARY KEY (id)
);

-- Create inheritance
CREATE TABLE IF NOT EXISTS inheritances (
  noble_id INT NOT NULL,
  house_id INT NOT NULL,
  PRIMARY KEY (noble_id, house_id)
);

-- Create king
CREATE TABLE IF NOT EXISTS kings (
  id INT NOT NULL AUTO_INCREMENT,
  noble_id INT NOT NULL,
  heir_id INT NOT NULL,
  PRIMARY KEY(id),
  CONSTRAINT fk_king_noble FOREIGN KEY (noble_id)
  REFERENCES nobles(id),
  CONSTRAINT fk_king_heir FOREIGN KEY (heir_id)
  REFERENCES nobles(id)
);

CREATE UNIQUE INDEX king_noble
ON kings(noble_id);

-- Create lord
CREATE TABLE IF NOT EXISTS lords (
  id INT NOT NULL AUTO_INCREMENT,
  noble_id INT NOT NULL,
  heir_id INT NOT NULL,
  PRIMARY KEY(id),
  CONSTRAINT fk_lord_noble FOREIGN KEY (noble_id)
  REFERENCES nobles(id),
  CONSTRAINT fk_lord_heir FOREIGN KEY (heir_id)
  REFERENCES nobles(id)
);

CREATE UNIQUE INDEX lord_noble
ON lords(noble_id);

-- Create castle
CREATE TABLE IF NOT EXISTS castles (
  id INT NOT NULL AUTO_INCREMENT,
  region_id INT NOT NULL,
  name VARCHAR(255) NOT NULL,
  towers_number INT NOT NULL DEFAULT 0,
  halls_number INT NOT NULL DEFAULT 0,
  PRIMARY KEY(id),
  CONSTRAINT fk_castle_region FOREIGN KEY (region_id)
  REFERENCES regions(id)
);

CREATE INDEX castle_region
ON castles(region_id);

-- Create lords_castles
CREATE TABLE IF NOT EXISTS lords_castles (
  id INT NOT NULL AUTO_INCREMENT,
  lord_id INT NOT NULL,
  castle_id INT NOT NULL,
  rule_begin_date DATE NOT NULL,
  rule_end_date DATE,
  is_current_ruler BOOLEAN NOT NULL,
  PRIMARY KEY(id),
  CONSTRAINT fk_castle_lord FOREIGN KEY (lord_id)
  REFERENCES lords(id),
  CONSTRAINT fk_lord_castle FOREIGN KEY (castle_id)
  REFERENCES castles(id)
);

CREATE INDEX lord_castle
ON lords_castles(lord_id, castle_id);

-- Create reign
CREATE TABLE IF NOT EXISTS reigns (
  id INT NOT NULL AUTO_INCREMENT,
  king_id INT NOT NULL,
  kingdom_id INT NOT NULL,
  rule_begin_date DATE NOT NULL,
  rule_end_date DATE,
  is_current_ruler BOOLEAN NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk_kingdom_king FOREIGN KEY (king_id)
  REFERENCES kings(id),
  CONSTRAINT fk_king_kingdom FOREIGN KEY (kingdom_id)
  REFERENCES kingdoms(id)
);

-- Create great_lord
CREATE TABLE IF NOT EXISTS great_lords (
  id INT NOT NULL AUTO_INCREMENT,
  lord_id INT NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk_great_lord_lord FOREIGN KEY (lord_id)
  REFERENCES lords(id)
);

CREATE UNIQUE INDEX grat_lord_lord
ON great_lords(lord_id);

-- Create small_lord
CREATE TABLE IF NOT EXISTS small_lords (
  id INT NOT NULL AUTO_INCREMENT,
  lord_id INT NOT NULL,
  sovereign_id INT NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk_small_lord_lord FOREIGN KEY (lord_id)
  REFERENCES lords(id),
  CONSTRAINT fk_small_lord_sovereign FOREIGN KEY (sovereign_id)
  REFERENCES great_lords(id)
);

CREATE UNIQUE INDEX small_lord_lord
ON small_lords(lord_id);

CREATE INDEX small_lord_sovereign
ON small_lords(sovereign_id);
