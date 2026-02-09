final int NO_PARTICLES = 100 ;
final int MY_WIDTH = 500 ;
final int MY_HEIGHT = 500 ;

Particle[] particles ;

int xStart, yStart, xEnd, yEnd ;
PVector force ;

// initialise screen and particle array
void setup() {
  size(500, 500) ;
  particles = new Particle[NO_PARTICLES] ;
  for (int i = 0; i < NO_PARTICLES; i++) 
    particles[i] = new Particle((int)random(0,MY_WIDTH),
                                (int)random(0,MY_HEIGHT),
                                random(-.5f,.5f),
                                random(-.5f,.5f),
                                random(0.001f,0.005f)) ;
  force = new PVector(5f,5f) ;
}

// update particles, render.
void draw() {
  background(128) ;
  if (mousePressed) line (xStart, yStart, mouseX, mouseY) ;
  for (int i = 0; i  < NO_PARTICLES; i++) {
    particles[i].integrate(force) ;
    PVector position = particles[i].position ;
    float invMass = particles[i].invMass ;
    if (invMass <= 0.002f) fill(0) ;
    else if (invMass <= 0.003f) fill(100) ;
    else if (invMass <= 0.004f) fill(200) ;
    else fill(255) ;
    rect(position.x, position.y, 5, 5) ; 
  }
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
  force = new PVector(xEnd - xStart, yEnd - yStart) ;
}
