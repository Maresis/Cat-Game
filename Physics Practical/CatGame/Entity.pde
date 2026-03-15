import java.util.ArrayList;
import java.util.Arrays;
/*
 This class represents any entity in the game that is affected by the physics engine.
*/
class Entity{
    // Particle array to represent the particles that make up an Entity
    // all entities have hit boxes. If these hit boxes collide with something do something
    private ArrayList<Particle> particles;

    private ForceRegistry forceRegistry;

    // different between entities
    // might be redundant but we will keep for now
    protected float moveIncrement;

    //just to track entities affects. If a player entity and a hostile entity collide the player dies.
    protected Boolean hostile = Boolean.FALSE;

    public Entity(){
        ForceRegistry = new ForceRegistry();

    }

    public void draw(){
        //by deafult entities will just be represented by a shape of thier particles position
        beginShape();
            for(Particle p: particles){
                particle.integrate();
                // position is a PVector in particle
                vertex(particle.position.x, particle.position.y);
            }
        endShape(CLOSE);

    }

    public void update(){
        forceRegistry.updateForces();
    }

    public void clearForces(){
        ForceRegistry.clear();
    }

    public void addForce(ForceGenerator fg){
        for(Particle p: particles){
            // add force to particle
            ForceRegistry.add(p, fg);
        }
    }



}