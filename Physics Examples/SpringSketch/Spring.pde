/**
 * A force generator that applies a spring force.
 */
public final class Spring extends ForceGenerator {
  // The particle at the other end of the spring
  Particle other ;
  
  // The spring constant
  float k ;
  
  // Natural length of the spring
  float l0 ;
  
  // Creates a new spring with the given parameters
  public Spring(Particle other, float k, float l0) {
    this.other = other ;
    this.k = k ;
    this.l0 = l0 ;
  }
  
  // Applies the spring force to the given particle
  // -k × (magnitude of d – l0) × normal(d)
  public void updateForce(Particle particle) {
    // Calculate the vector of the spring
    PVector d = particle.position.get() ;
    d.sub(other.position.get()) ;
    
    // Calculate force magnitude
    float magnitude = d.mag() ;
    magnitude = magnitude - l0 ;
    magnitude *= k ;
    
    // Calculate the final force, apply it.
    d.normalize() ;
    d.mult(-magnitude) ;
    particle.addForce(d) ;
  }
}
