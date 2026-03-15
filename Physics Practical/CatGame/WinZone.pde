

class WinZone extends Tile {

    public WinZone(float posX, float posY){
        super(posX, posY);
        this.collidable = Boolean.TRUE;
    }

    public void draw(float offsetX, float offsetY){
        //rect coord upper left corner x y width height
        // basic drawing, will replace with assets later
        //green
        fill(0 , 255, 0);
        rect(posX + offsetX, posY + offsetY, TILE_LENGTH, TILE_LENGTH);
    }
}