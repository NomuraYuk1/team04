class Puddle {
  float x, y, w, h;
  float slowRate;

  Puddle(float startX, float startY, float puddleW, float puddleH, float rate) {
    x = startX;
    y = startY;
    w = puddleW;
    h = puddleH;
    slowRate = rate;
  }

  void display() {
    fill(10, 80, 120);
    ellipse(x + w/2, y + h/2, w, h);
  }

  boolean hitTest(Player p) {
    return (p.x > x && p.x < x + w && p.y > y && p.y < y + h);
  }
}
