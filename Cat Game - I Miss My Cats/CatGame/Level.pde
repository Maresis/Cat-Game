/*
    Here is the class that defines how levels are set up.

    This sets up the sight range, stores the level file, holds player spawnPoint

    This will be a bit more useful down the line when there are multiple levels. Now it's a smidge redundant.
*/
class Level{
    // these are all public because they will all be accessed by the main function when a level is chosen and I dont want to write use a lot of getters and setters
    // public int sightRangeX;
    // public int sightRangeY;

    public String levelFile;

    public int startPosX;
    public int startPosY;

    public Level(String file){
        this.levelFile = file;
        
    }

}