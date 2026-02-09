final int NO_PARTICLES = 100 ;
final int MY_WIDTH = 500 ;
final int MY_HEIGHT = 500 ;

Particle[] particles ;

int xStart, yStart, xEnd, yEnd ;

// A force generator that applies a force specified by the user.
UserForce userForce ;

// Holds all the force generators and the particles they apply to
ForceRegistry forceRegistry ;

// initialise screen and particle array
void setup() {
  size(500, 500) ;
  particles = new Particle[NO_PARTICLES] ;

  //Create a gravitational force
  Gravity gravity = new Gravity(new PVector(0f, .1f)) ;
  
  //Create a drag force
  //NB Increase k1, k2 to see an effect 
  Drag drag = new Drag(10, 10) ;
  
  //Create the user force
  userForce = new UserForce(new PVector(0f, 0f)) ;
  
  //Create the ForceRegistry
  forceRegistry = new ForceRegistry() ;  
  
  // Create particles, register gravity's 
  for (int i = 0; i < NO_PARTICLES; i++) {
    particles[i] = new Particle((int)random(0,MY_WIDTH),
                                (int)random(0,MY_HEIGHT),
                                random(-.5f,.5f),
                                random(-.5f,.5f),
                                random(0.001f,0.005f)) ;
    forceRegistry.add(particles[i], gravity) ;
    forceRegistry.add(particles[i], drag) ;
    forceRegistry.add(particles[i], userForce) ;
  }
}

// update particles, render.
void draw() {
  background(128) ;
  forceRegistry.updateForces() ;
  for (int i = 0; i  < NO_PARTICLES; i++) {
    particles[i].integrate() ;
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
  userForce.set(xEnd - xStart, yEnd - yStart) ;
}