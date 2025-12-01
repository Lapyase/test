/**
 * Swirling Abstract Color Field
 *
 * Drop this sketch into Processing and press play to watch a slow-moving, 
 * colorful vortex made from hundreds of wandering particles. The background 
 * softly fades, leaving a trail-like motion blur that accentuates the swirl.
 */

int particleCount = 1200;
Particle[] particles = new Particle[particleCount];
float noiseScale = 0.0025;
float noiseZ = 0;
float noiseZSpeed = 0.0025;
float fadeAmount = 10;

void setup() {
  size(900, 900, P2D);
  colorMode(HSB, 360, 100, 100, 100);
  noStroke();
  smooth(8);
  resetParticles();
  background(220, 30, 5);
}

void draw() {
  // Gentle fade to keep trails visible.
  fill(220, 30, 5, fadeAmount);
  rect(0, 0, width, height);

  translate(width / 2.0, height / 2.0);
  for (Particle p : particles) {
    p.update();
    p.display();
  }
  noiseZ += noiseZSpeed;
}

void mousePressed() {
  // Restart with a fresh palette and positions.
  resetParticles();
}

void resetParticles() {
  randomSeed((int)millis());
  noiseZ = random(1000);
  for (int i = 0; i < particleCount; i++) {
    particles[i] = new Particle();
  }
}

class Particle {
  PVector pos;
  float hue;
  float speed;

  Particle() {
    float radius = random(width * 0.05, width * 0.45);
    float angle = random(TWO_PI);
    pos = new PVector(cos(angle) * radius, sin(angle) * radius);
    hue = random(360);
    speed = random(0.6, 1.8);
  }

  void update() {
    // Swirl toward center with a noise-driven push.
    float swirl = atan2(pos.y, pos.x) + HALF_PI;
    float n = noise((pos.x + width * 0.5) * noiseScale, (pos.y + height * 0.5) * noiseScale, noiseZ);
    float angle = swirl + map(n, 0, 1, -PI * 0.25, PI * 0.25);
    PVector vel = PVector.fromAngle(angle).setMag(speed);
    pos.add(vel);

    // Soft boundary wrap to keep flow continuous.
    float maxR = width * 0.5;
    if (pos.mag() > maxR) {
      pos.normalize();
      pos.mult(maxR * 0.1);
    }
  }

  void display() {
    fill(hue, 85, 100, 80);
    ellipse(pos.x, pos.y, 3.5, 3.5);
    hue = (hue + 0.3) % 360;
  }
}
