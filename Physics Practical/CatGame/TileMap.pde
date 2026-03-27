import java.util.Scanner;
import java.io.File;

class TileMap {
    private Tile[][] tileMap;

    private int height;
    private int length;

    private int lengthRange;
    private int heightRange;

    //player start position
    public int playerStartX = 0;// default values
    public int playerStartY = 0;

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
    public TileMap(String filePath, int lengthRange, int heightRange){
        //set start position to the middle of the screen and beginning of tileMap by default

        
        try {
            // have to use sketch path sense the levels are in the sketch folder, not the data folder
            // this says it is never closed but it literally is
            Scanner sc = new Scanner(new File (dataPath(filePath)));
            // the height and length of the map will be the first two Ints
            // check if next Int exists
            // print(sc.next());
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

            int posX;
            int posY;
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
                        this.tileMap[length][height] = new ClimbableZone(posX, posY);
                        break;
                    case 3:
                        this.tileMap[length][height] = new DeathZone(posX, posY);
                        break;
                    case 40:
                    case 41:
                    case 42:
                        int spawnType = type % 10; // get the integer value in ones place
                        this.tileMap[length][height] = new EntitySpawn(posX, posY, spawnType);
                        if(spawnType == 0){
                            //this is where the player is supposed to spawn
                            playerStartX = posX;
                            playerStartY = posY;
                        }
                        break;
                    case 5:
                        this.tileMap[length][height] = new WinZone(posX, posY);
                        break;
                    default:
                        throw new Exception("Tried to create invalid Tile type. Check that Tile is in Range. Coordinate: (" + length + "," + height +")");
                    
                }
                length++;
            }

            sc.close();
        }
        catch (Exception e){
            println(e.getMessage());
        }

        //set height and length range
        this.lengthRange = lengthRange;
        this.heightRange = heightRange;

    }

    
    public void draw(float offsetX, float offsetY, float tileX, float tileY){
        //this function is pretty simple, if the tiles are in the range of the current offset then they get drawn
        //lets define the range
        // with the character in the center the range of "sight" should be 5 tiles tall and 6 tiles wide

        // println(tileX);
        // the length range will be the x offset / tileLength rounded down on the low end this x offset / tileLength + (tileLength * length) rounded up on the high end
        int lowXRange = floor(tileX/Tile.TILE_LENGTH) - (lengthRange/2);
        int highXRange = ceil(tileX/Tile.TILE_LENGTH + (lengthRange/2));

        // Height is defined similarly
        // these can accidentally round above or below limit make sure they dont
        // println(tileY);
        int lowYRange = floor((tileY/Tile.TILE_LENGTH) - (heightRange/2));
        int highYRange = ceil((tileY/Tile.TILE_LENGTH) + (heightRange/2));

        if(lowXRange < 0) lowXRange = 0;
        if(lowYRange < 0) lowYRange = 0;
        if(highXRange > length) highXRange = length;
        if(highYRange > height) highYRange = height;

        // println("X [" + lowXRange + "," + highXRange + "  Y [" + lowYRange + "," + highYRange );
        // println("Offset x y "+ offsetX, offsetY);

        
        for(int i = lowYRange; i < highYRange; i++){
            for(int j = lowXRange; j < highXRange; j++){
                //do math for position of tiles

                tileMap[j][i].draw(j * Tile.TILE_LENGTH - offsetX, i * Tile.TILE_LENGTH - offsetY);
            }
        }

    }

    public int getLengthRange(){return lengthRange;}

    public int getHeightRange(){return heightRange;}

    public int getLength() {return length;}

    public int getHeight() {return height;}

    public Tile getTile(int x, int y){
        if(x < 0 || y < 0 || x >= length || y >= height) return null;
        return tileMap[x][y];
    }

    //most of my logic for this A* algorithm for pathfind was from https://www.geeksforgeeks.org/dsa/a-search-algorithm/
    // the last two are floats so i can determine the location of the new start
    public Stack<PathNode> findPath(int startX, int startY, int endX, int endY, float sX, float sY){
        // if you cannot reach goal / goal is in collidable object
        if(getTile(endX, endY).collidable){
            return new Stack<PathNode>(); // return empty list
        }

        //if the entitiy is offscreen (start)
        if(startX < 0 || startY < 0 || startX >= length || startY >= height){
            return new Stack<PathNode>(); // return empty list
        }

        //also we need to change the start tile if it is a collidible object
        if(getTile(startX, startY).collidable){
            //this is kind of a hack. This only works because entites should only be able to be slightly in a tile thats no collidable
            if(round(sX) > startX){
                //entered from right
                startX = round(sX);
            }
            else {
                //entered from left
                startX -= 1;
            }

            if(round(sY) > startY){
                //entered from bottom
                startY = round(sY);
            }
            else{
                //top
                startY -= 1;
            }

        }

        //create open and closed lists
        ArrayList<PathNode> open = new ArrayList<PathNode>();
        ArrayList<PathNode> closed = new ArrayList<PathNode>();

        //add the starting tkle to the list
        open.add(new PathNode(startX, startY, 0, heuristic(startX,startY,endX,endY), null));

        while(!open.isEmpty()){
            //find node with the least f on open list. Call it "q"
            PathNode q = open.get(0); //set to first element
            
            for(PathNode p: open){
                if(q.f > p.f){
                    //p is the node with least f
                    q = p;
                }
            }
            // pop q off of list
            open.remove(q);

            //generate q's successors an set parent's to q
            ArrayList<Tile> neighbors = getNeighbors(q);

            //for each successor
            for(Tile t: neighbors){
                //if it is the goal
                if((t.posX / Tile.TILE_LENGTH == endX) && (t.posY / Tile.TILE_LENGTH == endY)){
                    //found path
                    PathNode goalNode = new PathNode(endX, endY, q.g +1, 0, q);
                    return reconstructPath(goalNode);
                    //check if collidable then make PathNode
                }else if(!t.collidable){
                    //only make paths for non collidable tile
                    float g = q.g + 1;
                    float h = heuristic((int)(t.posX /Tile.TILE_LENGTH), (int)(t.posY / Tile.TILE_LENGTH), endX, endY);

                    //create new node
                    PathNode node = new PathNode((int)(t.posX /Tile.TILE_LENGTH), (int)(t.posY / Tile.TILE_LENGTH), g, h, q);
                    if(nodeInList(open, node)){
                        continue;
                    }
                    if(nodeInList(closed, node)){
                        continue;
                    }

                    //otherwise add successor to open list
                    open.add(node);
                }

            }
            //push q on closed list
            closed.add(q);
            
        }
        return new Stack<PathNode>();// node path found
    }
    //  h = sqrt ( (current_cell.x – goal.x)2 + 
    //         (current_cell.y – goal.y)2 )
    private float heuristic(int currentX, int currentY, int goalX, int goalY){
        //triangles, can't be bothered to spell
        // return sqrt(pow((currentX - goalX),2) + pow((currentY - goalY),2) );

        //manhatten
        return (abs (currentX - goalX) + abs(currentY - goalY));
    }

    private ArrayList<Tile> getNeighbors(PathNode tile){
        int lowX = ((tile.x - 1) >= 0) ? tile.x - 1 : 0;
        int highX = ((tile.x +1) < length) ? tile.x + 1 : length - 1;

        int lowY =  ((tile.y - 1) >= 0) ? tile.y - 1 : 0;
        int highY = ((tile.y +1) < height) ? tile.y + 1 : height - 1;

        ArrayList<Tile> neighbors = new ArrayList<Tile>();
        for(int x = lowX; x <= highX; x++){
            for(int y = lowY; y <= highY; y++){
                if(!(x == tile.x && y == tile.y)){
                    //add tile to list
                    neighbors.add(getTile(x,y));
                }
            }
        }
        return neighbors;
    }

    // iii) if a node with the same position as 
    //         successor is in the OPEN list which has a 
    //        lower f than successor, skip this successor
    private boolean nodeInList(ArrayList<PathNode> pathList, PathNode node){
        for(PathNode p: pathList){
            // same coordinates and lo
            if(p.x == node.x && p.y == node.y && p.f < node.f){
                //no need to add node to list
                return true;
            }
        }
        return false;
    }

    private Stack<PathNode> reconstructPath(PathNode node){
        Stack<PathNode> path = new Stack<PathNode>();
       //while the node has a parent
        while(node.parent != null){
            path.push(node);
            node = node.parent; //parent is the new node
        }
        //the current node is no the start node with no parent
        // path.push(node);
        //im actually going to skip adding the start node because the
        // entity is already there
        return path;
    }

}
