// content taken from lecture material on physics engines
/*
 * A force generator can be asked to add forces to
 * one or more particles.
 */
abstract class ForceGenerator {
  abstract void updateForce(Particle p) ;
}
