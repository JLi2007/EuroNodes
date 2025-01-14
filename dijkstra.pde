String runDijkstra(Node n1, Node n2){ 
    int startingNode = returnNodePosition(n1);
    int endingNode = returnNodePosition(n2);
    int nodesSize = nodes.size();
    int[] distances = new int[nodesSize];
    int[] predecessors = new int[nodesSize];
    boolean[] visited = new boolean[nodesSize];

    for (int i = 0; i < nodesSize; i++) {
        distances[i] = Integer.MAX_VALUE;
        predecessors[i] = Integer.MIN_VALUE;
    }

    distances[startingNode] = 0;

    for (int i = 0; i < nodesSize; i++){
        int min = minDistance(distances, visited);
        if(min == -1){
            break;
        }

        // change the the node with the minimum distance to visited
        visited[min] = true;

        for(int c = 0; c < nodesSize; c++){
            Edge edge = returnEdge(nodes.get(min), nodes.get(c));
            if(edge != null){
                int edgeDist = edge.dist;
                if(!visited[c] && edgeDist != 0 && distances[min] != Integer.MAX_VALUE){
                    int newDist = distances[min] + edgeDist;
                    if(newDist < distances[c]){
                        distances[c] = newDist;
                        predecessors[c] = min;
                    }
                }
            }
        }
    }

    // build the return string
    StringBuilder path = new StringBuilder();
    for (int e = endingNode; e != Integer.MIN_VALUE; e = predecessors[e]) {
        path.insert(0, nodes.get(e).country + (path.length() > 0 ? "->" : ""));
    }

    return path.toString() + "," + distances[endingNode];
}

int minDistance(int[] distances, boolean[] visited){
    int min = Integer.MAX_VALUE;
    int minIndex = -1;
    int nodesSize = nodes.size();

    // check if all nodes are visited as if minIndex changes there is an unvisited node
    for(int c = 0; c < nodesSize; c++){
        if(!visited[c] && distances[c] <= min){
            min = distances[c];
            minIndex = c;
        }
    }
    return minIndex;
}

int normalizeDistance(int d){
    // actual distance from Paris to Madrid (Km)
    float n = 1274.8;
    // distance in the program (units)
    float p = 194.0;

    // return the new distance in km
    return int(d*(n/p));
}