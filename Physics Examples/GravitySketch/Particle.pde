// a representation of a point mass
final class Particle {
  
  // Vectors to hold pos, vel
  // I'm allowing public access to keep things snappy.
  public final PVector position, velocity ;
    
  // Store inverse mass to allow simulation of infinite mass
  private float invMass ;
  
  Particle(int x, int y, float xVel, float yVel, float invM) {
    position = new PVector(x, y) ;
    velocity = new PVector(xVel, yVel) ;
    invMass = invM ;    
  }
  
  // update position and velocity
  // Takes gravity as a parameter for this demonstration
  void integrate(PVector gravity) {
    // If infinite mass, we don't integrate
    if (invMass <= 0f) return ;
    
    // update position
    position.add(velocity) ;
    
    PVector acceleration = gravity.copy() ;
    acceleration.mult(invMass) ;
    
    // update velocity
    velocity.add(acceleration) ;
  }
}
