import oscP5.*;

// a single tracked face from FaceOSC
class Face {

  // num faces found
  int found;

  // pose
  float poseScale;
  PVector posePosition = new PVector();
  PVector poseOrientation = new PVector();

  // gesture
  float mouthHeight, mouthWidth;
  float eyeLeft, eyeRight;
  float eyebrowLeft, eyebrowRight;
  float jaw;
  float nostrils;

  // past
  float lastEyeHeight;
  float lastEyebrowHeight;
  boolean wasSpeaking = false;
  float startSpeakingTime = 0;
  float totalTime = 0;
  float stoppedSpeakingTime = 0;

  Face() {
  }

  boolean isSmiling() {
    float minSmileWidth = 15;
    float minSmileHeight = 2;

    if ((mouthWidth > minSmileWidth) &&
      (mouthHeight > minSmileHeight)) {
      return true;
    }
    return false;
  }

  boolean isBlinking() {
    float eyeHeight = (face.eyeLeft + face.eyeRight) / 2;
    float eyebrowHeight = (face.eyebrowLeft + face.eyebrowRight) / 2;

    if ((eyeHeight < lastEyeHeight) &&
      (eyebrowHeight > lastEyebrowHeight)) {
      return true;
    }
    return false;
  }

  boolean isSpeaking() {
    int speakingMouthHeightThreshold = 2;
    /* Debug: 
     println("MOUTHHEIGHT");
     println(face.mouthHeight);
     */
     println("totalTime: ");
     print(totalTime);
     println("");
     
    if (face.mouthHeight > speakingMouthHeightThreshold) {
      if (!wasSpeaking) {
        totalTime = 0;
        startSpeakingTime = millis();
        wasSpeaking = true;
      }
      else {
        totalTime = millis() - startSpeakingTime;
      }
      println("SPEAKING");
      return true;
    } 
    else {
      if (wasSpeaking) {
        println("NOT SPEAKING");
        stoppedSpeakingTime = millis();
        wasSpeaking = false;
        totalTime = 0;
      }
      else {
        totalTime = -1*(millis() - stoppedSpeakingTime);
      }
      return false;
    }
  }

  // parse an OSC message from FaceOSC
  // returns true if a message was handled
  boolean parseOSC(OscMessage m) {

    if (m.checkAddrPattern("/found")) {
      found = m.get(0).intValue();
      return true;
    }      

    // pose
    else if (m.checkAddrPattern("/pose/scale")) {
      poseScale = m.get(0).floatValue();
      return true;
    }
    else if (m.checkAddrPattern("/pose/position")) {
      posePosition.x = m.get(0).floatValue();
      posePosition.y = m.get(1).floatValue();
      return true;
    }
    else if (m.checkAddrPattern("/pose/orientation")) {
      poseOrientation.x = m.get(0).floatValue();
      poseOrientation.y = m.get(1).floatValue();
      poseOrientation.z = m.get(2).floatValue();
      return true;
    }

    // gesture
    else if (m.checkAddrPattern("/gesture/mouth/width")) {
      mouthWidth = m.get(0).floatValue();
      return true;
    }
    else if (m.checkAddrPattern("/gesture/mouth/height")) {
      mouthHeight = m.get(0).floatValue();
      return true;
    }
    else if (m.checkAddrPattern("/gesture/eye/left")) {
      eyeLeft = m.get(0).floatValue();
      return true;
    }
    else if (m.checkAddrPattern("/gesture/eye/right")) {
      eyeRight = m.get(0).floatValue();
      return true;
    }
    else if (m.checkAddrPattern("/gesture/eyebrow/left")) {
      eyebrowLeft = m.get(0).floatValue();
      return true;
    }
    else if (m.checkAddrPattern("/gesture/eyebrow/right")) {
      eyebrowRight = m.get(0).floatValue();
      return true;
    }
    else if (m.checkAddrPattern("/gesture/jaw")) {
      jaw = m.get(0).floatValue();
      return true;
    }
    else if (m.checkAddrPattern("/gesture/nostrils")) {
      nostrils = m.get(0).floatValue();
      return true;
    }

    return false;
  }

  // get the current face values as a string (includes end lines)
  String toString() {
    return "found: " + found + "\n"
      + "pose" + "\n"
      + " scale: " + poseScale + "\n"
      + " position: " + posePosition.toString() + "\n"
      + " orientation: " + poseOrientation.toString() + "\n"
      + "gesture" + "\n"
      + " mouth: " + mouthWidth + " " + mouthHeight + "\n"
      + " eye: " + eyeLeft + " " + eyeRight + "\n"
      + " eyebrow: " + eyebrowLeft + " " + eyebrowRight + "\n"
      + " jaw: " + jaw + "\n"
      + " nostrils: " + nostrils + "\n";
  }
};

