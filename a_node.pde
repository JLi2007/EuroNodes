class Node{
    String country;
    float x,y;
    float radius;
    color defaultColour;  //default color and stroke
    color defaultStroke;
    color selectedColour; //selected color and stroke
    color selectedStroke;
    color currentColour;  //current color and stroke
    color currentStroke;
    boolean isSelected;
    HashMap<String, Integer> borderingCountries;

    Node(String name, float x, float y, float r){
        this.country = name;
        this.x = x;
        this.y = y;
        this.radius = r;
        this.defaultColour = color(44, 94, 232,100);     //default node color | blue
        this.defaultStroke = color(2, 30, 107);        //default node color stroke| darker blue
        this.selectedColour = color(191, 8, 75,100);     //when node is clicked | red & pink 
        this.selectedStroke = color(97, 5, 39);        //when node is clicked stroke | darker red & pink
        this.currentColour = this.defaultColour;       //initial state
        this.currentStroke = this.defaultStroke;
        this.isSelected = false;
        this.borderingCountries = new HashMap<String, Integer>();
    }

    // on mouse event
    void updateState(){
        if(isMouseInside()){
            if (!this.isSelected){
                println("clicked " + this.country);
                this.currentColour = this.selectedColour;
                this.currentStroke = this.selectedStroke;
                this.isSelected = true;
            }
        }else{
          if (this.isSelected){
                println("released " + this.country);
                this.currentColour = this.defaultColour;
                this.currentStroke = this.defaultStroke;
                this.isSelected = false;
            }
        }
    }

    void addDefaultNeighbors(){
        for(int n = 0; n<=nodes.size()-1; n++){
            int d = calculateDistance(this, nodes.get(n));
            if(d!=0 && d<borderingDistance){
                this.borderingCountries.put(nodes.get(n).country, d);
            }
        }
    }

    // prints the hashmap to visualize the neighbors in terminal
    void printNeighbors(){
        println("-------------------------------------");
        println(this.country + "'s neighbors: ");
        for (Map.Entry country : this.borderingCountries.entrySet()) {
            print(country.getKey() + " is ");
            println(country.getValue() + " units away");
        }
    }

    // checks if mouse is inside the node
    boolean isMouseInside(){
        return dist(mouseX, mouseY, this.x, this.y) <= this.radius;
    }

    // calculate distance between two nodes
    int calculateDistance(Node n1, Node n2){
        return int(dist(n1.x, n1.y, n2.x, n2.y));
    }

    void drawNode(){
        strokeWeight(5);
        stroke(this.currentStroke);
        fill(this.currentColour);
        circle(this.x,this.y,2*this.radius);
    }
}