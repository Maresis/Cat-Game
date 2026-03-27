import java.util.ArrayList;
import java.util.Stack;

Player player;
ArrayList<Entity> entities = new ArrayList<Entity>();
TileMap tileMap;

final int tileLength = Tile.TILE_LENGTH;

final int screenWidth = 800;
final int screenHeight = 600;
//defines the range around the player that 
final int tileLengthRange = screenWidth/tileLength + 2;
final int tileHeightRange = screenHeight/tileLength + 2;

//increment
final int PLAYER_MOVE_PROPORTION = tileLength;

//set up levels
ArrayList<Level> levels = new ArrayList<Level>();
int currentLevel = 0; //default value

//starting position will always be the same
final int startPosX = screenWidth/2 - tileLength/2;
final int startPosY = screenHeight/2;

float tilePosX;
float tilePosY;

//offset will always be calculated Tile position - start
float offsetX;
float offsetY;

ForceRegistry forceRegistry;

boolean gameEnded = false;

void initGame(){
    //TODO Add game states
    for(Entity e: entities){
        e.alive = false;
        e.onScreen = false;
    }
    entities.clear();
    player.alive = true;
    setup();
}

void settings(){
    size(screenWidth, screenHeight);
}

void setup(){
    //I'll add level choosing later but for now no

    //later we will create a way of deriving the starting position from the tilemap
    //for level 1 the player starts at tile[5][7]
    levels.add(new Level("level1.txt"));

    forceRegistry = new ForceRegistry();

    //create Gravity from lecture materials
    // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //Create a gravitational force
    Gravity gravity = new Gravity(new PVector(0f, 1f)) ;
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //copy ends

    //create tileMap
    tileMap = new TileMap(levels.get(currentLevel).levelFile, tileLengthRange, tileHeightRange);
    // high key we can store the start position in the constuctor

    //spawn entities
    for(int x = 0; x < tileMap.getLength(); x++){
        for(int y = 0; y < tileMap.getHeight(); y++){
            //check if entity spawn tile
            Tile t = tileMap.getTile(x, y);
            if((t instanceof EntitySpawn ) && (t.getSpawnType() > 0)){
                //spawn enemy

                print("Spawning enemy (" + x +"," + y + ") Type: " + t.getSpawnType());
                entities.add(new Enemy(x, y, t.getSpawnType()));
            }
        }
    }

    //create player
    // public Player(int posX, int posY, int moveIncrement){
    player = new Player(startPosX, startPosY, tileMap.playerStartX, tileMap.playerStartY, screenWidth/PLAYER_MOVE_PROPORTION);
    player.addForce(gravity);

    //set offset
    tilePosX = player.tilePosX;
    tilePosY = player.tilePosY;

    offsetX = tilePosX - startPosX;
    offsetY = tilePosY - startPosY;

}

void draw(){

    //test end conditions
    // TODO modify these screens to be more interesting and change game states
    if(player.win){
        //go to win screen
        gameEnded = true;
        background(0, 255, 0);
        textSize(32);
        text("You Win! Press Enter to Restart", screenWidth / 2 - 200, screenHeight / 2);
        fill(255);
    }
    else if(!player.alive){
        //go to lose screen
        background(0);
        textSize(32);
        text("Loser! Press Enter to Restart", screenWidth / 2 - 200, screenHeight / 2);
        fill(255);
        gameEnded = true;
    }
    else{
        //how do we draw?
        //first background
        background(255);

        println(tilePosX);

        

        //calculate offset of the player character
        //this fuction essentially figures out the new offset based on the physics applied to the player and the movement by the user
        player.calculateOffset(tileMap);

        tilePosX = player.tilePosX;
        tilePosY = player.tilePosY;

        offsetX = player.tilePosX - startPosX;
        offsetY = player.tilePosY - startPosY;

        //update jumpParticles position
        // for(Particle p: jumpParticles){
        //     p.position.set(p.position.x - offsetX, p.position.y - offsetY);
        // }
        // determine if entities are onscreen
        for(Entity e:entities){
            if(e.getType() > 0){//check if on screen if so then draw entity
                if(e.onScreen(tilePosX, tilePosY)){
                    e.draw(offsetX, offsetY);
                }
            }
        }

        forceRegistry.updateForces();
        
        //draw tilemap before anything else
        tileMap.draw(offsetX, offsetY, tilePosX, tilePosY);

        //draw player character
        player.draw();

        //draw entities when I add them
    }
}


/*
    Keys that can be read and their actions are as follows:
    'a' : Move player left
    'd' : Move player right
    'space' : Player jumps
    'tab' : change cat
    'shift' : use special ability

    for both key functions. When you press shift you should still be able to move left and right
    capitalized letters have been added.

*/
void keyPressed(){
    //could've stayed as a switch statment. Oh well.
    if(key == 'a'|| key == 'A' || key == 'd' || key == 'D'){
       player.setMoving(key, true); 
    }
    if(key == ' '){
        player.startJump();

    }
    if(key == TAB){
        player.switchCats();
    }
    if(key == ENTER && gameEnded){
        initGame();
    }
    if(key == CODED && keyCode == SHIFT){
        player.useAbility();
    }

}

void keyReleased(){

    if((key == 'a'|| key == 'A' || key == 'd' || key == 'D')){
       player.setMoving(key, false); 
    }
    if(key == CODED && keyCode == SHIFT){
        player.disableAbility();
    }

}

// For the memories <3. Inheritence wise why the fuck would I try to handle forces enacted on an entity. Outside
// of the entity's class? I already had force handling built in to Entity anyway. Everybody makes mistakes.
// void jump(){
//     //for jump we will use jumping springs that are based on anchor springs
//     //the anchor will be the player particles
//     //they will be attached to 4 particles that are generated base on the player particle location
//     // float startingX = player.particles.get(0).position.x;
//     // float startingY = player.particles.get(0).position.y;
//     int xJump = 0;
//     int yJump = 20;

//     for(Particle p: player.particles){
//         // Particle(int x, int y, float xVel, float yVel, float invM)
//         jumpParticles.add(new Particle((int)(p.position.x + xJump), (int)(p.position.y + yJump), 0, 0, 0.1));
//         forceRegistry.add(jumpParticles.get(jumpParticles.size() - 1), new JumpingSpring(p.position, SPRING_CONSTANT, REST_LENGTH, p.position.x));
//     }
// }

