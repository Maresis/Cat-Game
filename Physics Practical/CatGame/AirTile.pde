

class AirTile extends Tile{
    private final Boolean collidable = Boolean.FALSE;
    private float posX;
    private float posY;

    public AirTile(float posX, float posY){
        this.posX = posX;
        this.posY = posY;
    }

    public void draw(float offsetX, float offsetY){
        //rect coord upper left corner x y width height
        // basic dra
        fill(255);
        rect(this.posX + offsetX, this.posY + offsetY, Tile.tileLength, Tile.tileLength);
    }

}