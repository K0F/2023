
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



float fade = 0;
color c;

void setup(){
  size(1280,1024,P2D);
  frameRate(60);
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this,10000);
  
  /* myRemoteLocation is a NetAddress. a NetAddress takes 2 parameters,
   * an ip address and a port number. myRemoteLocation is used as parameter in
   * oscP5.send() when sending osc packets to another computer, device, 
   * application. usage see below. for testing purposes the listening port
   * and the port of the remote location address are the same, hence you will
   * send messages back to this sketch.
   */
//  myRemoteLocation = new NetAddress("127.0.0.1",10000);
 
}


void draw() {
  background(0);

  fill(c,fade);
  noStroke();
  ellipse(width/2,height/2,300,300);
  
  fade*=0.9;
}


void oscEvent(OscMessage theOscMessage) {
  /* check if theOscMessage has the address pattern we are looking for. */
  
  if(theOscMessage.checkAddrPattern("/osc/timer")==true) {
    /* check if the typetag is the right one. */
    if(theOscMessage.checkTypetag("i")) {
      /* parse theOscMessage and extract the values from the osc message arguments. */
      int firstValue = theOscMessage.get(0).intValue();  
      print("### received an osc message /test with typetag i.");
      println(" values: "+firstValue);
      fade = 255;
      
      switch(firstValue){
        case 0:
        c = color(255,0,0);
        break;
       case 1:
        c = color(0,255,0);
        break;
        case 2:
        c = color(0,0,255);
        break;
        case 3:
        c = color(255,255,255);
        break;
        }

      return;
    }  
  } 
  println("### received an osc message. with address pattern "+theOscMessage.addrPattern());
}
