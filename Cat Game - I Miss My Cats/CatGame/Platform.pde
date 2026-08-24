

class Platform extends Tile{
    // private final Boolean collidable = Boolean.TRUE;
    // private float posX;
    // private float posY;

    public Platform(float posX, float posY){
        super(posX, posY);
        this.collidable = Boolean.TRUE;
        image = loadImage("Platform.png");
    }
    // taking up too much of a load
    public void draw(float posX, float posY){
        //rect coord upper left corner x y width height
        // basic drawing, will replace with assets later
        //red
        // image(platformImage, posX, posY, TILE_LENGTH, TILE_LENGTH);
        fill(255, 0, 0);
        rect(posX, posY, TILE_LENGTH, TILE_LENGTH);
    }


    
}