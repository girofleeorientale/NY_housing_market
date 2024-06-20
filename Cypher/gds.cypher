// r1
CALL gds.graph.project(
    'myGraph2',
    {
        Property: {
            properties: ['price','beds','sqft']
        }
    },
    '*'
);


// r2
CALL gds.knn.write.estimate('myGraph2', {
  nodeProperties: ['sqft'],
  writeRelationshipType: 'SIMILAR',
  writeProperty: 'score',
  topK: 1
})
YIELD nodeCount, bytesMin, bytesMax, requiredMemory

// r3
// centrality: article rank
CALL gds.graph.project(
  'myGraph',
  'Beds',
  'FEWER_THAN')

// r4
// résultat: required memory : 1480 bytes
CALL gds.articleRank.write.estimate('myGraph', {
  writeProperty: 'centrality',
  maxIterations: 20
})
YIELD nodeCount, relationshipCount, bytesMin, bytesMax, requiredMemory

// r5
CALL gds.articleRank.stream('myGraph')
YIELD nodeId, score
RETURN gds.util.asNode(nodeId).name AS name, score
ORDER BY score DESC, name ASC

// r6
// résultat : 0.2645597457885742
CALL gds.articleRank.stats('myGraph')
YIELD centralityDistribution
RETURN centralityDistribution.max AS max

