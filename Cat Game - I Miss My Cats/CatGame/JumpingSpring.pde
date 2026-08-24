// copied code from Spring in lecture material and modified it to work for this purpose
/**
    The main modification of this force compared to normal springs is that it only exacts the full force of the
    spring in one frame (from a compressed spring). I did this because I felt like it was the most similar to a cat's jump
    plus gravity naturally bring the player back down. I had to represent two particles as well due to the complexity
    caused by offsets and the tile map system. Forces had to be applied to the player like they were moving without 
    them moving at all. 
  */

/**
 * A force generator that applies a spring force.
 */
public final class JumpingSpring extends ForceGenerator {

  boolean disable = false;
  // The particle at the other end of the spring
  Particle other ;
  
  // The spring constant
  float k ;
  
  // Natural length of the spring
  float l0 ;
  
  // Creates a new spring with the given parameters
  public JumpingSpring(Particle other, float k, float l0) {
    this.other = other ;
    this.k = k ;
    this.l0 = l0 ;
  }
  
  // Applies the spring force to the given particle
  // -k × (magnitude of d – l0) × normal(d)
  public void updateForce(Particle particle) {
    if(!disable){// Calculate the vector of the spring
      PVector d = particle.position.get() ;
      d.sub(other.position.get()) ;
      
      // Calculate force magnitude
      float magnitude = d.mag() ;
      magnitude = magnitude - l0 ;
      magnitude *= k ;
      
      // Calculate the final force, apply it.
      d.normalize() ;
      d.mult(-magnitude) ;
      
      //activated one time
        disable = true;
      
      particle.addForce(d) ;
    }
  }
}
