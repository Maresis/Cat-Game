/*
    The player can be three different kinds of cats. This class represents each one
*/
class Cat{
    private String name;

    //useful code for images that I used to help
    //https://stackoverflow.com/questions/9344370/load-multiple-images-in-processing
    /*
    PImage a;
    Pimage b;

    void setup() {
    size(800,800);
    background(127);
    a = loadImage("a/1.jpg");
    b = loadImage("b/1.jpg");
    noLoop();
    }  

    void draw(){
    image(a,random(300),random(300),a.width/2, a.height/2);
    image(b,random(300),random(300),b.width/2, b.height/2);
}
    also https://processing.org/reference/image_.html
     */
    private PImage defaultImage;
    private PImage abilityImage;

    //to be replaced with asset
    private color c;

    public String specialAbility;

    public Cat(String name, color col, String ability, String normalImage, String specialImage){
        this.name = name;
        this.c = col;
        this.specialAbility = ability;
        defaultImage = loadImage(normalImage);
        abilityImage = loadImage(specialImage);

        //create pixels <3
    }

    public void draw(ArrayList<Particle> particles, int image, int width, int height, int direction){
        //what image do we draw?
        switch(image){
            case 0:
            //ill figure out direction later
                //defaultImage  
                // scale(direction, 1); // scale from https://discourse.processing.org/t/flip-the-image-horizontally/25165/2
                image(defaultImage, particles.get(0).position.x, particles.get(0).position.y, width, height);  
                break;
            case 1:
            image(abilityImage, particles.get(0).position.x, particles.get(0).position.y, width, height); 
                break;
        }
        // beginShape();
        // for(Particle p: particles){
        //     vertex(p.position.x, p.position.y);
        // }
        // endShape(CLOSE);

    }


}