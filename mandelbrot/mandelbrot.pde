PShader mandelbrotShader;
float zoom = 1.0;
float centerX = -0.5;
float centerY = 0.0;

void setup() {
  size(800, 800, P2D);
  mandelbrotShader = loadShader("mandelbrot.glsl");
  shader(mandelbrotShader);
}

void draw() {
  mandelbrotShader.set("zoom", zoom);
  mandelbrotShader.set("centerX", centerX);
  mandelbrotShader.set("centerY", centerY);
  shader(mandelbrotShader);
  rect(0, 0, width, height);
}

void mouseClicked() {
  float newCenterX = map(mouseX, 0, width, centerX - 2.0 / zoom, centerX + 2.0 / zoom);
  float newCenterY = map(mouseY, 0, height, centerY - 2.0 / zoom, centerY + 2.0 / zoom);
  centerX = newCenterX;
  centerY = newCenterY;
  zoom *= 2.0;
}
