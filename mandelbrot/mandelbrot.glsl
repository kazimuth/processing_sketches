
#ifdef GL_ES
precision highp float;
#endif

uniform float zoom;
uniform float centerX;
uniform float centerY;

void main() {
  float x0 = (gl_FragCoord.x / zoom - 400.0 / zoom + centerX);
  float y0 = (gl_FragCoord.y / zoom - 400.0 / zoom + centerY);
  float x = 0.0;
  float y = 0.0;
  int iteration = 0;
  int maxIteration = 100;
  while (x * x + y * y < 4.0 && iteration < maxIteration) {
    float xTemp = x * x - y * y + x0;
    y = 2.0 * x * y + y0;
    x = xTemp;
    iteration++;
  }
  float colorValue = float(iteration) / float(maxIteration);
  gl_FragColor = vec4(colorValue, colorValue, colorValue, 1.0);
}