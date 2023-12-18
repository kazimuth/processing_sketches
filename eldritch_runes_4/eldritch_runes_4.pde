float noiseScale = 0.02;
float flickerThreshold = 0.5;

String[] runes = { 
  "\u16A0", // FEHU
  "\u16A2", // URUZ
  "\u16A6", // ANSUZ
  "\u16A8", // RAIDHO
  "\u16AA", // KAUNA
  "\u16AC", // GEBO
  "\u16AE", // WUNJO
  "\u16B1", // HAGLAZ
  "\u16B3", // NAUDIZ
  "\u16B7", // ISA
  "\u16B9", // JERA
  "\u16BB", // EIHWAZ
  "\u16BE", // Perthro
  "\u16C1", // ALGIZ
  "\u16C3", // SOWILO
  "\u16C6", // TIWAZ
};

float[][] fluidField;
int fluidWidth;
int fluidHeight;
float fluidViscosity = 0.05;
float fluidForceScale = 1.0;
float fluidVelocityScale = 0.5;
float fluidDissipation = 0.99;

void initFluidField() {
  // Initialize fluid field with Perlin noise
  float noiseScale = 0.02;
  float noiseZ = 0.0;

  for (int i = 0; i < fluidWidth; i++) {
    for (int j = 0; j < fluidHeight; j++) {
      float noiseValue = noise(i * noiseScale, j * noiseScale, noiseZ);
      fluidField[i][j] = map(noiseValue, 0.0, 1.0, -1.0, 1.0);
    }
  }
}

void setup() {
  size(800, 600);
  background(0);
  frameRate(30);
  textFont(createFont("Segoe UI Historic", 16));
  textAlign(CENTER, CENTER);

  // Initialize fluid simulation
  fluidWidth = width / 10;
  fluidHeight = height / 10;
  fluidField = new float[fluidWidth][fluidHeight];
  initFluidField();
}

void draw() {
  // Update fluid simulation
  updateFluid();

  // Clear the screen
  background(0);

  // Calculate center point of the screen
  float centerX = width / 2.0;
  float centerY = height / 2.0;

  // Calculate radius of the circle
  float radius = min(width, height) / 3.0;

  // Calculate angle between runes
  float angleBetweenRunes = TWO_PI / runes.length;

  // Draw eldritch runes in a circle
  for (int i = 0; i < runes.length; i++) {
    // Calculate position of current rune
    float angle = i * angleBetweenRunes;
    float x = centerX + radius * cos(angle);
    float y = centerY + radius * sin(angle);

    // Generate noise value for current position
    float noiseVal = noise(x * noiseScale, y * noiseScale, frameCount * 0.01);

    // Determine whether to draw the rune based on noise value
    if (noiseVal > flickerThreshold) {
      // Set color to a random shade of gray
      int gray = int(random(0, 255));
      fill(gray);
      noStroke();

      // Draw the rune
      text(runes[i], x, y);
    }
  }

  // Draw eldritch fluid
  drawFluid();
}

void updateFluid() {
  // Apply fluid forces
  for (int i = 0; i < fluidWidth; i++) {
    for (int j = 0; j < fluidHeight; j++) {
      // Calculate forces at current position
      float xForce = noise(i * noiseScale, j * noiseScale, frameCount * 0.01) * fluidForceScale;
      float yForce = noise(i * noiseScale, j *     noiseScale, (frameCount * 0.01) + 100) * fluidForceScale;

    // Apply forces to fluid field
    fluidField[i][j] += xForce;
    fluidField[i][j] += yForce;
    }
    }

// Apply viscosity to fluid field
for (int i = 1; i < fluidWidth - 1; i++) {
for (int j = 1; j < fluidHeight - 1; j++) {
float u = fluidField[i][j];
float uLeft = fluidField[i-1][j];
float uRight = fluidField[i+1][j];
float uUp = fluidField[i][j-1];
float uDown = fluidField[i][j+1];


  float laplace = (uLeft + uRight + uUp + uDown - 4 * u) / 4;
  fluidField[i][j] += fluidViscosity * laplace;
}

}

// Apply velocity to fluid field
for (int i = 0; i < fluidWidth; i++) {
for (int j = 0; j < fluidHeight; j++) {
fluidField[i][j] *= fluidDissipation;


  float xVelocity = fluidField[i][j] * fluidVelocityScale;
  float yVelocity = fluidField[i][j] * fluidVelocityScale;

  int xIndex = i + int(xVelocity);
  int yIndex = j + int(yVelocity);

  if (xIndex >= 0 && xIndex < fluidWidth && yIndex >= 0 && yIndex < fluidHeight) {
    fluidField[xIndex][yIndex] += fluidField[i][j] * fluidVelocityScale;
  }
}

}
}

void drawFluid() {
// Draw fluid field as a series of rectangles
for (int i = 0; i < fluidWidth; i++) {
for (int j = 0; j < fluidHeight; j++) {
float fluidValue = fluidField[i][j];


  // Map fluid value to a color
  int fluidColor = color(map(fluidValue, -1.0, 1.0, 0, 255));

  // Draw rectangle at current position
  fill(fluidColor, 50);
  noStroke();
  rect(i * 10, j * 10, 10, 10);
}

}
}
