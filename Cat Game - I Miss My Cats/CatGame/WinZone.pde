

class WinZone extends Tile {

    public WinZone(float posX, float posY){
        super(posX, posY);
        this.collidable = Boolean.TRUE;
        // What do all cats want?
        image = loadImage("FoodBowl.png");
    }

    public void draw(float posX, float posY){
        //rect coord upper left corner x y width height
        // basic drawing, will replace with assets later
        //green
        image(image, posX, posY, TILE_LENGTH, TILE_LENGTH);
    }
}