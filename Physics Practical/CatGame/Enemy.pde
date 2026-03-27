
enum EnemyState {
    IDLE, CHASE, FLEE, DEAD, SHOOTING
}

class Enemy extends Entity{
    // 1 - ghost, 2 - water cannon, 3 - water drop, 4 vacuum?

    //behaviors
    EnemyState state = EnemyState.IDLE;
    float speed;
    float maxForce = 0.1;
    PVector velocity;
    PVector acceleration;

    PImage leftGhost;
    PImage rightGhost;
    public Enemy(int spawnx, int spawny, int type){
        super();
        this.spawnX = spawnx;
        this.spawnY = spawny;
        this.type = type;

        this.velocity = new PVector(0,0);
        this.acceleration = new PVector(0,0);

        //set default invMass
        this.invMass = normalInvMass;
        //type determines particles

        leftGhost = loadImage("GhostLeft.png");
        rightGhost = loadImage("GhostRight.png");

        //cannon stats
        int shots = 5;
        int lastshot = 0; //millis where last shot happened
        int shotinterval = 4000; // intervast in milliseconds between shots
        
        switch(type){
            case 1:
                // print("created ghost");
                //ghost cats are the same size as cats so use default

                //mass should be way lighter than a cat so the inverse mass should be much larger
                invMass *= 10;
                
                //set speed. ghost is slightly slower than a cat
                // this speed is actually set differently than the player moves so we will have to fidget wit hit a bit

                speed = 3;

                //lets add gravity to the ghost just to test
                //set behavior
                break;
            case 2:
                //default width and hieght
                invMass = 0; // cannon does not move
            case 3:
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

        // addForce(new Gravity(new PVector(0f, 1f)));

    }

    @Override
    public void draw(float offsetX, float offsetY){
        if(alive){
            //by deafult entities will just be represented by a shape of thier particles position
            update(); // update forces
            
            //integrate particles
            for(Particle p: particles){
                p.integrate();
            }

            handleCollisions(player.tilePosX, player.tilePosY);

            if(type == 1){
                //if ghost use ghost asset
                if(velocity.x < 0){
                    //ghost left
                    image(leftGhost, particles.get(0).position.x - offsetX, particles.get(0).position.y - offsetY, width, height);
                }else{
                    image(rightGhost, particles.get(0).position.x - offsetX, particles.get(0).position.y - offsetY, width, height);
                }
            }else{
                fill(0);
                beginShape();
                    for(Particle p: particles){
                        // position is a PVector in particle
                        vertex(p.position.x - offsetX, p.position.y - offsetY );
                    }
                endShape(CLOSE);
            }

            if(offScreen(offsetX, offsetY)){
                    state = EnemyState.DEAD;
                }
        }

        //we'll do collisions here but we want to test forces first
    }

    // override update function to add initial state functionality

    @Override
    public void update(){
        super.update();

        switch (state){
            case IDLE:
                if(onScreen && (type == 1))
                    state = EnemyState.CHASE;
                break;
            case CHASE:
                if(player.immune)
                    state = EnemyState.FLEE; // flees from sleeping poe
                 
                chasePlayer();
                //currently state change not defined. 
                //changes in different scenarios
                break;
            case DEAD:
                alive = false;
                break;
            case FLEE:
                //if cat is no longer immune
                if(!player.immune)
                    state = EnemyState.CHASE;
                //no defined behavior yet
                flee();
                break;
            case SHOOTING:
                //shoots bullets at the cat, unless the cat is to the right of it or above it
                break;
        }

        //always seperate just in case
        seperateBehavior();
    }

    private boolean offScreen(float offsetX, float offsetY){
        boolean offScreen = true;
        for(Particle p: particles){
            if(p.position.x * width - offsetX < 0 && p.position.y * height - offsetY < 0){} // do nothing in all cases
            if(p.position.x * width - offsetX < screenWidth && p.position.y * height - offsetY > screenHeight){}
            if(p.position.x * width - offsetX < screenWidth && p.position.y * height - offsetY < 0){}
            if(p.position.x * width - offsetX < 0 && p.position.y * height - offsetY > screenHeight){}
            else offScreen = false; // false if ever on the screen
        }
        return offScreen;
    }

    private void handleCollisions(float playerTileX, float playerTileY){
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
            if(!player.immune){
                player.kill();
                //also kill entity
                state = EnemyState.DEAD;
            }
        }

        //test other entitites
        for(Entity e: entities){
            if(testCollision.detectCollision(particles.get(0).position, width, height, e.particles.get(0).position, e.width, e.height)){
                PVector correction = testCollision.correctCollision();
                        
                //fix the position of each particle
                for(Particle p: particles){
                    p.position.x += correction.x;
                    p.position.y += correction.y;
                }

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

    private void chasePlayer(){
        //inspired from steering lecture material
        // the target position is the player's position
        PVector desiredVelocity = PVector.sub(new PVector(player.tilePosX,player.tilePosY) , particles.get(0).position);
        desiredVelocity.setMag(speed);
        PVector steering = PVector.sub(desiredVelocity, velocity);
        steering.limit(maxForce);

        acceleration.add(steering);
        velocity.add(acceleration);
        velocity.limit(speed);
        //may have to change this we will see
        for(Particle p: particles){
            //add change to each particle
            p.position.add(velocity);
        }

        //for now we won't do anything with orientation but later

        //reset acceleration
        acceleration.mult(0);
    }

    private void flee(){
        //taken and modified from lecture material
        PVector desiredVelocity = PVector.sub(particles.get(0).position, new PVector(player.tilePosX,player.tilePosY));
        desiredVelocity.setMag(speed);
        PVector steering = PVector.sub(desiredVelocity, velocity);
        steering.limit(maxForce);

        acceleration.add(steering);
        velocity.add(acceleration);
        velocity.limit(speed);
        //may have to change this we will see
        for(Particle p: particles){
            //add change to each particle
            //after an entity is spawned it moved independently of the tileMap
            p.position.add(velocity);

            //reset acceleration
            acceleration.mult(0);
        }
    }

    // code copied and further developed from lecture material
    // things must stay a tiles length away from each other
    public void seperateBehavior(){
        PVector seperationForce = new PVector(0,0);
        int neighborCount = 0;

        for(Entity e : entities){
            if( e != this){
                float distance = PVector.dist(this.particles.get(0).position, e.particles.get(0).position);
                if( distance < Tile.TILE_LENGTH && distance > 0){
                    PVector fleeDirection = PVector.sub(this.particles.get(0).position, e.particles.get(0).position);
                    fleeDirection.normalize();
                    fleeDirection.div(distance);
                    seperationForce.add(fleeDirection);
                    neighborCount++;
                }
            }
        }

        //reset acceleration
        acceleration.mult(0);
        if(neighborCount > 0){
            seperationForce.div((float) neighborCount);
            seperationForce.setMag(speed);
            PVector steering = PVector.sub(seperationForce, velocity);
            steering.limit(maxForce);
            acceleration.add(steering);
        }

        //update velocity and position
        velocity.add(acceleration);
        velocity.limit(speed);
        //change psoition for each particle
        for(Particle p: particles){
            p.position.add(velocity);
        }
        //reset acceleration
        acceleration.mult(0);

        
    }

    // private float calculateDistance(Entity ent1, Entity ent2){
    //     //is there an intersection between these two?
    //     if((ent1.particles.get(0).position.x < ent2.partcles.get(0).position.x)){
    //         //first entity left of second
    //         if()
    //     }
    //     else{
    //         //right
    //     }
        
        
    // }
}