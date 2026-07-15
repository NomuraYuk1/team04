class Wall {
  float x, y, w, h;

  Wall(float startX, float startY, float wallW, float wallH) {
    x = startX;
    y = startY;
    w = wallW;
    h = wallH;
  }

  void display() {
    fill(255);
    stroke(200);
    rect(x, y, w, h);
    noStroke();
  }
}
