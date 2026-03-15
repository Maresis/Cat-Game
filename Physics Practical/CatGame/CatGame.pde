import java.util.ArrayList;

Player player;
ArrayList<Entity> entities = new ArrayList<Entity>();
TileMap tileMap;



int screenWidth;
int screenHeight;
final int tileLength = Tile.TILE_LENGTH;

void setup(){

}

void draw(){

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
            player.move(key);
            break;
        case 'd':
            player.move(key);
            break;
        case ' ':
            player.startJump();
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

}