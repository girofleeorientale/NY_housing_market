// r 1
// trouver les biens moins chers que 300000 de type 'Condo'
MATCH (p:Property)-[:IS_A]->(t:TypeP)
WHERE p.price < 300000 AND t.typeP = 'Condo'
RETURN p

// r2
// trouver les biens moins chers que 300000 de type 'Condo'
// qui ont la relation 'HAS_BATH'
MATCH (b:Bath)<-[:HAS_BATH]-(p:Property)-[:IS_A]->(t:TypeP)
WHERE p.price < 300000 AND t.typeP = 'Condo'
RETURN p, b, t

// r3
// trouver les biens pour lesquels le type n'est pas défini
// (= pas de relation [:IS_A])
MATCH (p: Property)
WHERE NOT EXISTS ((p)-[:IS_A]-())
RETURN count(*)

// r4
// trouver les biens ou le pattern défini n'existe pas
MATCH (p:Property)-[*]->(l:Locality)
WHERE l.locality = 'Kings County'
AND NOT EXISTS {
    MATCH (p)-[:HAS_BATH]->(b:Bath)
    WHERE p.sqft < 100000 AND b.bath < 10
}
RETURN p.address AS address, p.sqft

// même requête
MATCH (p:Property)-[*]->(l:Locality),
    (p)-[:HAS_BATH]->(b:Bath)
WHERE l.locality = 'Kings County'
AND (p.sqft < 100000 AND b.bath > 10)
OR (p.sqft >= 100000 AND b.bath < 10)
return p.address AS address, p.sqft, b.bath


// r5
// trouver les propriétés moins chères que 500000
// et en plus les propriétés de type 'Condo'
MATCH (p:Property)
WHERE p.price < 500000
OPTIONAL MATCH (p)-[r:IS_A]->(c)
WHERE c.typeP<>'Condo'
RETURN p, c

// r6
// Trouver les 5 premières compagnies par ordre alphabétique
MATCH (c:Company)
WITH c
ORDER BY c.cny ASC
LIMIT 5
RETURN collect(c.cny)

// r7
// trouver les biens avec 1 chambre
MATCH (p:Property)-[:HAS_BEDS]->(b:Beds)
WITH p, b
WHERE b.beds = 1
RETURN count(b)

// r8
// donner les adresses des biens qui sont à New York
// et qui ont plus de 3 chambres
MATCH (p:Property)-[:HAS_BEDS]->(b:Beds)
MATCH (p:Property)-[:LOCATED_AT*]->(l:Locality {locality:'New York'})
WITH *, (b.beds > 3) AS many_beds
RETURN p.address, many_beds


// r9
// pour explorer les données et la topologie du graphe:
// trouver les biens situés à Bronx County
// moins chers que 300000
MATCH w=(p:Property)-[:LOCATED_AT*]->(l:Locality)
WHERE l.locality = 'Bronx County'
AND p.price < 300000
RETURN w, p, l


// r 10
// trouver les 'états' situés à Kings County
MATCH (s:State), (l {locality:"Kings County"})
WITH s, l
MATCH w = (s)-[:LOCATED_AT]->(l)
UNWIND nodes(w) as n
WITH COLLECT(n) as m
RETURN m

// r 11
// faire la somme des valeurs
// qui sont dans la liste des nombres possibles de salles de bains
MATCH p = (b1:Bath)-[:FEWER_THAN]->(b2:Bath)
UNWIND nodes(p) as k
WITH COLLECT(k) as m
RETURN reduce(totalBaths = 0, n IN m | totalBaths + n.bath)

// r 12
// trouver le bien le moins cher et le plus cher
// parmi ceux qui sont situés à New York et ont deux chambres
CALL {
  MATCH w=(b {beds: 2})<-[:HAS_BEDS]-(p:Property)-[:LOCATED_AT*]->(l:Locality {locality: 'New York'})
  RETURN p
  ORDER BY p.price ASC
  LIMIT 1
UNION
  MATCH w=(b {beds: 2})<-[:HAS_BEDS]-(p:Property)-[:LOCATED_AT*]->(l:Locality {locality: 'New York'})
  RETURN p
  ORDER BY p.price DESC
  LIMIT 1
}
RETURN p.price

// r 13
// retourne un booléen qui indique si à Kings County
// il y a un 'état' dont le nom commence par 'Brooklyn'
MATCH w= (s:State)-[*]->(l:Locality) 
WHERE l.locality='Kings County'
UNWIND nodes(w) as n
WITH COLLECT(n) as m
RETURN  any(x IN m
WHERE x.state starts WITH 'Brooklyn') 

// r 14
// retourne un booléen qui indique si 
// pour les biens plus chers que 1000000 situés à Manhattan
// il existe la relation 'HAS_BEDS'
MATCH w=(p:Property)-[:LOCATED_AT]->(s:State)
WHERE p.price > 1000000 AND s.state STARTS WITH 'Manhattan'
RETURN
  p.address AS address,
  exists((p)-[:HAS_BEDS]->()) AS exists_beds