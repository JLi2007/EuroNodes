import java.util.Map;

PImage map;
PFont font;
int borderingDistance = 300; //placeholder for now

//Arrays
ArrayList<Node> nodes = new ArrayList<Node>();

void setup(){
    size(1250,750);
    map = loadImage("europe.jpg");

    // font
    font = createFont("SansSerif", 15);
    textFont(font);
    textAlign(CENTER, CENTER);

    // create all the countries (nodes)
    nodes.add(new Node("Russia", 1017, 346, 35));
    nodes.add(new Node("Ukraine", 902, 463, 20));
    nodes.add(new Node("France", 448, 496, 18));
    nodes.add(new Node("Spain", 350, 664, 17));
    nodes.add(new Node("Sweden", 701, 264, 17));
    nodes.add(new Node("Germany", 626, 419, 16));
    nodes.add(new Node("Finland", 813, 243, 16));
    
    for(Node node:nodes){
        node.addDefaultNeighbors();
        node.printNeighbors();
    }
}

void draw(){
    background(map);

    // draw the lines of reference
    stroke(0);
    strokeWeight(1);
    fill(0);

    // horizontal axis
    for(int x=0; x<=width/100; x++){
        line(100*x, 0, 100*x, height);
        text(str(100*x),100*x,10);
    }

    // vertical axis
    for(int y=1; y<=height/100; y++){
        line(0,100*y,width,100*y);
        text(str(100*y),20,100*y);
    }

    for(Node node: nodes){
        node.drawNode();
    }
}