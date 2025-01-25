// James Li, ICS 4UI Final Project, Jan 24 2025

// Imports
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

// Variables
PImage map, startCountryFlag, startCountryImg, endCountryFlag, endCountryImg, passCountryFlag, passCountryImg, selectedCountryFlag;
PFont defaultFont;
int borderingDistance = 120; // placeholder for now
boolean showEdges = false, showEdgeDist = false, firstEdges = true, showGrid = false;
boolean showDijkstra = false, showCountryInfo = false, successStatus = true;  // gui
String addEdgeStatus = "N"; // dubs as a boolean N = none | S = success | F = fail
String startingCountry, endingCountry, passingCountry, startingCity, endingCity, passingCity, selectedCountry, addedEdge1, addedEdge2;    // from the dropdown
int dijkstraDistance;
String dijkstraOutput, dijkstraRoute;

//Arrays
ArrayList<Node> nodes = new ArrayList<Node>();
ArrayList<Edge> edges = new ArrayList<Edge>();

// Hashmaps
HashMap<String, String> mapToIso2 = new HashMap<String, String>();

void setup(){
    size(1100,750);

    // start the surface on the top left corner of computer screen
    surface.setLocation(0, 0);
    map = loadImage("europe.jpg");

    // initialize the hashmap mapping country names to iso2 for the api call
    createGUI();

    // initialize lines
    smooth();
    strokeJoin(ROUND);
    strokeCap(ROUND);

    // initialize font
    defaultFont = createFont("SansSerif", 15);
    textFont(defaultFont);
    textAlign(CENTER, CENTER);

    // create all the countries (nodes)
    nodes.add(new Node("Russia", 1017, 346, 45));
    nodes.add(new Node("Ukraine", 902, 463, 25));
    nodes.add(new Node("France", 448, 496, 22));
    nodes.add(new Node("Spain", 351, 665, 21));
    nodes.add(new Node("Sweden", 701, 264, 21));
    nodes.add(new Node("Germany", 626, 419, 20));
    nodes.add(new Node("Finland", 813, 243, 20));
    nodes.add(new Node("Norway", 583, 250, 20));
    nodes.add(new Node("Poland", 748, 425, 19));
    nodes.add(new Node("Italy", 610, 636, 19));
    nodes.add(new Node("United Kingdom", 407, 441, 18));
    nodes.add(new Node("Romania", 831, 586, 18));
    nodes.add(new Node("Belarus", 854, 388, 17));
    nodes.add(new Node("Greece", 793, 710, 16));
    nodes.add(new Node("Bulgaria", 785, 620, 15));
    nodes.add(new Node("Iceland", 55, 144, 15));
    nodes.add(new Node("Hungary", 717, 524, 14));
    nodes.add(new Node("Portugal", 262, 697, 14));
    nodes.add(new Node("Austria", 673, 510, 13));
    nodes.add(new Node("Czechia", 642, 470, 12));
    nodes.add(new Node("Serbia", 738, 578, 12));
    nodes.add(new Node("Ireland", 309, 401, 12));
    nodes.add(new Node("Lithuania", 818, 371, 12));
    nodes.add(new Node("Latvia", 798, 320, 11));
    nodes.add(new Node("Denmark", 612, 348, 10));
    nodes.add(new Node("Netherlands", 489, 422, 10));
    nodes.add(new Node("Switzerland", 530, 537, 9));
    nodes.add(new Node("Belgium", 480, 455, 9));

    // add the 'default' neighbors
    for(Node node: nodes){
        node.addDefaultNeighbors();
    }

    // create additional neighbors to make the starting map more realistic
    returnNodeWithName("Iceland").addAdditionalNeighbor(returnNodeWithName("Norway"));
    returnNodeWithName("Iceland").addAdditionalNeighbor(returnNodeWithName("Ireland"));
    returnNodeWithName("Russia").addAdditionalNeighbor(returnNodeWithName("Ukraine"));
    returnNodeWithName("Russia").addAdditionalNeighbor(returnNodeWithName("Finland"));
    returnNodeWithName("Spain").addAdditionalNeighbor(returnNodeWithName("France"));
    returnNodeWithName("Italy").addAdditionalNeighbor(returnNodeWithName("Greece"));
    returnNodeWithName("Italy").addAdditionalNeighbor(returnNodeWithName("France"));
    returnNodeWithName("Italy").addAdditionalNeighbor(returnNodeWithName("Switzerland"));
    returnNodeWithName("Italy").addAdditionalNeighbor(returnNodeWithName("Austria"));
    returnNodeWithName("Germany").addAdditionalNeighbor(returnNodeWithName("Switzerland"));
    returnNodeWithName("Germany").addAdditionalNeighbor(returnNodeWithName("Netherlands"));
    returnNodeWithName("Germany").addAdditionalNeighbor(returnNodeWithName("Poland"));
    returnNodeWithName("Denmark").addAdditionalNeighbor(returnNodeWithName("Sweden"));
    returnNodeWithName("Poland").addAdditionalNeighbor(returnNodeWithName("Ukraine"));
    returnNodeWithName("Hungary").addAdditionalNeighbor(returnNodeWithName("Ukraine"));
    returnNodeWithName("Ireland").addAdditionalNeighbor(returnNodeWithName("Portugal"));

    // remove unrealistic neighbors
    returnNodeWithName("Hungary").removeNeighbor(returnNodeWithName("Czechia"));
    returnNodeWithName("Hungary").removeNeighbor(returnNodeWithName("Bulgaria"));
    returnNodeWithName("Austria").removeNeighbor(returnNodeWithName("Bulgaria"));
    returnNodeWithName("Austria").removeNeighbor(returnNodeWithName("Serbia"));
    returnNodeWithName("Austria").removeNeighbor(returnNodeWithName("Germany"));
    returnNodeWithName("Poland").removeNeighbor(returnNodeWithName("Hungary"));
    returnNodeWithName("Poland").removeNeighbor(returnNodeWithName("Austria"));
    returnNodeWithName("Poland").removeNeighbor(returnNodeWithName("Latvia"));
    returnNodeWithName("France").removeNeighbor(returnNodeWithName("Netherlands"));

    // create the Edges to show them on screen
    for(Node node: nodes){
        // node.printNeighbors();
        node.createEdges(false);
    }

    // the first edges have been created
    firstEdges=false;
}

void draw(){
    background(map);

    // draw the lines of reference
    stroke(0,0,0,150);
    strokeWeight(1);
    fill(0,0,0,150);

    // if the showGrid checkbox is toggled, draw a grid
    if(showGrid){
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
    }

    // draw nodes
    for(Node node: nodes){
        node.drawNode();

        // update this variable for ui purposes
        if(node.isSelected){
            selectedCountry = node.country;
        }
    }
    
    // draw the edges
    if(showEdges){
        // show ui based on checkbox state
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

    // edge addition background
    fill(2, 30, 107, 150);
    rect(0, 600, 200, 200);

    // country info background
    fill(97, 5, 39, 180);
    rect(0, 200, 200, 400);

    // transparent blue box
    fill(2, 30, 107, 60);
    stroke(97, 5, 39, 160);
    rect(30, 290, 170, 140);

    // red vertical bar
    fill(97, 5, 39, 160);
    stroke(97, 5, 39, 160);
    rect(0, 210, 30, 380);

    // uses basic matrix functions to create and display text
    fill(2, 30, 107);
    // open matrix
    pushMatrix();
    translate(11, 400);
    // rotate 180 degrees
    rotate(-HALF_PI);

    // display the name of the selected country if there is one selected, or else display the default line
    if(showCountryInfo && selectedCountry != null){
      textSize(21);
      text(selectedCountry, 0, 0);
      textSize(15);
    }
    else{
      text("Select a country on the UI to display information", 0, 0);
    }

    // close matrix
    popMatrix();
    
    // update the sidebar if a country is selected
    if(showCountryInfo && selectedCountry!=null){
        showGUIButtons();

        fill(2, 30, 107);
        text("Closest Border", 110, 300);
        text("Furthest Border", 110, 375);

        // request the flag of selected country, load it, and display it
        String flag = requestHTTPFlag(selectedCountry);
        selectedCountryFlag = loadImage(flag);
        image(selectedCountryFlag, 80, 225);
        image(selectedCountryFlag, 80, 525);

        // return the closest and the furthest border (based of distance)
        Node n1 = returnNodeWithName(selectedCountry);
        String[] c = n1.returnNeighbors();
        
        // display the bordering country names on screen
        textSize(21);

        // special consideration to "United Kingdom" as the name is too long for size 21 font
        if(c[0].equals("United Kingdom")){
            textSize(16);
        }
        text(c[0], 110, 325);

        if(c[1].equals("United Kingdom")){
            textSize(16);
        }
        text(c[1], 110, 400);

        // reset text size
        textSize(15);
    }

    // if a country is not selected, don't show the wiki and image buttons
    if(!showCountryInfo){
        hideGUIButtons();
    }
}

// RETURN FUNCTIONS
// return the Node via country name
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

// return the position of the Node in the nodes arraylist via Node
int returnNodePosition(Node n1){
    for(int n = 0; n<nodes.size(); n++){
        if(nodes.get(n) == n1){
            return n;
        }
    }
    return 0;
}

// return the Edge between two Nodes via the two Nodes
Edge returnEdge(Node n1, Node n2){
    for(Edge edge: edges){
        if(edge.n1 == n1 && edge.n2 == n2){
            return edge;
        }
    }
    return null;
}

// return the index of the Edge between two Nodes via the two Nodes
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