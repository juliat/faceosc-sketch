class SpeechBubble {
  float xPos; 
  float yPos; 

  float sbHeight = 150*0.25;
  float sbWidth = 250*0.25;
 
  float initialRadius = (sbHeight/3);
  float radius = initialRadius;
 
  int numPoints = 30;
  // http://math.rice.edu/~pcmi/sphere/degrad.gif
  float extrusionTheta = (5*PI)/6;
  float epsilon = PI/25;
  
  void draw(float xPosition, float yPosition) {
    xPos = xPosition;
    yPos = yPosition;
    
    float timeRadiusFactor = face.totalTime/10000;
    
    radius = radius + timeRadiusFactor;
    
    if (radius < 10) {
      return;
    }
    
    float xCenter = xPos+sbWidth/2 + timeRadiusFactor;
    float yCenter = yPos+sbHeight/2 - (timeRadiusFactor/2);
    
    println("DRAWN");
    beginShape();
    
      // variables for calculating each point
      float x;
      float y;
      float theta;   
      
      // iterate and draw points around circle.
      for (int i = 0; i <= numPoints; i++) {
        
        theta = map(i, 0, numPoints-2, 0, 2*PI);
        // this minus-2 is a hack to make the circle close
        x = radius*cos(theta) + xCenter;
        y = radius*sin(theta) + yCenter;
        
        // check to see if we're at the point in the circle where 
        // we want to draw the part of the speech bubble that sticks out
        if (((theta - epsilon) < extrusionTheta) && 
            ((theta + epsilon) > extrusionTheta)){
             
              float extrusionRadius = PI/25;
              
              float startTheta = extrusionTheta - extrusionRadius;
              float endTheta = extrusionTheta + extrusionRadius;
              
              float startX = radius*cos(startTheta) + xCenter;
              float startY = radius*sin(startTheta) + yCenter;
  
              float endX = radius*cos(endTheta) + xCenter;
              float endY = radius*sin(endTheta) + yCenter;
            
              curveVertex(startX, startY);
              vertex(startX, startY);
              vertex(x - (radius/1.5), y+ (radius/3));
              vertex(endX, endY);
              curveVertex(endX, endY);
        }
        else {
          curveVertex(x, y);
        }
      }
    endShape();
  }
}
