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
  // 4: オプション
  // 5: 操作説明
  // 6: ゲーム説明
  int gameState = 0;

  // 難易度
  int difficulty = 0;
  // 0 = NORMAL
  // 1 = HARD

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

    if (gameState == 5) {
      drawHowToPlay();
      return;
    }

    if (gameState == 6) {
      drawGameGuide();
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

    int y = MAP_HEIGHT;

    fill(0);
    noStroke();
    rect(0, y, width, STATUS_HEIGHT);

    fill(255);
    textAlign(CENTER);

    textSize(15);

    text("敵の数", 70, y+20);
    text("宝の数", 180, y+20);
    text("残り時間", 330, y+20);
    text("スコア", 470, y+20);
    text("アイテム", 650, y+20);

    textSize(30);

    text(enemyCount, 70, y+55);
    text(treasureCount+"/"+totalTreasure, 180, y+55);

    String t=nf(time/60, 2)+":"+nf(time%60, 2);
    text(t, 330, y+55);

    text(score, 470, y+55);

    text("なし", 650, y+55);
  }

  // ===== メッセージ欄 =====
  void drawMessage() {

    int y = MAP_HEIGHT + STATUS_HEIGHT;

    stroke(180);
    strokeWeight(4);
    line(0, y, width, y);

    noStroke();

    fill(70);
    rect(0, y, width, MESSAGE_HEIGHT);

    stroke(170, 140, 90);
    strokeWeight(3);

    fill(45);
    rect(20, y + 15, width - 40, MESSAGE_HEIGHT - 35, 15);

    fill(255, 220, 100);
    textAlign(LEFT, TOP);
    textSize(18);
    text("MESSAGE", 35, y + 22);

    fill(255);
    textSize(22);

    if (messageTimer > 0) {
      text(message, 35, y + 55);
      messageTimer--;
    }

    fill(0, 180, 255);
    textSize(24);
    text("▼", width - 50, y + MESSAGE_HEIGHT - 25);
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

    // ▼ リトライボタン追加
    drawGameOverButton(width/2-95, 240, 190, 55, "リトライ");

    // ▼ タイトルへ戻るボタン（既存）
    drawGameOverButton(width/2-95, 320, 190, 55, "タイトルに戻る");
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

    fill(255);
    textSize(24);

    text("難易度", width/2-120, 170);

    if (difficulty==0) {
      text("◀ NORMAL ▶", width/2+90, 170);
    } else {
      text("◀ HARD ▶", width/2+90, 170);
    }

    drawButton(width/2-110, 240, 220, 55, "操作説明");

    drawButton(width/2-110, 320, 220, 55, "ゲーム説明");

    drawButton(width/2-110, 420, 220, 55, "タイトルへ戻る");
  }


  void drawHowToPlay() {

    background(70);

    fill(255, 200, 80);
    textAlign(CENTER);
    textSize(40);
    text("操作説明", width/2, 80);

    fill(255);
    textAlign(LEFT);

    textSize(24);
    text("Enterでもゲームスタートできる！", 120, 120);
    text("↑ ↓ ← → ：移動", 120, 170);
    text("宝を全部集めるとクリア", 120, 220);
    text("敵に当たるとゲームオーバー", 120, 270);

    drawButton(width/2-110, 450, 220, 55, "戻る");
  }

  void drawGameGuide() {

    background(70);

    fill(255, 200, 80);
    textAlign(CENTER);
    textSize(40);
    text("ゲーム説明", width/2, 80);

    fill(255);
    textAlign(LEFT);

    textSize(22);

    text("制限時間内に宝を全て集めよう！", 100, 170);
    text("赤い敵に当たるとゲームオーバー", 100, 220);
    text("白：無敵エリア　青：氷エリア　黄色：宝", 100, 270);
    text("宝1個：＋100点　クリア：＋500点", 100, 320);
    text("残り時間1秒：＋10点　マグマ：＋20点", 100, 370 );




    drawButton(width/2-110, 450, 220, 55, "戻る");
  }
}
