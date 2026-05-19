import java.util.Arrays;

class LevelGenerator{
    private int difficultyScale;

    private int vertJumpLimit = 2;
    private int fallLimit = 4;
    private int horzJumpLimit = 4;

    private int platformSizeMin = 2;
    private int platformSizeLimit = 6;

    private int maxColumnHeight = 6;

    public LevelGenerator(int diffScale){
        difficultyScale = diffScale;
    }

    // returns the string of the level generated
    public String generateLevel(int sizeX, int sizeY, int difficulty){
        String fileName = "generatedLevel.txt";

        //lets first generate an array of 0s
        int level[][];
        level = new int[sizeX][sizeY];

        for(int[] row : level) {
            Arrays.fill(row,0);
        }

        // place platforms around 
        placePlatforms(level, sizeX, sizeY, difficulty);

        //fill bottom with death
        for(int x = 0; x < sizeX; x++){
            level[x][sizeY - 1] = 3;
        }



        writeLevel(fileName, level, sizeX, sizeY);


        return fileName;
    }

    
    private void writeLevel(String name, int[][] level, int sizeX, int sizeY){
        String fileName = "data/" + name;
        
        // https://processing.org/reference/createWriter_.html
        PrintWriter output = createWriter(fileName);
        output.println(sizeX);
        output.println(sizeY);

        for(int y = 0; y < sizeY; y++){
            for(int x = 0; x < sizeX; x++){
                output.print(level[x][y] + " ");
            }
            output.println();
        }

        output.flush();
        output.close();
    }

    float increment;
    float baseChance; // starts at a % spawn chance based on difficulty
    float spawnChance;
    void placePlatforms(int[][] level, int sizeX, int sizeY, int difficulty){
        increment = map(difficulty, 1, difficultyScale, 0, 0.15);
        baseChance = map(difficulty, 1, difficultyScale, 0, 0.15); // starts at a % spawn chance based on difficulty
        spawnChance = baseChance;
        // first we have to chose a start point
        // naturally it makes more naturally sense for players to start at the left and bottom
        level[5][sizeY - 6] = 40;
        //create first platform underneath the start
        level[3][sizeY - 5] = 1;
        level[4][sizeY - 5] = 1;
        level[5][sizeY - 5] = 1;
        level[6][sizeY - 5] = 1;
        level[7][sizeY - 5] = 1;

        // put this platform into an list of PVectors
        ArrayList<PVector> platform = new ArrayList<PVector>();
        platform.add(new PVector(3, sizeY - 5));
        platform.add(new PVector(4, sizeY - 5));
        platform.add(new PVector(5, sizeY - 5));
        platform.add(new PVector(6, sizeY - 5));
        platform.add(new PVector(7, sizeY - 5));


        // recursively generate platforms
        ArrayList<PVector> endPlaform = generatePlatforms(platform, level, sizeX, sizeY, 1, 0, difficulty);
        //put the win block in the middle of this platform
        level[int(endPlaform.get(int(endPlaform.size()/2)).x)][int(endPlaform.get(int(endPlaform.size()/2)).y) - 1] = 5;


    }

    //generates a series of platforms and returns the last platform to put the finish on
    private ArrayList<PVector> generatePlatforms(ArrayList<PVector> parentPlatform, int[][] level, int sizeX, int sizeY, int direction, int depth, int difficulty){

        boolean change = false;
        //to prevent too mcuh recursion
        if(depth > 100) return parentPlatform;

        //scale limits for difficulty
        int scaledHorzLimit = ceil(map(difficulty, 1, difficultyScale, 2, horzJumpLimit));
        int scaledVertLimit = ceil(map(difficulty, 1, difficultyScale, 1, vertJumpLimit));
        int scaledFallLimit = ceil(map(difficulty, 1, difficultyScale, 1, fallLimit));

        // low difficulties create a bias that is larger and vice versa
        //used for random generation
        float difficultyBias = map(difficulty, 1, difficultyScale, 2.0, 0.35);


        //determine the direction the next platform is going to be in
        // the closer it is to the edge it is more likely to change direction
        int currentX = int(parentPlatform.get(int(parentPlatform.size()/2)).x);
        float chanceToFlip = 0;

        if(direction == 1){ // moving right X increases
            // pow makes the chance lower
            chanceToFlip = pow((float(currentX) / sizeX), 4);
        }
        else{// moving left X decreases
            chanceToFlip = pow(1 - (float(currentX) / sizeX), 4);
        }

        if(random(1) < chanceToFlip){
            direction *= -1; // change direction
            change = true;
        }
        //ok we're going to do a few things here
        //use random number to figure out how far this platform is from the last one
        //first determine jump distance (horizontal)
        // bias makes it more likely to choose longer distances at harder difficulties
        int horzDist = ceil(pow(random(1), difficultyBias) * scaledHorzLimit);
        
        // are we going up or down
        float vertDirection = random(1);
        int vertDist;

        PVector start = new PVector();

        boolean climbable = false;

        // should only fall if we are not changing direction
        // 5 % chance of climbing
        if((vertDirection < 0.05 && (parentPlatform.get(0).y + fallLimit < sizeY)) && !change) {// go down also less likely
            //add bias
            vertDist = ceil(pow(random(1), difficultyBias) * scaledFallLimit) ; // falling is positive

        }else if(vertDirection < 0.22 && !change){//climbing 
            //can go up as much as platform length
            //climbs are not very affected by diffculty other than horizontal distance
            vertDist = -1 * ceil(random(vertJumpLimit, platformSizeLimit));
        
            climbable = true;
        
        }else{ //jumping
            if(horzDist == horzJumpLimit){
                vertDist = -1 * int(pow(random(1), difficultyBias) * 2);
            }
            else{
                vertDist = -1 * ceil(pow(random(1), difficultyBias) * scaledVertLimit); // jumping is negative
            }
        }

        PVector platformEdge = getPlatformEdge(parentPlatform, direction);


        //check if space there is space for a new platform in a the given direction
        if(spaceInLevel(level, horzDist, direction, platformEdge, sizeX, climbable)){
            start = new PVector(platformEdge.x + horzDist * direction, platformEdge.y + vertDist);
        }else{
            //generatePlatforms(parentPlatform, level, sizeX, sizeY, direction, depth + 1);
            climbable = false;
            direction *= -1;
            platformEdge = getPlatformEdge(parentPlatform, direction);
            horzDist = 2;
            vertDist = -2;
            start = new PVector(platformEdge.x + horzDist * direction, platformEdge.y + vertDist);
        }

        //double check that the direction doesn't cause a major fuckup
        int attempts = 0;
        while(attempts < 5 && (((start.x - platformSizeLimit) < 0 && direction < 0)|| ((start.x + platformSizeLimit) >= sizeX) && direction > 0)){
            climbable = false;
            direction *= -1;
            platformEdge = getPlatformEdge(parentPlatform, direction);
            horzDist = 2;
            vertDist = -2;
            start = new PVector(platformEdge.x + horzDist * direction, platformEdge.y + vertDist);
            attempts++; // bound so that this doesn't loop infinitely
        }
        if(attempts >= 5){
            //regenerate a new platform
            return generatePlatforms(parentPlatform, level, sizeX, sizeY, direction, depth + 1, difficulty); // pass the parent if the last platform didn't work
        }

        //determine the size of the platform (max size 10?)
        int size = int(random(platformSizeMin,platformSizeLimit));

        // generate the platform with a using 2D noise
        // also add platform to Pvector list
        ArrayList<PVector> platform = new ArrayList<PVector>();
        float noiseFactor = random(100); 
        float baseNoise = noise(noiseFactor); //the first tile. important for jump clearence
        for(int x = 0; x < size; x++){
            int xIndex = int(start.x) + (x * direction);

            int columnHeight = int((noise(noiseFactor) - baseNoise)* maxColumnHeight); // colmn height can be zero. think as offset

            //only at x == 0 clamp column height to zero
            if(!climbable && x == 0) columnHeight = 0;

            //random increment noise.
            noiseFactor += random(0.2,0.5);

            if(xIndex < 0 || xIndex >= sizeX) continue; // skips platform.add too
            int y;
            // if(x == 0)
            //     y = int(start.y);
            // else
            y = int(start.y - columnHeight);

            if(y < 2 || y >= sizeY) continue;

            if(level[xIndex][y] != 6){
                if(x == 0 && climbable){
                    //create clibing blocks instead of first block
                    for(int i = int(platformEdge.y); i >= y - 1; i--){
                        level[xIndex][i] = 2;
                    }
                }else{
                    level[xIndex][y] = 1;

                    //add player clearance above written tile
                    level[xIndex][y-1] = 6; // 6 is player space
                    level[xIndex][y-2] = 6;
                    if(y-3 >= 0) level[xIndex][y-3] = 7; // helpfuly for spawning enemies
                    if(y-4 >= 0) level[xIndex][y-4] = 7;
                    platform.add(new PVector(xIndex, y));
                }
            }else if(xIndex == 0){
                break; //leave the platform empty and generate a new platform
            }
        }


        if(!platform.isEmpty()){
            //see if there is a ghost on the platform
            if(random(1) < spawnChance){
                //spawn ghost on this platform
                float platformSpawn = 0.01; //1 percent chance on first tile
                float platformInc = 1.0 / float(platform.size() * 3); // guarantee's a spawn on this platform. but just somewhere on it rather then a set spot

                for(PVector tile:platform){
                    for(int i = 1; i <= 3; i++){
                        if(random(1) < platformSpawn){
                            //spawn enemy and break
                            level[int(tile.x)][int(tile.y - i)] = 41;
                            platformSpawn = 0;
                            break;
                        }else{ //otherwise increase chance of spawn
                            platformSpawn+=platformInc;
                        }
                    }
                    //hardest difficulty can spawn multiple ghosts per platform
                    if(platformSpawn == 0 && difficulty != difficultyScale) break; 
                }
                //reset spawnchance
                spawnChance = baseChance;
                    
            }else{//otherwise increase spawn increment
                spawnChance += increment;
            }

        }

        //if the platforms are high enough then stop recursion
        if((start.y < platformSizeLimit + 2) && !platform.isEmpty()){
            return platform;
        }
        else{
            if(platform.isEmpty())
                return generatePlatforms(parentPlatform, level, sizeX, sizeY, direction, depth + 1, difficulty); // pass the parent if the last platform didn't work

            else
                return generatePlatforms(platform, level, sizeX, sizeY, direction, depth + 1, difficulty);
        }

    }

    private PVector getPlatformEdge(ArrayList<PVector> platform, int direction){
        boolean firstIsLeft = platform.get(0).x < platform.get(platform.size()-1).x;
        if(direction > 0){
            return firstIsLeft ? platform.get(platform.size()-1) : platform.get(0);
        } else {
            return firstIsLeft ? platform.get(0) : platform.get(platform.size()-1);
    }
}

    private boolean spaceInLevel(int[][] level, int horzDist, int direction, PVector platformEdge, int sizeX, boolean climbable){
        boolean space = true;

        if(platformEdge.x + ((horzDist + platformSizeLimit) * direction) < 0 || platformEdge.x + ((horzDist + platformSizeLimit) * direction) >= sizeX){
            return false;
        }

        if(climbable && level[int(platformEdge.x) + horzDist * direction][int(platformEdge.y)] == 1){
            return false;
        }
        //we will allow for some overlap for the sake of not breaking everything
        for(int i = 0; i < int(platformSizeLimit/2); i++){ // i is an offset
           if(level[int(platformEdge.x) + ((horzDist + i) * direction)][int(platformEdge.y)] == 0){
            space = true;
           } else{
            space = false;
            break; // break loop and return
           }
        }
        return space;
    }

    // lets start with generating a level with just 0's and 1's
}