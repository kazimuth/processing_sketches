import controlP5.*;
import peasy.*;

float ACCEL_RANGE = 690.0;
float VEL_LIMIT = 300.0;
float POS_LIMIT = 120.0;
//float centralSpringFactor = 1.0;
float centralSpringFactor = 0.05;

float wormFriction = 0.01;
float dampingFactor() {
  return 1.0 - wormFriction;
}


boolean drawDiagnostics;

ResizableCircularBuffer<PVector> segments = new ResizableCircularBuffer(128);

PeasyCam cam;
ControlP5 cp5;

PVector pos = new PVector(0.0, 0.0, 0.0);
PVector vel = new PVector(0.0, 0.0, 0.0);

// don't use built-in var
int FRAME_RATE = 60;

void setup() {
  frameRate(FRAME_RATE);
  size(1980, 1020, P3D);
  cam = new PeasyCam(this, 400);
  cp5 = new ControlP5(this);
  cp5.setAutoDraw(false); // COOPERATE WITH PEASYCAM!

  setDrawDiagnostics(false);

  cp5.setFont(loadFont("Candara-LightItalic-36.vlw"));

  textFont(loadFont("Candara-LightItalic-14.vlw"));
  cp5.addSlider("centralSpringFactor")
    .setPosition(50, 50)
    .setRange(0.0, 1.0)
    .setLabel("central spring factor");

  cp5.addSlider("ACCEL_RANGE")
    .setPosition(50, 100)
    .setRange(0.0, 1000.0)
    .setLabel("acceleration range");

  cp5.addSlider("wormFriction")
    .setPosition(50, 150)
    .setRange(0.0, 1.0)
    .setLabel("worm friction");

  cp5.addSlider("VEL_LIMIT")
    .setPosition(50, 200)
    .setRange(0.0, 1000.0)
    .setLabel("velocity limit");


  for (int i = 0; i < 75; i++) {
    segments.add(new PVector(pos.x, pos.y, pos.z));
  }
}

PVector accel = new PVector();
void draw() {
  background(120, 160, 160);
  textMode(CORNER);
  //text("press d\nto debug\nworm", POS_LIMIT, POS_LIMIT - 20);
  text("drag to rotate worm\nscroll to zoom worm\npress d to debug worm", -POS_LIMIT, POS_LIMIT - 36, POS_LIMIT);

  noFill();
  stroke(255, 255, 255);
  box(2*POS_LIMIT); // whoops
  noStroke();
  int size = segments.size();
  for (int i = 0; i < size; i++) {
    PVector pos = segments.get(i);
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    //fill(255.0 - (120 * (float)i / (float)size));
    //fill(map((float)i, 0.0, (float)size, 170, 60));
    //fill(map((float)i, 0.0, (float)size, 170, 60), 0, 0);
    fill(map((float)i, 0.0, (float)size, 60, 170), 0, 0);
    /*colorMode(HSB);
     fill(map((float)i, 0, size, 0, 255), 220, 220);
     colorMode(RGB);*/
    box(7.0 * (float)i/(float)size);
    popMatrix();
  }

  accel.x = random(-ACCEL_RANGE, ACCEL_RANGE);
  accel.y = random(-ACCEL_RANGE, ACCEL_RANGE);
  accel.z = random(-ACCEL_RANGE, ACCEL_RANGE);
  accel.div(FRAME_RATE);

  accel.x -= pos.x * centralSpringFactor;
  accel.y -= pos.y * centralSpringFactor;
  accel.z -= pos.z * centralSpringFactor;


  vel.add(accel);
  vel.mult(dampingFactor());
  vel.limit(VEL_LIMIT);
  pos.add(vel.copy().div(FRAME_RATE));
  /*
  if (pos.x > POS_LIMIT) {
   pos.x -= 2*POS_LIMIT;
   }
   if (pos.x < -POS_LIMIT) {
   pos.x += 2*POS_LIMIT;
   }
   if (pos.y > POS_LIMIT) {
   pos.y -= 2*POS_LIMIT;
   }
   if (pos.y < -POS_LIMIT) {
   pos.y += 2*POS_LIMIT;
   }
   if (pos.z > POS_LIMIT) {
   pos.z -= 2*POS_LIMIT;
   }
   if (pos.z < -POS_LIMIT) {
   pos.z += 2*POS_LIMIT;
   }
   */
  if (pos.x > POS_LIMIT) {
    pos.x = POS_LIMIT;
    vel.x *= -1;
  }
  if (pos.x < -POS_LIMIT) {
    pos.x = -POS_LIMIT;
    vel.x *= -1;
  }
  if (pos.y > POS_LIMIT) {
    pos.y = POS_LIMIT;
    vel.y *= -1;
  }
  if (pos.y < -POS_LIMIT) {
    pos.y = -POS_LIMIT;
    vel.y *= -1;
  }
  if (pos.z > POS_LIMIT) {
    pos.z = POS_LIMIT;
    vel.z *= -1;
  }
  if (pos.z < -POS_LIMIT) {
    pos.z = -POS_LIMIT;
    vel.z *= -1;
  }
  PVector current = segments.remove();
  current.set(pos);
  segments.add(current);

  if (drawDiagnostics) {
    // central spring
    stroke(255);
    line(0.0, 0.0, 0.0, pos.x, pos.y, pos.z);
    stroke(220, 220, 0);
    line(pos.x, pos.y, pos.z,
      pos.x - pos.x * centralSpringFactor,
      pos.y - pos.y * centralSpringFactor,
      pos.z - pos.z * centralSpringFactor);

    // vel
    stroke(255, 0, 0);
    line(pos.x, pos.y, pos.z, pos.x + vel.x, pos.y + vel.y, pos.z + vel.z);

    // acc
    stroke(0, 0, 255);
    line(pos.x + vel.x, pos.y + vel.y, pos.z + vel.z,
      pos.x + vel.x + accel.x, pos.y + vel.y + accel.y, pos.z + vel.z + accel.z);
  }
  cam.beginHUD();
  cp5.draw();
  cam.endHUD();
}

void setDrawDiagnostics(boolean drawEm) {
  drawDiagnostics = drawEm;
  cam.setActive(!drawDiagnostics);
  cp5.setVisible(drawDiagnostics);
}

void keyPressed() {
  if (key == 'd') {
    setDrawDiagnostics(!drawDiagnostics);
  }
}
