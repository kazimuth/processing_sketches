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

int textSize = 72;

void setup() {
  //size(1920*2, 1080*2);
  fullScreen();
  background(0);
  frameRate(30);
  textAlign(CENTER, CENTER);
  textFont(createFont("Segoe UI Historic", textSize));
}

void draw() {
  // Clear the screen
  background(0);

  // Draw eldritch runes
  for (int x = 0; x < width; x += textSize/1.9) {
    for (int y = 0; y < height; y += textSize/1.9) {
      // Generate noise value for current position
      float noiseVal = noise(x * noiseScale, y * noiseScale, frameCount * 0.01);

      // Determine whether to draw the rune based on noise value
      if (noiseVal > flickerThreshold) {
        // Set color to a random shade of gray
        int red = int(random(0, 255));
        fill(red, 0, 0);
        noStroke();

        // Select a random rune from the array
        String rune = runes[int(random(runes.length))];

        // Draw the rune
        text(rune, x + textSize, y + textSize);
      }
    }
  }
}
