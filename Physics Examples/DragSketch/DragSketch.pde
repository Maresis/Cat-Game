final int NO_PARTICLES = 100 ;
final int MY_WIDTH = 300 ;
final int MY_HEIGHT = 300 ;

Particle[] particles ;

// initialise screen and particle array
void setup() {
  size(300, 300) ;
  particles = new Particle[NO_PARTICLES] ;
  for (int i = 0; i < NO_PARTICLES; i++) 
    particles[i] = new Particle((int)random(0,MY_WIDTH),
                                (int)random(0,MY_HEIGHT),
                                random(-.5f,.5f),
                                random(-.5f,.5f),
                                0f,0f) ;
}

// update particles, render.
void draw() {
  background(128) ;
  for (int i = 0; i  < NO_PARTICLES; i++) {
    particles[i].integrate() ;
    PVector position = particles[i].position ;
    rect(position.x, position.y, 5, 5) ; 
  }
}