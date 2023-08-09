import processing.serial.*;

// The serial port:
Serial myPort;

// 1 step = 11.1111um
int len = 5000;


void setup(){
	size(420,594);
	// List all the available serial ports:
	printArray(Serial.list());
	// Open the port you are using at the rate you want:
	myPort = new Serial(this, Serial.list()[0], 9600);
}

boolean ready = true;

void draw(){
 background(255); 
 
  while (myPort.available() > 0) {q
    String inBuffer = myPort.readString();   
    if (inBuffer != null) {
	if(inBuffer.trim().equals("ready"))
		ready = true;		
    	println(inBuffer);
    }
  }

  stroke(0);

}

void keyPressed(){
  if(key=='x'){
   myPort.write("x");
 }

 if(key=='y'){
   myPort.write("y");
 }

 if(keyCode==ENTER && ready){
	myPort.write("X00064Y00064L"+nf(len,5));
	ready = false;
 }
}
