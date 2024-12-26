from math import *


#A SAMPLE WEIGHTED DIGRAPH. FEEL FREE TO CHANGE!
G = {'A': [ ['B',3], ['C',2], ['D',4] ],
     'B': [ ['E',8], ['F',5] ],
     'C': [ ['F',6], ['G',5] ],
     'D': [ ['G',2] ],
     'E': [ ['H',2] ],
     'F': [ ['E',3], ['H',7], ['I',6] ],  #i.e. F has 3 neighbours: E (cost 3), H (cost 7), I (at cost 6)
     'G': [ ['F',1], ['I',5] ],
     'H': [ ['J',1] ],
     'I': [ ['J',3] ],
     'J': [ ]
     }

G = {'A': [ ['B',5], ['C',2], ['F',8] ],
     'B': [ ['D',12], ['F',1] ],
     'C': [ ['F',5], ['E',9] ],
     'D': [ ['G',2] ],
     'E': [ ['G',6] ],
     'F': [ ['D',9], ['E',4] ],  
     'G': [  ]
     }

#DICTIONARIES USED IN THE ALGORITHM
SD = {}       #Stores the shortest distances found so far to each node
visited = {}  #Whether each node has been processed or not (True or False)
pred = {}     #For each node, stores the best-found node that points to that node

infinity = 999999  #A crude approximation of infinity


#RUNS DIJKSTRA'S ALGORITHM FROM STARTING NODE s TO TARGET NODE t
def runDijkstrasAlgorithm(s, t):
	global Q, SD, pred
	
	#Setting the initial values of Q, SD, pred and visited
	Q = [s]
	SD[s] = 0

	for node in G:
		pred[node] = ""
		
		if node != s:
			SD[node] = infinity
				
		visited[node] = False

	#The main loop
	while len(Q) > 0:
		minNode = getMinNode( Q )
		Q.remove( minNode )

		minNodesEdges = G[minNode] #The list of all edges leaving minNode.
															 #For example, in G above, if minNode is 'F', 
															 #then minNodeEdges is the array [ ['E',3], ['H',7], ['I',6] ]

		for e in minNodesEdges: #For every edge e leaving minNode...
			eNode = e[0]  #The label of the node that edge e points to
			eCost = e[1]  #The cost of edge e
			
			if SD[ minNode ] + eCost < SD[ eNode ]: #Updating eNode's SD and 
																							#pred values if we found a shorter way to get there
				SD[ eNode ] = SD[ minNode ] + eCost
				pred[ eNode ] = minNode

			if visited[ eNode ] == False:
				Q.append(eNode)

	printResults(s, t)


#FINDS THE NODE IN Q THAT HAS THE SMALLEST VALUE OF SD.
#EXAMPLE: Q MIGHT BE THE ARRAY ['C', 'F', 'H', 'B'], 
#DISCLAIMER:  The implementation shown here is easy to code but is not the most efficient way when the network is very large. For large networks, it's more efficient to use what's called a min-priority queue using a data structure known as a heap.
	
def getMinNode(Q):  
	minVal = infinity
	minNode = ''
	
	for q in Q:
		if SD[q] < minVal:
			minVal = SD[q]
			minNode = q

	return minNode  #Example: might return node label 'H'


#USES pred TO TRACE THE SHORTEST PATH BACKWARDS FROM t TO s, AND THEN REVERSES THAT PATH SO THAT IT'S
#PRINTED IN ORDER FROM s TO t.
def printResults(s, t): 

	n = t
	nodesOnSP = [] #An array for storing the nodes on the shortest path in forwards order

	#Basically reverses the "pred" trail 
	while n != "":
		nodesOnSP = [n] + nodesOnSP
		
		if pred[n] != "":
			n = pred[n]
				
		else:
				n = ""

	print("The shortest path from", s, "to", t, "is", nodesOnSP)
	print("The length of this path is", SD[t])

            
runDijkstrasAlgorithm('A','G')