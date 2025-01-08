import g4p_controls.*;
import java.util.Map;
import java.util.List;
import java.util.ArrayList;
import java.util.Comparator;
import java.awt.Font;

PImage map;
PFont font;
int borderingDistance = 300; //placeholder for now
boolean showEdges = false, showEdgeDist = false, firstEdges = true;
String startingNode, endingNode, passingNode;    //from the dropdown
int[] dijkstraArray;

//Arrays
ArrayList<Node> nodes = new ArrayList<Node>();
ArrayList<Edge> edges = new ArrayList<Edge>();

void setup(){
    size(1100,750);
    // start the surface on the top left corner of computer screen
    surface.setLocation(0, 0);
    map = loadImage("europe.jpg");
    createGUI();
    smooth();
    strokeJoin(ROUND);
    strokeCap(ROUND);

    // font
    font = createFont("SansSerif", 15);
    textFont(font);
    textAlign(CENTER, CENTER);

    // create all the countries (nodes)
    nodes.add(new Node("Russia", 1017, 346, 40));
    nodes.add(new Node("Ukraine", 902, 463, 22));
    nodes.add(new Node("France", 448, 496, 20));
    nodes.add(new Node("Spain", 350, 664, 19));
    nodes.add(new Node("Sweden", 701, 264, 19));
    nodes.add(new Node("Germany", 626, 419, 18));
    nodes.add(new Node("Finland", 813, 243, 18));
    nodes.add(new Node("Norway", 583, 247, 18));
    
    for(Node node:nodes){
        node.addDefaultNeighbors();
        node.printNeighbors();
        node.createEdges(false);
    }
    firstEdges=false;
}

void draw(){
    background(map);

    // draw the lines of reference
    stroke(0);
    strokeWeight(1);
    fill(0);

    // horizontal axis
    for(int x=0; x<width/100; x++){
        line(100*x, 0, 100*x, height);
        text(str(100*x),100*x,10);
    }

    // vertical axis
    for(int y=1; y<=height/100; y++){
        line(0,100*y,width,100*y);
        text(str(100*y),20,100*y);
    }

    // draw node and edges
    for(Node node: nodes){
        node.drawNode();
    }
    
    if(showEdges){
        for(Edge edge: edges){
            edge.showEdge();
        }
    }
}

// return the Node with name of country
Node returnNodeWithName(String name){
    for(Node node: nodes){
        if(node.country.equals(name)){
            return node;
        }
    }
    return null;
}

// return the position of Node in the nodes arraylist
int returnNodePosition(Node n1){
    for(int n = 0; n<nodes.size(); n++){
        if(nodes.get(n) == n1){
            return n;
        }
    }
    return 0;
}

// return the Edge between two Nodes
Edge returnEdge(Node n1, Node n2){
    for(Edge edge: edges){
        if(edge.n1 == n1 && edge.n2 == n2){
            return edge;
        }
    }
    return null;
}

// return the index of the Edge between two Nodes
int returnEdgeIndex(Node n1, Node n2){
    for(int i = 0; i<edges.size(); i++){
        if(edges.get(i).n1 == n1 && edges.get(i).n2 == n2){
            return i;
        }
    }
    return 0;
}

// split the country and city and return the country part
String returnCountry(String input){
    String[] cityAndCountry = split(input, ", ");
    return cityAndCountry[1];
}