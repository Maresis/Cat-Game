

abstract class Tile {
    // private Boolean collidable;

    // // the (x,y) coordinate respresents the top left corner of a tile
    // private float xPos;
    // private float yPos;

    // Every tile is a 64 by 64 square
    // public for speediness
    public static final int tileLength = 64;

    abstract void draw(float offsetX, float offsetY);

    // take a nonstatic entity as input and checks if it is in the static tile
    // abstract Boolean checkObjectCollsion(NonstaticObject obj);
}