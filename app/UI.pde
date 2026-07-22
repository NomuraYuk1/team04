class UI {

  // ===== 属性 =====
  int time = 120;
  int score = 0;
  int treasureCount = 0;
  int totalTreasure = 5;
  int enemyCount = 1;

  // ===== パーティクル（光の粒子）用変数 =====
  int numParticles = 25; // 粒子の数
  float[] pX = new float[numParticles];
  float[] pY = new float[numParticles];
  float[] pSize = new float[numParticles];
  float[] pSpeed = new float[numParticles];
  float[] pAlpha = new float[numParticles];
  boolean particlesInitialized = false; // 初期化フラグ

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
  // ===== GAME OVER（ダーク＆危険な雰囲気） =====
  void drawGameOver() {

    // 1. 背景：深い闇と血の気（赤紫色）を感じさせるダークグラデーション
    for (int i = 0; i < height; i++) {
      float inter = map(i, 0, height, 0, 1);
      // 上部は黒に近い闇、下部はうっすらと禍々しい赤紫
      stroke(lerpColor(color(15, 10, 20), color(45, 15, 35), inter));
      line(0, i, width, i);
    }

    textAlign(CENTER, CENTER);

    // 2. 「GAME OVER...」テキスト（影 ＋ 毒々しい紫＆赤の配色）
    // 影（黒）
    fill(0, 0, 0, 200);
    textSize(55);
    text("GAME OVER...", width/2 + 3, 120 + 3);

    // 本体（グラデーション風の禍々しい赤紫）
    fill(210, 50, 100);
    text("GAME OVER...", width/2, 120);

    // 3. スコア表示（くっきり見える白・ゴールド系）
    fill(0, 0, 0, 180);
    textSize(28);
    text("スコア：" + score, width/2 + 2, 200 + 2); // 影

    fill(255, 230, 180); // くっきり見えるクリームゴールド
    text("スコア：" + score, width/2, 200);

    // 4. ボタン描画（配置・サイズは元のまま）
    drawGameOverButton(width/2-95, 260, 190, 55, "リトライ");
    drawGameOverButton(width/2-95, 340, 190, 55, "タイトルに戻る");
  }

  // ===== GAME CLEAR（豪華＆達成感のある雰囲気） =====
  void drawGameClear() {

    // 1. 背景：明るいダンジョンの奥底・光を感じるグラデーション
    for (int i = 0; i < height; i++) {
      float inter = map(i, 0, height, 0, 1);
      // 深い青緑〜神聖なエメラルドグリーンへのグラデーション
      stroke(lerpColor(color(10, 25, 20), color(20, 60, 45), inter));
      line(0, i, width, i);
    }

    textAlign(CENTER, CENTER);

    // 2. 「GAME CLEAR!」テキスト（輝くグリーン）
    fill(0, 0, 0, 200);
    textSize(55);
    text("GAME CLEAR!", width/2 + 3, 120 + 3); // 影

    fill(80, 255, 160); // 鮮やかなエメラルドグリーン
    text("GAME CLEAR!", width/2, 120);

    // 3. スコア表示
    fill(0, 0, 0, 180);
    textSize(28);
    text("スコア：" + score, width/2 + 2, 200 + 2); // 影

    fill(255, 240, 180);
    text("スコア：" + score, width/2, 200);

    // 4. ボタン描画
    drawGameOverButton(width/2-95, 240, 190, 55, "リトライ");
    drawGameOverButton(width/2-95, 320, 190, 55, "タイトルに戻る");
  }


  // ===== 強化版 リトライ／タイトルへ戻るボタン =====
  void drawGameOverButton(float x, float y, float w, float h, String label) {

    // マウスが乗っているか
    boolean hover =
      mouseX >= x && mouseX <= x+w &&
      mouseY >= y && mouseY <= y+h;

    // ★ボタンのドロップシャドウ
    noStroke();
    fill(0, 0, 0, 140);
    rect(x + 4, y + 4, w, h, 10);

    // ★ホバー時と通常時のパープル・ブロンズの質感分け
    if (hover) {
      fill(170, 40, 210);     // ホバー時：明るく鮮やかなネオンパープル
      stroke(240, 180, 255); // 枠線：明るく発光する薄紫
      strokeWeight(3);
    } else {
      fill(110, 25, 140);    // 通常時：重厚なダークパープル
      stroke(180, 100, 210); // 枠線：落ち着いた紫
      strokeWeight(2);
    }

    rect(x, y, w, h, 10);

    // ★文字の装飾
    textAlign(CENTER, CENTER);
    textSize(24);

    // 文字の影（視認性を爆発的に上げる）
    fill(0, 0, 0, 180);
    text(label, x + w/2 + 1, y + h/2 + 2);

    // 文字の本体
    if (hover) {
      fill(255, 255, 255); // ホバー時は純白
    } else {
      fill(240, 220, 255); // 通常時はごく薄いパープルホワイト
    }
    text(label, x + w/2, y + h/2);
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

  // ===== 強化版 タイトル画面描画 =====
  void drawTitle() {
    // 1. 背景（重厚なダークストーン風のグラデーション）
    for (int i = 0; i < height; i++) {
      float inter = map(i, 0, height, 0, 1);
      // 上部は深いダークグレー、下部はほんのり茶・金混じりの暗がり
      stroke(lerpColor(color(25, 25, 30), color(50, 40, 35), inter));
      line(0, i, width, i);
    }

    drawParticles();

    textAlign(CENTER, CENTER);

    // 2. メインタイトル「迷宮の宝を探せ！」
    // ★ドロップシャドウ（影）で立体感を出す
    fill(20, 10, 0, 180);
    textSize(48);
    text("迷宮の宝を探せ！", width/2 + 3, 110 + 3);

    // ★本体（豪華なゴールド描画）
    fill(255, 215, 0); // 鮮やかなゴールド
    text("迷宮の宝を探せ！", width/2, 110);

    // 3. サブタイトル「～全ての宝を集めて脱出せよ～」
    fill(20, 10, 0, 150);
    textSize(20);
    text("～全ての宝を集めて脱出せよ～", width/2 + 2, 160 + 2); // 影

    fill(255, 240, 180); // 薄い金・クリーム色
    text("～全ての宝を集めて脱出せよ～", width/2, 160);

    // 4. ボタン描画（配置・サイズは元のまま）
    drawButton(width/2-110, 230, 220, 55, "ゲーム開始");
    drawButton(width/2-110, 305, 220, 55, "オプション");
    drawButton(width/2-110, 380, 220, 55, "ゲーム終了");

    // 5. さりげない親切機能の追加（[ Enter ]キー表示）
    fill(255, 215, 0, 180);
    textSize(14);
    text("Press [ ENTER ] to Quick Start", width/2, 460);
  }

  // ===== 強化版 ボタン描画 =====
  void drawButton(float x, float y, float w, float h, String label) {

    boolean hover =
      mouseX >= x && mouseX <= x + w &&
      mouseY >= y && mouseY <= y + h;

    // ★ボタンのドロップシャドウ（重厚感アップ）
    noStroke();
    fill(0, 0, 0, 120);
    rect(x + 4, y + 4, w, h, 12);

    // ★ホバー時の発光・通常時の質感塗り分け
    if (hover) {
      fill(180, 100, 40);  // ホバー時：鮮やかな金ブロンズ
      stroke(255, 235, 120); // 枠線：明るいゴールド発光
      strokeWeight(3);
    } else {
      fill(100, 50, 35);   // 通常時：渋いアンティークブロンズ
      stroke(180, 130, 70);  // 枠線：抑えめの真鍮色
      strokeWeight(2);
    }

    rect(x, y, w, h, 12);

    // ★ボタン文字の装飾
    textAlign(CENTER, CENTER);
    textSize(22);

    // 文字の影
    fill(0, 0, 0, 150);
    text(label, x + w/2 + 1, y + h/2 + 2);

    // 文字の本体
    if (hover) {
      fill(255, 255, 220); // ホバー時は文字も明るく強調
    } else {
      fill(255, 220, 150); // 通常時のゴールドホワイト
    }
    text(label, x + w/2, y + h/2);
  }

  // ===== 統一デザイン版 OPTION =====
  void drawOption() {
    // 1. 背景：重厚なダークストーン風グラデーション
    for (int i = 0; i < height; i++) {
      float inter = map(i, 0, height, 0, 1);
      stroke(lerpColor(color(25, 25, 30), color(50, 40, 35), inter));
      line(0, i, width, i);
    }

    textAlign(CENTER, CENTER);

    // 2. 見出し「OPTION」
    fill(20, 10, 0, 180);
    textSize(42);
    text("OPTION", width/2 + 3, 90 + 3); // 影

    fill(255, 215, 0); // ゴールド
    text("OPTION", width/2, 90);

    // 3. 難易度切り替え表示
    textSize(24);
    fill(0, 0, 0, 180);
    text("難易度", width/2 - 120 + 2, 170 + 2); // 影
    fill(255, 240, 180);
    text("難易度", width/2 - 120, 170);

    if (difficulty == 0) {
      fill(0, 0, 0, 180);
      text("◀ NORMAL ▶", width/2 + 90 + 2, 170 + 2);
      fill(100, 220, 255); // NORMALカラー（水色）
      text("◀ NORMAL ▶", width/2 + 90, 170);
    } else {
      fill(0, 0, 0, 180);
      text("◀ HARD ▶", width/2 + 90 + 2, 170 + 2);
      fill(255, 120, 255); // HARDカラー（ピンク紫）
      text("◀ HARD ▶", width/2 + 90, 170);
    }

    // 4. ボタン描画（既存の強化版drawButtonを使用）
    drawButton(width/2 - 110, 240, 220, 55, "操作説明");
    drawButton(width/2 - 110, 320, 220, 55, "ゲーム説明");
    drawButton(width/2 - 110, 420, 220, 55, "タイトルへ戻る");
  }


  // ===== 統一デザイン版 操作説明 =====
  void drawHowToPlay() {
    // 1. 背景グラデーション
    for (int i = 0; i < height; i++) {
      float inter = map(i, 0, height, 0, 1);
      stroke(lerpColor(color(25, 25, 30), color(50, 40, 35), inter));
      line(0, i, width, i);
    }

    // 2. タイトル
    textAlign(CENTER, CENTER);
    fill(20, 10, 0, 180);
    textSize(40);
    text("操作説明", width/2 + 3, 80 + 3); // 影

    fill(255, 215, 0);
    text("操作説明", width/2, 80);

    // ─── 説明文エリア（左揃え） ───
    textAlign(LEFT, CENTER);

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

    // 2. 特殊操作
    fill(255, 220, 100);
    textSize(24);
    text("【 特殊アクション 】", 100, 265);

    textSize(20);
    fill(255);
    text("・", 120, 310);
    fill(100, 255, 100);
    text("方向キー ＋ [ SPACE ]", 140, 310);

    fill(255);
    textSize(18);
    text("：クモの巣に捕まった時、4回連打して脱出", 340, 310);

    // 3. 便利機能
    textSize(24);
    fill(255, 220, 100);
    text("【 便利機能 】", 100, 380);

    textSize(20);
    fill(255);
    text("・", 120, 425);
    fill(255);
    text("[ Enter ] キー", 140, 425);

    fill(255);
    textSize(18);
    text("：タイトル画面で即座にゲームスタート！", 270, 425);

    // 戻るボタン
    drawButton(width/2 - 110, 480, 220, 55, "戻る");
  }


  // ===== 統一デザイン版 ゲーム説明 =====
  // ===== 統一デザイン版 ゲーム説明 =====
  void drawGameGuide() {
    // 1. 背景グラデーション
    for (int i = 0; i < height; i++) {
      float inter = map(i, 0, height, 0, 1);
      stroke(lerpColor(color(25, 25, 30), color(50, 40, 35), inter));
      line(0, i, width, i);
    }

    // 2. タイトル
    textAlign(CENTER, CENTER);
    fill(20, 10, 0, 180);
    textSize(40);
    text("ゲーム説明", width/2 + 3, 80 + 3); // 影

    fill(255, 215, 0);
    text("ゲーム説明", width/2, 80);

    // ─── モード切り替えタブ ───
    noStroke();
    fill(0, 0, 0, 120);
    rect(width/2 - 160 + 3, 120 + 3, 150, 40, 7);
    rect(width/2 + 10 + 3, 120 + 3, 150, 40, 7);

    // NORMALタブ
    if (guideMode == 0) {
      fill(40, 120, 180);
      stroke(100, 220, 255);
      strokeWeight(2);
    } else {
      fill(25, 50, 80);
      noStroke();
    }
    rect(width/2 - 160, 120, 150, 40, 7);

    // HARDタブ
    if (guideMode == 1) {
      fill(180, 40, 180);
      stroke(255, 120, 255);
      strokeWeight(2);
    } else {
      fill(80, 25, 80);
      noStroke();
    }
    rect(width/2 + 10, 120, 150, 40, 7);

    // タブ文字
    fill(255);
    textSize(18);
    textAlign(CENTER, CENTER);
    text("NORMALモード", width/2 - 85, 138);
    text("HARDモード", width/2 + 85, 138);

    // ─── 説明文の表示 ───
    textAlign(LEFT, CENTER);

    if (guideMode == 0) {
      // ◆ NORMAL モードの説明
      fill(100, 200, 255);
      textSize(20);
      text("【NORMALのマップギミック】", 60, 195);

      textSize(15);
      fill(255);
      text("・", 70, 225);
      fill(255, 255, 0);
      text("黄色の○（宝）", 85, 225);
      fill(255);
      text("：マップ内のすべての宝を集めるとクリア！(+100点)", 210, 225);

      fill(255);
      text("・", 70, 250);
      fill(100, 200, 255);
      text("青色の○エリア（氷床）", 85, 250);
      fill(255);
      text("：氷の上で滑っている間、プレイヤーの移動速度がアップ！", 240, 250);

      fill(255);
      text("・", 70, 275);
      fill(255, 255, 255);
      text("白色の□エリア（無敵）", 85, 275);
      fill(255);
      text("：踏むと一定時間、敵やマグマを一切寄せ付けない無敵状態に！", 240, 275);

      fill(255);
      text("・", 70, 300);
      fill(255, 100, 100);
      text("赤色の○エリア（マグマ）", 85, 300);
      fill(255);
      text("：1.6秒触れ続けるとゲームオーバー！触れると、スコアが －20点。", 255, 300);

      // アイテム共通説明
      fill(255, 220, 100);
      textSize(20);
      text("【アイテム仕様（色付き□・全4種）】", 60, 340);

      textSize(15);

      // 敵撃退（赤）
      fill(255, 0, 0);
      text("■ 敵撃退（赤）", 70, 370);
      fill(255);
      text("：取得時、敵を1体倒す", 200, 370);

      // バリア（青）
      fill(0, 0, 255);
      text("■ バリア（青）", 70, 395);
      fill(255);
      text("：敵接触時に自動で身代わりになる（マグマには無効）", 200, 395);

      // スピードアップ（緑）
      fill(0, 255, 0);
      text("■ スピードアップ（緑）", 70, 420);
      fill(255);
      text("：プレイヤーの移動速度が 1.1倍 にアップ", 250, 420);

      // 敵スピードダウン（黄）
      fill(255, 255, 0);
      text("■ 敵スピードダウン（黄）", 70, 445);
      fill(255);
      text("：敵全体の移動速度が 0.75倍 にダウン", 250, 445);


      fill(255, 220, 100);
      textSize(18);
      text("【クリア報酬】ステージクリア：＋500点 ｜ 残り時間ボーナス：1秒につき ＋10点", 60, 485);
    } else {
      // ◆ HARD モードの説明
      fill(255, 120, 255);
      textSize(20);
      text("【HARD限定のマップギミック＆エネミー強化】", 60, 195);

      textSize(15);
      fill(255);
      text("・", 70, 225);
      fill(150, 150, 150);
      text("灰黒の○エリア（水たまり）", 85, 225);
      fill(255);
      text("：足を取られ、通り抜ける間の移動速度が大幅ダウン！", 270, 225);

      fill(255);
      text("・", 70, 250);
      fill(200, 255, 200);
      text("緑網（クモの巣）", 85, 250);
      fill(255);
      text("：捕まると移動不可！方向キー＋[ SPACE ] 4回連打で脱出！", 210, 250);

      fill(255);
      text("・", 70, 275);
      fill(255, 200, 100);
      text("閉開ゲート", 85, 275);
      fill(255);
      text("：定期的に開閉を繰り返す壁。閉まっている時は通行不能！", 210, 275);

      fill(255);
      text("・", 70, 300);
      fill(255, 100, 100);
      text("敵の強化", 85, 300);
      fill(255);
      text("：徘徊する敵が4体に増加！さらにプレイヤーを追う超高速の敵が潜む…", 210, 300);


      // ◆ アイテム説明（色付き□・全4種）
      fill(255, 220, 100);
      textSize(20);
      text("【アイテム仕様（色付き□・全4種）】", 60, 340);

      textSize(15);

      // 敵撃退（赤）
      fill(255, 0, 0);
      text("■ 敵撃退（赤）", 70, 370);
      fill(255);
      text("：取得時、敵を1体倒す", 200, 370);

      // バリア（青）
      fill(0, 0, 255);
      text("■ バリア（青）", 70, 395);
      fill(255);
      text("：敵接触時に自動で身代わりになる（マグマには無効）", 200, 395);

      // スピードアップ（緑）
      fill(0, 255, 0);
      text("■ スピードアップ（緑）", 70, 420);
      fill(255);
      text("：プレイヤーの移動速度が 1.1倍 にアップ", 250, 420);

      // 敵スピードダウン（黄）
      fill(255, 255, 0);
      text("■ 敵スピードダウン（黄）", 70, 445);
      fill(255);
      text("：敵全体の移動速度が 0.75倍 にダウン", 250, 445);


      // ◆ クリア報酬
      fill(255, 220, 100);
      textSize(18);
      text("【クリア報酬】ステージクリア：＋500点 ｜ 残り時間ボーナス：1秒につき ＋10点", 60, 485);
    }

    // 共通の戻るボタン
    drawButton(width/2 - 110, 530, 220, 50, "戻る");
  }




  // ===== パーティクルの初期化 =====
  void initParticles() {
    for (int i = 0; i < numParticles; i++) {
      pX[i] = random(width);
      pY[i] = random(height);
      pSize[i] = random(2, 6);       // 粒子の大きさ
      pSpeed[i] = random(0.5, 1.5);  // 上昇スピード
      pAlpha[i] = random(100, 230);  // 透明度
    }
    particlesInitialized = true;
  }

  // ===== パーティクルの描画と移動 =====
  void drawParticles() {
    // まだ初期化されていなければ初期化する
    if (!particlesInitialized) {
      initParticles();
    }

    noStroke();
    for (int i = 0; i < numParticles; i++) {
      // 粒子を描画（あたたかみのある金の輝き）
      fill(255, 220, 120, pAlpha[i]);
      ellipse(pX[i], pY[i], pSize[i], pSize[i]);

      // 上に向かってゆっくり移動
      pY[i] -= pSpeed[i];

      // 画面の上に消えたら、画面の下から再登場させる
      if (pY[i] < -10) {
        pY[i] = height + 10;
        pX[i] = random(width);
        pAlpha[i] = random(100, 230);
      }
    }
  }
}
