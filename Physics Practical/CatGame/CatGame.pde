import java.util.ArrayList;

Player player;
ArrayList<Entity> entities = new ArrayList<Entity>();
TileMap tileMap;

final int tileLength = Tile.TILE_LENGTH;

//defines the range around the player that 
final int tileLengthRange = 6;
final int tileHeightRange = 5;

final int screenWidth = tileLengthRange * tileLength;
final int screenHeight = tileHeightRange * tileLength;;

//increment
final int PLAYER_MOVE_PROPORTION = tileLength;

//set up levels
ArrayList<Level> levels = new ArrayList<Level>();
int currentLevel = 0; //default value

//this techincally work like a cameria but we are keeping track of an x and y offset
//default = to starting position
float offsetX;
float offsetY;

void settings(){
    size(screenWidth, screenHeight);
}

void setup(){
    //I'll add level choosing later but for now no

    //later we will create a way of deriving the starting position from the tilemap
    //for level 1 the player starts at tile[5][7]
    levels.add(new Level("level1.txt", 4 * tileLength, 6 * tileLength));

    //create tileMap
    tileMap = new TileMap(levels.get(currentLevel).levelFile, tileLengthRange, tileHeightRange);
    //create player
    // public Player(int posX, int posY, int moveIncrement){
    player = new Player(levels.get(currentLevel).startPosX, levels.get(currentLevel).startPosY, screenWidth/PLAYER_MOVE_PROPORTION);

    //set offset
    offsetX = player.offsetX;
    offsetY = player.offsetY;

}

void draw(){
    //how do we draw?
    //first background
    background(255);

    //calculate offset of the player character
    //this fuction essentially figures out the new offset based on the physics applied to the player and the movement by the user
    player.calculateOffset();

    //set offset
    offsetX = player.offsetX;
    offsetY = player.offsetY;

    //draw tilemap before anything else
    tileMap.draw(offsetX, offsetY);

    //draw player character
    player.draw();

    //draw entities when I add them

}


/*
    Keys that can be read and their actions are as follows:
    'a' : Move player left
    'd' : Move player right
    'space' : Player jumps
    'tab' : change cat
    'shift' : use special ability

*/
void keyPressed(){
    switch(key){
        case 'a':
            player.setMoving(key);
            break;
        case 'd':
            player.setMoving(key);
            break;
        case ' ':
            // player.startJump();
            break;
        case TAB:
            break;
        case CODED:
            if(keyCode == SHIFT ){
                player.useAbility();
            }
            break;
        default:
            break;

    }

}

void keyReleased(){
    switch(key){
        case 'a':
            player.move(key);
            break;
        case 'd':
            player.move(key);
            break;
        case CODED:
            if(keyCode == SHIFT ){
                player.disableAbility();
            }
            break;
        default:
            break;

    }

}