class Player {
  float x;
  float y;
  float size;
  float speed;

  boolean up;
  boolean down;
  boolean left;
  boolean right;

  Player(float x, float y) {
    this.x = x;
    this.y = y;
    this.size = 30;
    this.speed = 4;
  }

  void move() {
    if (up) y -= speed;
    if (down) y += speed;
    if (left) x -= speed;
    if (right) x += speed;

    // 画面外に出ないようにする
    x = constrain(x, size / 2, width - size / 2);
    y = constrain(y, size / 2, height - size / 2);
  }

  void display() {
    fill(0, 120, 255);
    ellipse(x, y, size, size);
  }

  void setMove(int keyCode, boolean isPressed) {
    if (keyCode == UP) up = isPressed;
    if (keyCode == DOWN) down = isPressed;
    if (keyCode == LEFT) left = isPressed;
    if (keyCode == RIGHT) right = isPressed;
  }
}

void keyPressed() {
  player.setMove(keyCode, true);
}

void keyReleased() {
  player.setMove(keyCode, false);
}
