int width = 400;
int height = 400;

float[][] wavefunction = new float[width][height];

void setup() {
  size(400, 400);
  colorMode(HSB);
  
  // Initialize wavefunction to a Gaussian wave packet
  float sigma = 20;
  for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j++) {
      float x = map(i, 0, width, -10*sigma, 10*sigma);
      float y = map(j, 0, height, -10*sigma, 10*sigma);
      wavefunction[i][j] = exp(-0.5*(x*x + y*y)/(sigma*sigma));
    }
  }
  
  // Apply the slit by setting wavefunction to zero in the middle
  int slitWidth = 50;
  int slitX = width/2 - slitWidth/2;
  for (int i = slitX; i < slitX + slitWidth; i++) {
    for (int j = 0; j < height; j++) {
      wavefunction[i][j] = 0;
    }
  }
  
  // Normalize the wavefunction
  float norm = 0;
  for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j++) {
      norm += wavefunction[i][j]*wavefunction[i][j];
    }
  }
  norm = sqrt(norm);
  for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j++) {
      wavefunction[i][j] /= norm;
    }
  }
}

void draw() {
  background(0);
  loadPixels();
  for (int i = 1; i < width-1; i++) {
    for (int j = 1; j < height-1; j++) {
      float amplitude = wavefunction[i][j];
      float phase = atan2(wavefunction[i][j+1] - wavefunction[i][j-1],
                          wavefunction[i+1][j] - wavefunction[i-1][j]);
      pixels[i + j*width] = color(map(phase, -PI, PI, 0, 255), 255, map(amplitude, 0, 1, 0, 255));
    }
  }
  updatePixels();
}
