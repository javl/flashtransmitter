import ketai.camera.*;

KetaiCamera cam;

boolean ledStatus = false;
long prevTrigger;
String received = "";
String receivedComplete = "";
String textReceived = "";
int currentBrightness = 0;

void setup() {
  //size(displayWidth, displayHeight);
  fullScreen();
  orientation(PORTRAIT);
  cam = new KetaiCamera(this, 320, 240, 24);
  cam.start();
  fill(255, 0, 0);
  textSize(48);
  //println("displayWidth: " + displayWidth);
  //println("displayheight: " + displayHeight);
}
void draw() {
  background(0);
  if (cam !=null) {
    //pushMatrix();
    //rotate(-PI/2.0);
    rotate(PI/2.0);
    image(cam, 0, -displayWidth, displayHeight, displayWidth);
    rotate(-PI/2.0);
    //color c = get(displayHeight/2, displayWidth/2);
    //color c = color(255, 0, 0);
    fill(255, 0, 0);
    //int combinedBrightness = 0;
    //for(int i=0;i<5;i++){
    //for(int k=0;k<5;k++){
    //combinedBrightness += brightness(cam.get((cam.width/2)+i, (cam.height/2))
    //}
    //}
    color c = cam.get(cam.width/2, cam.height/2);
    fill(c);
    //println(brightness(c));
    boolean newLedStatus = false;
    currentBrightness = int(brightness(c));
    if (currentBrightness > 200) {
      newLedStatus = true;
    }
    if (newLedStatus != ledStatus) {
      long now = millis();
      long timeDiff = now - prevTrigger;
      if (timeDiff < 1200) {
        received += "0";
      } else if (timeDiff < 3000) {
        received += "1";
      }
      println("Numbers saved: " + received.length());
      if (received.length() >= 8) {
        println("received: " + received);
        receivedComplete = received;
        textReceived += char(unbinary(receivedComplete));
        received = "";
      }
      prevTrigger = now;
      if (newLedStatus) {
        //println("ON!");
      } else {
        //println("OFF!");
      }
      println("switch after " + (timeDiff/1000.0));
      ledStatus = newLedStatus;
    }
    noStroke();
    rect(displayWidth/2-20, displayHeight/2-20, 40, 40);
    //println("center? " + displayWidth/2 + ", " + displayHeight/2);
    //println(mouseX + ", " + mouseY);
    fill(0);
    text(currentBrightness, 10, 50); 
    text("Received:", 10, 100); 
    text(received, 250, 100);
    if (receivedComplete.length() == 8) {
      text(unbinary(receivedComplete), 10, 150);
      text(char(unbinary(receivedComplete)), 10, 200);
    }    
    text(textReceived, 10, 250);
    fill(255);
    text(currentBrightness, 10-2, 50-2); 
    text("Received:", 10-2, 100-2); 
    text(received, 250-2, 100-2);
    if (receivedComplete.length() == 8) {
      text(unbinary(receivedComplete), 10-2, 150-2);
      text(char(unbinary(receivedComplete)), 10-2, 200-2);
    }
    text(textReceived, 10-2, 250-2);
  }
}

void onCameraPreviewEvent() {
  cam.read();
}

void mousePressed() {
  //println("mouse pressed");
  //if (cam.isFlashEnabled())
  //cam.disableFlash();
  //else
  //cam.enableFlash();
  //}
  println("reset received");
  received = "";
}

public void onResume() {
  super.onResume();
  if (cam != null) {
    //cam.resume();
    cam.start();
    println("cam is not null onResume");
  } else {
    println("cam is null onResume");
  }
} 
public void onPause() {
  if (cam != null) {
    //cam.pause();
    cam.stop();
    println("cam is not null onPause");
  } else {
    println("cam is null onPause");
  }
  super.onPause();
}