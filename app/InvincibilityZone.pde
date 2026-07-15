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
    float pr = p.size / 2; // p.r の代わりに p.size の半分を使用
    return (p.x + pr > x && p.x - pr < x + w && p.y + pr > y && p.y - pr < y + h);
  }
}
