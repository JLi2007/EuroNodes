void mousePressed(){
    for(Node node: nodes){
        node.updateState();
    }
}