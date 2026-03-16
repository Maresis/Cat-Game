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

    // the number of jumps a cat can take before touching another surface
    private int jumps;

    //is the cat immune to damange
    private Boolean immune = false;

    private final float normalInvMass = 0.1;


    //offset that the position of the world is based off of
    //public to make it "snappy" lol
    public float tilePosX;
    public float tilePosY;

    boolean movingRight = false;
    boolean movingLeft = false;
    boolean climbing = false;
    
    /*
        Creates and draws player. On
    */
    public Player(int screenPosX, int ScreenPosY, int tilePosX, int tilePosY, int moveIncrement){
        // entity constructor. Creates particle array, force generator etc.
        super();

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
        cats.add(new Cat("Edgar", color(125), "Double Jump"));
        cats.add(new Cat("Poe", color(190), "Super Nap"));
        cats.add(new Cat("Alan", color(0), "Climb"));

        //default cat is Edgar
        this.currentCat = 0;
        //Edgar has two jumps
        this.jumps = 2;
        
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

        PVector offset = new PVector();
        //integrate each particle
        for(Particle p: particles){
            offset = p.playerIntegrate();
        }
        //the final vector should be the bottom left corner. We'll base it on the top left
        //calculate offset
        // where it moved from start pos
        float newPosX = offset.x;

        float newPosY = offset.y - (Tile.TILE_LENGTH);
        
        //the new tile position is this new position - the starting position + the tileposition
        this.tilePosX += (newPosX - startPosX);
        this.tilePosY += (newPosY - startPosY);

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
        for(int i = lowYRange; i < highYRange; i++){
            for(int j = lowXRange; j < highXRange; j++){
                //send to collision to check
                //detectCollision(PVector entityWA, float entityWidth, float entityHeight, PVector tileWA, float tileWidth, float tileHeight)
                if(testCollision.detectCollision(new PVector(tilePosX, tilePosY), width, height, new PVector(j * Tile.TILE_LENGTH, i * Tile.TILE_LENGTH), Tile.TILE_LENGTH, Tile.TILE_LENGTH)){
                    //found collision. Handle it.
                    // if collidable
                    if(tileMap.getTile(j, i).isCollidable()){
                        correction = testCollision.correctCollision();
                        tilePosX += correction.x;
                        tilePosY += correction.y;
                    }
                }
            }
        }
    }

    public void draw(){
        //call draw method in the cat class
        cats.get(currentCat).draw(particles);
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
    public void startJump(){

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
        }
        else if (cats.get(currentCat).specialAbility == "Climb"){
            //work like move but changes offsetY negatively 
            // offsetY -= moveIncrement;

            //set climbing
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

        if(cats.get(currentCat).specialAbility == "Double Jump"){
            jumps = 2;
        }
        else{
            jumps = 1;
        }
        
    }


}