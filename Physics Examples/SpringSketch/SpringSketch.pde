final int MY_WIDTH = 500 ;
final int MY_HEIGHT = 500 ;

// For the mouse velocity drawing
int xStart, yStart ;

// Suggested values: 75 (to see initial expansion)
//                   125 (to see initial compression)
final int REST_LENGTH = 125 ;
final float SPRING_CONSTANT = .2 ;

// 2 particles for the demo
Particle p1, p2 ;

// Holds all the force generators and the particles they apply to
ForceRegistry forceRegistry ;

// initialise screen and particle array
void setup() {
  size(500, 500) ;
  
  // Start them 100 apart
  p1 = new Particle(150, 250, 0, 0, 0.005f) ;
  p2 = new Particle(250, 250, 0, 0, 0.005f) ;

  //Create the ForceRegistry
  forceRegistry = new ForceRegistry() ;  

  //Create & register a spring force on p1 from p2
  Spring spring1 = new Spring(p2, SPRING_CONSTANT, REST_LENGTH) ;
  forceRegistry.add(p1, spring1) ;
  //Create & register a spring force on p2 from p1
  Spring spring2 = new Spring(p1, SPRING_CONSTANT, REST_LENGTH) ;
  forceRegistry.add(p2, spring2) ;
  
}

// update particles, render.
void draw() {
  background(128) ;
  forceRegistry.updateForces() ;
  p1.integrate() ;
  p2.integrate() ;
  // draw spring
  line(p1.position.x, p1.position.y, p2.position.x, p2.position.y) ;
  // draw particles
  fill(255) ;
  ellipse(p1.position.x, p1.position.y, 15, 15) ;
  fill(0) ;
  ellipse(p2.position.x, p2.position.y, 15, 15) ;  
}

// When mouse is pressed, store x, y coords
void mousePressed() {
  xStart = mouseX ;
  yStart = mouseY ;
}

// When mouse is released create new vector relative to stored x, y coords
void mouseReleased() {
  p1.velocity = new PVector(mouseX - xStart, mouseY - yStart) ;
}