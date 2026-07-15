class IceFloor {
  float x, y, r;
  float fastRate;

  IceFloor(float startX, float startY, float radius, float rate) {
    x = startX;
    y = startY;
    r = radius;
    fastRate = rate;
  }

  void display() {
    fill(180, 210, 255);
    ellipse(x, y, r * 2, r * 2);
  }

  boolean hitTest(Player p) {
    return (dist(p.x, p.y, x, y) < r + p.r);
  }
}
