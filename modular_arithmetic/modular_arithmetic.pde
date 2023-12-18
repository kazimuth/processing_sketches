import peasy.*;

PeasyCam cam;

void setup() {
  size(1600, 1600, P3D);
  smooth(8);
  cam = new PeasyCam(this, 600);
}

void project(float source, PVector out) {
  out.x = cos(source) * scaleFactor;
  out.y = sin(source) * scaleFactor;
  out.z = -(source * scaleFactor) /2;
}

final float delta = 0.1;
int perCycle = 5;
final int cycles = 5;
final float scaleFactor = 120;
final float circleZ = scaleFactor * 0.75;

PVector previous = new PVector();
PVector current = new PVector();
void drawSpiral() {
  stroke(0, 0, 0);
  noFill();
  for (float theta = 0.0; theta < PI * 2 * cycles; theta += delta) {
    project(theta, previous);
    project(theta + delta, current);
    line(previous.x, previous.y, previous.z, current.x, current.y, current.z);
  }
}
void drawCircle() {
  stroke(0, 0, 0);
  noFill();
  for (float theta = 0; theta < PI * 2; theta += delta) {
    project(theta, previous);
    project(theta + delta, current);
    line(previous.x, previous.y, circleZ, current.x, current.y, circleZ);
  }
}

PVector point_ = new PVector();
void drawSpiralPoints() {
  noStroke();
  fill(255, 0, 0);
  textSize(20);


  for (int n = 0; n < perCycle * cycles + 1; n++) {
    project((n * 2 * PI) / perCycle, point_);
    pushMatrix();
    translate(point_.x, point_.y, point_.z);
    box(0.03 * scaleFactor);
    translate(3, -1.5, 0);
    text("" + n, 0, 0);
    popMatrix();
  }
}

void drawCirclePoints() {
  noStroke();
  fill(0, 255, 0);

  for (int n = 0; n < perCycle; n++) {
    project((n * 2 * PI) / perCycle, point_);
    pushMatrix();
    translate(point_.x, point_.y, circleZ);
    box(0.03 * scaleFactor);
    translate(3, -1.5, 0);
    text(n + " mod " + perCycle, 0, 0);
    popMatrix();
  }
}
void drawCircleProjectionLines() {
  stroke(230, 240, 230);
  float spiralMaxZ = - cycles * 2 * PI * scaleFactor / 2;

  for (int n = perCycle * (cycles - 1) + 1; n < perCycle * cycles + 1; n++) {
    project((n * 2 * PI) / perCycle, point_);
    line(point_.x, point_.y, circleZ, point_.x, point_.y, point_.z);
  }
}

void drawSideLine() {
  stroke(0,0,0);
  float x = 0;
  line(0.0, x, 0.0,
       0.0, x, - scaleFactor * (perCycle * cycles + 1) / 2);
}

/// TODO: try drawing these as intervals...
void sidePointPosition(int cycle, PVector out) {
  out.x = scaleFactor * 2.0;
  //out.x = 0;
  out.y = 0;
  out.z = -((cycle + 0.5) * 2 * PI * scaleFactor) / (2);
  //out.z = -(cycle * 2 * PI * scaleFactor) / (2);
}
void drawSidePoints() {
  noStroke();
  fill(0,0,255);
  for (int cycle = 0; cycle < cycles; cycle++) {
    sidePointPosition(cycle, point_);
    pushMatrix();
    translate(point_.x, point_.y, point_.z);
    box(0.03 * scaleFactor);
    translate(3, -1.5, 0);
    text(cycle, 0, 0);
    popMatrix();
  }
}
PVector sidePoint = new PVector();
void drawSideProjections() {
   stroke(230, 230, 255);

  for (int n = 0; n < perCycle * cycles + 1; n++) {
    project((n * 2 * PI) / perCycle, point_);
    sidePointPosition(n / perCycle, sidePoint);
    line(point_.x, point_.y, point_.z, sidePoint.x, sidePoint.y, sidePoint.z);
  }
}

boolean drawCircle = true;
boolean drawSidePoints = true;

void draw() {
  background(255, 255, 255);
  if (drawCircle) {
    drawCircleProjectionLines();
    drawCircle();
    drawCirclePoints();
  }
  if (drawSidePoints) {
    drawSideProjections();
    drawSidePoints();
  }
  drawSpiral();
  drawSpiralPoints();

}

void keyPressed() {
  if (key == 'c') {
    drawCircle = !drawCircle;
  } else if (key == 's') {
    drawSidePoints = !drawSidePoints;
  } else if (key == 'z') {
    if (perCycle > 1) {
      perCycle -= 1;
    }
  } else if (key == 'x') {
    perCycle += 1;
  }
}
