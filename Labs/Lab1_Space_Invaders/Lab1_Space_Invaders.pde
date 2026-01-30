// how will you handle different phases: pre-game, game, post-game?

// Some constants used to derive sizes for game elements from display size
final int PLAYER_WIDTH_PROPORTION = 10,
          PLAYER_HEIGHT_PROPORTION = 10,
          PLAYER_INIT_X_PROPORTION = 2,
          PLAYER_INCREMENT_PROPORTION = 50 ;
final int MISSILE_WIDTH_PROPORTION = 4,
          MISSILE_HEIGHT_PROPORTION = 4,
          MISSILE_INCREMENT_PROPORTION = 50 ;
//add alien proportions
//COMPARED TO SCREEN
final int ALIEN_WIDTH_PROPORTION = 25,
          ALIEN_HEIGHT_PROPORTION = 25,
          //aliens will come from a random x at the top of the screen so I don't want to make this constant
          ALIEN_INCREMENT_PROPORTION = 50;

final int screen_width = 800;// fullHD :)
final int screen_height = 600;
// The player and the missile - elements of the game should go in a class.
PlayerShip player ;
PlayerMissile missile ;
boolean firing = false ;
// Notice how these Booleans are used instead of polling the keyboard every frame.
boolean movingLeft = false ;
boolean movingRight = false ;

// Initialise display and game elements
// NB Accessing displayWidth/Height pre setup() doesn't seem to work out
void settings(){
  size(screen_width,screen_height); 
}

void setup() {
  // initialise the player. 
  int playerWidth = screen_width/PLAYER_WIDTH_PROPORTION ;
  int playerHeight = screen_height/PLAYER_HEIGHT_PROPORTION ;
  int playerInitX = screen_width/PLAYER_INIT_X_PROPORTION - playerWidth/2 ;
  int playerInitY = screen_height - playerHeight ;
  int playerIncrement = screen_width/PLAYER_INCREMENT_PROPORTION ;    
  player = new PlayerShip(playerInitX, playerInitY,
                          playerWidth, playerHeight, playerIncrement) ;
  // not initially firing, but initialise missile object
  missile = new PlayerMissile(0,0,
                              playerWidth/MISSILE_WIDTH_PROPORTION,
                              playerHeight/MISSILE_HEIGHT_PROPORTION,
                              MISSILE_INCREMENT_PROPORTION) ;
}

// update and render
void draw() {
  background(0) ;
  // the player
  if (movingLeft) {
    player.moveLeft() ;
  }
  else if (movingRight) {
    player.moveRight() ; 
  }
  player.draw() ;
  println(frameRate);
  // the missile
  if (firing) {
    // render missile
    if (missile.move()) {
      missile.draw() ;
    }
    else firing = false ;
  }
  
  //lets throw an alien on the screen. We don't want to do this globally as aliens will die lol.
  // "Some of you will die. That's a sacrifice I'm willing to make"
  // we will throw him in the middle of the screen
  // for reference player dimensions are
  // constructor is (int x, int y, int AlienWidth, int AlienHeight, int moveIncrement)
  // we will start in middle
  int alienWidth = screen_width/ALIEN_WIDTH_PROPORTION ;
  int alienHeight = screen_height/ALIEN_HEIGHT_PROPORTION ;
  int alienInitX = screen_width/2 ; // middle
  int alienInitY = alienHeight ;
  int alienIncrement = screen_width/ALIEN_INCREMENT_PROPORTION ; 
  Alien testAlien = new Alien( alienInitX, alienInitY, alienWidth, alienHeight, alienIncrement);
  //TEST THAT IT SHOWS UP
  testAlien.draw();
  
  //we determine a hit if the missile intersects with the alien at all during draw.
  // if there are multiple aliens we will have to do this for each one
  // lets make a new function 
  intersectsAM(testAlien, playerMissile);
}

// Read keyboard for input. Notice how booleans are used to maintain state and so
// give a smooth update. These methods are not called often enough otherwise.
void keyPressed() {
  // space to fire   
  if (key == ' ') {
    fire() ; 
  }  
  if (key == CODED) {
     switch (keyCode) {
       case LEFT :
         movingLeft = true ;
         break ;
       case RIGHT :
         movingRight = true ;
         break ;
     }
  }
}
void keyReleased() {
  if (key == CODED) {
     switch (keyCode) {
       case LEFT :
         movingLeft = false ;
         break ;
       case RIGHT :
         movingRight = false ;
         break ;
     }
  }  
}

boolean intersectsAM(Alien alien, PlayerMissile missile){
  
}

// initiate firing, if missile not already there.
// Can you support firing multiple missiles?
void fire() {
  if (!firing) {
    missile.reset(player.getX() + player.playerWidth/MISSILE_WIDTH_PROPORTION,
                  player.getY() - player.playerHeight/MISSILE_WIDTH_PROPORTION) ;
    firing = true ;
  }
}

final class PlayerMissile {
  // The missile is represented by another handsome rectangle
  // the position field indicates the top-left of that rectangle.  
  PVector position ;
  int missileWidth, missileHeight ;
  int moveIncrement ;
  
  PlayerMissile(int x, int y, int missileWidth, int missileHeight, int moveIncrement) {
    position = new PVector(x, y) ;
    this.missileWidth = missileWidth ;
    this.missileHeight = missileHeight ;
    this.moveIncrement = moveIncrement ;
  }
  
  // reuse this object rather than go through object creation
  void reset(int x, int y) {
    position.x = x ;
    position.y = y ;
  }
  
  // The missile is displayed as a rectangle
  void draw() {
    //neon green because why tf not
    //fill(0, 255, 34) ;
    fill(255);
    rect(position.x, position.y, missileWidth, missileHeight) ;
    //beginShape();
    //the four vertexes will be the 
    //im also realizing that this is the missile so oop
    //bottom left if position is in the bottom left corner
    //vertex(position.x, position.y);
    ////top of ship
    //vertex( ( position.x + ( missileWidth / 2 ) ), position.y - missileHeight);
    ////bottom right corner of ship
    //vertex( ( position.x + missileWidth ), ( position.y ) );
    ////middle part that makes the pointy bit
    ////lets make it go up like a fourth of the size of the shape for shits and giggles
    //vertex( ( position.x + ( missileWidth / 2 ) ), ( position.y - ( missileHeight * 0.25 ) ) );
    //endShape(CLOSE);
    //lets use begin shape to make a more interesting triangle
  }
  
  // handle movement. Returns true if not out of play area
  // What about collision detection with enemies?
  boolean move() {
    return (position.y -= moveIncrement) >= 0 ;
  }  
}

final class PlayerShip {
  // The player's ship is represented as a handsome rectangle
  // the position field indicates the top-left of that rectangle.
  PVector position ;
  int playerWidth, playerHeight ;
  int moveIncrement ;
  
  PlayerShip(int x, int y, int playerWidth, int playerHeight, int moveIncrement) {
    position = new PVector(x, y) ;
    this.playerWidth = playerWidth ;
    this.playerHeight = playerHeight ;
    this.moveIncrement = moveIncrement ;
  }
  
  // getters
  int getX() {return (int)position.x ;}
  int getY() {return (int)position.y ;}
  
  // The player's ship is displayed as a rectangle
  void draw() {
    //fill(255) ;
    fill(0, 255, 34) ;
    
    //rect(position.x, position.y, playerWidth, playerHeight) ;
    
    beginShape();
    //bottom left if position is in the bottom left corner
    vertex(position.x, position.y);
    ////top of ship
    vertex( ( position.x + ( playerWidth / 2 ) ), position.y - playerHeight);
    ////bottom right corner of ship
    vertex( ( position.x + playerWidth ), ( position.y ) );
    ////middle part that makes the pointy bit
    ////lets make it go up like a fourth of the size of the shape for shits and giggles
    vertex( ( position.x + ( playerWidth / 2 ) ), ( position.y - ( playerHeight * 0.25 ) ) );
    endShape(CLOSE);
  }
  
  // Handle movement - do you want to support up/down movement too?
  void moveLeft() {
    position.x -= moveIncrement ;
    if (position.x < 0) position.x = 0 ;
  }
  void moveRight() {
    position.x += moveIncrement ;
    if (position.x > screen_width-playerWidth) 
      position.x = screen_width-playerWidth ;
  }  
}

final class Alien {
  // The player's ship is represented as a handsome rectangle
  // First of all this is for Aliens second of all FUCK rectangles. Boring
  // the position field indicates the top-left of that rectangle.
  PVector position ;
  int AlienWidth, AlienHeight ;
  int moveIncrement ;
  float health ;
  
  Alien(int x, int y, int AlienWidth, int AlienHeight, int moveIncrement) {
    position = new PVector(x, y) ;
    this.AlienWidth = AlienWidth ;
    this.AlienHeight = AlienHeight ;
    this.moveIncrement = moveIncrement ;
    this.health = 100;
  }
  
  // getters
  int getX() {return (int)position.x ;}
  int getY() {return (int)position.y ;}
  
  // The player's ship is displayed as a rectangle
  void draw() {
    float colour = this.health/100 * 255;
    fill(colour) ;
    println(colour);
    rect(position.x, position.y, AlienWidth, AlienHeight) ;
  }
  
  // the alien is hit by a missile
  void hit(){
    this.health -= 10;
  }
  
  boolean alive(){
    return this.health > 0;
  }
  
  // Handle movement
  void moveLeft() {
    position.x -= moveIncrement ;
    if (position.x < 0) position.x = 0 ;
  }
  void moveRight() {
    position.x += moveIncrement ;
    if (position.x > screen_width-AlienWidth) 
      position.x = screen_width-AlienWidth ;
  }
  
  void moveUp(){
       position.y -= moveIncrement ;
    if (position.y < 0) position.y = 0 ;
  }
  
  void moveDown(){
    position.y += moveIncrement ;
    if (position.y > screen_height-AlienHeight) 
      position.y = screen_height-AlienHeight ;
  }
}
