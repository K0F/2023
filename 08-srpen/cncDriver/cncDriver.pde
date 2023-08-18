import processing.serial.*;

// The serial port:
Serial myPort;

// 1 step = 11.1111um
int len = 18900;
int mag = 1200/2;
int interval = 15;

int speedx = 32;
int speedy = 32;
float atx, aty, btx, bty, alen, blen, prevAlen, prevBlen;

void setup(){
  size(210*2,297*2,P2D);
  frameRate(120);
  // List all the available serial ports:
  printArray(Serial.list());
  // Open the port you are using at the rate you want:
  myPort = new Serial(this, Serial.list()[0], 9600);
  delay(500);
  move(10,10);
  
  noiseSeed(2023);
  
  
  alen = map(dist(0,0,-width*1.5,-height*1.5),0,width,0,len);
  blen = map(dist(0,0,width*1.5+width,-height*1.5),0,width,0,len);
}


boolean ready = true;
boolean aready, bready;

void draw(){
  background(255);

  //mag = int(noise(frameCount/1200.0)*len);

  while (myPort.available() > 0) {
    String inBuffer = myPort.readString();
    if (inBuffer != null) {
      if(inBuffer.trim().equals("A ready") && !aready){
        aready = true;
        println("A OK");
      };
      
      if(inBuffer.trim().equals("B ready") && !bready){
        bready = true;
        println("B OK");
      };
      
        if(!aready || !bready)
        ready = false;
      
      if(aready && bready && !ready)
        ready = true;
        aready = false;
        bready = false;
        println("A and B OK");
        };
        
        
      println(inBuffer);
    }
  
  if(frameCount%interval==0){
        gotoxy((sin(frameCount/1200.0*TAU))*mag,(cos(frameCount/1200.0*TAU))*mag);
  }
  
  
  /*
  if(frameCount%(interval*100)==0){
        gotoxy(width/2,height/2);
  }
  */
  
  //line(atx,aty,)

}


void gotoxy(float _x, float _y){
    
  
  prevAlen = alen;
  prevBlen = blen;


  float tx = _x;
  float ty = _y; 


  
  alen = map(dist(tx,ty,-width*1.5,-height*1.5),0,width,0,len);
  blen = map(dist(tx,ty,width*1.5+width,-height*1.5),0,width,0,len);
  
  //speedx = int(constrain(blen/alen,2,120));
 // speedy = int(constrain(alen/blen,2,120))    ;
  
  if(alen-prevAlen>0){
  myPort.write("y");
  
  }else if(alen-prevAlen<0){
  myPort.write("u");
}
  
  if(blen-prevBlen>0){
  myPort.write("c");
}else if(blen-prevBlen<0){
  myPort.write("x");
}
  
  println(int(alen-prevAlen)+", "+int(blen-prevBlen));
  move(int(abs(alen-prevAlen)),int(abs(blen-prevBlen)));
  
}


void moveX(int _x){
  myPort.write("X"+nf(speedx,5)+"A"+nf(_x,5));
  //ready = false;
}

void moveY(int _y){
  myPort.write("Y"+nf(speedy,5)+"B"+nf(_y,5));
  //ready = false;
}

void move(int _x, int _y){
  myPort.write("X"+nf(speedx,5)+"Y"+nf(speedy,5)+"A"+nf(_x,5)+"B"+nf(_y,5));
  //ready = false;
}

/*
void send(){
  myPort.write("X"+nf(speedx,5)+"Y"+nf(speedy,5)+"A"+nf(_x,5)+"B"+nf(_y,5));
  ready = false;
}
*/

void keyPressed(){
  if(key=='x'){
    myPort.write("x");
  }

  if(key=='y'){
    myPort.write("y");
  }

  if(keyCode==ENTER){
    myPort.write("s");
  }
}
