

 class Tile {
    // by deafult Tiles are no collide
    protected boolean collidable = Boolean.FALSE;
    protected boolean climbable = Boolean.FALSE;

    // // the (x,y) coordinate respresents the top left corner of a tile
    protected float posX;
    protected float posY;

    // public for speediness
    // 
    public static final int TILE_LENGTH = 100;

    protected PImage image;
    //save on mem hopefully
    protected PImage platformImage = loadImage("Platform.png");

    public Tile(float posX, float posY){
        this.posX = posX;
        this.posY = posY;
    }

    public int getSpawnType(){
        //default no type
        return -1;
    }

    //lets completely disregard the position of the tile. That is just for finding what tiles to print
    public void draw(float posX, float posY){
        // tiles by default are White
        fill(255);
        rect(posX, posY, TILE_LENGTH, TILE_LENGTH);
    }

    public boolean isCollidable(){
        return collidable;
    }

    // take a nonstatic entity as input and checks if it is in the static tile
    // abstract Boolean checkObjectCollsion(NonstaticObject obj);
}