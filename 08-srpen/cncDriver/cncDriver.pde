import processing.serial.*;

// The serial port:
Serial myPort;

// 1 step = 11.1111um
int len = 2500;
int speedx = 24;
int speedy = 24;
float atx, aty, btx, bty, alen, blen;

void setup(){
  size(420,594,P2D);
  frameRate(60);
  // List all the available serial ports:
  printArray(Serial.list());
  // Open the port you are using at the rate you want:
  myPort = new Serial(this, Serial.list()[0], 9600);
}


boolean ready = true;

void draw(){
  background(255);

  len = int(noise(frameCount/25)*1000);

  while (myPort.available() > 0) {
    String inBuffer = myPort.readString();
    if (inBuffer != null) {
      if(inBuffer.trim().equals("B ready") && !ready){
        ready = true;
        println("OK");
        }
      println(inBuffer);
    }
  }

  atx = noise(millis()/100.0,0) * len;
  aty = noise(0,millis()/100.0) * len;
  
  btx = width - atx;
  bty = aty;

  float alpha = atan(aty/atx);
  alen = (cos(alpha) * atx);

  float beta = atan(bty/btx);
  blen = (cos(beta) * btx);

  if(frameCount%240==0){
    myPort.write("x");
    //myPort.write("y");
  }
	if(frameCount%5==0){
    move(int(blen),int(alen));
	}
  stroke(0);

}


void move(int _x, int _y){
  myPort.write("X"+nf(speedx,5)+"Y"+nf(speedy,5)+"A"+nf(_x,5)+"B"+nf(_y,5));
  ready = false;
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
    ready = !ready;
  }
}
