/**
 * CustomPipeline 
 * by Andres Colubri. 
 * 
 * Create a Capture object with a pipeline description to 
 * get video from non-standard sources.
 */

import processing.video.*;

Capture cam;

void setup() {
  size(640, 480,P2D);
  frameRate(30);
  // Start the pipeline description with the "pipeline:" prefix, 
  // the rest could be any regular GStreamer pipeline as passed to gst-launch:
  // https://gstreamer.freedesktop.org/documentation/tools/gst-launch.html?gi-language=c#pipeline-description 
  cam = new Capture(this, 640, 480, "pipeline:ximagesrc startx=1280 use-damage=0 ! video/x-raw,framerate=30/1 ! videoscale method=0 ! video/x-raw,width=640,height=480 ");
  cam.start();  
}

void draw() {
  if (cam.available() == true) {
    cam.read();
  }
  image(cam, 0, 0, width, height);
}
