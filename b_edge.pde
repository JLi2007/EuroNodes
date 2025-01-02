class Edge{
    Node n1, n2;    //the two nodes that make up this edge
    int dist;       //distance between the nodes
    color defaultStroke;
    color selectedStroke;
    color currentStroke;
    color inverseCurrentStroke;
    int weight;

    Edge(Node n1, Node n2, int dist, boolean selected){
        this.n1 = n1;
        this.n2 = n2;
        this.dist = dist; 
        this.defaultStroke = color(2, 30, 107);  
        this.selectedStroke = color(191, 8, 75);
        this.weight = 4;
        if(selected){
            this.currentStroke = this.selectedStroke;
            this.inverseCurrentStroke = this.defaultStroke;
            this.weight = 5;
        }else{
            this.currentStroke = this.defaultStroke;
            this.inverseCurrentStroke = this.selectedStroke;
        }
    }

    void showEdge(){
        strokeWeight(this.weight);
        stroke(this.currentStroke);
        line(n1.x, n1.y, n2.x, n2.y);
        if(showEdgeDist){
            showEdgeDist();
        }
    }

    void showEdgeDist(){
        float x = (this.n1.x + this.n2.x ) / 2;
        float y = (this.n1.y + this.n2.y ) / 2;
        if(this.dist != 0){
            fill(this.inverseCurrentStroke);
            strokeWeight(1);
            rect(x-15,y-9,30,20);
            fill(this.currentStroke);
            text(this.dist, x, y);
        }
    }
}