LOAD CSV WITH HEADERS FROM 'file:///ny_house_cleaned.csv' AS row FIELDTERMINATOR ';'
WITH toInteger(row['ID']) AS propId, toInteger(row['BEDS']) AS beds, toInteger(row['BATH']) AS baths, toFloat(row['PRICE']) AS price, toFloat(row['PROPERTYSQFT']) AS sqft, row['ADDRESS'] AS address
MERGE (p:Property {propId: propId})
  SET p.beds = beds, p.baths = baths, p.price = price, p.sqft = sqft, p.address = address
RETURN count(p);

LOAD CSV WITH HEADERS FROM 'file:///ny_house_cleaned.csv' AS row FIELDTERMINATOR ';'
WITH row['BROKERTITLE'] AS cny
MERGE (c:Company {cny: cny})
RETURN count(c);


LOAD CSV WITH HEADERS FROM 'file:///ny_house_cleaned.csv' AS row FIELDTERMINATOR ';'
WITH row where row['TYPE'] is not null
WITH row['TYPE'] AS typeP
MERGE (t:TypeP {typeP: typeP})
RETURN count(t);

LOAD CSV WITH HEADERS FROM 'file:///ny_house_cleaned.csv' AS row FIELDTERMINATOR ';'
WITH toInteger(row['BEDS']) AS beds
MERGE (b:Beds {beds: beds})
RETURN count(b);

MATCH (b:Beds)
WITH b
ORDER BY b.beds ASC
WITH collect(b) as bedsList
FOREACH (i in range(0, size(bedsList) - 2) |
 FOREACH (node1 in [bedsList[i]] |
  FOREACH (node2 in [bedsList[i+1]] |
   CREATE (node1)-[:FEWER_THAN]->(node2))))

LOAD CSV WITH HEADERS FROM 'file:///ny_house_cleaned.csv' AS row FIELDTERMINATOR ';'
WITH toInteger(row['BATH']) AS bath
MERGE (ba:Bath {bath: bath})
RETURN count(ba);

MATCH (ba:Bath)
WITH ba
ORDER BY ba.bath ASC
WITH collect(ba) as bathList
FOREACH (i in range(0, size(bathList) - 2) |
 FOREACH (node1 in [bathList[i]] |
  FOREACH (node2 in [bathList[i+1]] |
   CREATE (node1)-[:FEWER_THAN]->(node2))))


LOAD CSV WITH HEADERS FROM 'file:///ny_house_cleaned.csv' AS row FIELDTERMINATOR ';'
WITH row['STATE'] AS state
MERGE (s:State {state: state})
RETURN count(s);

LOAD CSV WITH HEADERS FROM 'file:///ny_house_cleaned.csv' AS row FIELDTERMINATOR ';'
WITH row['LOCALITY'] AS locality
MERGE (l:Locality {locality: locality})
RETURN count(l);

LOAD CSV WITH HEADERS FROM 'file:///ny_house_cleaned.csv' AS row FIELDTERMINATOR ';'
WITH toInteger(row.ID) AS propId, row.BROKERTITLE AS cny
MATCH (p:Property {propId: propId})
MATCH (c:Company {cny: cny})
MERGE (p)-[rel:BROKERED_BY]->(c)
RETURN count(rel);


LOAD CSV WITH HEADERS FROM 'file:///ny_house_cleaned.csv' AS row FIELDTERMINATOR ';'
WITH toInteger(row['ID']) AS propId, row['TYPE'] as typeP
MATCH (p:Property {propId: propId})
MATCH (t:TypeP {typeP: typeP})
MERGE (p)-[rel:IS_A]->(t)
RETURN count(rel);


LOAD CSV WITH HEADERS FROM 'file:///ny_house_cleaned.csv' AS row FIELDTERMINATOR ';'
WITH toInteger(row['ID']) AS propId, toInteger(row['BEDS']) as beds
MATCH (p:Property {propId: propId})
MATCH (b:Beds {beds: beds})
MERGE (p)-[rel:HAS_BEDS]->(b)
RETURN count(rel);


LOAD CSV WITH HEADERS FROM 'file:///ny_house_cleaned.csv' AS row FIELDTERMINATOR ';'
WITH toInteger(row['ID']) AS propId, toInteger(row['BATH']) as bath
MATCH (p:Property {propId: propId})
MATCH (ba:Bath {bath: bath})
MERGE (p)-[rel:HAS_BATH]->(ba)
RETURN count(rel);

LOAD CSV WITH HEADERS FROM 'file:///ny_house_cleaned.csv' AS row FIELDTERMINATOR ';'
WITH toInteger(row['ID']) AS propId, row['STATE'] as state
MATCH (s:State {state: state})
MATCH (p:Property {propId: propId})
MERGE (p)-[rel:LOCATED_AT]->(s)
RETURN count(rel);


LOAD CSV WITH HEADERS FROM 'file:///ny_house_cleaned.csv' AS row FIELDTERMINATOR ';'
WITH row['STATE'] AS state, row['LOCALITY'] as locality
MATCH (s:State {state: state})
MATCH (l:Locality {locality: locality})
MERGE (s)-[rel:LOCATED_AT]->(l)
RETURN count(rel);

// constraints and indexes

CREATE CONSTRAINT surface_type
FOR (p:Property)
REQUIRE p.sqft IS :: FLOAT

CREATE CONSTRAINT price_type
FOR (p:Property)
REQUIRE p.price IS :: FLOAT

CREATE CONSTRAINT beds_type
FOR (b:Beds)
REQUIRE b.beds IS :: INTEGER

CREATE CONSTRAINT bath_type
FOR (b:Bath)
REQUIRE b.bath IS :: INTEGER

CREATE CONSTRAINT prop_id_unique IF NOT EXISTS
FOR (p:Property) REQUIRE p.propId IS UNIQUE

CREATE CONSTRAINT company_name_unique IF NOT EXISTS
FOR (c:Company) REQUIRE c.cny IS UNIQUE


CREATE INDEX i_addr FOR (p:Property) ON (p.address)

CREATE INDEX i_state FOR (s:State) ON (s:state)

CREATE INDEX i_locality FOR (l:Locality) ON (l.locality)

