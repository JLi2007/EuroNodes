/* autogenerated by Processing revision 1293 on 2025-01-14 */
import processing.core.*;
import processing.data.*;
import processing.event.*;
import processing.opengl.*;

import g4p_controls.*;
import java.util.Map;
import java.util.List;
import java.util.ArrayList;
import java.util.Comparator;
import java.lang.StringBuilder;
import java.awt.Font;

import java.util.HashMap;
import java.util.ArrayList;
import java.io.File;
import java.io.BufferedReader;
import java.io.PrintWriter;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.IOException;

public class mouse extends PApplet {

public void mousePressed(){
    for(Node node: nodes){
        node.unselectState();
    }
    for(Node node: nodes){
        node.selectState();
    }
}
class Node{
    String country;
    float x,y;
    float radius;
    int defaultColour; 
    int defaultStroke;
    int selectedColour;
    int selectedStroke;
    int currentColour; 
    int currentStroke;
    boolean isSelected;
    HashMap<String, Integer> borderingCountries;

    Node(String name, float x, float y, float r){
        this.country = name;
        this.x = x;
        this.y = y;
        this.radius = r;
        this.defaultColour = color(44, 94, 232, 100);   //default node color | blue
        this.defaultStroke = color(2, 30, 107);        //default node color stroke| darker blue
        this.selectedColour = color(191, 8, 75, 100);   //when node is clicked | red & pink 
        this.selectedStroke = color(97, 5, 39);        //when node is clicked stroke | darker red & pink
        this.currentColour = this.defaultColour;       //initial state
        this.currentStroke = this.defaultStroke;
        this.isSelected = false;
        this.borderingCountries = new HashMap<String, Integer>();
    }

    // on mouse event
    public void unselectState(){
        // unselect node case 1 | another node is selected
        if (this.isSelected && !isMouseInside()){
            println("released " + this.country);
            this.currentColour = this.defaultColour;
            this.currentStroke = this.defaultStroke;
            this.isSelected = false;
            createEdges(false);
            showCountryInfo = false;
        }
    }

    public void selectState(){
        // select node
        if (!this.isSelected && isMouseInside()){
            println("clicked " + this.country);
            this.currentColour = this.selectedColour;
            this.currentStroke = this.selectedStroke;
            this.isSelected = true;
            createEdges(true);
            showCountryInfo = true;
        }

        // unselect node case 2 | the node is already selected and it gets clicked again
        else if(this.isSelected && isMouseInside()){
            println("released " + this.country);
            this.currentColour = this.defaultColour;
            this.currentStroke = this.defaultStroke;
            this.isSelected = false;
            createEdges(false);
            showCountryInfo = false;
        }
    }

    public void addDefaultNeighbors(){
        for(int n = 0; n<=nodes.size()-1; n++){
            int d = calculateDistance(this, nodes.get(n));
            if(d<borderingDistance){ //d!=0 && 
                this.borderingCountries.put(nodes.get(n).country, d);
            }
        }
    }

    // prints the hashmap to visualize the neighbors in terminal
    public void printNeighbors(){
        println(this.country + "'s neighbors: ");

        // sort by increasing distances when printing to terminal 
        // when they are initially printed, they are in random order (default hashmap behavior)
        List<Map.Entry<String, Integer>> sortedBorderingCountries = new ArrayList<>(this.borderingCountries.entrySet());
        sortedBorderingCountries.sort(Comparator.comparing(Map.Entry<String, Integer>::getValue)); 

        // print the sorted neighbors
        for (Map.Entry country : sortedBorderingCountries) {
            print(country.getKey() + " is ");
            println(country.getValue() + " units away");
        }
        println("-------------------------------------");
    }

    // create edges with all its neighbors
    public void createEdges(boolean selected){
        for (Map.Entry<String, Integer> country : this.borderingCountries.entrySet()) {
            Node n = returnNodeWithName(country.getKey());

            if(n!=null){
                // first, remove the previous edge
                if(!firstEdges){
                    int removeEdge = returnEdgeIndex(this, n);
                    edges.remove(removeEdge);
                }

                // then, add the new edge
                edges.add(new Edge(this, n, country.getValue(), selected));
            }
        }
    }

    // checks if mouse is inside the node
    public boolean isMouseInside(){
        return dist(mouseX, mouseY, this.x, this.y) <= this.radius;
    }

    // calculate distance between two nodes
    public int calculateDistance(Node n1, Node n2){
        return PApplet.parseInt(dist(n1.x, n1.y, n2.x, n2.y));
    }

    public void drawNode(){
        strokeWeight(5);
        stroke(this.currentStroke);
        fill(this.currentColour);
        circle(this.x,this.y,2*this.radius);
    }
}
class Edge{
    Node n1, n2;    //the two nodes that make up this edge
    int dist;       //distance between the nodes
    int defaultStroke;
    int selectedStroke;
    int currentStroke;
    int inverseCurrentStroke;
    int weight;

    Edge(Node n1, Node n2, int dist, boolean selected){
        this.n1 = n1;
        this.n2 = n2;
        this.dist = dist; 
        this.defaultStroke = color(2, 30, 107);  
        this.selectedStroke = color(191, 8, 75);
        this.weight = 3;
        if(selected){
            this.currentStroke = this.selectedStroke;
            this.inverseCurrentStroke = this.defaultStroke;
            this.weight = 4;
        }else{
            this.currentStroke = this.defaultStroke;
            this.inverseCurrentStroke = this.selectedStroke;
        }
    }

    public void showEdge(){
        strokeWeight(this.weight);
        stroke(this.currentStroke);
        line(n1.x, n1.y, n2.x, n2.y);
    }

    public void showEdgeDist(){
        if(showEdgeDist){
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
}
public String runDijkstra(Node n1, Node n2){ 
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

public int minDistance(int[] distances, boolean[] visited){
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

public int normalizeDistance(int d){
    // actual distance from Paris to Madrid (Km)
    float n = 1274.8f;
    // distance in the program (units)
    float p = 194.0f;

    // return the new distance in km
    return PApplet.parseInt(d*(n/p));
}
/* =========================================================
 * ====                   WARNING                        ===
 * =========================================================
 * The code in this tab has been generated from the GUI form
 * designer and care should be taken when editing this file.
 * Only add/edit code inside the event handlers i.e. only
 * use lines between the matching comment tags. e.g.

 void myBtnEvents(GButton button)
     // It is safe to enter your event code here  

 
 * Do not rename this tab!
 * =========================================================
 */
synchronized public void draw_toolbarWindow(PApplet appc, GWinData data) {
    appc.background(230);
    appc.fill(196, 196, 196);
    appc.stroke(196, 196, 196);
    appc.rect(0, 400, 400, 200);
    appc.fill(13, 1, 115);
    appc.stroke(13, 1, 115);
    appc.textSize(18);

    // if statements to determine what to display on status    
    if(successStatus){
      appc.fill(23, 163, 2);
      appc.text("✓ STATUS ✓", 165, 420);
    } 
    else{
      appc.fill(199, 8, 21);
      appc.text("x STATUS x", 165, 420);
    }

    if(showDijkstra){
      statusDescription.setText(endingCity + " is " + dijkstraDistance + " units (" + normalizeDistance(dijkstraDistance) + "km) away from " + startingCity + " \n" + dijkstraRoute);
    }
    else if(addEdgeStatus.equals("F")){
      statusDescription.setText("CANNOT add edge, country name(s) spelled wrong or the country(s) do not exist on the map");
    }
    else if(addEdgeStatus.equals("S")){
      statusDescription.setText("Added edge from " + addedEdge1.toUpperCase() + " to " + addedEdge2.toUpperCase());
    }  
} 

public void edgesChecked(GCheckbox source, GEvent event) { 
  showEdges = !showEdges;
} 

public void edgeDistChecked(GCheckbox source, GEvent event) { 
  showEdgeDist = !showEdgeDist;
} 

public void selectStartingCountry(GDropList source, GEvent event) {
  showDijkstra = false;
  startingCountry = returnCountry(startingSelect.getSelectedText());
  startingCity = returnCity(startingSelect.getSelectedText());
}

public void selectEndingCountry(GDropList source, GEvent event) {
  showDijkstra = false;
  endingCountry = returnCountry(endingSelect.getSelectedText());
  endingCity = returnCity(endingSelect.getSelectedText());
}

public void selectPassingCountry(GDropList source, GEvent event) {
  showDijkstra = false;

  // if the user inputs a passing country
  if(passingSelect.getSelectedText().equals("N/A") == false){
    passingCountry = returnCountry(passingSelect.getSelectedText());
    passingCity = returnCity(passingSelect.getSelectedText());
  }

  else{
    passingCountry = null;
    passingCity = null;
  }
}

public void inputEdge1(GTextField source, GEvent event) { 
  addedEdge1 = addEdge1.getText();
  addEdgeStatus = "N";
} 

public void inputEdge2(GTextField source, GEvent event) { 
  addedEdge2 = addEdge2.getText();
  addEdgeStatus = "N";
} 

public void addEdge(GButton source, GEvent event) {
  showDijkstra = false;

  // add the edge if the user inputs are correct
  if(returnNodeWithName(addedEdge1) != null && returnNodeWithName(addedEdge2) != null ){
    Node n1 = returnNodeWithName(addedEdge1);
    Node n2 = returnNodeWithName(addedEdge2);
    int d = n1.calculateDistance(n1,n2);
    n1.borderingCountries.put(n2.country, d);
    n2.borderingCountries.put(n1.country, d);
    n1.createEdges(false);
    n2.createEdges(false);
    // display success message in STATUS
    successStatus = true;
    addEdgeStatus = "S";
  }
  // otherwise, display the failure message in STATUS
  else{
    successStatus = false;
    addEdgeStatus = "F";
  }
} 

public void initDijkstra(GButton source, GEvent event) { 
  if(startingCountry != null && endingCountry != null){

    // in the format "country1->country2->country3,distance"
    dijkstraOutput= runDijkstra(returnNodeWithName(startingCountry), returnNodeWithName(endingCountry));
    dijkstraRoute = dijkstraOutput.split(",")[0];
    dijkstraDistance = PApplet.parseInt(dijkstraOutput.split(",")[1]);

    println(dijkstraRoute, dijkstraDistance);

    // placeholder
    println("ran dijkstra and populated array var");

    println(endingCountry + " is " + dijkstraDistance + " units away from " + startingCountry);
    successStatus = true;
    showDijkstra = true;
    addEdgeStatus = "N";
  }
} 

// Create all the GUI controls. 
// autogenerated do not edit
public void createGUI(){
  G4P.messagesEnabled(false);
  G4P.setGlobalColorScheme(GCScheme.BLUE_SCHEME);
  G4P.setMouseOverEnabled(false);
  surface.setTitle("Euro•Nodes");

  toolbarWindow = GWindow.getWindow(this, "Toolbar", 1100, 0, 400, 500, JAVA2D);
  toolbarWindow.noLoop();
  toolbarWindow.setActionOnClose(G4P.KEEP_OPEN);
  toolbarWindow.addDrawHandler(this, "draw_toolbarWindow");
  toolbarWindow.loop();

  edgesCheck = new GCheckbox(toolbarWindow, 20, 10, 200, 50);
  edgesCheck.setFont(new Font("SansSerif", Font.PLAIN, 18));
  edgesCheck.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  edgesCheck.setText(" Show Edges -->");
  edgesCheck.setOpaque(false);
  edgesCheck.addEventHandler(this, "edgesChecked");

  edgeDistCheck = new GCheckbox(toolbarWindow, 200, 10, 200, 50);
  edgeDistCheck.setFont(new Font("SansSerif", Font.PLAIN, 18));
  edgeDistCheck.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  edgeDistCheck.setText(" Show Edge Dists");
  edgeDistCheck.setOpaque(false);
  edgeDistCheck.addEventHandler(this, "edgeDistChecked");

  startingSelect = new GDropList(toolbarWindow, 20, 90, 150, 100, 5, 10);
  startingSelect.setItems(loadStrings("list_countries"), 0);
  startingSelect.addEventHandler(this, "selectStartingCountry");
  starting_label = new GLabel(toolbarWindow, 20, 70, 150, 20);
  starting_label.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  starting_label.setText("Where To Start");
  starting_label.setOpaque(false);
  starting_label.setFont(new Font("SansSerif", Font.PLAIN, 14));

  endingSelect = new GDropList(toolbarWindow, 20, 190, 150, 100, 5, 10);
  endingSelect.setItems(loadStrings("list_countries"), 0);
  endingSelect.addEventHandler(this, "selectEndingCountry");
  ending_label = new GLabel(toolbarWindow, 20, 170, 150, 20);
  ending_label.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  ending_label.setText("Where To End");
  ending_label.setOpaque(false);
  ending_label.setFont(new Font("SansSerif", Font.PLAIN, 14));

  passingSelect = new GDropList(toolbarWindow, 20, 290, 150, 100, 5, 10);
  passingSelect.setItems(loadStrings("list_countries2"), 0);
  passingSelect.addEventHandler(this, "selectPassingCountry");
  passing_label = new GLabel(toolbarWindow, 20, 270, 150, 20);
  passing_label.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  passing_label.setText("Where To Pass");
  passing_label.setOpaque(false);
  passing_label.setFont(new Font("SansSerif", Font.PLAIN, 14));

  dijkstra_btn = new GButton(toolbarWindow, 150, 350, 100, 30);
  dijkstra_btn.setText("Run Algo");
  dijkstra_btn.addEventHandler(this, "initDijkstra");

  adding_edge_label = new GLabel(this, 0, 600, 200, 50);
  adding_edge_label.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  adding_edge_label.setText("Add an edge between two countries");
  adding_edge_label.setOpaque(false);
  adding_edge_label.setFont(new Font("SansSerif", Font.PLAIN, 14));
  adding_edge_label.setLocalColorScheme(GCScheme.RED_SCHEME);
  addEdge1 = new GTextField(this, 10, 650, 120, 30, G4P.SCROLLBARS_NONE);
  addEdge1.setOpaque(true);
  addEdge1.addEventHandler(this, "inputEdge1");
  addEdge1.setLocalColorScheme(GCScheme.RED_SCHEME);
  addEdge1.setPromptText("Country 1");
  addEdge2 = new GTextField(this, 10, 700, 120, 30, G4P.SCROLLBARS_NONE);
  addEdge2.setOpaque(true);
  addEdge2.addEventHandler(this, "inputEdge2");
  addEdge2.setLocalColorScheme(GCScheme.RED_SCHEME);
  addEdge2.setPromptText("Country 2");
  add_edge_btn = new GButton(this, 140, 650, 50, 80);
  add_edge_btn.setText("Add Edge");
  add_edge_btn.addEventHandler(this, "addEdge");
  add_edge_btn.setLocalColorScheme(GCScheme.RED_SCHEME);

  adding_edge_label = new GLabel(this, 0, 200, 200, 20);
  adding_edge_label.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  adding_edge_label.setText("Country Info");
  adding_edge_label.setOpaque(false);
  adding_edge_label.setFont(new Font("SansSerif", Font.PLAIN, 15));

  statusDescription = new GTextArea(toolbarWindow, 10, 430, 380, 60, G4P.SCROLLBARS_NONE);
  statusDescription.setText("Welcome to Euronodes");
  statusDescription.setFont( new Font("SansSerif", Font.PLAIN, 14) );
  
  // initialize variables   
  startingCountry = returnCountry(startingSelect.getSelectedText());
  startingCity = returnCity(startingSelect.getSelectedText());
  endingCountry = returnCountry(endingSelect.getSelectedText());
  endingCity = returnCity(startingSelect.getSelectedText());
}

// Variable declarations 
// autogenerated do not edit
GWindow toolbarWindow;
GCheckbox edgesCheck, edgeDistCheck; 
GDropList startingSelect, endingSelect, passingSelect; 
GLabel starting_label, ending_label, passing_label, adding_edge_label, info_label; 
GButton dijkstra_btn, add_edge_btn; 
GTextField addEdge1, addEdge2;
GTextArea statusDescription;








PImage map;
PFont font;
int borderingDistance = 150; // placeholder for now
boolean showEdges = false, showEdgeDist = false, firstEdges = true;
boolean showDijkstra = false, showCountryInfo = false, successStatus = true;  // gui
String addEdgeStatus = "N"; // dubs as a boolean N = none | S = success | F = fail
String startingCountry, endingCountry, passingCountry, startingCity, endingCity, passingCity, selectedCountry, addedEdge1, addedEdge2;    // from the dropdown
int dijkstraDistance;
String dijkstraOutput, dijkstraRoute;

//Arrays
ArrayList<Node> nodes = new ArrayList<Node>();
ArrayList<Edge> edges = new ArrayList<Edge>();

public void setup(){
    /* size commented out by preprocessor */;
    // start the surface on the top left corner of computer screen
    surface.setLocation(0, 0);
    map = loadImage("europe.jpg");
    createGUI();
    /* smooth commented out by preprocessor */;
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
    nodes.add(new Node("Norway", 583, 247, 20));
    nodes.add(new Node("Poland", 748, 424, 19));
    nodes.add(new Node("Italy", 610, 635, 19));
    nodes.add(new Node("United Kingdom", 408, 441, 18));
    nodes.add(new Node("Romania", 830, 585, 18));
    nodes.add(new Node("Belarus", 854, 388, 17));
    nodes.add(new Node("Greece", 795, 707, 16));
    
    for(Node node:nodes){
        node.addDefaultNeighbors();
        node.printNeighbors();
        node.createEdges(false);
    }
    firstEdges=false;
}

public void draw(){
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

    // semi-transparent rectangles on the left side
    fill(2, 30, 107, 120);
    rect(0, 600, 200, 200);
    fill(97, 5, 39, 120);
    rect(0, 200, 200, 400);

    // placeholder?
    fill(0);
    if(showCountryInfo && selectedCountry != null){
      text(selectedCountry, 10, 250);
    }
    else{
      text("Select a country on the UI to display information", 10, 250);
    }

    // draw node and edges
    for(Node node: nodes){
        node.drawNode();

        // update this variable for gui purposes
        if(node.isSelected){
            selectedCountry = node.country;
        }
    }
    
    if(showEdges){
        for(Edge edge: edges){
            edge.showEdge();
        }
        for(Edge edge: edges){
            edge.showEdgeDist();
        }
    }
}

// return the Node with name of country
public Node returnNodeWithName(String name){
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
public int returnNodePosition(Node n1){
    for(int n = 0; n<nodes.size(); n++){
        if(nodes.get(n) == n1){
            return n;
        }
    }
    return 0;
}

// return the Edge between two Nodes
public Edge returnEdge(Node n1, Node n2){
    for(Edge edge: edges){
        if(edge.n1 == n1 && edge.n2 == n2){
            return edge;
        }
    }
    return null;
}

// return the index of the Edge between two Nodes
public int returnEdgeIndex(Node n1, Node n2){
    for(int i = 0; i<edges.size(); i++){
        if(edges.get(i).n1 == n1 && edges.get(i).n2 == n2){
            return i;
        }
    }
    return 0;
}

// split the country and city and return the country part
public String returnCountry(String input){
    String[] cityAndCountry = split(input, ", ");
    return cityAndCountry[1];
}

// split the country and city and return the city part
public String returnCity(String input){
    String[] cityAndCountry = split(input, ", ");
    return cityAndCountry[0];
}


  public void settings() { size(1100, 750);
smooth(); }

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "mouse" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
