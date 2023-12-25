
import processing.core.*;
import peasy.*;

float scale = 200; // scaling factor for the orbital positions
int numPoints = 500; // number of points in the cloud
float[][] positions; // positions of the points
float[][] colors; // colors of the points
float[][] velocities; // velocities of the points
float[] probability; // probability of each point

PeasyCam cam;

void setup() {
  size(800, 800, P3D);
  colorMode(HSB);

  // set up the camera
  cam = new PeasyCam(this, 500);

  // initialize the arrays
  positions = new float[numPoints][3];
  colors = new float[numPoints][3];
  velocities = new float[numPoints][3];
  probability = new float[numPoints];

  // generate the points and colors
  for (int i = 0; i < numPoints; i++) {
    float x = random(-1, 1);
    float y = random(-1, 1);
    float z = random(-1, 1);
    float r = sqrt(x*x + y*y + z*z);
    positions[i][0] = x*scale/r;
    positions[i][1] = y*scale/r;
    positions[i][2] = z*scale/r;
    colors[i][0] = random(0, 255);
    colors[i][1] = random(0, 255);
    colors[i][2] = random(0, 255);
    probability[i] = d4(x, y, z);
  }
}

void draw() {
  background(0);

  // update the velocities of the points
  for (int i = 0; i < numPoints; i++) {
    float x = positions[i][0];
    float y = positions[i][1];
    float z = positions[i][2];
    float r = sqrt(x*x + y*y + z*z);
    float a = atan2(y, x);
    float b = acos(z/r);
    float p = d4(x, y, z);
    float f = 0.1*pow(p, 0.5);
    velocities[i][0] += f*cos(a)*sin(b);
    velocities[i][1] += f*sin(a)*sin(b);
    velocities[i][2] += f*cos(b);
  }

  // update the positions of the points
  for (int i = 0; i < numPoints; i++) {
    positions[i][0] += velocities[i][0];
    positions[i][1] += velocities[i][1];
    positions[i][2] += velocities[i][2];
    velocities[i][0] *= 0.99;
    velocities[i][1] *= 0.99;
    velocities[i][2] *= 0.99;
    if (positions[i][0]*positions[i][0] + positions[i][1]*positions[i][1] + positions[i][2]*positions[i][2] > scale*scale) {
      float x = random(-1, 1);
      float y = random(-1, 1);
      float z = random(-1, 1);
      float r = sqrt(x*x + y*y + z*z);
      positions[i][0] = x*scale/r;
      positions[i][1] = y*scale/r;
      positions[i][2] = z*scale/r;
      colors[i][0] = random(0, 255);
      colors[i][1] = random(0, 255);
      colors[i][2] = random(0, 255);
      probability[i] = d4(x, y, z);
    }
  }


  // draw the points
  noStroke();
  for (int i = 0; i < numPoints; i++) {
    float phase = atan2(positions[i][1], positions[i][0]); // calculate the phase at the point
    float hue = map(phase, -PI, PI, 0, 255); // map the phase to a hue value
    color c = color(hue, 255, 255, probability[i]*255); // create a color with the mapped hue and probability
    fill(c);
    //fill(colors[i][0], colors[i][1], colors[i][2], probability[i]*255);
    pushMatrix();
    translate(positions[i][0], positions[i][1], positions[i][2]);
    box(5);
    popMatrix();
  }
}

// d4 orbital function
float d4(float x, float y, float z) {
  float r2 = x*x + y*y + z*z;
  float r = sqrt(r2);
  float a = atan2(y, x);
  float b = acos(z/r);
  float p = sqrt(15/(2*PI))*r2*r*sin(b)*cos(b)*sin(2*a);
  return p*p;
}
