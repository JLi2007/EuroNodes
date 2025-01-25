// Mouse functions

// when mouse is pressed, update node states
void mousePressed(){
    for(Node node: nodes){
        node.unselectState();
    }
    for(Node node: nodes){
        node.selectState();
    }
}