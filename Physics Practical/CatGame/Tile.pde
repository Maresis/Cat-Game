

 class Tile {
    // by deafult Tiles are no collide
    protected final Boolean collidable = Boolean.FALSE;

    // // the (x,y) coordinate respresents the top left corner of a tile
    protected float posX;
    protected float posY;

    // Every tile is a 64 by 64 square
    // public for speediness
    public static final int TILE_LENGTH = 64;

    Tile(float posX, float posY){
        this.posX = posX;
        this.posY = posY;
    }

    void draw(float offsetX, float offsetY){
        // tiles by default are White
        fill(255);
        rect(this.posX + offsetX, this.posY + offsetY, TILE_LENGTH, TILE_LENGTH);
    }

    // take a nonstatic entity as input and checks if it is in the static tile
    // abstract Boolean checkObjectCollsion(NonstaticObject obj);
}