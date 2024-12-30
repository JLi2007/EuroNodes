import g4p_controls.*;
import java.util.Map;
import java.awt.Font;

PImage map;
PFont font;
int borderingDistance = 300; //placeholder for now
boolean showEdges = false;

//Arrays
ArrayList<Node> nodes = new ArrayList<Node>();
ArrayList<Edge> edges = new ArrayList<Edge>();

void setup(){
    size(1100,750);
    surface.setLocation(0, 0);
    createGUI();
    map = loadImage("europe.jpg");

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

Node returnNode(String name){
    for(Node node: nodes){
        if(node.country.equals(name)){
            return node;
        }
    }
    return null;
}