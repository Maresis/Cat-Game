final int NO_PARTICLES = 9 ;
final int MY_WIDTH = 500 ;
final int MY_HEIGHT = 500 ;

Particle[] particles ;

PVector gravity ;

// initialise screen and particle array
void setup() {
  size(500, 500) ;
  background(0) ;
  particles = new Particle[NO_PARTICLES] ;
  for (int i = 0; i < NO_PARTICLES; i++) 
    particles[i] = new Particle((int)random(0,MY_WIDTH),
                                (int)random(0,MY_HEIGHT),
                                random(-.5f,.5f),
                                random(-.5f,.5f),
                                random(0.001f,0.005f)) ;
  gravity = new PVector(0f,0f) ;
}

// update particles, render.
void draw() {
  //the star
  ellipse(MY_WIDTH/2, MY_HEIGHT/2,10,10) ;
  //the particles  
  for (int i = 0; i  < NO_PARTICLES; i++) {
    Particle p = particles[i] ;
    // calculate gravity vector
    gravity.x = MY_WIDTH/2-p.position.x ;
    gravity.y = MY_HEIGHT/2-p.position.y ;
    // scale it with distance
    float distance = gravity.mag() ;
    gravity.mult(1/distance) ;
    
    particles[i].integrate(gravity) ;
    PVector position = particles[i].position ;
    float invMass = particles[i].invMass ;
    if (invMass <= 0.002f) stroke(64) ;
    else if (invMass <= 0.003f) stroke(128) ;
    else if (invMass <= 0.004f) stroke(192) ;
    else stroke(255) ;
    point(position.x, position.y) ; 
  }
}

// clear screen
void mousePressed() {
  background(0) ; 
}