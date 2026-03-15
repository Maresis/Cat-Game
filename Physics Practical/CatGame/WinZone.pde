

class WinZone extends Tile {
    private final Boolean collidable = Boolean.TRUE;
    private float posX;
    private float posY;

    public WinZone(float posX, float posY){
        this.posX = posX;
        this.posY = posY;
    }

    public void draw(float offsetX, float offsetY){
        //rect coord upper left corner x y width height
        // basic drawing, will replace with assets later
        //red
        fill(255, 0, 0);
        rect(this.posX + offsetX, this.posY + offsetY, Tile.tileLength, Tile.tileLength);
    }
}