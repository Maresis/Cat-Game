/*
    The player can be three different kinds of cats. This class represents each one
*/
class Cat{
    private String name;

    //to be replaced with asset
    private color c;

    public String specialAbility;

    public Cat(String name, color col, String ability ){
        this.name = name;
        this.c = col;
        this.specialAbility = ability;
    }

    public void draw(ArrayList<Particle> particles){
        fill(c);

        beginShape();
        for(Particle p: particles){
            vertex(p.position.x, p.position.y);
        }
        endShape(CLOSE);

    }


}