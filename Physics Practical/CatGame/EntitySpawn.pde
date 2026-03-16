

class EntitySpawn extends Tile{
    // private final Boolean collidable = Boolean.FALSE;
    // private float posX;
    // private float posY;

    private Boolean alive;
    


    public EntitySpawn(float posX, float posY, int type){
        super(posX, posY);
    }

    //for now use default behavior
    public void draw(float offsetX, float offsetY){
        //rect coord upper left corner x y width height
        // basic drawing, will replace with assets later
        //white
        // fill(255);
        // rect(this.posX + offsetX, this.posY + offsetY, Tile.tileLength, Tile.tileLength);
        //draw nothing for now
    }
}