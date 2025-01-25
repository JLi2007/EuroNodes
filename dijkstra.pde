// Uses Dijkstra's shortest path algorithm. 
// To understand what the code is doing, read this as it explains it FAR better than my comments can:
// https://www.w3schools.com/dsa/dsa_algo_graphs_dijkstra.php 

String runDijkstra(Node n1, Node n2, boolean passing){
    // return the position of starting and ending nodes 
    int startingNode = returnNodePosition(n1);
    int endingNode = returnNodePosition(n2);

    // initialize arrays 
    int nodesSize = nodes.size();
    int[] distances = new int[nodesSize];
    int[] predecessors = new int[nodesSize];   //holds the "travel history" 
    boolean[] visited = new boolean[nodesSize];

    // initialize values in the arrays to Java max and min values
    // they could be any values but these large absolute value integers make them distinctable
    for (int i = 0; i < nodesSize; i++) {
        distances[i] = Integer.MAX_VALUE;
        predecessors[i] = Integer.MIN_VALUE;
    }

    // the distance from the starting node to itself is 0
    distances[startingNode] = 0;

    // this loop represents the progression of the algorithm
    // every cycle, one the next cloest node gets selected
    for (int i = 0; i < nodesSize; i++){
        // find the node with the minimum distance. this is the "current node"
        int min = minDistance(distances, visited);

        // if there are no more nodes to visit, we are done here
        if(min == -1){
            break;
        }

        // change the current node to visited, we are on it right now
        visited[min] = true;

        // iterate with c, representing "the neighboring node"
        // the program checks all the nodes on the map, if there a node has a direct connection to the "current node", update its distance
        // otherwise, skip over it. It will eventually be reached in future cycles
        for(int c = 0; c < nodesSize; c++){
            // return the edge between "the neighboring node" and the "current node"
            Edge edge = returnEdge(nodes.get(min), nodes.get(c));
            
            if(edge != null){
                // access the edge distance
                int edgeDist = edge.dist;

                if(!visited[c] && edgeDist != 0 && distances[min] != Integer.MAX_VALUE){
                    // this is the new distance from starting node to the "neighbouring node" via "current node". 
                    int newDist = distances[min] + edgeDist;
                    if(newDist < distances[c]){
                        // update the distances array of the neighboring node
                        // Note: this node is still "UNVISITED". Updating the distance still guarantees it to be found as the "current node" in future cycles
                        distances[c] = newDist;
                        // update the path history array with the current node, marking that it has been visited
                        predecessors[c] = min;
                    }
                }
            }
        }
    }

    // printArray(distances);

    // build the return string with java StringBuilder
    StringBuilder path = new StringBuilder();
    String previousNode = null;
    
    // iterate through the saved "travel history" to create the correct path
    // loop starts from the most recent visited node and makes its way back through history
    for (int e = endingNode; e != Integer.MIN_VALUE; e = predecessors[e]) {
        // avoids duplicates like "... country1-->country2-->country2 ..."
        if(nodes.get(e).country != previousNode){
            if(passing){
                // this if statement also avoids duplicates like "... country1-->country2-->country2 ..." (for a special case when there is a passing country constraint)
                if(nodes.get(e).country != n1.country){
                    // inserting "Italy" to "Germany" results in "Italy -> Germany"
                    path.insert(0, nodes.get(e).country + (path.length() > 0 ? "->" : ""));
                    previousNode = nodes.get(e).country;
                }
            }
            else{
                path.insert(0, nodes.get(e).country + (path.length() > 0 ? "->" : ""));
                previousNode = nodes.get(e).country;
            }
        }
    }

    // if beginning and ending country are the same, return "country1 --> country1" rather than only "country1"
    if(n1 == n2){
        path.insert(0, n1.country + "->");
    }

    // return the final stringbuilder string
    return path.toString() + "," + distances[endingNode];
}

// find the closest node / check if all the nodes are visitied already
int minDistance(int[] distances, boolean[] visited){
    int min = Integer.MAX_VALUE;
    int minIndex = -1;

    // check if all nodes are visited: if minIndex changes there is an unvisited node
    for(int c = 0; c < nodes.size(); c++){
        if(!visited[c] && distances[c] <= min){
            min = distances[c];

            // update the minIndex variable upon finding the closest unvisited node
            minIndex = c;
        }
    }

    // if this returns -1, that means there are no more nodes to visit, otherwise, it returns the closest node
    return minIndex;
}

// normalize the distance to actual km
int normalizeDistance(int d){
    // actual distance from Paris to Madrid (Km)
    float n = 1274.8;
    // distance in the program (units)
    float p = 194.0;

    // return the new distance in km
    return int(d*(n/p));
}