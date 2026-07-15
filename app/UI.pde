class UI {

  // ===== 属性 =====
  int time = 120;
  int score = 0;
  int treasureCount = 0;
  int totalTreasure = 5;
  int enemyCount = 1;

  int frameCounter = 0;

  String message = "ゲームスタート！";
  int messageTimer = 120;

  // 0: タイトル
  // 1: プレイ中
  // 2: ゲームクリア
  // 3: ゲームオーバー
  // 4:オプション
  int gameState = 0;

  // ===== メイン表示 =====
  void display() {

    // タイトル
    if (gameState == 0) {
      drawTitle();
      return;
    }

    if (gameState == 4) {
      drawOption();
      return;
    }

    updateTime();

    // プレイ中
    drawStatus();
    drawMessage();

    // ゲームクリア
    if (gameState == 2) {
      drawGameClear();
    }

    // ゲームオーバー
    if (gameState == 3) {
      drawGameOver();
    }
  }

  // ===== ステータスバー =====
  void drawStatus() {

    fill(0);
    rect(0, 0, width, 70, 15);

    fill(255);
    textAlign(CENTER);

    textSize(15);

    text("敵の数", 70, 20);
    text("宝の数", 180, 20);
    text("残り時間", 330, 20);
    text("スコア", 470, 20);
    text("アイテム", 650, 20);

    textSize(30);

    text(enemyCount, 70, 55);
    text(treasureCount + "/" + totalTreasure, 180, 55);

    String t = nf(time/60, 2)+":"+nf(time%60, 2);
    text(t, 330, 55);

    text(score, 470, 55);

    text("なし", 650, 55);
  }

  // ===== メッセージ欄 =====
  // ===== メッセージ欄 =====
  void drawMessage() {


    // ゲーム画面との境界線
    stroke(180);
    strokeWeight(5);
    line(0, height - 130, width, height - 130);

    // メッセージエリア全体の背景
    noStroke();
    fill(70);
    rect(0, height - 130, width, 130);

    // メッセージボックス
    stroke(170, 140, 90);
    strokeWeight(3);
    fill(45);
    rect(20, height - 115, width - 40, 95, 15);

    // タイトル
    fill(255, 220, 100);
    textAlign(LEFT, TOP);
    textSize(18);
    text("MESSAGE", 35, height - 108);

    // メッセージ
    fill(255);
    textSize(22);

    if (messageTimer > 0) {
      text(message, 35, height - 75);
      messageTimer--;
    }

    // ▼マーク
    fill(0, 180, 255);
    textSize(24);
    text("▼", width - 50, height - 45);
  }

  // ===== メッセージ変更 =====
  void showMessage(String msg) {
    message = msg;
    messageTimer = 120;
  }

  // ===== GAME OVER =====
  void drawGameOver() {

    // 背景
    background(90);

    textAlign(CENTER, CENTER);

    // GAME OVER
    fill(90, 0, 130);
    textSize(55);
    text("GAME OVER...", width/2, 120);

    // スコア
    fill(255);
    textSize(28);
    text("スコア：" + score, width/2, 200);

    // ボタン
    drawGameOverButton(width/2-95, 260, 190, 55, "リトライ");
    drawGameOverButton(width/2-95, 340, 190, 55, "タイトルに戻る");
  }

  // ===== GAME CLEAR =====
  void drawGameClear() {

    background(90);

    textAlign(CENTER, CENTER);

    fill(0, 255, 100);
    textSize(55);
    text("GAME CLEAR!", width/2, 120);

    fill(255);
    textSize(28);
    text("スコア：" + score, width/2, 200);

    drawGameOverButton(width/2-95, 300, 190, 55, "タイトルに戻る");
  }

  void drawGameOverButton(float x, float y, float w, float h, String label) {

    // マウスが乗っているか
    boolean hover =
      mouseX >= x && mouseX <= x+w &&
      mouseY >= y && mouseY <= y+h;

    noStroke();

    if (hover) {
      fill(160, 20, 200);
    } else {
      fill(140, 20, 180);
    }

    rect(x, y, w, h, 10);

    fill(255);
    textSize(24);
    textAlign(CENTER, CENTER);
    text(label, x+w/2, y+h/2);
  }

  void updateTime() {

    if (gameState != 1) return;

    frameCounter++;

    if (frameCounter >= 60) {
      frameCounter = 0;

      if (time > 0) {
        time--;
      } else {
        gameState = 3;
      }
    }
  }


  void drawTitle() {

    background(90);    // 灰色

    textAlign(CENTER, CENTER);

    // タイトル
    fill(255, 180, 80);
    textAlign(CENTER, CENTER);
    textSize(48);
    text("迷宮の宝を探せ！", width/2, 110);

    // サブタイトル
    fill(240);
    textSize(20);
    text("～全ての宝を集めて脱出せよ～", width/2, 160);

    // ボタン
    drawButton(width/2-110, 230, 220, 55, "ゲーム開始");
    drawButton(width/2-110, 305, 220, 55, "オプション");
    drawButton(width/2-110, 380, 220, 55, "ゲーム終了");
  }

  void drawButton(float x, float y, float w, float h, String label) {

    boolean hover =
      mouseX >= x && mouseX <= x + w &&
      mouseY >= y && mouseY <= y + h;

    if (hover) {
      fill(150, 80, 70);   // マウスが乗っている
    } else {
      fill(110, 60, 50);   // 通常
    }

    stroke(170, 120, 70);
    strokeWeight(2);
    rect(x, y, w, h, 12);

    fill(255);
    textAlign(CENTER, CENTER);
    textSize(22);
    text(label, x + w/2, y + h/2);
  }

  void drawOption() {

    background(70);

    textAlign(CENTER);

    fill(255, 200, 80);
    textSize(42);
    text("OPTION", width/2, 90);

    fill(255);
    textSize(24);

    text("BGM", width/2-120, 170);
    text("ON", width/2+100, 170);

    text("効果音", width/2-120, 230);
    text("ON", width/2+100, 230);

    text("難易度", width/2-120, 290);
    text("NORMAL", width/2+100, 290);

    drawButton(width/2-110, 420, 220, 55, "タイトルへ戻る");
  }
}
