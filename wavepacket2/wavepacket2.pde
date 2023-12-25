float waveSpeed = 0.05; // speed of wave animation
float waveAmplitude = 100; // amplitude of wave
float waveFrequency = 2; // frequency of wave
float slitWidth = 20; // width of the slit
float distanceToScreen = 200; // distance from slit to screen
float screenWidth = 800; // width of screen
float screenHeight = 600; // height of screen
float[] phase; // phase of wave at each point on screen
float[] amplitude; // amplitude of wave at each point on screen

void setup() {
  size(800, 600);
  colorMode(HSB, 1.0);
  phase = new float[width];
  amplitude = new float[width];
  for (int i = 0; i < width; i++) {
    float x = map(i, 0, width, -screenWidth/2, screenWidth/2);
    amplitude[i] = sin(PI * x / slitWidth) / (PI * x / slitWidth);
    phase[i] = 0;
  }
}

void draw() {
  background(0);
  float time = millis() * waveSpeed;
  for (int i = 0; i < width; i++) {
    float x = map(i, 0, width, -screenWidth/2, screenWidth/2);
    float y = 0;
    if (abs(x) < slitWidth/2) {
      y = amplitude[i] * sin(TWO_PI * waveFrequency * x - time);
    }
    float hue = (phase[i] + 1) / 2; // map phase to hue
    float brightness = map(y, -waveAmplitude, waveAmplitude, 0, 1); // map amplitude to brightness
    stroke(hue, 1, brightness);
    point(i, height/2 + y * distanceToScreen); // project onto screen
    phase[i] += waveFrequency * x * waveSpeed; // update phase
  }
}
