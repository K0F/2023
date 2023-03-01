

void setup(){
  size(1280,720);

}


void draw(){

  background(0);
  
  rectMode(CENTER);

  pushMatrix();
  translate(width/2,height/2);
  float R = 100.0;
  for(int i = 0 ; i < 10 ; i++){
    float x = cos(i/10.0*TAU)*R;
    float y = sin(i/10.0*TAU)*R;
    translate(x,y);
    rotate(radians(i/10.0*TAU));
    rect(0,0,5,5);
  }

  popMatrix();


}
