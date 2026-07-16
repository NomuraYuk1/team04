class Enemy {
  float x;
  float y;
  float size;
  float speed;
  int direction;

  Enemy(float x, float y) {
    this.x = x;
    this.y = y;
    this.size = 30;
    this.speed = 3;
    this.direction = 1;
  }

  void move() {

    x += speed * direction;

    if (x > 700 || x < 100) {
      direction *= -1;
    }

    y = constrain(y, size/2, MAP_HEIGHT-size/2);
  }

  void display() {
    fill(255, 0, 0);
    ellipse(x, y, size, size);
  }

  boolean hitPlayer(Player p) {
    float d = dist(x, y, p.x, p.y);
    return d < (size / 2 + p.size / 2);
  }
}
