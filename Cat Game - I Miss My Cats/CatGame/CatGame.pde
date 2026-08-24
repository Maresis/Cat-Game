import java.util.ArrayList;
import java.util.Stack;

Player player;
ArrayList<Entity> entities = new ArrayList<Entity>();
TileMap tileMap;
LevelGenerator levelGenerator;

enum GameState {MENU, GENERATE, PLAYING, LOADING};
GameState gameState;

//DEFAULT GENERATION VALUES
int MAX_GEN_X = 256;
int MAX_GEN_Y = 256;
int MAX_DIFFICULTY = 5;

int genSizeX = 32;
int genSizeY = 32;
// default is easy
int difficulty = 1;


final int tileLength = Tile.TILE_LENGTH;

final int screenWidth = 1280;
final int screenHeight = 720;
//defines the range around the player that 
final int tileLengthRange = screenWidth/tileLength + 2;
final int tileHeightRange = screenHeight/tileLength + 2;

//increment
final int PLAYER_MOVE_PROPORTION = int(tileLength * (1.0 / 13));

//set up levels
ArrayList<Level> levels = new ArrayList<Level>();
int currentLevel = 0; //default value

//starting position will always be the same
final int startPosX = screenWidth/2 - tileLength/2;
final int startPosY = screenHeight/2 - int(screenHeight/8.0);

float tilePosX;
float tilePosY;

//offset will always be calculated Tile position - start
float offsetX;
float offsetY;

ForceRegistry forceRegistry;

boolean gameEnded = false;

void settings(){
    size(screenWidth, screenHeight);
}

//start the game in menu
void setup(){
    levelGenerator = new LevelGenerator(MAX_DIFFICULTY);
    gameState = GameState.MENU;

}

void startGame(String level){

    levels.clear();//I have not set up level selection so...

    levels.add(new Level(level));

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
    println(tileMap.playerStartX+ " " + tileMap.playerStartY);
    player = new Player(startPosX, startPosY, tileMap.playerStartX, tileMap.playerStartY, PLAYER_MOVE_PROPORTION);
    player.addForce(gravity);

    //set offset
    tilePosX = player.tilePosX;
    tilePosY = player.tilePosY;

    offsetX = tilePosX - startPosX;
    offsetY = tilePosY - startPosY;

    gameState = GameState.PLAYING;

}

void initGame(){
    entities.clear();
    gameEnded = false;

    forceRegistry = new ForceRegistry();
    Gravity gravity = new Gravity(new PVector(0f, 1f));

    //respawn entities
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
    // recreate player at spawn
    player = new Player(startPosX, startPosY, tileMap.playerStartX, tileMap.playerStartY, PLAYER_MOVE_PROPORTION);
    player.addForce(gravity);

    tilePosX = player.tilePosX;
    tilePosY = player.tilePosY;
    offsetX = tilePosX - startPosX;
    offsetY = tilePosY - startPosY;
}

void draw(){
    if(gameState == GameState.MENU) drawMenu();
    else if(gameState == GameState.GENERATE) drawGenerate();
    else if(gameState == GameState.PLAYING) drawGame();
    else drawLoad();
}

void drawMenu(){
    background(30);
    textAlign(CENTER);

    fill(255);
    textSize(48);
    text("Cat Game", screenWidth/2, screenHeight/3);
    fill(255);
    textSize(28);
    text("1 - Play Previous Level", screenWidth/2, screenHeight/2);
    text("2 - Generate New Level",  screenWidth/2, screenHeight/2 + 50);

}

void drawLoad(){
    background(30);
    textAlign(CENTER);

    fill(255);
    textSize(48);
    text("LOADING", screenWidth/2, screenHeight/2);
}


int genOption = 0; // 0 width, 1 height, 2 difficulty
void drawGenerate(){
    background(30);
    textAlign(CENTER);

    //title
    fill(255);
    textSize(36);
    text("Generate Level", screenWidth/2, screenHeight/4); //nearer to top

    //three generation options width, height, difficulty
    String[] labels = {"Width: " + genSizeX, "Height: " + genSizeY, "Difficulty: " + difficulty};
    
    // 3 optio
    for(int i = 0; i < 3; i++){
        // selected option will be yellow
        fill(i == genOption ? color(255, 255, 0): color(255));
        textSize(26);

        //arrows are also around the selected object
        text((i == genOption ? " <" : "  ") + labels[i] + (i == genOption ? "> " : "  "), screenWidth/2, screenHeight/2 + i*50 - 50);

    }

    fill(160);
    textSize(18);
    text("UP/DOWN: select   LEFT/RIGHT: change   ENTER: generate   BACKSPACE: back", screenWidth/2, screenHeight*3/4);

}

void drawGame(){

    //test end conditions
    // TODO modify these screens to be more interesting and change game states
    if(player.win){
        //go to win screen
        gameEnded = true;
        background(0, 255, 0);
        textSize(32);
        text("You Win! Press Enter to Restart\nOr Press Backspace to Return to Menu", screenWidth / 2, screenHeight / 2);
        fill(255);
    }
    else if(!player.alive){
        //go to lose screen
        background(0);
        textSize(32);
        text("Loser! Press Enter to Restart\nOr Press Backspace to Return to Menu", screenWidth / 2, screenHeight / 2);
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

        forceRegistry.updateForces();
        
        //draw tilemap before anything else
        tileMap.draw(offsetX, offsetY, tilePosX, tilePosY);

        for(Entity e:entities){
            if(e.getType() > 0){//check if on screen if so then draw entity
                if(e.onScreen(tilePosX, tilePosY)){
                    e.draw(offsetX, offsetY);
                }
            }
        }

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
    if(gameState == GameState.MENU){
        if (key == '1'){ 
            gameState = GameState.LOADING;
            startGame("generatedLevel.txt");
        }
        else if(key == '2') gameState = GameState.GENERATE;
    }else if (gameState == GameState.GENERATE){

        if(key == CODED){
            if(keyCode == DOWN){
                genOption = (genOption + 1 > 2) ? 0 : genOption + 1;

            }
            else if(keyCode == UP){
                genOption = (genOption - 1 < 0) ? 2 : genOption - 1;
            }

            if(keyCode == RIGHT){
                if(genOption == 0){
                    genSizeX = (genSizeX * 2 > MAX_GEN_X) ? (MAX_GEN_X/8) : genSizeX * 2;
                }else if(genOption == 1){
                    genSizeY = (genSizeY * 2 > MAX_GEN_Y) ? (MAX_GEN_Y/8) : genSizeY * 2;
                }else{
                    difficulty = (difficulty + 1 > MAX_DIFFICULTY) ? 1 : difficulty + 1;
                }
            }
            else if(keyCode == LEFT){
                if(genOption == 0){
                    genSizeX = (genSizeX / 2 < (MAX_GEN_X/8)) ? (MAX_GEN_X) : genSizeX / 2;
                }else if(genOption == 1){
                    genSizeY = (genSizeY / 2 < (MAX_GEN_Y/8)) ? (MAX_GEN_Y) : genSizeY / 2;
                }else{
                    difficulty = (difficulty - 1 < 1) ? MAX_DIFFICULTY : difficulty - 1;
                }
            }
        }
        else if(key == ENTER){
            gameState = GameState.LOADING;
            startGame(levelGenerator.generateLevel(genSizeX, genSizeY, difficulty));
        }else if( key == BACKSPACE){
            gameState = GameState.MENU;
        }

    }else{//could've stayed as a switch statment. Oh well.
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
        if(key == BACKSPACE && gameEnded){
            gameEnded = false;
            gameState= GameState.MENU;
        }
        if(key == CODED && keyCode == SHIFT){
            player.useAbility();
        }
    }
}

void keyReleased(){

    if(gameState != GameState.PLAYING) return;

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

