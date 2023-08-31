

ArrayList points;

// Y:X ratio
float ratio = 1.0;
float correction = -180.0+360.0;

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
   for(int i = 1;i<points.size();i++){
   Point tmp1 = (Point)points.get(i-1);
   Point tmp2 = (Point)points.get(i);
   float mag = dist(tmp1.x/ratio,(tmp1.y),tmp2.x/ratio,(tmp2.y));
   float angle = atan2((tmp2.y)-(tmp1.y),(tmp2.x)/ratio-(tmp1.x)/ratio);
   //if(mag>10){
   //for(int ii = 1;ii<points.size();ii++){
     
     
   //}
   //}
   output = expand(output,output.length+1);
   output[output.length-1] = int(degrees(angle+correction))+" "+int(mag);
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
