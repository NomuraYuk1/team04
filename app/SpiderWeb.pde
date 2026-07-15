class SpiderWeb {
  float x, y, w, h;
  int requiredTaps;

  SpiderWeb(float startX, float startY, float webW, float webH, int taps) {
    x = startX;
    y = startY;
    w = webW;
    h = webH;
    requiredTaps = taps;
  }

  void display() {
    stroke(255);
    line(x, y, x + w, y + h);
    line(x + w, y, x, y + h);
    line(x + w/2, y, x + w/2, y + h);
    line(x, y + h/2, x + w, y + h/2);
    noFill();
    ellipse(x + w/2, y + h/2, w/2, h/2);
    ellipse(x + w/2, y + h/2, w, h);
    noStroke();
  }

  boolean hitTest(Player p) {
    return (p.x + p.r > x && p.x - p.r < x + w && p.y + p.r > y && p.y - p.r < y + h);
  }
}
