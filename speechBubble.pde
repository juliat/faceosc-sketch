void drawSpeechBubble(int xPos, int yPos) {
  println("DRAWN");
  fill(255, 0, 0); 

  /* debug 
  float foo = (face.totalSpeakingTime/10);
  ellipse(xPos, yPos, foo, foo);
  */
  
  float sbHeight = 150;
  float sbWidth = 250;
  
  strokeJoin(ROUND);
  
  beginShape();
    float radius = sbHeight/2;
    float xCenter = xPos+sbWidth/2;
    float yCenter = yPos+sbHeight/2;
    int numPoints = 20;
    // http://math.rice.edu/~pcmi/sphere/degrad.gif
    float extrusionTheta = (2*PI)/3;
    float epsilon = PI/numPoints;

    float x;
    float y;
    float theta;
    
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
            vertex(x - (radius/2), y+ (radius/3));
            vertex(endX, endY);
            curveVertex(endX, endY);
      }
      else {
        curveVertex(x, y);
      }
    }
    
  endShape();
}
