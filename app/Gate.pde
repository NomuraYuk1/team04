class Gate {
  float x, y, w, h;
  boolean Open;
  int intervalTime;
  int lastSwitchTime;

  Gate(float startX, float startY, float gateW, float gateH, int interval) {
    x = startX;
    y = startY;
    w = gateW;
    h = gateH;
    intervalTime = interval;
    Open = true;
    lastSwitchTime = 0;
  }

  void update() {
    if (millis() - lastSwitchTime > intervalTime) {
      Open = !Open;
      lastSwitchTime = millis();
    }
  }

  void display() {
    if (Open) {
      fill(0, 255, 0, 150);
    } else {
      fill(255, 0, 0);
    }
    rect(x, y, w, h);
  }

  boolean Passable() {
    return Open;
  }
}
