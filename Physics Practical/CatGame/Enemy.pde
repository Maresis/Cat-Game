

class Enemy extends Entity{
    // 1 - ghost, 2 - water


    public Enemy(int spawnx, int spawny, int type){
        super();
        this.spawnX = spawnx;
        this.spawnY = spawny;
        this.type = type;

        //set default invMass
        this.invMass = normalInvMass;
        //type determines particles

        
        switch(type){
            case 1:
                // print("created ghost");
                //ghost cats are the same size as cats so use default

                //mass should be way lighter than a cat so the inverse mass should be much larger
                invMass *= 10;
                
                //lets add gravity to the ghost just to test
                //set behavior
                break;
            case 2:
                //the width of a water droplet will be half the area of a ghost
                width /= 2;
                height /= 2;

                //lets call water like 5 times light than a cat
                invMass *= 5;
                break;
            default:

        }
        particles.add(new Particle((spawnx * Tile.TILE_LENGTH), (spawny * Tile.TILE_LENGTH), 0, 0, invMass));
        particles.add(new Particle((spawnx * Tile.TILE_LENGTH) + width, (spawny * Tile.TILE_LENGTH), 0, 0, invMass));
        particles.add(new Particle((spawnx * Tile.TILE_LENGTH) + width, (spawny * Tile.TILE_LENGTH) + height, 0, 0, invMass));
        particles.add(new Particle((spawnx * Tile.TILE_LENGTH), (spawny * Tile.TILE_LENGTH) + height, 0, 0, invMass));

        addForce(new Gravity(new PVector(0f, 1f)));

    }

    public int draw(float offsetX, float offsetY){
        //by deafult entities will just be represented by a shape of thier particles position
        update(); // update forces
        
        //integrate particles
        for(Particle p: particles){
            p.integrate();
        }

        int damage = handleCollisions(tileMap, player, player.tilePosX, player.tilePosY);

        fill(0);
        beginShape();
            for(Particle p: particles){
                // position is a PVector in particle
                vertex(p.position.x - offsetX, p.position.y - offsetY );
            }
        endShape(CLOSE);

        return damage;

        //we'll do collisions here but we want to test forces first
    }

    private int handleCollisions(float playerTileX, float playerTileY){
        //use player to calculate tile positioning
        int lowXRange = floor((playerTileX/Tile.TILE_LENGTH) - (tileMap.getLengthRange()/2));
        int highXRange = ceil(playerTileX/Tile.TILE_LENGTH + (tileMap.getLengthRange()/2));

        int lowYRange = floor((playerTileY/Tile.TILE_LENGTH) - (tileMap.getHeightRange()/2));
        int highYRange = ceil((playerTileY/Tile.TILE_LENGTH) + (tileMap.getHeightRange()/2));

        if(lowXRange < 0) lowXRange = 0;
        if(lowYRange < 0) lowYRange = 0;
        if(highXRange > tileMap.getLength()) highXRange = tileMap.getLength();
        if(highYRange > tileMap.getHeight()) highYRange = tileMap.getHeight();

        //test tiles
        for( int x = lowXRange; x < highXRange; x++){
            for(int y = lowYRange; y < highYRange; y++){
                //the particles position of the first particle should be the tile position
                if(testCollision.detectCollision(new PVector(particles.get(0).position.x, particles.get(0).position.y), width, height, new PVector(x * Tile.TILE_LENGTH, y * Tile.TILE_LENGTH), Tile.TILE_LENGTH, Tile.TILE_LENGTH)){
                    Tile currentTile = tileMap.getTile(x, y);

                    if(currentTile.isCollidable()){
                        PVector correction = testCollision.correctCollision();
                        
                        //fix the position of each particle
                        for(Particle p: particles){
                            p.position.x += correction.x;
                            p.position.y += correction.y;
                        }
                    

                        //also zero velocity so that thinks don't clip though tiles because they are moving at super sonic speed
                        for(Particle p: particles){
                            //only zero velocity in direction of collision so that the cats don't stick to walls
                            if(correction.x != 0)
                                p.velocity.x = 0;
                            else if(correction.y != 0)
                                p.velocity.y = 0;
                        }
                }
                }
            }
        }


        //test player 
        if(testCollision.detectCollision(new PVector(particles.get(0).position.x, particles.get(0).position.y), width, height, new PVector(playerTileX, playerTileY), player.width, player.height)){
            //kill player
            print("Kill the player");
            return 1;
        }

        return 0;

    }

}