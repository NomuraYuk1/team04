class Magma {
  float x, y, r;
  int dmgVal;

  Magma(float startX, float startY, float radius, int dmg) {
    x = startX;
    y = startY;
    r = radius;
    dmgVal = dmg;
  }

  void display() {
    fill(255, 0, 0);
    ellipse(x, y, r * 2, r * 2);
  }

  boolean hitTest(Player p) {
    return (dist(p.x, p.y, x, y) < r + p.r);
  }
}
