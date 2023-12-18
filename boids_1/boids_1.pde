ArrayList<Boid> boids;

void setup() {
  size(800, 600);
  boids = new ArrayList<Boid>();
  for (int i = 0; i < 50; i++) {
    boids.add(new Boid());
  }
}

void draw() {
  background(255);
  for (Boid b : boids) {
    b.run(boids);
  }
}

class Boid {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;
  float maxspeed;
  
  Boid() {
    position = new PVector(random(width), random(height));
    velocity = new PVector(random(-1, 1), random(-1, 1));
    acceleration = new PVector(0, 0);
    r = 2.0;
    maxspeed = 2;
    maxforce = 0.03;
  }
  
  void run(ArrayList<Boid> boids) {
    flock(boids);
    update();
    borders();
    render();
  }
  
  void applyForce(PVector force) {
    acceleration.add(force);
  }
  
  void flock(ArrayList<Boid> boids) {
    PVector sep = separate(boids);
    PVector ali = align(boids);
    PVector coh = cohesion(boids);
    
    sep.mult(1.5);
    ali.mult(1.0);
    coh.mult(1.0);
    
    applyForce(sep);
    applyForce(ali);
    applyForce(coh);
  }
  
  void update() {
    velocity.add(acceleration);
    velocity.limit(maxspeed);
    position.add(velocity);
    acceleration.mult(0);
  }
  
  void render() {
    float theta = velocity.heading2D() + radians(90);
    fill(127);
    stroke(200);
    pushMatrix();
    translate(position.x, position.y);
    rotate(theta);
    beginShape(TRIANGLES);
    vertex(0, -r * 2);
    vertex(-r, r * 2);
    vertex(r, r * 2);
    endShape();
    popMatrix();
  }
  
  void borders() {
    if (position.x < -r) position.x = width + r;
    if (position.y < -r) position.y = height + r;
    if (position.x > width + r) position.x = -r;
    if (position.y > height + r) position.y = -r;
  }
  
  PVector separate (ArrayList<Boid> boids) {
    float desiredseparation = 25.0;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(position, other.position);
      if ((d > 0) && (d < desiredseparation)) {
        PVector diff = PVector.sub(position, other.position);
        diff.normalize();
        diff.div(d);
        steer.add(diff);
        count++;
      }
    }
    if (count > 0) {
      steer.div((float)count);
    }
    if (steer.mag() > 0) {
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(velocity);
      steer.limit(maxforce);
    }
    return steer;
  }
  
  PVector align (ArrayList<Boid> boids) {
    float neighbordist = 50.0;
    PVector sum = new PVector(0, 0);
    int count = 0;
for (Boid other : boids) {
  float d = PVector.dist(position, other.position);
  if ((d > 0) && (d < neighbordist)) {
    sum.add(other.velocity);
    count++;
  }
}
if (count > 0) {
  sum.div((float)count);
  sum.normalize();
  sum.mult(maxspeed);
  PVector steer = PVector.sub(sum, velocity);
  steer.limit(maxforce);
  return steer;
} else {
  return new PVector(0, 0);
}

}

PVector cohesion (ArrayList<Boid> boids) {
float neighbordist = 50.0;
PVector sum = new PVector(0, 0);
int count = 0;
for (Boid other : boids) {
float d = PVector.dist(position, other.position);
if ((d > 0) && (d < neighbordist)) {
sum.add(other.position);
count++;
}
}
if (count > 0) {
sum.div(count);
return seek(sum);
} else {
return new PVector(0, 0);
}
}

PVector seek (PVector target) {
PVector desired = PVector.sub(target, position);
desired.normalize();
desired.mult(maxspeed);
PVector steer = PVector.sub(desired, velocity);
steer.limit(maxforce);
return steer;
}
}
