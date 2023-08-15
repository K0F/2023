import processing.serial.*;

// The serial port:
Serial myPort;

// 1 step = 11.1111um
int len = 3600;
int mag;
int interval = 60;

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

  mag = int(noise(frameCount/600.0)*len);

  while (myPort.available() > 0) {
    String inBuffer = myPort.readString();
    if (inBuffer != null) {
      if(inBuffer.trim().equals("B ready") || inBuffer.trim().equals("A ready") && !ready){
        ready = true;
        println("OK");
        }
      println(inBuffer);
    }
  }

  atx = noise(millis()/1000.0,0) * mag;
  aty = noise(0,millis()/1000.0) * mag;
  
  btx = width - atx;
  bty = aty;

  float alpha = atan(aty/atx);
  alen = (cos(alpha) * atx);

  float beta = atan(bty/btx);
  blen = (cos(beta) * btx);

  if(frameCount%interval==0){

if(alen<0)
    myPort.write("x");
    if(blen<0)
    myPort.write("y");

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
