class InvincibilityZone {
  float x, y, w, h;
  int timeLimit;

  InvincibilityZone(float startX, float startY, float size, int limit) {
    x = startX;
    y = startY;
    w = size;
    h = size;
    timeLimit = limit;
  }

  void display() {
    fill(255);
    rect(x, y, w, h);
  }

  boolean hitTest(Player p) {
    return (p.x + p.r > x && p.x - p.r < x + w && p.y + p.r > y && p.y - p.r < y + h);
  }
}
