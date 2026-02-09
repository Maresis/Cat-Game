// Global vars: 

int xStart, yStart, xEnd, yEnd ;
float magnitude ;
PVector v, n ;
boolean started = false ;

// grab screen, initialise PVector variables
void setup() {
  fullScreen() ;
  v = new PVector(0, 0) ;
  n = new PVector(0, 0) ;
}

// clear background, render current vector and textual desc

void draw() {
  background(128);
  if (!started) {
    text("Click, drag to draw a vector", displayWidth/2, displayHeight/2) ;
    return ;
  }  
  if (!mousePressed)
    line (xStart, yStart, xEnd, yEnd) ;
  else
    line (xStart, yStart, mouseX, mouseY) ;
  text("xStart: " + xStart, 0, 10); 
  text("yStart: " + yStart, 100, 10);
  text("xEnd: " + xEnd, 0, 30); 
  text("yEnd: " + yEnd, 100, 30);
  text("Vector: ("+v.x+", "+v.y+")", 0, 50) ; 
  text("Magnitude: "+magnitude, 0, 70) ;
  text("Normal: ("+n.x+", "+n.y+")", 0, 90) ; 
}

// When mouse is pressed, store x, y coords

void mousePressed() {
  started = true ;
  xStart = mouseX ;
  yStart = mouseY ;
}

// When mouse is released create new vector relative to stored x, y coords
void mouseReleased() {
  xEnd = mouseX ;
  yEnd = mouseY ;
  v = new PVector(xEnd - xStart, yEnd - yStart) ;
  magnitude = v.mag() ;
  n = v.get() ;
  n.normalize() ;
}
