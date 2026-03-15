import java.util.ArrayList;
import java.util.Arrays;
/*
 This class represents any entity in the game that is affected by the physics engine.
*/
class Entity{
    // Particle array to represent the particles that make up an Entity
    // all entities have hit boxes. If these hit boxes collide with something do something
    protected ArrayList<Particle> particles;

    protected ForceRegistry forceRegistry;

    // different between entities
    // might be redundant but we will keep for now
    protected int moveIncrement;

    protected float invMass;

    //just to track entities affects. If a player entity and a hostile entity collide the player dies.
    protected Boolean hostile = Boolean.FALSE;

    public Entity(){
        forceRegistry = new ForceRegistry();
        particles = new ArrayList<Particle>();
    }

    public void draw(){
        //by deafult entities will just be represented by a shape of thier particles position
        fill(0);
        beginShape();
            for(Particle p: particles){
                p.integrate();
                // position is a PVector in particle
                vertex(p.position.x, p.position.y);
            }
        endShape(CLOSE);

    }

    public void update(){
        forceRegistry.updateForces();
    }

    public void clearForces(){
        forceRegistry.clear();
    }

    public void addForce(ForceGenerator fg){
        for(Particle p: particles){
            // add force to particle
            forceRegistry.add(p, fg);
        }
    }



}