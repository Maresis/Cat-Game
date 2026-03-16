import java.awt.Rectangle;

// this class just detects collision and returns how to handle them

class CollisionSystem{
    //rectangles literally make this so easy hehehehehehehe
    Rectangle entity;
    Rectangle tile;
    Rectangle collision;


    PVector correction;
    PVector direcction;
    
    //
    public CollisionSystem(){
        entity = new Rectangle();
        tile = new Rectangle();
        collision = new Rectangle();
        //default value
        correction = new PVector(0, 0);
        direction = new PVector(0, 0);
        this.correction.
    }
    public boolean detectCollision(PVector entityWA, float entityWidth, float entityHeight, PVector tileWA, float tileWidth, float tileHeight){
        // topleftx toplefty width height
        entity.setRect(entityWA.x, entityWA.y, entityWidth, entityHeight);
        tile.setRect(tileWA.x, tileWA.y, tileWidth, tileHeight);

        if(entity.intersects(tile)){
            return true
        }else{
            return false;
        }
    }
    //WASD for directions
    public PVector correctCollision(){
        
        // check for overlap
        if(entity.intersects(tile)){
            // get collision
            collision = entity.createIntersection(tile);
        }
        else{
            //return (0,0) vector. no correction needed
            return correction;
        }

        //find direction
        determineDirection();

        //set correction
        correction.set(collision.getWidth() * direction.x, collision.getLength() * direction.y);

        return correction;
    }

    private void determineDirection(){
        float x; // ;)
        float y;

        //entity left or right of tile
        if(entity.getX() <= tile.getX()){
            //entity is to the left so move it left
            x = -1;
        }
        else{
            x = 1;
        }

        //entity below or above tile
        if(entity.getY() <= tile.getY()){
            //above move up
            y = -1
        }
        else{
            y = 1;
        }

        direction.set(x, y);   
    }


}