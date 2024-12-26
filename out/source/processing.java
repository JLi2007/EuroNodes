/* autogenerated by Processing revision 1293 on 2024-12-26 */
import processing.core.*;
import processing.data.*;
import processing.event.*;
import processing.opengl.*;

import java.util.HashMap;
import java.util.ArrayList;
import java.io.File;
import java.io.BufferedReader;
import java.io.PrintWriter;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.IOException;

public class processing extends PApplet {

PImage map;
PFont font;

public void setup(){
    /* size commented out by preprocessor */;
    map = loadImage("europe.jpg");
    background(map);

    // font
    font = createFont("SansSerif", 15);
    textFont(font);
    textAlign(CENTER, CENTER);

    println(PFont.list());

    // create all the countries
}

public void draw(){
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
class Node{
    String country;
    float x,y;
    HashMap<String, Integer> borderingCountries;

    Node(String countryName, float x, float y){
        this.country = countryName;
        this.x = x;
        this.y = y;
        this.borderingCountries = new HashMap<String, Integer>();
    }
     
}


  public void settings() { size(1250, 750); }

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "processing" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}