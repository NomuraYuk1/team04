class Enemy {
  float x;
  float y;
  float size;
  float speed;

  int enemyType;
  boolean alive;

  // ランダム移動・巡回移動に使う
  float directionX;
  float directionY;

  int lastDirectionChange;
  int directionChangeInterval;

  // 巡回＋追尾型が反応する距離
  float chaseRange;

  Enemy(float x, float y, int enemyType, float speed) {
    this.x = x;
    this.y = y;
    this.enemyType = enemyType;
    this.speed = speed;

    size = 30;
    alive = true;

    directionX = 1;
    directionY = 0;

    lastDirectionChange = millis();
    directionChangeInterval = 1200;

    chaseRange = 180;

    // ランダム移動型は最初の方向をランダムにする
    if (enemyType == 0) {
      chooseRandomDirection();
    }
  }

  void move(Player target) {
    if (!alive) {
      return;
    }

    if (enemyType == 0) {
      randomMove();

    } else if (enemyType == 1) {
      chaseMove(target);

    } else if (enemyType == 2) {
      patrolAndChaseMove(target);
    }
  }

  // =====================================
  // ランダム移動型
  // =====================================
  void randomMove() {
    // 一定時間ごとに進む方向を変更
    if (millis() - lastDirectionChange >= directionChangeInterval) {
      chooseRandomDirection();
      lastDirectionChange = millis();
    }

    float nextX = x + directionX * speed;
    float nextY = y + directionY * speed;

    if (canMoveTo(nextX, nextY)) {
      x = nextX;
      y = nextY;

    } else {
      // 壁にぶつかったら方向を変更
      chooseRandomDirection();
      lastDirectionChange = millis();
    }
  }

  // =====================================
  // 追尾型
  // =====================================
  void chaseMove(Player target) {
    float differenceX = target.x - x;
    float differenceY = target.y - y;

    /*
     * 斜め移動させず、
     * 距離の大きい方向から上下左右に追いかける
     */
    if (abs(differenceX) >= abs(differenceY)) {
      if (!moveTowardX(differenceX)) {
        moveTowardY(differenceY);
      }

    } else {
      if (!moveTowardY(differenceY)) {
        moveTowardX(differenceX);
      }
    }
  }

  boolean moveTowardX(float differenceX) {
    if (differenceX == 0) {
      return false;
    }

    float nextX;

    if (differenceX > 0) {
      nextX = x + speed;
    } else {
      nextX = x - speed;
    }

    if (canMoveTo(nextX, y)) {
      x = nextX;
      return true;
    }

    return false;
  }

  boolean moveTowardY(float differenceY) {
    if (differenceY == 0) {
      return false;
    }

    float nextY;

    if (differenceY > 0) {
      nextY = y + speed;
    } else {
      nextY = y - speed;
    }

    if (canMoveTo(x, nextY)) {
      y = nextY;
      return true;
    }

    return false;
  }

  // =====================================
  // 普段は巡回、近づいたら追尾する型
  // =====================================
  void patrolAndChaseMove(Player target) {
    float distanceToPlayer = dist(x, y, target.x, target.y);

    if (distanceToPlayer <= chaseRange) {
      // プレイヤーが近い場合
      chaseMove(target);

    } else {
      // プレイヤーが遠い場合は横方向に巡回
      patrolMove();
    }
  }

  void patrolMove() {
    float nextX = x + directionX * speed;

    if (canMoveTo(nextX, y)) {
      x = nextX;

    } else {
      // 壁に当たったら反対方向へ進む
      directionX *= -1;
    }
  }

  // =====================================
  // ランダムな上下左右を選ぶ
  // =====================================
  void chooseRandomDirection() {
    int direction = int(random(4));

    if (direction == 0) {
      directionX = 1;
      directionY = 0;

    } else if (direction == 1) {
      directionX = -1;
      directionY = 0;

    } else if (direction == 2) {
      directionX = 0;
      directionY = 1;

    } else {
      directionX = 0;
      directionY = -1;
    }
  }

  // =====================================
  // 移動可能か判定
  // =====================================
  boolean canMoveTo(float nextX, float nextY) {
    float radius = size / 2;

    // 画面外へ出ない
    if (nextX - radius < 0 ||
        nextX + radius > width ||
        nextY - radius < 0 ||
        nextY + radius > MAP_HEIGHT) {

      return false;
    }

    // 壁との当たり判定
    for (Wall wall : walls) {
      if (nextX + radius > wall.x &&
          nextX - radius < wall.x + wall.w &&
          nextY + radius > wall.y &&
          nextY - radius < wall.y + wall.h) {

        return false;
      }
    }

    // HARDでは閉じたゲートも通れない
    if (ui.difficulty == 1) {
      for (Gate gate : gates) {
        if (!gate.Open &&
            nextX + radius > gate.x &&
            nextX - radius < gate.x + gate.w &&
            nextY + radius > gate.y &&
            nextY - radius < gate.y + gate.h) {

          return false;
        }
      }
    }

    return true;
  }

  // =====================================
  // 敵の表示
  // =====================================
  void display() {
    if (!alive) {
      return;
    }

    if (enemyType == 0) {
      // ランダム型：緑
      fill(0, 200, 100);

    } else if (enemyType == 1) {
      // 追尾型：紫
      fill(180, 0, 180);

    } else {
      // 巡回＋追尾型：赤
      fill(255, 60, 60);
    }

    stroke(255);
    strokeWeight(2);
    ellipse(x, y, size, size);
    noStroke();

    // 目
    fill(255);
    ellipse(x - 6, y - 4, 7, 7);
    ellipse(x + 6, y - 4, 7, 7);

    fill(0);
    ellipse(x - 6, y - 4, 3, 3);
    ellipse(x + 6, y - 4, 3, 3);
  }

  // =====================================
  // プレイヤーとの接触判定
  // =====================================
  boolean hitPlayer(Player target) {
    if (!alive) {
      return false;
    }

    float distanceToPlayer =
      dist(x, y, target.x, target.y);

    return distanceToPlayer <
      size / 2 + target.size / 2;
  }

  void defeat() {
    alive = false;
  }
}
