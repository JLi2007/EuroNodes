class Node{
    String country;
    float x,y;
    float radius;
    color defaultColour; 
    color defaultStroke;
    color selectedColour;
    color selectedStroke;
    color currentColour; 
    color currentStroke;
    boolean isSelected;
    HashMap<String, Integer> borderingCountries; //Java hashmap

    Node(String name, float x, float y, float r){
        this.country = name;
        this.x = x;
        this.y = y;
        this.radius = r;
        this.defaultColour = color(44, 94, 232, 100);  //default node color | blue
        this.defaultStroke = color(2, 30, 107);        //default node color stroke| darker blue
        this.selectedColour = color(191, 8, 75, 100);  //when node is clicked | red & pink 
        this.selectedStroke = color(97, 5, 39);        //when node is clicked stroke | darker red & pink
        this.currentColour = this.defaultColour;       //initial state
        this.currentStroke = this.defaultStroke;
        this.isSelected = false;
        this.borderingCountries = new HashMap<String, Integer>();
    }

    // on mouse event
    void unselectState(){
        // unselect node case 1 | another node is selected
        if (this.isSelected && !isMouseInside() && !isMouseOnUI()){
            println("released " + this.country);
            this.currentColour = this.defaultColour;
            this.currentStroke = this.defaultStroke;
            this.isSelected = false;
            createEdges(false);
            showCountryInfo = false;
        }
    }

    // on mouse event
    void selectState(){
        // select node | this node is clicked
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

    // checks if mouse is inside the node
    boolean isMouseInside(){
        return dist(mouseX, mouseY, this.x, this.y) <= this.radius;
    }

    // checks if the mouse is inside the ui
    boolean isMouseOnUI(){
        if(mouseX>0 && mouseX<200 && mouseY>200 && mouseY<800){
            return true;
        }
        return false;
    }

    // add all "default neighbors"
    void addDefaultNeighbors(){
        for(int n = 0; n<=nodes.size()-1; n++){
            int d = calculateDistance(this, nodes.get(n));
            if(d<borderingDistance){ //only add if the distance is under the borderingDistance variable
                this.borderingCountries.put(nodes.get(n).country, d);
            }
        }
    }

    // adds a neighbor both ways
    void addAdditionalNeighbor(Node n1){
        int d = calculateDistance(this, n1);
        this.borderingCountries.put(n1.country, d);
        n1.borderingCountries.put(this.country, d);
    }
    
    // removes a neighbor both ways
    void removeNeighbor(Node n1){
        this.borderingCountries.remove(n1.country);
        n1.borderingCountries.remove(this.country); 
    }

    // prints the hashmap to visualize the neighbors in terminal
    void printNeighbors(){
        println(this.country + "'s neighbors: ");

        // sort by increasing distances when printing to terminal 
        // if they are printed without sorting, they are in random order (default hashmap behavior)
        // use java comparator and lists
        List<Map.Entry<String, Integer>> sortedBorderingCountries = new ArrayList<>(this.borderingCountries.entrySet());
        sortedBorderingCountries.sort(Comparator.comparing(Map.Entry<String, Integer>::getValue)); 

        // print the sorted neighbors
        for (Map.Entry country : sortedBorderingCountries) {
            print(country.getKey() + " is ");
            println(country.getValue() + " units away");
        }
        println("-------------------------------------");
    }

    // sorts the hashmap to return the closest and furthest neighbor
    String[] returnNeighbors(){
        String[] returnString = new String[this.borderingCountries.size()];

        // sort the hashmap
        List<Map.Entry<String, Integer>> sortedBorderingCountries = new ArrayList<>(this.borderingCountries.entrySet());
        sortedBorderingCountries.sort(Comparator.comparing(Map.Entry<String, Integer>::getValue)); 

        int c = 0;

        // return the first and last indexes of the sorted hashmap, guaranteeing them to be the closest and farthest border
        for (Map.Entry country: sortedBorderingCountries){
            if(c==1){
                returnString[0] = country.getKey().toString();
            }
            if(c==sortedBorderingCountries.size() - 1){
                returnString[1] = country.getKey().toString();
            }
            c++;
        }

        return returnString;
    }

    // create edges with all its neighbors
    void createEdges(boolean selected){

        // for each country in this.bordering countries, remove previous instances, then add the new edge
        for (Map.Entry<String, Integer> country : this.borderingCountries.entrySet()) {
            // retrieve the other node
            Node n = returnNodeWithName(country.getKey());

            if(n!=null){
                // remove the previous edge (if applicable)
                if(!firstEdges){
                    int removeEdge = returnEdgeIndex(this, n);
                    if(removeEdge != 0){
                        edges.remove(removeEdge);
                    }
                }

                // add the new edge
                edges.add(new Edge(this, n, country.getValue(), selected));
            }
        }
    }

    // calculate distance between two nodes
    int calculateDistance(Node n1, Node n2){
        return int(dist(n1.x, n1.y, n2.x, n2.y));
    }

    // draw node with the correct colours
    void drawNode(){
        strokeWeight(5);
        stroke(this.currentStroke);
        fill(this.currentColour);
        circle(this.x,this.y,2*this.radius);
    }
}