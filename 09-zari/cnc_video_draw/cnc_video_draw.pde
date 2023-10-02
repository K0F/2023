/**
 * CustomPipeline 
 * by Andres Colubri. 
 * 
 * Create a Capture object with a pipeline description to 
 * get video from non-standard sources.
 */

import processing.video.*;
import gab.opencv.*;

OpenCV opencv;
Capture cam;

int numPixels;
int[] previousFrame;


ArrayList<Contour> contours;
ArrayList<Contour> polygons;

float scalar = 75.0;
boolean save = false;

void setup() {
  size(640, 480);
  frameRate(30);
  // Start the pipeline description with the "pipeline:" prefix, 
  // the rest could be any regular GStreamer pipeline as passed to gst-launch:
  // https://gstreamer.freedesktop.org/documentation/tools/gst-launch.html?gi-language=c#pipeline-description 
  cam = new Capture(this, 640, 480, "pipeline:ximagesrc startx=1984 starty=420 use-damage=0 ! video/x-raw,framerate=30/1 ! videoscale method=0 ! video/x-raw,width=640,height=480 ");
  cam.start();  
  
  
  
  numPixels = cam.width * cam.height;
  // Create an array to store the previously captured frame
  previousFrame = new int[numPixels];
  loadPixels();
  
  
  opencv = new OpenCV(this, cam);
  opencv.gray();
}

void draw() {
  if (cam.available() == true) {
    cam.read();
    cam.loadPixels();

    /*
    int movementSum = 0; // Amount of movement in the frame
    for (int i = 0; i < numPixels; i++) { // For each pixel in the video frame...
      color currColor = cam.pixels[i];
      color prevColor = previousFrame[i];
      // Extract the red, green, and blue components from current pixel
      int currR = (currColor >> 16) & 0xFF; // Like red(), but faster
      int currG = (currColor >> 8) & 0xFF;
      int currB = currColor & 0xFF;
      // Extract red, green, and blue components from previous pixel
      int prevR = (prevColor >> 16) & 0xFF;
      int prevG = (prevColor >> 8) & 0xFF;
      int prevB = prevColor & 0xFF;
      // Compute the difference of the red, green, and blue values
      int diffR = abs(currR - prevR);
      int diffG = abs(currG - prevG);
      int diffB = abs(currB - prevB);
      // Add these differences to the running tally
      movementSum += diffR + diffG + diffB;
      // Render the difference image to the screen
      pixels[i] = color(diffR, diffG, diffB);
      // The following line is much faster, but more confusing to read
      //pixels[i] = 0xff000000 | (diffR << 16) | (diffG << 8) | diffB;
      // Save the current color into the 'previous' buffer
      previousFrame[i] = currColor;
    }
    */
    // To prevent flicker from frames that are all black (no movement),
    // only update the screen if the image has changed.
    //if (movementSum > 0) {
      opencv.loadImage(cam);
  opencv.gray();
  opencv.threshold(threshold);
  PImage dst = opencv.getOutput();


background(0);
  contours = opencv.findContours();
  println("found " + contours.size() + " contours");
  noFill();
  
  String output[] = new String[0];
  
  for (Contour contour : contours) {
    stroke(0, 255, 0);
    //contour.draw();
    
    stroke(255, 255, 255);
    beginShape();
    for (PVector point : contour.getPoints()) {
      vertex(point.x, point.y);
      
      if(save){
       output = expand(output,output.length+1);
   output[output.length-1] = int(((width-point.x/1.49125))*scalar)+" "+int((height-point.y)*scalar);
      }
    }
    endShape();
    
      
   
    
  }
  if(save){
    String fn = nf(year(),4)+nf(month(),2)+nf(day(),2)+"_"+nf(hour(),2)+nf(minute(),2)+nf(second(),2)+"_"+nf(frameCount,8); 
    saveStrings(fn+".txt",output);
	cam.save(fn+".png");
  save = false;
  }
      
      //updatePixels();
      //println(movementSum); // Print the total amount of movement to the console
    //}
  }
  
   
  //image(cam, 0, 0, width, height);
}

int threshold= 128;

void keyPressed(){
if(key==' '){
  save = true;
  }

  if(keyCode == UP){
  	threshold++;
  	threshold=constrain(threshold,1,255);
  }
  
  if(keyCode == DOWN){
  	threshold--;
  	threshold=constrain(threshold,1,255);
  }
}
