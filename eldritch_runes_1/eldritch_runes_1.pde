float noiseScale = 0.02;
float flickerThreshold = 0.5;

void setup() {
  size(800, 600);
  background(0);
  frameRate(30);
}

void draw() {
  // Clear the screen
  background(0);

  // Draw eldritch runes
  for (int x = 0; x < width; x += 20) {
    for (int y = 0; y < height; y += 20) {
      // Generate noise value for current position
      float noiseVal = noise(x * noiseScale, y * noiseScale, frameCount * 0.01);

      // Determine whether to draw the rune based on noise value
      if (noiseVal > flickerThreshold) {
        // Set color to a random shade of gray
        int gray = int(random(0, 255));
        fill(gray);
        noStroke();

        // Draw the rune (you can replace this with your own rune drawing code)
        rect(x, y, 10, 10);
      }
    }
  }
}
