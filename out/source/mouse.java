/* autogenerated by Processing revision 1293 on 2025-01-02 */
import processing.core.*;
import processing.data.*;
import processing.event.*;
import processing.opengl.*;

import g4p_controls.*;
import java.util.Map;
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
        this.defaultColour = color(44, 94, 232,100);   //default node color | blue
        this.defaultStroke = color(2, 30, 107);        //default node color stroke| darker blue
        this.selectedColour = color(191, 8, 75,100);   //when node is clicked | red & pink 
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
        }

        // unselect node case 2 | the node is already selected and it gets clicked again
        else if(this.isSelected && isMouseInside()){
            println("released " + this.country);
            this.currentColour = this.defaultColour;
            this.currentStroke = this.defaultStroke;
            this.isSelected = false;
            createEdges(false);
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
        println("-------------------------------------");
        println(this.country + "'s neighbors: ");
        for (Map.Entry country : this.borderingCountries.entrySet()) {
            print(country.getKey() + " is ");
            println(country.getValue() + " units away");
        }
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
        this.weight = 5;
        if(selected){
            this.currentStroke = this.selectedStroke;
            this.inverseCurrentStroke = this.defaultStroke;
            this.weight = 6;
        }else{
            this.currentStroke = this.defaultStroke;
            this.inverseCurrentStroke = this.selectedStroke;
        }
    }

    public void showEdge(){
        strokeWeight(this.weight);
        stroke(this.currentStroke);
        line(n1.x, n1.y, n2.x, n2.y);
        if(showEdgeDist){
            showEdgeDist();
        }
    }

    public void showEdgeDist(){
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
public int[] runDijkstra(Node n1){ 
    dijkstraArray = new int[nodes.size()];
    int startingNode = returnNodePosition(n1);
    int nodesSize = nodes.size();
    int[] distances = new int[nodesSize];
    boolean[] visited = new boolean[nodesSize];

    for (int i = 0; i < nodesSize; i++) {
        distances[i] = Integer.MAX_VALUE;
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
                    }
                }
            }
        }
    }
    return distances;
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
/* =========================================================
 * ====                   WARNING                        ===
 * =========================================================
 * The code in this tab has been generated from the GUI form
 * designer and care should be taken when editing this file.
 * Only add/edit code inside the event handlers i.e. only
 * use lines between the matching comment tags. e.g.

 void myBtnEvents(GButton button) { //_CODE_:button1:12356:
     // It is safe to enter your event code here  
 } //_CODE_:button1:12356:
 
 * Do not rename this tab!
 * =========================================================
 */
synchronized public void draw_toolbarWindow(PApplet appc, GWinData data) { //_CODE_:toolbarWindow:990813:
  appc.background(230);
} //_CODE_:toolbarWindow:990813:

public void edgesChecked(GCheckbox source, GEvent event) { //_CODE_:edgesCheck:657761:
  showEdges = !showEdges;
} //_CODE_:edgesCheck:657761:

public void edgeDistChecked(GCheckbox source, GEvent event) { //_CODE_:edgesCheck:657761:
  showEdgeDist = !showEdgeDist;
} //_CODE_:edgesCheck:657761:


public void selectStartingCountry(GDropList source, GEvent event) { //_CODE_:Starting:463717:
  startingNode = returnCountry(startingSelect.getSelectedText());
} //_CODE_:Starting:463717:

public void initDijkstra(GButton source, GEvent event) { //_CODE_:dijkstra_btn:278201:
  if(startingNode != null){
    dijkstraArray = runDijkstra(returnNodeWithName(startingNode));
    printArray(dijkstraArray);
    println("ran dijkstra and populated array var");
  }
} //_CODE_:dijkstra_btn:278201:

// Create all the GUI controls. 
// autogenerated do not edit
public void createGUI(){
  G4P.messagesEnabled(false);
  G4P.setGlobalColorScheme(GCScheme.BLUE_SCHEME);
  G4P.setMouseOverEnabled(false);
  surface.setTitle("Euro•Nodes");

  toolbarWindow = GWindow.getWindow(this, "Toolbar", 1100, 0, 400, 400, JAVA2D);
  toolbarWindow.noLoop();
  toolbarWindow.setActionOnClose(G4P.KEEP_OPEN);
  toolbarWindow.addDrawHandler(this, "draw_toolbarWindow");
  toolbarWindow.loop();

  edgesCheck = new GCheckbox(toolbarWindow, 50, 10, 200, 50);
  edgesCheck.setFont(new Font("SansSerif", Font.PLAIN, 18));
  edgesCheck.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  edgesCheck.setText(" Show Edges");
  edgesCheck.setOpaque(false);
  edgesCheck.addEventHandler(this, "edgesChecked");

  edgeDistCheck = new GCheckbox(toolbarWindow, 200, 10, 200, 50);
  edgeDistCheck.setFont(new Font("SansSerif", Font.PLAIN, 18));
  edgeDistCheck.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  edgeDistCheck.setText(" Show Edge Dists");
  edgeDistCheck.setOpaque(false);
  edgeDistCheck.addEventHandler(this, "edgeDistChecked");

  startingSelect = new GDropList(toolbarWindow, 50, 120, 150, 150, 5, 10);
  startingSelect.setItems(loadStrings("list_countries"), 0);
  startingSelect.addEventHandler(this, "selectStartingCountry");
  starting_label = new GLabel(toolbarWindow, 50, 90, 150, 20);
  starting_label.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  starting_label.setText("Where To Start");
  starting_label.setOpaque(false);
  starting_label.setFont(new Font("SansSerif", Font.PLAIN, 14));

  dijkstra_btn = new GButton(toolbarWindow, 150, 200, 100, 30);
  dijkstra_btn.setText("Run Algo");
  dijkstra_btn.addEventHandler(this, "initDijkstra");

  startingNode = returnCountry(startingSelect.getSelectedText());
}

// Variable declarations 
// autogenerated do not edit
GWindow toolbarWindow;
GCheckbox edgesCheck, edgeDistCheck; 
GDropList startingSelect; 
GLabel starting_label; 
GButton dijkstra_btn; 




PImage map;
PFont font;
int borderingDistance = 300; //placeholder for now
boolean showEdges = false, showEdgeDist = false, firstEdges = true;
String startingNode;    //from the dropdown
int[] dijkstraArray;

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
public Node returnNodeWithName(String name){
    for(Node node: nodes){
        if(node.country.equals(name)){
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
