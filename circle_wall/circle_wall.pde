import processing.core.PApplet;
import peasy.PeasyCam;


int circleSize = 30;
PeasyCam cam;
int numCircles = 1600;
float[] circleX = new float[numCircles];
float[] circleY = new float[numCircles];
float[] circleZ = new float[numCircles];
color[] circleColors = new color[numCircles];



public void setup() {
  size(1280, 720, P3D);
  cam = new PeasyCam(this, 400);
  for (int i = 0; i < numCircles; i++) {
    circleX[i] = random(-width / 2, width * 5/ 2);
    circleY[i] = random(-height*5 / 2, height*5 / 2);
    circleZ[i] = 0;
    circleColors[i] = color(random(255));
  }
  noStroke();
}

public void draw() {
  background(255);
  // Resample circles that overlap earlier circles.
  for (int i = 0; i < numCircles; i++) {
    for (int j = 0; j < i; j++) {
      if (circlesOverlap(circleX[i], circleY[i], circleSize, circleX[j], circleY[j], circleSize)) {
        // Resample circle i.
    circleX[i] = random(-width / 2, width * 5/ 2);
    circleY[i] = random(-height*5 / 2, height*5 / 2);
      }
    }
  }

  for (int i = 0; i < numCircles; i++) {
    fill(circleColors[i]);
    ellipse(circleX[i], circleY[i], circleSize*2, circleSize*2);
  }
}

private boolean circlesOverlap(float x1, float y1, float r1, float x2, float y2, float r2) {
  // Calculate the distance between the centers of the two circles.
  float d = dist(x1, y1, x2, y2);

  // Check if the distance is less than the sum of the radii.
  return d < r1 + r2;
}
