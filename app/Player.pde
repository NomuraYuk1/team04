class Player {
  float x;
  float y;
  float size;
  float speed;

  // 0：停止、1：上、2：下、3：左、4：右
  int moveDirection;

  Player(float x, float y) {
    this.x = x;
    this.y = y;
    size = 30;
    speed = 4;
    moveDirection = 0;
  }

  void move() {
    if (moveDirection == 1) {
      y -= speed;
    } else if (moveDirection == 2) {
      y += speed;
    } else if (moveDirection == 3) {
      x -= speed;
    } else if (moveDirection == 4) {
      x += speed;
    }

    // 画面外に出ないようにする
    x = constrain(x, size / 2, width - size / 2);
    y = constrain(y, size / 2, MAP_HEIGHT - size / 2);
  }

  void display() {
    if (isInvincible) {
      fill(100, 220, 255);
    } else {
      fill(0, 120, 255);
    }

    stroke(255);
    strokeWeight(2);
    ellipse(x, y, size, size);
    noStroke();
  }

  void setMove(int inputKeyCode, boolean isPressed) {
    if (isPressed) {
      if (inputKeyCode == UP) {
        moveDirection = 1;
      } else if (inputKeyCode == DOWN) {
        moveDirection = 2;
      } else if (inputKeyCode == LEFT) {
        moveDirection = 3;
      } else if (inputKeyCode == RIGHT) {
        moveDirection = 4;
      }
    } else {
      // 押していた方向キーを離したら停止
      if ((inputKeyCode == UP && moveDirection == 1) ||
          (inputKeyCode == DOWN && moveDirection == 2) ||
          (inputKeyCode == LEFT && moveDirection == 3) ||
          (inputKeyCode == RIGHT && moveDirection == 4)) {

        moveDirection = 0;
      }
    }
  }

  void stop() {
    moveDirection = 0;
  }
}
