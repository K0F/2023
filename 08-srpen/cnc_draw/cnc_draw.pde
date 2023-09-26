

ArrayList points;

// Y:X ratio
// float ratio = 2.0;
// float correction = -180.0+360.0;
float scalar = 100.0;

//////////////////////////////////

void setup(){
   size(210*3,297*3); 
  frameRate(60);
    points = new ArrayList();
}



void draw(){
  
  background(255);
  stroke(0);
  
  beginShape();
  for(int i = 0;i<points.size();i++){
   Point tmp = (Point)points.get(i);
   vertex(tmp.x,tmp.y);
  }
  vertex(mouseX,mouseY);
  endShape();
  
  
}

void keyPressed(){
 if(key=='s'){
   String output[] = new String[0];
   for(int i = 0; i<points.size(); i++){
   Point tmp = (Point)points.get(i);
   output = expand(output,output.length+1);
   output[output.length-1] = int((tmp.x)*scalar)+" "+int((tmp.y)*scalar);
  }
  
  saveStrings("drawing.txt",output);
 }
 
 if(key==' '){
  points= new ArrayList(); 
 }
 
 if(keyCode==BACKSPACE){
   if(points.size()>1)
  points.remove(points.size()-1); 
 }
}

void mousePressed(){
 points.add(new Point(mouseX,mouseY)); 
}


class Point{
  float x,y;
  
  Point(float _x, float _y){
   x=_x;
   y=_y;
  }
    
}
