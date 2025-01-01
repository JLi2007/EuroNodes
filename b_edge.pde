class Edge{
    Node n1, n2;    //the two nodes that make up this edge
    int dist;       //distance between the nodes
    int weight = 4;
    color defaultStroke;
    color selectedStroke;
    color currentStroke;

    Edge(Node n1, Node n2, int dist, boolean selected){
        this.n1 = n1;
        this.n2 = n2;
        this.dist = dist; 
        this.defaultStroke = color(2, 30, 107);  
        this.selectedStroke = color(97, 5, 39); 
        if(selected){
            this.currentStroke = this.selectedStroke;
        }else{
            this.currentStroke = this.defaultStroke;
        }
    }

    void showEdge(){
        strokeWeight(weight);
        strokeCap(ROUND);
        stroke(this.currentStroke);
        line(n1.x, n1.y, n2.x, n2.y);
    }
}