// taken from lecture materials on physics
// modified a bit to work with project.
// a representation of a point mass
final class Particle {
  
  // Vectors to hold pos, vel
  // I'm allowing public access to keep things snappy.
  public PVector position, velocity ;
  
  // Vector to accumulate forces prior to integration
  private PVector forceAccumulator ; 
  
  // damping factor to simulate drag, as per Millington
  // Disabled when using Drag Force Generator
  // private static final float DAMPING = .995f ;
  
  // Store inverse mass to allow simulation of infinite mass
  private float invMass ;
  
  // If you do need the mass, here it is:
  public float getMass() {return 1/invMass ;}
  
  public Particle(int x, int y, float xVel, float yVel, float invM) {
    position = new PVector(x, y) ;
    velocity = new PVector(xVel, yVel) ;
    forceAccumulator = new PVector(0, 0) ;
    invMass = invM ;    
  }
  
  // Add a force to the accumulator
  void addForce(PVector force) {
    forceAccumulator.add(force) ;
  }

  void removeForce(PVector force){
    forceAccumulator.sub(force) ; 
  }

  // change invMass. Used to make Poe immovable while using special ability.
  void setInvMass(float invMass){
    this.invMass = invMass;
  }
  
  // update position and velocity
  void integrate() {
    // If infinite mass, we don't integrate
    if (invMass <= 0f) return ;
    
    // update position
    position.add(velocity) ;
    
    // NB If you have a constant acceleration (e.g. gravity) start with
    //    that then add the accumulated force / mass to that.
    PVector resultingAcceleration = forceAccumulator.get() ;
    resultingAcceleration.mult(invMass) ;
    
    // update velocity
    velocity.add(resultingAcceleration) ;
    // apply damping - disabled when Drag force present
    // velocity.mult(DAMPING) ;
    
    
    // Apply an impulse to bounce off the edge of the screen - simple version 
    
    // if ((position.x < 0) || (position.x > width)) velocity.x = -velocity.x ;
    // if ((position.y < 0) || (position.y > height)) velocity.y = -velocity.y ; 
    
    
    // More careful version of edge of screen impulse
    // if nonplayer particles hit the edge of the screen they die and are handled elsewhere
    // it is easier to test if a particles position is < 0 to check for death.
    // player particles physically cannot reach the end of the screen
    
    
    
    // Clear accumulator
    forceAccumulator.x = 0 ;
    forceAccumulator.y = 0 ;    
  }

  // we have to integrate the player differently since they never actually move on the screen
  // essentially we do all the physics math on a stand in that is used to calculate the offset.
  // This offset is then used to move literally everything else around the character, mimicing movement.
  public PVector playerIntegrate(){
    
    PVector offset = position.copy(); // clone position Pvector so we can add velocity to it without changing the position
    // update position
    offset.add(velocity) ;
    
    // NB If you have a constant acceleration (e.g. gravity) start with
    //    that then add the accumulated force / mass to that.
    PVector resultingAcceleration = forceAccumulator.get() ;
    resultingAcceleration.mult(invMass) ;
    
    // update velocity
    velocity.add(resultingAcceleration) ;
    // apply damping - disabled when Drag force present
    // velocity.mult(DAMPING) ;

    //so basically we return offset because using this we can calculate the offset based on the set position of the Particles
    // Clear accumulator
    forceAccumulator.x = 0 ;
    forceAccumulator.y = 0 ;  

    // If infinite mass, we don't integrate
    if (invMass <= 0f) return position; //return positions so offset will be the same
    
    return offset;
  }
}
