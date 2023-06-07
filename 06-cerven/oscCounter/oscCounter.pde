/**
 * oscP5parsing by andreas schlegel
 * example shows how to parse incoming osc messages "by hand".
 * it is recommended to take a look at oscP5plug for an
 * alternative and more convenient way to parse messages.
 * oscP5 website at http://www.sojamo.de/oscP5
 */

import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

boolean gotNew = false;
int BAR,TOTAL,BPM;
float fade = 255;

void setup() {
  size(1024,768,P2D);
  frameRate(30);
  textFont(createFont("Monaco",48,true));
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this,10001);
  
}

void draw() {
  background(fade);
  
  fill(255-fade);
  fade *= 0.75;
  
  if(gotNew)
  fade = 255.0;
  
  textAlign(CENTER);
  text(nf(TOTAL,4)+"\n"+nf(BAR,4)+"\n"+nf(BPM,4),width/2,height/2-100);
  
  gotNew = false;
}


void mousePressed() {
  /* create a new osc message object */
  OscMessage myMessage = new OscMessage("/test");
  
  myMessage.add(123); /* add an int to the osc message */
  myMessage.add(12.34); /* add a float to the osc message */
  myMessage.add("some text"); /* add a string to the osc message */

  /* send the message */
  oscP5.send(myMessage, myRemoteLocation); 
}


void oscEvent(OscMessage theOscMessage) {
  /* check if theOscMessage has the address pattern we are looking for. */
  
  if(theOscMessage.checkAddrPattern("/osc/timer")==true) {
    /* check if the typetag is the right one. */
    
    if(theOscMessage.checkTypetag("iii")) {
      /* parse theOscMessage and extract the values from the osc message arguments. */
      BAR = theOscMessage.get(0).intValue();  
      TOTAL = theOscMessage.get(1).intValue();
      BPM = theOscMessage.get(2).intValue();
       
      //print("### received an osc message: "+theOscMessage.typetag()+" with typetag: "+theOscMessage.typetag()+".");
      //println(" values: "+firstValue+", "+secondValue);
      gotNew = true;
      return;
    }  
  } 
  println("### received an osc message. with address pattern "+theOscMessage.addrPattern());
}
