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
    // プレイヤーの半径を計算
    float pr = p.size / 2;
    // 四角形（蜘蛛の巣）と円（プレイヤー）の当たり判定
    return (p.x + pr > x && p.x - pr < x + w && p.y + pr > y && p.y - pr < y + h);
  }
}
