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

  int guideMode = 0; // 0: NORMALの説明、1: HARDの説明

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

    // ★【修正箇所】項目名を「アイテム」から「バリア」に変更
    text("バリア", 650, y+20);

    textSize(30);

    text(enemyCount, 70, y+55);
    text(treasureCount+"/"+totalTreasure, 180, y+55);

    String t=nf(time/60, 2)+":"+nf(time%60, 2);
    text(t, 330, y+55);

    text(score, 470, y+55);

    // ★【修正箇所】シンプルにバリアの個数だけを表示する
    // 「◯個」と表示したい場合は、 barrier + "個" にしてください
    text(barrier, 650, y+55);
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

    // タイトル
    fill(255, 200, 80);
    textAlign(CENTER);
    textSize(40);
    text("操作説明", width/2, 80);

    // ─── ここから操作方法（左揃え） ───
    textAlign(LEFT);

    // 1. 移動操作
    fill(255, 220, 100);
    textSize(24);
    text("【 移動アクション 】", 100, 150);

    textSize(20);
    fill(255);
    text("・", 120, 195);
    fill(100, 200, 255);
    text("↑ ↓ ← → （矢印キー）", 140, 195);
    fill(255);
    text("：プレイヤーの移動", 360, 195);


    // 2. 特殊操作（★見切れ対策：説明の開始位置を右にずらし、文字サイズを少し調整）
    fill(255, 220, 100);
    textSize(24);
    text("【 特殊アクション 】", 100, 265);

    textSize(20);
    fill(255);
    text("・", 120, 310);
    fill(100, 255, 100);
    text("方向キー ＋ [ SPACE ]", 140, 310); // キーの名前

    fill(255);
    textSize(18); // ★ここの説明文だけ少し小さくして収める
    text("：クモの巣に捕まった時、4回連打して脱出", 380, 310); // ★開始X座標を360から380に調整


    // 3. ショートカット（★見やすさのために特殊操作に文字サイズを合わせています）
    textSize(24);
    fill(255, 220, 100);
    text("【 便利機能 】", 100, 380);

    textSize(20);
    fill(255);
    text("・", 120, 425);
    fill(255, 255, 255);
    text("[ Enter ] キー", 140, 425);

    fill(255);
    textSize(18); // ★こちらもサイズを統一
    text("：タイトル画面で即座にゲームスタート！", 380, 425); // ★こちらも380に統一


    // 戻るボタン
    drawButton(width/2-110, 480, 220, 55, "戻る");
  }

  void drawGameGuide() {
    background(70);

    // タイトル
    fill(255, 200, 80);
    textAlign(CENTER);
    textSize(40);
    text("ゲーム説明", width/2, 80);

    // ─── モード切り替えタブ（ボタン）の描画 ───
    if (guideMode == 0) fill(100, 200, 255);
    else fill(50, 100, 150);
    rect(width/2 - 160, 120, 150, 40, 7);

    if (guideMode == 1) fill(255, 100, 255);
    else fill(150, 50, 150);
    rect(width/2 + 10, 120, 150, 40, 7);

    // タブの文字入れ
    fill(255);
    textSize(18);
    textAlign(CENTER);
    text("NORMALモード", width/2 - 85, 146);
    text("HARDモード", width/2 + 85, 146);

    // ─── 説明文の表示（左揃え） ───
    textAlign(LEFT);

    if (guideMode == 0) {
      // ◆ NORMAL モードの説明
      fill(100, 200, 255);
      textSize(22);
      text("【NORMALのマップ＆アイテム】", 80, 200);

      textSize(18);
      fill(255);
      text("・", 100, 240);
      fill(255, 255, 0);
      text("黄色の○（宝）", 120, 240);
      fill(255);
      text("：最重要！マップ内のすべての宝を集めるとクリア！(+100点)", 260, 240);

      fill(255);
      text("・", 100, 280);
      fill(100, 255, 100);
      text("緑色の□（バリア）", 120, 280);
      fill(255);
      text("：所持中に敵に捕まった際、自動で発動してミスを防ぐ！", 260, 280);

      fill(255);
      text("・", 100, 320);
      fill(100, 200, 255);
      text("青色（氷床）", 120, 320);
      fill(255);
      text("：氷の上で滑っている間、プレイヤーの移動速度がアップ！", 260, 320);

      fill(255);
      text("・", 100, 360);
      fill(255, 255, 255);
      text("白色（無敵エリア）", 120, 360);
      fill(255);
      text("：踏むと一定時間、敵やマグマを一切寄せ付けない無敵状態に！", 260, 360);

      fill(255);
      text("・", 100, 400);
      fill(255, 100, 100);
      text("赤色（マグマ）", 120, 400);
      fill(255);
      text("：トラップ。触れると体力が減り、スコアが －20点", 260, 400);

      fill(255, 220, 100);
      textSize(22);
      text("【クリア報酬】", 80, 455);
      textSize(18);
      fill(255);
      text("・ステージクリア：＋500点  ｜  残り時間ボーナス：1秒につき ＋10点", 100, 490);
    } else {
      // ◆ HARD モードの説明
      fill(255, 100, 255);
      textSize(22);
      text("【HARDの特殊マップ＆追加アイテム】", 80, 200);

      textSize(18);
      fill(255);
      text("・", 100, 240);
      fill(255, 255, 0);
      text("黄色の ○（宝）", 120, 240);
      fill(100, 255, 100);
      text("緑色の□（バリア）", 235, 240);
      fill(255);
      text("：NORMALと同様の効果。見つけたら即回収！", 380, 240);

      fill(255);
      text("・", 100, 280);
      fill(255, 150, 0);
      text("橙色の□（羽根）", 120, 280);
      fill(255);
      text("：HARD限定アイテム！拾うと移動スピードが永続アップ！", 260, 280);

      fill(255);
      text("・", 100, 320);
      fill(150, 150, 150);
      text("灰黒（水たまり）", 120, 320);
      fill(255);
      text("：足を取られ、通り抜ける間の移動速度が大幅ダウン！", 260, 320);

      fill(255);
      text("・", 100, 360);
      fill(200, 255, 200);
      text("緑網（クモの巣）", 120, 360);
      fill(255);
      text("：捕まると移動不可！方向キー＋[ SPACE ] 4回連打で脱出！", 260, 360);

      fill(255);
      text("・", 100, 400);
      fill(255, 200, 100);
      text("格子（自動ゲート）", 120, 400);
      fill(255);
      text("：定期的に開閉を繰り返す壁。閉まっている時は通行不能！", 260, 400);

      fill(255, 100, 100);
      textSize(22);
      text("【エネミー強化】", 80, 455);
      textSize(18);
      fill(255);
      text("・徘徊する敵が 4体に増加！さらにプレイヤーを執拗に追う超高速の敵が潜む…", 100, 490);
    }

    // 共通の戻るボタン
    drawButton(width/2-110, 540, 220, 55, "戻る");
  }
}
