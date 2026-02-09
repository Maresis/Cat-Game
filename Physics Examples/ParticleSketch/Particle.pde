// a representation of a point mass
final class Particle {
  
  // Three vectors to hold pos, vel, acceleration
  // I'm allowing public access to keep things snappy.
  public final PVector position, velocity, acceleration ;
  
  // Default is to sit at the origin
  Particle() {
    position = new PVector(0, 0) ;
    velocity = new PVector(0, 0) ;
    acceleration = new PVector(0, 0) ; 
  }
  
  // Otherwise do something more interesting
  Particle(int x, int y, float xVel, float yVel, float xAcc, float yAcc) {
    position = new PVector(x, y) ;
    velocity = new PVector(xVel, yVel) ;
    acceleration = new PVector(xAcc, yAcc) ;
  }
  
  // update position and velocity
  void integrate() {
    position.add(velocity) ;
    velocity.add(acceleration) ;
    // Apply an impulse to bounce off the edge of the screen
    if ((position.x < 0) || (position.x > width)) velocity.x = -velocity.x ;
    if ((position.y < 0) || (position.y > height)) velocity.y = -velocity.y ;     
  }
}
