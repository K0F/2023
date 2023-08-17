import processing.serial.*;

// The serial port:
Serial myPort;

// 1 step = 11.1111um
int len = 24;
int mag;
int interval = 30;

int speedx = 720;
int speedy = 720;
float atx, aty, btx, bty, alen, blen, prevAlen, prevBlen;

void setup(){
  size(400,400,P2D);
  frameRate(120);
  // List all the available serial ports:
  printArray(Serial.list());
  // Open the port you are using at the rate you want:
  myPort = new Serial(this, Serial.list()[0], 9600);
  delay(500);
  move(10,10);
  
  noiseSeed(2023);
}


boolean ready = true;
boolean aready, bready;

void draw(){
  background(255);

  mag = int(noise(frameCount/1200.0)*len);

  //while (myPort.available() > 0) {
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
        
        
      //println(inBuffer);
    //}
  

  atx = mouseX-width/2;
  aty = mouseY-height/2;
  btx = width/2 - atx;//(noise(0,millis()/1000.0,0)-0.5) * mag;
  bty = height/2 - aty;//(noise(0,0,millis()/1000.0)-0.5) * mag;


  float alpha = atan(aty/atx);
  alen = (cos(alpha) * atx);

  float beta = atan(bty/btx);
  blen = (sin(beta) * btx);

    
    if(frameCount%(interval)==0){
  if(atx<0 || btx<0)
  myPort.write("x");
  if(aty<0 || bty<0)
  myPort.write("y");
      move(int(abs(blen)),int(abs(alen)));
  
  
    //if(alen < 0)
  //  myPort.write("x");
   // moveX(int(alen));
    //if(blen < 0)
    
   // myPort.write("y");
   // moveY(int(blen));
}
    
    
    /*
  if(frameCount%(interval)==0){
      move(int(abs(blen)),int(abs(alen)));
      //move(10,100);
}
* */
    //ready = false;

	
	
  stroke(0);

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
  myPort.write("X"+nf(_x,5)+"Y"+nf(_y,5)+"A"+nf(speedx,5)+"B"+nf(speedy,5));
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
