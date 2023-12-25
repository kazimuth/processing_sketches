import peasy.*;
import controlP5.*;

int numDimensions = 9;      // Number of dimensions for the simulation
int numVertices = 10;        // Number of vertices in the simplex
float springStrength = 0.05;    // Strength of the springs (Hooke constant)
float damping = 0.9;       // Damping factor
float perlinScale = 0.02;   // Perlin noise scale
float dreamLength = 0.6;

Particle[] particles;       // Array to store the particles
float[][] positions2D;
float sqrtN;
NDVec curRod; // 0-alloc

PeasyCam cam;               // PeasyCam for 3D rendering

ControlP5 cp5;

void init() {
  println(numVertices + " " + numDimensions);
  particles = new Particle[numVertices];
  for (int i = 0; i < numVertices; i++) {
    float[] pos = new float[numDimensions];
    float[] vel = new float[numDimensions];
    for (int j = 0; j < numDimensions; j++) {
      pos[j] = random(0.1, 0.9);
    }
    particles[i] = new Particle(pos, vel);
  }
  positions2D = new float[numVertices][2];
  sqrtN = sqrt((float) numDimensions);
  curRod = new NDVec(numDimensions);
}

void setup() {
  size(800, 800, P2D);
  
  init();
  
  cp5 = new ControlP5(this);
  
  // Create the first slider
  cp5.addSlider("dimension")
     .setCaptionLabel("dimension")
     .setColorCaptionLabel(0)
     .setPosition(50, 50)
     .setSize(200, 20)
     .setRange(2, 10)
     .setValue(3)
     .setNumberOfTickMarks(9)
     .snapToTickMarks(true);
     
  // Create the second slider
  cp5.addSlider("vertices")
     .setCaptionLabel("vertices")
     .setColorCaptionLabel(0)
     .setPosition(50, 100)
     .setSize(200, 20)
     .setRange(1, 10)
     .setValue(4)
     .setNumberOfTickMarks(10)
     .snapToTickMarks(true);

  //frameRate(10);
}

void dimension(float value) {
  if ((int) value != numDimensions) {
    numDimensions = (int) value;
    init();
  }
}

void vertices(float value) {
  if ((int) value != numVertices) {
    numVertices = (int) value;
    init();
  }
}

void draw() {
  background(255);
  
  // Apply forces to particles
  for (Particle p : particles) {
    p.applySpringForces();
    p.applyDamping();
    p.update();
  }
  
  // Render the particles as a graph
  renderGraph();
}

void renderGraph() {
  // Project the particles onto 2D space
  for (int i = 0; i < numVertices; i++) {
    positions2D[i][0] = map(particles[i].pos.values[0], 0, 1, 0, width);
    positions2D[i][1] = map(particles[i].pos.values[1], 0, 1, 0, height);
  }
  
  // Draw edges between particles
  for (int i = 0; i < numVertices; i++) {
    for (int j = i + 1; j < numVertices; j++) {
      curRod.copyFrom(particles[i].pos);
      curRod.subtract(particles[j].pos);
      stroke((int)(255 * map(curRod.length(), 0.0, dreamLength * 2, 0.0, 1.0)));

      line(positions2D[i][0], positions2D[i][1], positions2D[j][0], positions2D[j][1]);
    }
  }
  
  // Draw nodes (particles)
  fill(255, 0, 0);
  for (int i = 0; i < numVertices; i++) {
    //ellipse(positions2D[i][0], positions2D[i][1], 10, 10);
  }
}


class Particle {
  NDVec pos;    // Position in n-dimensional space
  NDVec vel;    // Velocity in n-dimensional space
  
  Particle(float[] pos, float[] vel) {
    this.pos = new NDVec(pos);
    this.vel = new NDVec(vel);
  }
  
  void applySpringForces() {
    for (Particle p : particles) {
      if (p != this) {
        // curRod = this -> p = p - this
        curRod.copyFrom(p.pos);
        curRod.subtract(this.pos);
        
        // force on me
        // = -k * delta
        // = -k * (curRod -> dreamRod)
        // = -k * (dreamRod - curRod)
        // = -k * (norm(curRod)*dreamLength) - curRod)
        // = -k * (curRod / curRod.length * dreamLength - curRod)
        // = -k * curRod * (dreamLength / curRod.length - 1.0)
        // = curRod * (k * (dreamLength / curRod.length - 1.0))
        curRod.multiply(-springStrength * (dreamLength / curRod.length() - 1.0));
        this.vel.add(curRod);

        stroke(255,0,0);
        line(pos.values[0]*width, pos.values[1]*height, (pos.values[0] + curRod.values[0] * 10)*width,  (pos.values[1] + curRod.values[1] * 10)*height);
      }
    }
  }
  
  void applyDamping() {
    vel.multiply(damping);
  }
  
  void update() {
    pos.add(vel);

    for (int i = 0; i < numDimensions; i++) {
      // Constrain position within the box [0,1]^d
      if (pos.values[i] > 1) {
        pos.values[i] = 1;
        vel.values[i] = 0;
      } else if (pos.values[i] < 0) {
        pos.values[i] = 0;
        vel.values[i] = 0;
      }
    }
    
    // Perturb velocities using Perlin noise
    for (int i = 0; i < numDimensions; i++) {
      vel.values[i] += random(-0.0005, 0.0005);
    }
  }
}

public class NDVec {
    public final float[] values;

    public NDVec(int n) {
        this.values = new float[n];
    }

    public NDVec(float[] values) {
        this.values = values;
    }

    public NDVec copy() {
        float[] copyValues = new float[values.length];
        System.arraycopy(values, 0, copyValues, 0, values.length);
        return new NDVec(copyValues);
    }
    
    public void copyFrom(NDVec other) {
        if (values.length != other.values.length) {
            throw new IllegalArgumentException("Vector dimensions must be the same.");
        }
        System.arraycopy(other.values, 0, values, 0, values.length);
    }

    public void add(NDVec other) {
        if (values.length != other.values.length) {
            throw new IllegalArgumentException("Vector dimensions must be the same.");
        }
        for (int i = 0; i < values.length; i++) {
            values[i] += other.values[i];
        }
    }

    public void subtract(NDVec other) {
        if (values.length != other.values.length) {
            throw new IllegalArgumentException("Vector dimensions must be the same.");
        }
        for (int i = 0; i < values.length; i++) {
            values[i] -= other.values[i];
        }
    }

    public void multiply(float scalar) {
        for (int i = 0; i < values.length; i++) {
            values[i] *= scalar;
        }
    }
    
    public float length() {
        float result = 0;
        for (float value : values) {
            result += value * value;
        }
        return sqrt(result);
    }
    
    public void normalize() {
        this.multiply(1.0 / this.length());
    }
}
