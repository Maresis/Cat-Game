

class ClimbablePlatform extends Tile{
    // private final Boolean collidable = Boolean.TRUE;
    // private float posX;
    // private float posY;

    public ClimbablePlatform(float posX, float posY){
        super(posX, posY);
        this.collidable = Boolean.TRUE;
        this.climbable = Boolean.TRUE;
    }

    public void draw(float offsetX, float offsetY){
        //rect coord upper left corner x y width height
        // basic drawing, will replace with assets later
        //not red but different color than everything else
        fill(255, 255, 0);
        rect(this.posX + offsetX, this.posY + offsetY, TILE_LENGTH, TILE_LENGTH);
    }
}