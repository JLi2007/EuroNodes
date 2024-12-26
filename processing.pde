PImage map;
PFont font;

//Arrays
ArrayList<Node> nodes = new ArrayList<Node>();

//Colors
color color1 = color(44, 94, 232);  //default node color | blue
color color2 = color (191, 8, 75); //when node is clicked | red & pink 

void setup(){
    size(1250,750);
    map = loadImage("europe.jpg");
    background(map);

    // font
    font = createFont("SansSerif", 15);
    textFont(font);
    textAlign(CENTER, CENTER);

    // create all the countries (nodes)
}

void draw(){
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
}