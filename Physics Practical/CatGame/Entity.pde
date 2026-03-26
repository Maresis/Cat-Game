import java.util.ArrayList;
import java.util.Arrays;
/*
 This class represents any entity in the game that is affected by the physics engine.
*/
class Entity{
    // Particle array to represent the particles that make up an Entity
    // all entities have hit boxes. If these hit boxes collide with something do something
    // have to be public so I can add forces to them the other way
    public ArrayList<Particle> particles;

    protected ForceRegistry forceRegistry;

    // collisions <3
    protected CollisionSystem testCollision;

    // different between entities
    // might be redundant but we will keep for now
    protected int moveIncrement;

    protected float invMass;

    //just to track entities affects. If a player entity and a hostile entity collide the player dies.
    protected boolean hostile = false;

    protected int spawnX;

    protected int spawnY;

    protected boolean onScreen;

    protected boolean alive = true;

    protected int type = 0;

    //default width and height
    protected int width = Tile.TILE_LENGTH;
    protected int height = Tile.TILE_LENGTH;

    //default invmass
    protected final float normalInvMass = .01;


    public Entity(){
        forceRegistry = new ForceRegistry();
        particles = new ArrayList<Particle>();
        testCollision = new CollisionSystem();
    }

    public int draw(float offsetX, float offsetY){
        //by deafult entities will just be represented by a shape of thier particles position
        fill(0);
        beginShape();
            for(Particle p: particles){
                p.integrate();
                // position is a PVector in particle
                vertex(p.position.x - offsetX, p.position.y - offsetY);
            }
        endShape(CLOSE);
        return 0;
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

    public int getType(){
        return type;
    }

    public boolean onScreen( float tilePosX, float tilePosY){
        //determine if the entity is on the screen in it hasn't been on screen before
        if(alive && !onScreen){
            // set ranges for x
            int lowXRange = floor(tilePosX/Tile.TILE_LENGTH) - (tileLengthRange/2);
            int highXRange = ceil(tilePosX/Tile.TILE_LENGTH + (tileLengthRange/2));

            //set ranges for y
            int lowYRange = floor((tilePosY/Tile.TILE_LENGTH) - (tileHeightRange/2));
            int highYRange = ceil((tilePosY/Tile.TILE_LENGTH) + (tileHeightRange/2));

            for(int x = lowXRange; x < highXRange; x++){
                for(int y = lowYRange; y < highYRange; y++){
                    if((x ==spawnX ) && (y == spawnY)){
                        print("You made it to the onscreen function");
                        this.onScreen = true; //the entitiy is on screen

                        break;
                    }

                }
            }
        }
        return onScreen;
    }


}

