float wavelength = 40;
float k = TWO_PI / wavelength;
float spacing = 2;

float slitWidth = 20;
float slitCenter = width / 2;
float distanceToSlit = 100;

float[][] wave;

void setup() {
  size(600, 400);
  colorMode(HSB, 1.0);
  wave = new float[width][height];
}

void draw() {
  background(0);
  
  // Move the slit in a sinusoidal pattern
  slitCenter = width / 2 + 50 * sin(frameCount * 0.02);
  
  // Calculate the wave at each point on the screen
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      float distanceToSource = sqrt(sq(x - slitCenter) + sq(y - height/2) + sq(distanceToSlit));
      float phase = k * distanceToSource;
      float amplitude = cos(phase) / distanceToSource;
      wave[x][y] = amplitude;
    }
  }
  
  // Draw the wave on the screen
  for (int x = 0; x < width; x += spacing) {
    for (int y = 0; y < height; y += spacing) {
      float hue = (1 + wave[x][y]) / 2;
      float brightness = map(abs(wave[x][y]), 0, 0.2, 0, 1);
      stroke(hue, 1.0, brightness);
      point(x, y);
    }
  }
  
  // Draw the slit
  stroke(1, 0, 1);
  strokeWeight(2);
  line(slitCenter - slitWidth/2, 0, slitCenter - slitWidth/2, height);
  line(slitCenter + slitWidth/2, 0, slitCenter + slitWidth/2, height);
}
