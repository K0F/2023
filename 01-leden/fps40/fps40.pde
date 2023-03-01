
void setup(){
  size(1280,1024,P2D);
  frameRate(40);
}



void draw(){
  background(frameCount%2==0?0:255);
  if(frameCount>20160){
exit();
  }
  saveFrame("fr######.tga");
}
