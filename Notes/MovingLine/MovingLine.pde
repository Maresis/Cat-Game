// animation
//white lines on black background
// the lines from left border to right border
//this is from a tutorial on the processing website to learn processing better

void setup(){
  //when size is declared it initializes width and height
    size(600, 350);

}

int line_x = 0;
void draw() {
    //we will make background black
    background(0);

    //to change color of line
    stroke(255); //0 is blakc 255 is white

    // lets experiment a bit. Lets make white lines move across the screen
    //line should go from top to bottom of screen
    //lets do this recursively because I am an idiot.
    if( line_x < width){
      line(line_x, 0, line_x, height);
      //this controls the line going across the screen
      line_x += 5;
    }
    else{
      line_x = 0;
    }
    
    //The result of this was that the line continues to go across the screen when reset to 0 so it looped continuously
    // My guess is that this happens because when the variable "line" is changed, the compiler moves up to where the 
    // variable line was declared and moves on from there.


}
