void mousePressed(){
    for(Node node: nodes){
        node.unselectState();
    }
    for(Node node: nodes){
        node.selectState();
    }
}