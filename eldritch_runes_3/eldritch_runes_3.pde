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

void setup() {
  size(800, 600);
  background(0);
  frameRate(30);
  textFont(createFont("Segoe UI Historic", 16));
  textAlign(CENTER, CENTER);
}

void draw() {
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
}
