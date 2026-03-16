

class ClimbableZone extends Tile{
    // private final Boolean collidable = Boolean.TRUE;
    // private float posX;
    // private float posY;

    public ClimbableZone(float posX, float posY){
        super(posX, posY);
        this.collidable = Boolean.TRUE;
        this.climbable = Boolean.TRUE;
        image = loadImage("ScratchingPost.png");
    }

    public void draw(float posX, float posY){
        //rect coord upper left corner x y width height
        // basic drawing, will replace with assets later
        //not red but different color than everything else
        image(image, posX, posY, TILE_LENGTH, TILE_LENGTH);
    }
}