import java.util.Arrays;

class LevelGenerator{
    private int difficultyScale;

    private int vertJumpLimit = 2;
    private int fallLimit = 6;
    private int horzJumpLimit = 4;
    private int platformSizeLimit = 6;

    private float noiseScalar = 0.2;

    public LevelGenerator(int diffScale){
        difficultyScale = diffScale;
    }

    // returns the string of the level generated
    public String generateLevel(int sizeX, int sizeY){
        String fileName = "generatedLevel.txt";

        //lets first generate an array of 0s
        int level[][];
        level = new int[sizeX][sizeY];

        for(int[] row : level) {
            Arrays.fill(row,0);
        }

        // place platforms around 
        placePlatforms(level, sizeX, sizeY);

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

    void placePlatforms(int[][] level, int sizeX, int sizeY){
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
        generatePlatforms(platform, level, sizeX, sizeY, 1, 0);


    }

    private void generatePlatforms(ArrayList<PVector> parentPlatform, int[][] level, int sizeX, int sizeY, int direction, int depth){

        boolean change = false;
        //to prevent too mcuh recursion
        if(depth > 100) return;
        println(depth);

        //determine the direction the next platform is going to be in
        // the closer it is to the edge it is more likely to change direction
        int currentX = int(parentPlatform.get(int(parentPlatform.size()/2)).x);
        float chanceToFlip = 0;

        if(direction == 1){ // moving right X increases
            // pow makes the chance lower
            chanceToFlip = pow((float(currentX) / sizeX), 4);
        }
        else{// moving left X decreases
            chanceToFlip = pow(1 - float(currentX) / sizeX, 4);
        }

        if(random(1) < chanceToFlip){
            direction *= -1; // change direction
            change = true;
        }
        //ok we're going to do a few things here
        //use random number to figure out how far this platform is from the last one
        //first determine jump distance (horizontal)
        int horzDist = ceil(random(horzJumpLimit)); 
        
        // are we going up or down
        float vertDirection = random(1);
        int vertDist;

        PVector start = new PVector();

        if(vertDirection < 0.05 && (parentPlatform.get(0).y + fallLimit < sizeY)) {// go down also less likely
            vertDist = ceil(random(fallLimit)); // falling is positive

            //a platform below the pevious platform should be generated on the left or right side of the parent
            if(direction < 0){//moving left
                PVector platformEdge = (parentPlatform.get(0).x < parentPlatform.get(parentPlatform.size() - 1).x) ? parentPlatform.get(0) : parentPlatform.get(parentPlatform.size() - 1);
                start = new PVector(platformEdge.x - horzDist, platformEdge.y + vertDist);
            }else{//moving right
                PVector platformEdge = (parentPlatform.get(0).x < parentPlatform.get(parentPlatform.size() - 1).x) ? parentPlatform.get(parentPlatform.size() - 1) : parentPlatform.get(0);
                start = new PVector(platformEdge.x + horzDist, platformEdge.y + vertDist);
            }

        }else{ //jumping
            if(horzDist == horzJumpLimit){
                vertDist = 0;
            }
            else{
                vertDist = -1 * (ceil(random(vertJumpLimit))); // jumping is negative

            }

            PVector platformEdge;
            if(direction > 0){
                platformEdge = (parentPlatform.get(0).x < parentPlatform.get(parentPlatform.size()-1).x) 
                    ? parentPlatform.get(parentPlatform.size()-1) : parentPlatform.get(0);
            } else {
                platformEdge = (parentPlatform.get(0).x < parentPlatform.get(parentPlatform.size()-1).x) 
                    ? parentPlatform.get(0) : parentPlatform.get(parentPlatform.size()-1);
            }
            //check if space there is space for a new platform in a the given direction
            if(spaceInLevel(level, horzDist, direction, platformEdge, sizeX)){
                start = new PVector(platformEdge.x + horzDist * direction, platformEdge.y + vertDist);
            }else{
            //generatePlatforms(parentPlatform, level, sizeX, sizeY, direction, depth + 1);
                direction *= -1;
                change = true;
            }
            if(change){
                horzDist = 2;

                vertDist = min(vertDist, -2);
                start = new PVector(platformEdge.x + horzDist * direction, platformEdge.y + vertDist);
            }

        }
        
        //the jump height has a max

        //determine the size of the platform (max size 10?)
        int size = ceil(random(platformSizeLimit));
        
        // change direction and generate a platform in a different direction
        if(start.x - size <= 0 && depth != 0){ // direction should change to position
            start.x += size;

        }
        if(start.x + size >= sizeX){ // change to negative
            start.x -= size;
        }

        //check y as well
        if(start.y - vertDist - 3 < 0){
            start.y += 3;
        }

        // generate the platform with a using 2D noise
        // also add platform to Pvector list
        ArrayList<PVector> platform = new ArrayList<PVector>();
        float noiseFactor = noiseScalar;
        for(int x = 0; x < size; x++){
            int xIndex = int(start.x) + (x * direction);

            int columnHeight = int(noise(noiseFactor) * 1) + 1;
            noiseFactor += 0.1;

            if(xIndex < 0 || xIndex >= sizeX) continue; // skips platform.add too
            for(int y = int(start.y); y > int(start.y) - columnHeight; y--){
                if(y < 0 || y >= sizeY) continue;
                level[xIndex][y] = 1;
            }
            platform.add(new PVector(xIndex, int(start.y) + columnHeight - 1));
        }

        //if the platforms are high enough then stop recursion
        if(start.y < 5){
            return;
        }
        else{
            generatePlatforms(platform, level, sizeX, sizeY, direction, depth + 1);
        }

    }

    private boolean spaceInLevel(int[][] level, int horzDist, int direction, PVector platformEdge, int sizeX){
        boolean space = true;

        if(platformEdge.x + ((horzDist + platformSizeLimit) * direction) < 0 || platformEdge.x + ((horzDist + platformSizeLimit) * direction) >= sizeX){
            direction *= -1; // change direction
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