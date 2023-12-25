import controlP5.*;

ControlP5 cp5;

int gridSize = 100;
float cellSize;
float[][] spins;
float temperature = 2.5;
float externalField = 0.0;

void setup() {
  size(600, 600);
  frameRate(24);

  cp5 = new ControlP5(this);
  cp5.addSlider("temperature")
     .setRange(0.1, 5.0)
     .setValue(temperature)
     .setPosition(20, 20)
     .setSize(200, 20);
  
  cp5.addSlider("externalField")
     .setRange(-1.0, 1.0)
     .setValue(externalField)
     .setPosition(20, 50)
     .setSize(200, 20);

  cellSize = width/gridSize;
  spins = new float[gridSize][gridSize];
  initializeSpins();
}

void draw() {
  noStroke();
  background(255);

  updateSpins();
  
  for (int i = 0; i < gridSize; i++) {
    for (int j = 0; j < gridSize; j++) {
      if (spins[i][j] == 1.0) {
        fill(0);
      } else {
        fill(255);
      }
      rect(i*cellSize, j*cellSize, cellSize, cellSize);
    }
  }
}

void initializeSpins() {
  for (int i = 0; i < gridSize; i++) {
    for (int j = 0; j < gridSize; j++) {
      spins[i][j] = random(1) > 0.5 ? 1.0 : -1.0;
    }
  }
}

void updateSpins() {
  for (int i = 0; i < gridSize; i++) {
    for (int j = 0; j < gridSize; j++) {
      float energy = calculateEnergy(i, j);
      if (energy < 0) {
        spins[i][j] = -spins[i][j];
      } else {
        float p = exp(-energy/temperature);
        if (random(1) < p) {
          spins[i][j] = -spins[i][j];
        }
      }
    }
  }
}

float calculateEnergy(int x, int y) {
  float energy = 0;
  energy -= spins[x][y] * (-spins[(x+1)%gridSize][y] - spins[(x-1+gridSize)%gridSize][y] - spins[x][(y+1)%gridSize] - spins[x][(y-1+gridSize)%gridSize]);
  energy -= externalField * spins[x][y];
  return energy;
}
