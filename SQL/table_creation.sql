DROP TABLE IF EXISTS ny_property CASCADE;
DROP TABLE IF EXISTS ny_broker CASCADE;
DROP TABLE IF EXISTS location CASCADE;


CREATE TABLE ny_house (
    ID FLOAT,
    BROKERTITLE TEXT,
    TYPE TEXT,
    PRICE INTEGER,
    BEDS INTEGER CHECK (BEDS >= 1),
    BATH FLOAT CHECK (BATH >= 0),
    PROPERTYSQFT FLOAT CHECK (PROPERTYSQFT >= 30),
    ADDRESS TEXT,
    STATE TEXT,
    MAIN_ADDRESS TEXT,
    ADMINISTRATIVE_AREA_LEVEL_2 TEXT,
    LOCALITY TEXT,
    SUBLOCALITY TEXT,
    STREET_NAME TEXT,
    LONG_NAME TEXT,
    FORMATTED_ADDRESS TEXT,
    LATITUDE FLOAT,
    LONGITUDE FLOAT
);


-- Charger les données dans la table ny_house depuis le fichier CSV, a remplacer par votre propre chemin
\COPY ny_house FROM '/home/deux_arn/Bureau/BDspe/database/ny_house_cleaned.csv' WITH CSV HEADER DELIMITER ';';

-- Créer la table ny_broker
CREATE TABLE ny_broker (
    BROKER_ID SERIAL PRIMARY KEY,
    BROKERTITLE TEXT
);

-- Insérer des données dans la table ny_broker depuis la table ny_house
INSERT INTO ny_broker (BROKERTITLE)
SELECT DISTINCT BROKERTITLE FROM ny_house;

-- Créer la table location
CREATE TABLE location (
    LOCATION_ID SERIAL PRIMARY KEY,
    ADDRESS TEXT,
    STATE TEXT,
    MAIN_ADDRESS TEXT,
    ADMINISTRATIVE_AREA_LEVEL_2 TEXT,
    LOCALITY TEXT,
    SUBLOCALITY TEXT,
    STREET_NAME TEXT,
    LONG_NAME TEXT,
    FORMATTED_ADDRESS TEXT,
    LATITUDE FLOAT,
    LONGITUDE FLOAT
);

-- Insérer des données dans la table location depuis la table ny_house
INSERT INTO location (ADDRESS, STATE, MAIN_ADDRESS, ADMINISTRATIVE_AREA_LEVEL_2, LOCALITY, SUBLOCALITY, STREET_NAME, LONG_NAME, FORMATTED_ADDRESS, LATITUDE, LONGITUDE)
SELECT DISTINCT ADDRESS, STATE, MAIN_ADDRESS, ADMINISTRATIVE_AREA_LEVEL_2, LOCALITY, SUBLOCALITY, STREET_NAME, LONG_NAME, FORMATTED_ADDRESS, LATITUDE, LONGITUDE
FROM ny_house;

-- Créer la table ny_property
CREATE TABLE ny_property (
    PROPERTY_ID SERIAL PRIMARY KEY,
    TYPE TEXT,
    PRICE INTEGER,
    BEDS INTEGER CHECK (BEDS >= 1),
    BATH FLOAT CHECK (BATH >= 0),
    PROPERTYSQFT FLOAT CHECK (PROPERTYSQFT >= 30),
    LOCATION_ID INTEGER REFERENCES location(LOCATION_ID),
    BROKER_ID INTEGER REFERENCES ny_broker(BROKER_ID)
);



-- Insérer des données dans la table ny_property depuis la table ny_house
INSERT INTO ny_property (TYPE, PRICE, BEDS, BATH, PROPERTYSQFT, LOCATION_ID, BROKER_ID)
SELECT
    h.TYPE,
    h.PRICE,
    h.BEDS,
    h.BATH,
    h.PROPERTYSQFT,
    l.LOCATION_ID,
    b.BROKER_ID
FROM ny_house h
JOIN ny_broker b ON h.BROKERTITLE = b.BROKERTITLE
JOIN location l ON h.ADDRESS = l.ADDRESS;

CREATE INDEX price_index ON ny_property(PRICE);

DROP TABLE  ny_house;