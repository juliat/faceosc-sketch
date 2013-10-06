//
// a template for receiving face tracking osc messages from
// Kyle McDonald's FaceOSC https://github.com/kylemcdonald/ofxFaceTracker
//
// this example includes a class to abstract the Face data
//
// 2012 Dan Wilcox danomatika.com
// for the IACD Spring 2012 class at the CMU School of Art
//
// adapted from from Greg Borenstein's 2011 example
// http://www.gregborenstein.com/
// https://gist.github.com/1603230
//
import oscP5.*;
OscP5 oscP5;

// our FaceOSC tracked face dat
Face face = new Face();

float faceScale = 1;

void setup() {
  // default size is 640 by 480
  int defaultWidth = 640;
  int defaultHeight = 480;
  faceScale = 0.5; // shrink by half
  int realWidth = (int)(defaultWidth * faceScale);
  int realHeight = (int)(defaultHeight * faceScale);
  
  size(realWidth, realHeight, OPENGL);
  frameRate(30);

  oscP5 = new OscP5(this, 8338);
}

void draw() {  
  background(255);
  stroke(0);

  if (face.found > 0) {
    // draw such that the center of the face is at 0,0
    translate(face.posePosition.x*faceScale, face.posePosition.y*faceScale);
    // scale things down to the size of the tracked face
    // then shrink again by half for convenience
    scale(face.poseScale*0.5);
    
    rotateY (0 - face.poseOrientation.y); 
    rotateX (0 - face.poseOrientation.x); 
    rotateZ (    face.poseOrientation.z); 
    
    noFill();
    drawEyes();
    drawMouth();
    drawNose();
    drawEyebrows();
    print(face.toString());
  }
}

// OSC CALLBACK FUNCTIONS

void oscEvent(OscMessage m) {
  face.parseOSC(m);
}

void drawEyes() {
  int distanceFromCenterOfFace = 20;
  int heightOnFace = -9;
  int eyeWidth = 11;
  int eyeHeight =7;
  ellipse(-1*distanceFromCenterOfFace, face.eyeLeft * heightOnFace, eyeWidth, eyeHeight);
  ellipse(distanceFromCenterOfFace, face.eyeRight * heightOnFace, eyeWidth, eyeHeight);
}
void drawEyebrows() {
  rectMode(CENTER);
  fill(0);
  int distanceFromCenterOfFace = 20;
  int heightOnFace = -5;
  int eyebrowWidth = 23;
  int eyebrowHeight = 2;
  rect(-1*distanceFromCenterOfFace, face.eyebrowLeft * heightOnFace, eyebrowWidth, eyebrowHeight);
  rect(distanceFromCenterOfFace, face.eyebrowRight * heightOnFace, eyebrowWidth, eyebrowHeight);
}
void drawMouth() {
  int mouthWidth = 40;
  int heightOnFace = 14;
  int mouthHeightFactor = 3;
  
  float mLeftCornerX = (mouthWidth/2) * -1;
  float mLeftCornerY = heightOnFace;
 
  int numPoints = 6;
  beginShape();
  for (int i = 0; i <= numPoints; i++) {
    float pointX = mLeftCornerX + ((mouthWidth/6)*i);
    float pointY = map(i, 0, 6, 0, PI);
    
    pointY = (sin(pointY) * face.mouthHeight * mouthHeightFactor) + mLeftCornerY;
    curveVertex(pointX, pointY);
  }
  /*
  curveVertex(mLCornerX, mLCornerY);
  float m1X = (mouthWidth/6) * 1;
  float m1Y = face.mouthHeight + 4;
  curveVertex(m1X, m1Y);
  float m2X = (mouthWidth/6) * 2;
  float m2Y = face.mouthHeight + 12;
  curveVertex(m2X, m2Y);
  float mLowX = (mouthWidth/6) * 3;
  float mLowY = face.mouthHeight + 20;
  curveVertex(mLowX, mLowY);
  float m4X = (mouthWidth/6) * 4;
  float m4Y = face.mouthHeight + 12;
  curveVertex(m4X, m4Y);
  float m5X = (mouthWidth/6) * 5;
  float m5Y = face.mouthHeight + 4;
  curveVertex(m5X, m5Y);
  float mRCornerX = (mouthWidth/2);
  float mRCornerY = face.mouthHeight;
  curveVertex(mRCornerX, mRCornerY);
  */
  endShape();
}
void drawNose() {
  int distanceFromCenterOfFace = 5;
  int heightOnFace = -1;
  int nostrilWidth = 4;
  int nostrilHeight = 3;
  ellipse(-1*distanceFromCenterOfFace, face.nostrils * heightOnFace, nostrilWidth, nostrilHeight);
  ellipse(distanceFromCenterOfFace, face.nostrils * heightOnFace, nostrilWidth, nostrilHeight);
}

