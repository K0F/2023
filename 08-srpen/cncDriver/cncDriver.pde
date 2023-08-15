import processing.serial.*;

// The serial port:
Serial myPort;

// 1 step = 11.1111um
int len = 5000;
int speedx = 64;
int speedy = 64;
float atx, aty, btx, bty, alen, blen;

void setup(){
  size(420,594);
  frameRate(25);
  // List all the available serial ports:
  printArray(Serial.list());
  // Open the port you are using at the rate you want:
  myPort = new Serial(this, Serial.list()[0], 9600);
}


boolean ready = true;

void draw(){
  background(255);

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

  atx = random(0,width);
  aty = random(0,width);
  
  btx = width - atx;
  bty = aty;

  float alpha = atan(aty/atx);
  alen = (cos(alpha) * atx);

  float beta = atan(bty/btx);
  blen = (cos(beta) * btx);

  if(frameCount%25==0){
    move(int(blen),int(alen));
    myPort.write("x");
    myPort.write("y");
  }

  stroke(0);

}


void move(int _x, int _y){
  myPort.write("X00064Y00064A"+nf(_x,5)+"B"+nf(_y,5));
  ready = false;
}

void send(){
  myPort.write("X00064Y00064A"+nf(int(alen),5)+"B"+nf(int(blen),5));
  ready = false;
}

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
