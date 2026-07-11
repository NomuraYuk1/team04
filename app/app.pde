Player player;
Enemy enemy;
UI ui;

PFont font;

void setup() {

  size(800, 600);
  frameRate(60);

  font = createFont("Yu Gothic", 20);
  textFont(font);

  player = new Player(100, 100);
  enemy = new Enemy(400, 300);

  ui = new UI();
}

void draw() {

  background(240);

  // タイトル画面
  if (ui.gameState == 0) {
    ui.display();
    return;
  }

  // プレイ画面
  player.move();
  player.display();

  enemy.move();
  enemy.display();

  ui.display();

  // 敵と接触したらゲームオーバー
  if (enemy.hitPlayer(player)) {
    ui.gameState = 3;
  }
}

void keyPressed() {

  // タイトル画面
  if (ui.gameState == 0) {
    if (key == ENTER || key == RETURN) {
      ui.gameState = 1;
      ui.showMessage("ゲームスタート！");
    }
    return;
  }

  // プレイ中のみ移動
  if (ui.gameState == 1) {
    player.setMove(keyCode, true);
  }
}

void keyReleased() {

  if (ui.gameState == 1) {
    player.setMove(keyCode, false);
  }
}

void mousePressed() {

  if (ui.gameState == 0) {

    // ゲーム開始ボタン
    if (mouseX >= width/2-110 && mouseX <= width/2+110 &&
      mouseY >= 230 && mouseY <= 285) {

      ui.gameState = 1;
      ui.showMessage("ゲームスタート！");
    }

    // オプションボタン
    if (mouseX >= width/2-110 && mouseX <= width/2+110 &&
      mouseY >= 305 && mouseY <= 360) {

      println("オプション");
    }

    // ゲーム終了ボタン
    if (mouseX >= width/2-110 && mouseX <= width/2+110 &&
      mouseY >= 380 && mouseY <= 435) {

      println("ゲーム終了");
      exit();   // ← プログラム終了
    }
  }

  // ===== GAME OVER画面 =====
  if (ui.gameState == 3) {

    // リトライ
    if (mouseX >= width/2-95 && mouseX <= width/2+95 &&
      mouseY >= 260 && mouseY <= 315) {

      restartGame();
    }

    // タイトルへ戻る
    if (mouseX >= width/2-95 && mouseX <= width/2+95 &&
      mouseY >= 340 && mouseY <= 395) {

      ui.gameState = 0;
    }
  }
}

void restartGame() {

  player = new Player(100, 100);
  enemy = new Enemy(400, 300);

  ui = new UI();

  ui.gameState = 1;
}
