// Global vars: 

int x1, x2, x3, y1, y2, y3 ;
boolean started, drawing, drawingV1 ;
PVector v1, v2, v3 ;

// Specify canvas size, initialise PVector variables
void setup() {
  fullScreen() ;
  v1 = new PVector(0, 0) ;
  v2 = new PVector(0, 0) ;
  v3 = new PVector(0, 0) ;
  started = false ;
  drawing = false ;
  drawingV1 = false ;
}

// clear background, render current vector and textual desc
void draw() {
  background(128);
  if (!started) {
    text("Click, drag to draw 1st vector, click to define 2nd vector",
         displayWidth/2, displayHeight/2) ;
    return ; 
  }  
  if (!drawing) {
    stroke(0) ;
    line (x1, y1, x2, y2) ;
    line (x2, y2, x3, y3) ;
    stroke(255) ;
    line (x1, y1, x3, y3) ;
    text("x1: " + x1, 0, 10); 
    text("y1: " + y1, 100, 10);
    text("x2: " + x2, 0, 30); 
    text("y2: " + y2, 100, 30);
    text("x3: " + x3, 0, 50); 
    text("y3: " + y3, 100, 50);
    text("Vector1: ("+v1.x+", "+v1.y+")", 0, 70) ; 
    text("Vector2: ("+v2.x+", "+v2.y+")", 0, 90) ; 
    text("Vector1+Vector2: ("+v3.x+", "+v3.y+")", 0, 110) ; 
  }
  else if (drawingV1) {
    line (x1, y1, mouseX, mouseY) ; 
  }
  else {
    line (x1, y1, x2, y2) ;
    line (x2, y2, mouseX, mouseY) ; 
  }
}

// We only care if mouse pressed if not drawing.
void mousePressed() {
  started = true ;
  if (!drawing) {
    x1 = mouseX ;
    y1 = mouseY ;
    drawing = true ;
    drawingV1 = true ;
  }
}

// mouseReleased signifies end of each vector
void mouseReleased() {
  if (drawingV1) {
    x2 = mouseX ;
    y2 = mouseY ;
    drawingV1 = false ;
    v1 = new PVector(x2-x1, y2-y1) ;
  }
  else {
    x3 = mouseX ;
    y3 = mouseY ;
    v2 = new PVector(x3-x2, y3-y2) ;
    v3 = new PVector(x3-x1, y3-y1) ;
    drawing = false ; 
  }
}
