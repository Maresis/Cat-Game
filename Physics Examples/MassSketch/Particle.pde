// a representation of a point mass
final class Particle {
  
  // Vectors to hold pos, vel
  // I'm allowing public access to keep things snappy.
  public final PVector position, velocity ;
  
  // damping factor to simulate drag, as per Millington
  private static final float DAMPING = .995f ;
  
  // Store inverse mass to allow simulation of infinite mass
  private float invMass ;
  
  Particle(int x, int y, float xVel, float yVel, float invM) {
    position = new PVector(x, y) ;
    velocity = new PVector(xVel, yVel) ;
    invMass = invM ;    
  }
  
  // update position and velocity
  // Takes a force as a parameter for this demonstration
  void integrate(PVector force) {
    // If infinite mass, we don't integrate
    if (invMass <= 0f) return ;
    
    // update position
    position.add(velocity) ;
    
    PVector acceleration = force.get() ;
    acceleration.mult(invMass) ;
    
    // update velocity
    velocity.add(acceleration) ;
    // apply damping
    velocity.mult(DAMPING) ;
    // Apply an impulse to bounce off the edge of the screen
    if ((position.x < 0) || (position.x > width)) velocity.x = -velocity.x ;
    if ((position.y < 0) || (position.y > height)) velocity.y = -velocity.y ;     
  }
}
