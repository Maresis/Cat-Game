import java.util.ArrayList;

/*
    There are a couple things to keep in mind with the player.
    - Since this is a side scroller the character actually stays in the same place on the screen. Their coordinates never change.
    - To represent motion and the effects of physics, I will modify an offset that will move everything else on the screen accordingly.
    - This offset can be thought of as a "camera" of sorts. The world is built around the character.

    It's worth noting that the player chracter is a cat (this will be defined in a different class)

    What are some physical effects that the character should feel?
    - Gravity -- Priority
    - bouyancy + spring (cat's jump) springy jump and soft landing -- like to implement but we will see
    - 

*/
class Player extends Entity{
    // basic play properties
    // for now the cat hitbox is a square.
    private int width = Tile.TILE_LENGTH;
    private int height = Tile.TILE_LENGTH;

    //cats
    ArrayList<Cat> cats;
    private int currentCat;
    private final int numberOfCats = 3;

    //is the cat immune to damange
    private Boolean immune = false;

    private final float normalInvMass = .01;


    //offset that the position of the world is based off of
    //public to make it "snappy" lol
    public float tilePosX;
    public float tilePosY;

    boolean movingRight = false;
    boolean movingLeft = false;
    boolean climbing = false;
    boolean walking = true;
    boolean jumping = false;
    boolean canClimb = false;
    boolean alive = true;
    boolean win = false;

    ArrayList<Particle> jumpParticles;
    // jumpStart
    
    /*
        Creates and draws player. On
    */
    public Player(int screenPosX, int ScreenPosY, int tilePosX, int tilePosY, int moveIncrement){
        // entity constructor. Creates particle array, force generator etc.
        super();

        jumpParticles = new ArrayList<Particle>();

        //medium weight for player. not the heaviest but also not the lightest
        invMass = normalInvMass;

        this.moveIncrement = moveIncrement;

        // offset = position
        this.tilePosX = tilePosX;
        this.tilePosY = tilePosY;

        //create particles
        // Particle(int x, int y, float xVel, float yVel, float invM
        // create 4 particles for hit box
        particles.add(new Particle(screenPosX, ScreenPosY, 0, 0, invMass));
        particles.add(new Particle(screenPosX + width, ScreenPosY, 0, 0, invMass));
        particles.add(new Particle(screenPosX + width, ScreenPosY + height, 0, 0, invMass));
        particles.add(new Particle(screenPosX, ScreenPosY + height, 0, 0, invMass));

        //create cats <3
        cats = new ArrayList<Cat>();
        //(String name, color col, String ability, String normalImage, String specialImage)
        cats.add(new Cat("Edgar", color(125), "High Jump", "Edgar.png", "Edgar.png") );
        cats.add(new Cat("Poe", color(190), "Super Nap", "Poe.png", "PoeSleep.png"));
        cats.add(new Cat("Alan", color(0), "Climb", "Alan.png", "AlanClimbing.png"));

        //default cat is Edgar
        this.currentCat = 0;
        //Edgar has two jumps
        
    }

    public void calculateOffset(TileMap tileMap){

        //handle moving 
        println("Moving data d a w" + movingRight + " " + movingLeft + " " + climbing);
        if(movingRight){
            move('d');
        }
        else if(movingLeft){
            move('a');
        }

        if(climbing){
            move('w');
        }

        if(walking || climbing){
            jumping = false;
            jumpParticles.clear();
        }
        println(walking + "" + climbing + "" + immune);
        //if player is walking on a platform disable gravity
        forceRegistry.setIgnoreGravity(walking || climbing || immune);

        //update forces on object
        update();

        PVector offset = new PVector();
        //integrate each particle
        for(Particle p: particles){
            offset = p.playerIntegrate();

            //aditionally if the player is standing on a tile set the vert velocity to 0
            if(walking || climbing)
                p.velocity.set(p.velocity.x, 0);
        }
        //the final vector should be the bottom left corner. We'll base it on the top left
        //calculate offset
        // where it moved from start pos
        float newPosX = offset.x;

        float newPosY = offset.y - (Tile.TILE_LENGTH);
        
        //the new tile position is this new position - the starting position + the tileposition
        this.tilePosX += (newPosX - startPosX);
        this.tilePosY += (newPosY - startPosY);

        //update jumpParticles
        for(Particle p: jumpParticles){
            p.position.x -= (newPosX - startPosX);
            p.position.y -= (newPosY - startPosY);
        }

         //probably run collision detection here before actually finalizing drawing
        //adjust offsets accordingly
        //first find all the tiles that 
        handleCollisions(tileMap);


    }

    private void handleCollisions(TileMap tileMap){
        //define range for efficency
        //taken from draw method of TileMap
        int lowXRange = floor((tilePosX/Tile.TILE_LENGTH) - (tileMap.getLengthRange()/2));
        int highXRange = ceil(tilePosX/Tile.TILE_LENGTH + (tileMap.getLengthRange()/2));

        int lowYRange = floor((tilePosY/Tile.TILE_LENGTH) - (tileMap.getHeightRange()/2));
        int highYRange = ceil((tilePosY/Tile.TILE_LENGTH) + (tileMap.getHeightRange()/2));

        if(lowXRange < 0) lowXRange = 0;
        if(lowYRange < 0) lowYRange = 0;
        if(highXRange > tileMap.getLength()) highXRange = tileMap.getLength();
        if(highYRange > tileMap.getHeight()) highYRange = tileMap.getHeight();

        PVector correction = new PVector(0,0);

        int walkingTiles = 0;
        int climbingTiles = 0;
        //handle if the cat is walking on platform or not
        for(int i = lowYRange; i < highYRange; i++){
            for(int j = lowXRange; j < highXRange; j++){
                //send to collision to check
                //detectCollision(PVector entityWA, float entityWidth, float entityHeight, PVector tileWA, float tileWidth, float tileHeight)
                if(testCollision.detectCollision(new PVector(tilePosX, tilePosY), width, height, new PVector(j * Tile.TILE_LENGTH, i * Tile.TILE_LENGTH), Tile.TILE_LENGTH, Tile.TILE_LENGTH)){
                    //found collision. Handle it.
                    // if collidable
                    Tile currentTile = tileMap.getTile(j, i);
                    if(currentTile.isCollidable()){
                        if(currentTile instanceof ClimbableZone){
                            climbingTiles++;
                        }else{

                            //for walkable tile i.e platform and climbing platform
                            correction = testCollision.correctCollision();
                            tilePosX += correction.x;
                            tilePosY += correction.y;

                            if(correction.y < 0){
                                walkingTiles++;
                            }

                            //also zero velocity so that thinks don't clip though tiles because they are moving at super sonic speed
                            for(Particle p: particles){
                                //only zero velocity in direction of collision so that the cats don't stick to walls
                                if(correction.x != 0)
                                    p.velocity.x = 0;
                                else if(correction.y != 0)
                                    p.velocity.y = 0;
                            }

                            if(currentTile instanceof DeathZone){
                                alive = false;
                            }
                            if(currentTile instanceof WinZone){
                                win = true;
                            }
                        }

                    }
                }
            }
        }

        if(climbingTiles > 0){
            canClimb = true;
        }else{
            canClimb = false;
            climbing = false;
        }

        if(walkingTiles > 0){
            walking = true;
        }else{
            walking = false;
        }
    }

    public void draw(){
        //direction
        int direction = 1;
        if( movingLeft) direction = -1;
        //call draw method in the cat class
        if(climbing || immune){
        cats.get(currentCat).draw(particles, 1, width, height, direction);
        }
        else{
            //default cat
            cats.get(currentCat).draw(particles, 0, width, height, direction);
        }
    }

    public void setMoving(char key, boolean keyPressed){
        //this literally just flips the boolean value of the moving function
        if( key == 'a'){
            //move left -> offsetX is affected in negative direction
            movingLeft = keyPressed;
        }
        else if (key == 'd'){
            //move right -> offsetX is affected in positive direction
            movingRight = keyPressed;
        }
        else
            println("How tf did you get here?");

    }

    //we will handle keyboard input here
    public void move(char key){
        // used Space invaders as inspiration for moving character 
        if( key == 'a'){
            //move left -> offsetX is affected in negative direction
            this.tilePosX -= moveIncrement;
        }
        else if (key == 'd'){
            //move right -> offsetX is affected in positive direction
            this.tilePosX += moveIncrement;
        }
        else if(key == 'w'){ // up for climb
            this.tilePosY -= moveIncrement;
        }
        else
            println("How tf did you get here?");
    }

    // exerts force to begin jump
    //we can mess with these numbers to adjust jump

    // ~ from lecture material
    // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    private final int REST_LENGTH = 1000 ;
    private final float SPRING_CONSTANT = 1.7 ;
    // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    private PVector jOffset = new PVector(0, 20);
    public void startJump(){
        if(!jumping){
            jumping = true;
            float jumpOffset = 1;
            if(cats.get(currentCat).specialAbility == "High Jump")
                jumpOffset = 1.25;
            //force exerted is a jumpingSpring. each particle gets there own
            walking = false;
            for(Particle p: particles){
                // JumpingSpring(PVector anchor, float k, float l0)

                jumpParticles.add(new Particle((int) (p.position.x + jOffset.x), (int)(p.position.y + jOffset.y), 0, 0, 0.1));
                forceRegistry.add(p, new JumpingSpring(jumpParticles.get(jumpParticles.size() - 1), SPRING_CONSTANT, REST_LENGTH * jumpOffset));
            }
        }
    }

    public void resetJumps(){

    }

    public void useAbility(){
        // Edgar does not use the ability here because his is automatically implemented in jump amount
        // only need to activate once
        if(cats.get(currentCat).specialAbility == "Super Nap" && !immune){
            //activate immunity but set mass to infinite
            immune = Boolean.TRUE; // immune to damage while ability is active

            invMass = 0; // poe is immovable because he is sleeping

            //update mass of all particles
            for(Particle p: particles){
                p.setInvMass(invMass);
            }

            //stop moving
            movingLeft = false;
            movingRight = false;
        }
        else if (cats.get(currentCat).specialAbility == "Climb"){
            //work like move but changes offsetY negatively 
            // offsetY -= moveIncrement;

            //set climbing if they can climb
            if(canClimb)
                climbing = true;

        }
    }

    public void disableAbility(){
        //only Poe needs to be disabled
        if(cats.get(currentCat).specialAbility == "Super Nap" && immune){
            //activate immunity but set mass to infinite
            immune = Boolean.FALSE; // reset immunity

            invMass = normalInvMass; // reset mass

            //update mass of all particles
            for(Particle p: particles){
                p.setInvMass(invMass);
            }
        }else if(cats.get(currentCat).specialAbility == "Climb"){
            climbing = false;
        }
    }

    public void switchCats(){
        currentCat++;
        if(currentCat >= numberOfCats){
            currentCat = 0;
        }
        
    }


}