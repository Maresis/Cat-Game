import java.util.Scanner;
import java.io.File;

class TileMap {
    private Tile[][] tileMap;

    private int height;
    private int length;

    /*
        So there are a few different Tile types for when the tilemap is generated from a text file.
        Each tile is represented as an Int of some variety parsed by a space.
        The types are as follows:
        0 : Air ~ no collide
        1 : Platform ~ collide
        2 : Climbable Platform ~ collide
        3 : Death Zone ~ collide (triggers "death" on collision) 
        4 : Entity Spawn ~ no collide -- accompanied by second number 0 : player, 1 : water bullet, 2 : catnip rays
        5 : Player Win ~ collide
    */
    TileMap(String filePath){
        try {
            Scanner sc = new Scanner(filePath);
            // the height and length of the map will be the first two Ints
            // check if next Int exists
            if(sc.hasNextInt()){
                this.length = sc.nextInt();
            }
            else {
                throw new Exception("No Integers Found in Level File for Generation.");
            }

            if(sc.hasNextInt()){
                this.height = sc.nextInt();
            }
            else {
                throw new Exception("Insufficent Integers in Level File to Define Height.");
            }
            // finish constructing tileMap matrix with dimensions
            this.tileMap = new Tile[this.length][this.height];

            // now generate the rest of the tile map. 
            int height = 0;
            int length = 0;

            int type;

            float posX;
            float posY;
            while(sc.hasNextInt()){
                if(length >= this.length){
                    //move up height and reset length
                    height++;
                    length = 0;
                }
                if(height >= this.height){
                    //out of bounds
                    throw new Exception("Tile Map generation out of bounds. Check dimensions in level file.");
                }

                //time to create new tiles
                type = sc.nextInt();

                // math for tile position
                posX = Tile.TILE_LENGTH * length;
                posY = Tile.TILE_LENGTH * height;
                switch(type){
                    case 0:
                        //create Air tile 
                        this.tileMap[length][height] = new AirTile(posX, posY);
                        break;
                    case 1:
                        this.tileMap[length][height] = new Platform(posX, posY);
                        break;
                    case 2:
                        this.tileMap[length][height] = new ClimbablePlatform(posX, posY);
                        break;
                    case 3:
                        this.tileMap[length][height] = new DeathZone(posX, posY);
                        break;
                    case 40:
                    case 41:
                    case 42:
                        int spawnType = type % 10; // get the integer value in ones place
                        this.tileMap[length][height] = new EntitySpawn(posX, posY, spawnType);
                        break;
                    case 5:
                        this.tileMap[length][height] = new WinZone(posX, posY);
                        break;
                    default:
                        throw new Exception("Tried to create invalid Tile type. Check that Tile is in Range. Coordinate: (" + length + "," + height +")");
                }
            }

            sc.close();
        }
        catch (Exception e){
            println(e.getMessage());
        }
    }

    
    private final int LENGTH_RANGE = 6;
    private final int HEIGHT_RANGE = 5;
    public void draw(float offsetX, float offsetY){
        //this function is pretty simple, if the tiles are in the range of the current offset then they get drawn
        //lets define the range
        // with the character in the center the range of "sight" should be 5 tiles tall and 6 tiles wide

        // the length range will be the x offset / tileLength rounded down on the low end this x offset / tileLength + (tileLength * length) rounded up on the high end
        int lowXRange = floor(offsetX/Tile.TILE_LENGTH);
        int highXRange = ceil(offsetX/Tile.TILE_LENGTH + (Tile.TILE_LENGTH * LENGTH_RANGE));

        // Height is defined similarly
        int lowYRange = floor(offsetY/Tile.TILE_LENGTH);
        int highYRange = ceil(offsetY/Tile.TILE_LENGTH + (Tile.TILE_LENGTH * HEIGHT_RANGE));

        //now draw the tile in the tile map in this range
        for(int height = lowYRange; height <= highYRange; height++){
            for(int length = lowXRange; length <= highXRange; height++){
                tileMap[length][height].draw(offsetX, offsetY);
            }
        }

    }


}
