Player player; // プレイヤー
Enemy enemy;   // 敵
UI ui;         // UI

PFont font;

ArrayList<Wall> walls;
ArrayList<Gate> gates;
ArrayList<IceFloor> ices;
ArrayList<Magma> magmas;
ArrayList<InvincibilityZone> invincZones;
ArrayList<Item> items; // アイテム（宝）のリスト

// Playerクラスを書き換えないため、HPや無敵状態はメイン側で管理
int playerHp = 100;
boolean isInvincible = false;
int invincTimer = 0;

void setup() {
  size(800, 600);
  frameRate(60);

  font = createFont("Yu Gothic", 20);
  textFont(font);

  ui = new UI();
  
  initMap();
  player = new Player(50, 50); // 元のPlayerクラスを使用
  enemy = new Enemy(400, 300); // 元のEnemyクラスを使用
}

void initMap() {
  walls = new ArrayList<Wall>();
  gates = new ArrayList<Gate>();

  // 壁の配置
  walls.add(new Wall(180, 50, 40, 80));
  walls.add(new Wall(220, 90, 40, 40));
  walls.add(new Wall(450, 50, 40, 80));
  walls.add(new Wall(410, 50, 40, 40));
  walls.add(new Wall(620, 80, 40, 80));
  walls.add(new Wall(660, 120, 40, 40));
  walls.add(new Wall(80, 180, 40, 80));
  walls.add(new Wall(120, 180, 40, 40));
  walls.add(new Wall(300, 180, 40, 100));
  walls.add(new Wall(270, 210, 100, 40));
  walls.add(new Wall(450, 220, 40, 80));
  walls.add(new Wall(490, 260, 40, 40));
  walls.add(new Wall(650, 220, 40, 100));
  walls.add(new Wall(620, 250, 100, 40));
  walls.add(new Wall(200, 300, 40, 80));
  walls.add(new Wall(240, 340, 40, 40));
  walls.add(new Wall(380, 350, 100, 50));
  walls.add(new Wall(560, 320, 40, 80));
  walls.add(new Wall(600, 320, 40, 40));

  // 氷の床の配置
  ices = new ArrayList<IceFloor>();
  ices.add(new IceFloor(350, 100, 30, 1.5));
  ices.add(new IceFloor(560, 250, 30, 1.5));
  ices.add(new IceFloor(340, 330, 30, 1.5));

  // マグマの配置
  magmas = new ArrayList<Magma>();
  magmas.add(new Magma(120, 100, 30, 1));
  magmas.add(new Magma(230, 230, 30, 1));
  magmas.add(new Magma(550, 140, 30, 1));

  // 無敵ゾーンの配置
  invincZones = new ArrayList<InvincibilityZone>();
  invincZones.add(new InvincibilityZone(720, 20, 60, 5000));
  invincZones.add(new InvincibilityZone(20, 250, 60, 5000));
  invincZones.add(new InvincibilityZone(420, 140, 60, 5000));

  // ★ Itemクラスを変更せずに、インスタンス化してから座標を上書きして配置する
  items = new ArrayList<Item>();
  int[][] itemCoords = {{100, 100}, {500, 100}, {150, 450}, {700, 450}, {400, 250}};
  for (int i = 0; i < itemCoords.length; i++) {
    Item it = new Item();
    it.x = itemCoords[i][0];
    it.y = itemCoords[i][1];
    items.add(it);
  }
  ui.totalTreasure = items.size();
  ui.treasureCount = 0;
}

void draw() {
  background(15, 105, 135);

  if (ui.gameState == 0) {
    ui.display();
    return;
  }

  // 壁・各ギミックの描画処理
  for (Wall w : walls) {
    fill(230, 80, 230);
    stroke(100, 0, 100);
    rect(w.x, w.y, w.w, w.h);
    noStroke();
  }
  for (IceFloor ice : ices) ice.display();
  for (Magma magma : magmas) magma.display();
  for (InvincibilityZone iz : invincZones) iz.display();

  // ★ メインプログラム側でアイテムを金色で描画
  for (Item item : items) {
    fill(255, 215, 0); // 金色
    ellipse(item.x, item.y, 20, 20); // サイズ20の円として描画
  }

  if (ui.gameState == 1) { // プレイ中の処理
    player.speed = 4; // 基本速度リセット

    // 氷の床との当たり判定
    for (IceFloor ice : ices) {
      if (dist(player.x, player.y, ice.x, ice.y) < (player.size / 2) + ice.r) {
        player.speed *= ice.fastRate;
      }
    }

    // 移動前の座標を記録
    float prevX = player.x;
    float prevY = player.y;

    player.move(); // 元のPlayerクラスの移動実行

    // 壁との当たり判定（食い込んだら元の位置に戻す）
    boolean hitWall = false;
    float pr = player.size / 2;
    for (Wall w : walls) {
      if (player.x + pr > w.x && player.x - pr < w.x + w.w && 
          player.y + pr > w.y && player.y - pr < w.y + w.h) {
        hitWall = true;
      }
    }
    if (hitWall) {
      player.x = prevX;
      player.y = prevY;
    }

    // ★ アイテムとの当たり判定（取得したアイテムはリストから削除する）
    for (int i = items.size() - 1; i >= 0; i--) {
      Item item = items.get(i);
      // アイテムの半径を10として当たり判定
      if (dist(player.x, player.y, item.x, item.y) < (player.size / 2) + 10) {
        items.remove(i); // リストから削除
        ui.treasureCount++; // 宝の数を増やす
        if (ui.treasureCount >= ui.totalTreasure) {
          ui.gameState = 2; // 全て集めたらクリア
        }
      }
    }

    // マグマとの当たり判定
    for (Magma magma : magmas) {
      if (dist(player.x, player.y, magma.x, magma.y) < (player.size / 2) + magma.r) {
        if (!isInvincible) {
          playerHp -= magma.dmgVal;
          if (playerHp <= 0) ui.gameState = 3;
        }
      }
    }

    // 無敵ゾーンとの当たり判定
    for (InvincibilityZone iz : invincZones) {
      if (player.x + player.size/2 > iz.x && player.x - player.size/2 < iz.x + iz.w && 
          player.y + player.size/2 > iz.y && player.y - player.size/2 < iz.y + iz.h) {
        isInvincible = true;
        invincTimer = millis();
      }
    }

    // 制限時間経過による無敵状態の解除
    if (isInvincible && millis() - invincTimer > invincZones.get(0).timeLimit) {
      isInvincible = false;
    }

    enemy.move();
    if (enemy.hitPlayer(player) && !isInvincible) {
      ui.gameState = 3;
    }
  }

  // プレイヤーの描画とエフェクト
  player.display();
  if (playerHp <= 0) {
    fill(50, 200);
    ellipse(player.x, player.y, player.size, player.size);
  } else if (isInvincible) {
    fill(255, 150);
    ellipse(player.x, player.y, player.size, player.size);
  }

  enemy.display();
  ui.display();
}

void keyPressed() {
  if (ui.gameState == 0) {
    if (key == ENTER || key == RETURN) {
      ui.gameState = 1;
      ui.showMessage("ゲームスタート！");
    }
    return;
  }

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
    if (mouseX >= width/2-110 && mouseX <= width/2+110 && mouseY >= 230 && mouseY <= 285) {
      ui.gameState = 1;
      ui.showMessage("ゲームスタート！");
    } else if (mouseX >= width/2-110 && mouseX <= width/2+110 && mouseY >= 305 && mouseY <= 360) {
      ui.gameState = 4;
    } else if (mouseX >= width/2-110 && mouseX <= width/2+110 && mouseY >= 380 && mouseY <= 435) {
      exit();
    }
  } else if (ui.gameState == 4) {
    if (mouseX >= width/2-110 && mouseX <= width/2+110 && mouseY >= 420 && mouseY <= 475) {
      ui.gameState = 0;
    }
  } else if (ui.gameState == 3) {
    if (mouseX >= width/2-95 && mouseX <= width/2+95 && mouseY >= 260 && mouseY <= 315) {
      restartGame();
    } else if (mouseX >= width/2-95 && mouseX <= width/2+95 && mouseY >= 340 && mouseY <= 395) {
      ui.gameState = 0;
    }
  } else if (ui.gameState == 2) {
    if (mouseX >= width/2-95 && mouseX <= width/2+95 && mouseY >= 300 && mouseY <= 355) {
      ui.gameState = 0;
    }
  }
}

void restartGame() {
  initMap();
  player = new Player(50, 50);
  enemy = new Enemy(400, 300);
  ui = new UI();
  ui.gameState = 1;
  playerHp = 100;
  isInvincible = false;
  invincTimer = 0;
}
