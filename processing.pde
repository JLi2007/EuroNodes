import g4p_controls.*;
import http.requests.*;
import java.util.Map;
import java.util.List;
import java.util.ArrayList;
import java.util.Comparator;
import java.lang.StringBuilder;
import java.awt.Font;
import java.net.URL;
import java.net.URLConnection;
import java.io.File;
import java.io.InputStream;
import java.io.FileOutputStream;

PImage map, startCountryFlag, startCountryImg, endCountryFlag, endCountryImg, passCountryFlag, passCountryImg, selectedCountryFlag;
PFont font;
int borderingDistance = 195; // placeholder for now
boolean showEdges = false, showEdgeDist = false, firstEdges = true, showFlags = false;
boolean showDijkstra = false, showCountryInfo = false, successStatus = true;  // gui
String addEdgeStatus = "N"; // dubs as a boolean N = none | S = success | F = fail
String startingCountry, endingCountry, passingCountry, startingCity, endingCity, passingCity, selectedCountry, addedEdge1, addedEdge2;    // from the dropdown
int dijkstraDistance;
String dijkstraOutput, dijkstraRoute;

//Arrays
ArrayList<Node> nodes = new ArrayList<Node>();
ArrayList<Edge> edges = new ArrayList<Edge>();

// Hashmaps
HashMap<String, String> mapToIso2;

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
    nodes.add(new Node("Russia", 1017, 346, 45));
    nodes.add(new Node("Ukraine", 902, 463, 25));
    nodes.add(new Node("France", 448, 496, 22));
    nodes.add(new Node("Spain", 350, 664, 21));
    nodes.add(new Node("Sweden", 701, 264, 21));
    nodes.add(new Node("Germany", 626, 419, 20));
    nodes.add(new Node("Finland", 813, 243, 20));
    nodes.add(new Node("Norway", 583, 248, 20));
    nodes.add(new Node("Poland", 748, 424, 19));
    nodes.add(new Node("Italy", 610, 635, 19));
    nodes.add(new Node("United Kingdom", 408, 441, 18));
    nodes.add(new Node("Romania", 830, 585, 18));
    nodes.add(new Node("Belarus", 854, 388, 17));
    nodes.add(new Node("Greece", 793, 709, 16));
    nodes.add(new Node("Bulgaria", 786, 620, 15));
    nodes.add(new Node("Iceland", 55, 144, 15));
    nodes.add(new Node("Hungary", 715, 522, 14));
    
    for(Node node:nodes){
        node.addDefaultNeighbors();
        node.printNeighbors();
        node.createEdges(false);
    }

    // the first edges have been created
    firstEdges=false;

    // initialize the hashmap mapping country names to iso2 for the api call
    httpSetup();
}

void draw(){
    background(map);

    // draw the lines of reference
    stroke(0,0,0,150);
    strokeWeight(1);
    fill(0,0,0,150);

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

    // draw nodes
    for(Node node: nodes){
        node.drawNode();

        // update this variable for gui purposes
        if(node.isSelected){
            selectedCountry = node.country;
        }
    }
    
    // draw the edges
    if(showEdges){
        // based on checkbox state
        for(Edge edge: edges){
            edge.showEdge();
        }
        for(Edge edge: edges){
            edge.showEdgeDist();
        }
    }

    // semi-transparent rectangles on the left side
    stroke(0,0,0,150);
    strokeWeight(1);
    fill(2, 30, 107, 150);
    rect(0, 600, 200, 200);
    fill(97, 5, 39, 150);
    rect(0, 200, 200, 400);
    fill(97, 5, 39, 160);
    stroke(97, 5, 39, 160);
    rect(0, 210, 30, 380);

    // create and display text rotated 180 degrees
    fill(2, 30, 107);
    pushMatrix();
    translate(10, 400);
    rotate(-HALF_PI);
    if(showCountryInfo && selectedCountry != null){
      text(selectedCountry, 0, 0);
    }
    else{
      text("Select a country on the UI to display information", 0, 0);
    }
    popMatrix();
    
    // update the sidebar
    if(showCountryInfo && selectedCountry!=null){
      String flag = requestHTTPFlag(selectedCountry);
      selectedCountryFlag = loadImage(flag);
      image(selectedCountryFlag, 70, 250);

      Node n1 = returnNodeWithName(selectedCountry);
    }
}

// return the Node with name of country
Node returnNodeWithName(String name){
    if(name==null){
        return null;
    }

    for(Node node: nodes){
        if(node.country.toUpperCase().trim().equals(name.toUpperCase().trim())){
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

// split the country and city and return the city part
String returnCity(String input){
    String[] cityAndCountry = split(input, ", ");
    return cityAndCountry[0];
}