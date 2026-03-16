import java.awt.Rectangle;

// this class just detects collision and returns how to handle them
// THIS SYSTEM CANNOT BE USED RECURSIVELY. 
// REDESIGN IF RECURSION IS A MUST FOR FUTURE COLLISION DETECTION
// I MARKED PROBLEM 
class CollisionSystem{
    //rectangles literally make this so easy hehehehehehehe
    Rectangle entity;
    Rectangle tile;
    Rectangle collision;


    PVector correction;
    PVector direction;
    
    //
    public CollisionSystem(){
        entity = new Rectangle();
        tile = new Rectangle();
        collision = new Rectangle();
        //default value
        correction = new PVector(0, 0);
        direction = new PVector(0, 0);

    }
    public boolean detectCollision(PVector entityWA, float entityWidth, float entityHeight, PVector tileWA, float tileWidth, float tileHeight){
        // topleftx toplefty width height
        entity.setRect(entityWA.x, entityWA.y, entityWidth, entityHeight);
        tile.setRect(tileWA.x, tileWA.y, tileWidth, tileHeight);

        if(entity.intersects(tile)){
            return true;
        }else{
            return false;
        }
    }

    // THIS MAKES RECURSION PROBLEMATIC AS detetectionCollision should be called before this to make sure it is the
    //correct collision. I do no checks to make sure this happens. Will add later. TODO: MAKE SAFE
    public PVector correctCollision(){
        
        // check for overlap
        if(entity.intersects(tile)){
            // get collision
            collision = entity.intersection(tile);
        }
        else{
            //return (0,0) vector. no correction needed
            return correction;
        }

        //find direction
        determineDirection();

        //set correction
        correction.set((float)(collision.getWidth() * direction.x), (float)(collision.getHeight() * direction.y));

        return correction;
    }

    private void determineDirection(){
        float x; // ;)
        float y;

        if(collision.getWidth() < collision.getHeight()){
        //entity left or right of tile
            if(entity.getX() < tile.getX()){
                //entity is to the left so move it left
                x = -1;
            }
            else if(entity.getX() > tile.getX()){
                x = 1;
            }
            else{
                x = 0;
            }
            y = 0;
        }else{

            //entity below or above tile
            if(entity.getY() < tile.getY()){
                //above move up
                y = -1;
            }
            else if (entity.getY() > tile.getY()){
                y = 1;
            }
            else{
                y = 0;
            }
            x = 0;
        }

        direction.set(x, y);   
    }


}