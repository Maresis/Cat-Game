// Global vars: 
int xStart, yStart, xEnd, yEnd ;
PVector p, v, a ;

// Specify canvas size, initialise PVector variables
void setup() {
  fullScreen() ;
  p = new PVector(150, 150) ;
  v = new PVector(0, 0) ;
  a = new PVector(.01, .01) ;
}

// clear background, render object and textual desc
void draw() {
  background(128);
  if (mousePressed)
    line(xStart, yStart, mouseX, mouseY) ;
  v.add(a) ;
  p.add(v) ;
  rect(p.x, p.y, 100, 100) ;
  text("Velocity: ("+v.x+", "+v.y+")", 0, 10) ; 
  text("Acceleration: ("+a.x+", "+a.y+")", 0, 30) ;  
}

// When mouse is pressed, store x, y coords
void mousePressed() {
  xStart = mouseX ;
  yStart = mouseY ;
}

// When mouse is released create new vector relative to stored x, y coords
void mouseReleased() {
  xEnd = mouseX ;
  yEnd = mouseY ;
  a = new PVector((xEnd - xStart)/1000f, (yEnd - yStart)/1000f) ;
}
