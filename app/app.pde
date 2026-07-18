Player player;
ArrayList<Enemy> enemies;
UI ui;

import processing.sound.*;
SoundFile startSound;
SoundFile getSound;
SoundFile clearSound;
SoundFile gameOverSound;

PFont font;

final int MAP_HEIGHT = 520;
final int STATUS_HEIGHT = 70;
final int MESSAGE_HEIGHT = 130;

ArrayList<Wall> walls;
ArrayList<Gate> gates;
ArrayList<IceFloor> ices;
ArrayList<Magma> magmas;
ArrayList<InvincibilityZone> invincZones;

ArrayList<Puddle> puddles;
ArrayList<SpiderWeb> webs;

ArrayList<Item> items;
ArrayList<Item> effectItems;
int barrier = 0;
float speedEffect = 1.0;

int playerHp = 100;
boolean isInvincible = false;
int invincTimer = 0;

boolean isTrapped = false;
int webEscapeCount = 0;

void setup() {
  size(800, 720);
  frameRate(60);

  font = createFont("Yu Gothic", 20);
  textFont(font);

  ui = new UI();

  initMap();

  if (ui.difficulty == 0) {
    player = new Player(50, 50);
  } else {
    player = new Player(40, 40);
  }

  initEnemies();

  startSound = new SoundFile(this, "gamestart.mp3");
  getSound = new SoundFile(this, "takara_get.mp3");
  clearSound = new SoundFile(this, "clear.mp3");
  gameOverSound = new SoundFile(this, "gameover.mp3");
}

void initEnemies() {
  enemies = new ArrayList<Enemy>();

  if (ui.difficulty == 0) {
    // ==============================
    // NORMAL：敵2体
    // ==============================

    // ゆっくり追尾型
    enemies.add(
      new Enemy(
        700, 450,
        1,
        1.7
      )
    );

    // 巡回 → 近づいたら追尾
    Enemy nearChaseEnemy = new Enemy(
      400, 300,
      2,
      2.4
    );

    nearChaseEnemy.chaseRange = 200;
    enemies.add(nearChaseEnemy);

  } else {
    // ==============================
    // HARD：敵4体
    // ==============================

    // 遅いランダム型
    enemies.add(
      new Enemy(
        700, 450,
        0,
        1.8
      )
    );

    // 速いランダム型
    enemies.add(
      new Enemy(
        400, 150,
        0,
        3.2
      )
    );

    // 常時追尾型
    enemies.add(
      new Enemy(
        700, 250,
        1,
        2.5
      )
    );

    // 巡回 → 近づいたら追尾
    Enemy hardNearChaseEnemy = new Enemy(
      300, 350,
      2,
      2.2
    );

    hardNearChaseEnemy.chaseRange = 180;
    enemies.add(hardNearChaseEnemy);
  }

  ui.enemyCount = enemies.size();
}

void initMap() {
  walls = new ArrayList<Wall>();
  gates = new ArrayList<Gate>();
  ices = new ArrayList<IceFloor>();
  magmas = new ArrayList<Magma>();
  invincZones = new ArrayList<InvincibilityZone>();
  puddles = new ArrayList<Puddle>();
  webs = new ArrayList<SpiderWeb>();

  // ==========================================
  // 【難易度0 (NORMAL) のマップ】
  // ==========================================
  if (ui.difficulty == 0) {
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
    walls.add(new Wall(560, 360, 40, 80));
    walls.add(new Wall(600, 360, 40, 40));
    walls.add(new Wall(200, 420, 40, 60));
    walls.add(new Wall(280, 460, 80, 40));
    walls.add(new Wall(760, 400, 40, 100));
    walls.add(new Wall(330, 20, 40, 30));
    walls.add(new Wall(0, 130, 30, 60));
    walls.add(new Wall(80, 360, 40, 40));
    walls.add(new Wall(760, 180, 40, 50));
    walls.add(new Wall(540, 60, 40, 40));
    walls.add(new Wall(760, 300, 40, 40));

    ices.add(new IceFloor(350, 100, 30, 1.5));
    ices.add(new IceFloor(560, 250, 30, 1.5));
    ices.add(new IceFloor(340, 330, 30, 1.5));
    ices.add(new IceFloor(420, 450, 30, 1.5));

    magmas.add(new Magma(120, 100, 30, 1));
    magmas.add(new Magma(230, 230, 30, 1));
    magmas.add(new Magma(550, 140, 30, 1));
    magmas.add(new Magma(100, 480, 30, 1));
    magmas.add(new Magma(300, 400, 20, 1));

    invincZones.add(new InvincibilityZone(720, 20, 60, 5000));
    invincZones.add(new InvincibilityZone(20, 250, 60, 5000));
    invincZones.add(new InvincibilityZone(420, 140, 60, 5000));
    invincZones.add(new InvincibilityZone(600, 450, 50, 5000));
  } 
  // ==========================================
  // 【難易度1 (HARD) のマップ】
  // ==========================================
  else if (ui.difficulty == 1) {
    // 完全に隙間（50px以上）を確保した壁の配置
    walls.add(new Wall(130, 60, 130, 60));
    walls.add(new Wall(130, 160, 60, 80));
    walls.add(new Wall(160, 200, 60, 60));
    walls.add(new Wall(320, 60, 100, 60));
    walls.add(new Wall(340, 50, 60, 80));     
    walls.add(new Wall(510, 60, 110, 60));
    walls.add(new Wall(560, 120, 60, 80));
    walls.add(new Wall(670, 140, 80, 60));
    walls.add(new Wall(680, 120, 60, 100));   
    walls.add(new Wall(650, 320, 100, 50));
    walls.add(new Wall(660, 270, 50, 60));
    walls.add(new Wall(480, 370, 130, 50));   
    walls.add(new Wall(520, 240, 60, 80));
    walls.add(new Wall(150, 320, 100, 50));   
    walls.add(new Wall(170, 300, 60, 90));
    walls.add(new Wall(280, 220, 80, 50));
    walls.add(new Wall(300, 260, 50, 70));
    walls.add(new Wall(100, 470, 100, 30));   
    walls.add(new Wall(240, 400, 60, 60));    
    walls.add(new Wall(360, 430, 80, 40));
    walls.add(new Wall(560, 460, 80, 40));

    puddles.add(new Puddle(580, 480, 60, 30, 0.4));
    puddles.add(new Puddle(650, 20, 100, 50, 0.4));
    puddles.add(new Puddle(350, 370, 80, 40, 0.4));
    puddles.add(new Puddle(60, 360, 90, 45, 0.4));
    puddles.add(new Puddle(450, 450, 60, 40, 0.4));
    puddles.add(new Puddle(20, 20, 60, 40, 0.4));
    puddles.add(new Puddle(400, 180, 70, 40, 0.4));
    puddles.add(new Puddle(200, 100, 50, 50, 0.4));
    puddles.add(new Puddle(700, 400, 80, 40, 0.4)); 

    webs.add(new SpiderWeb(80, 120, 40, 40, 5)); 
    webs.add(new SpiderWeb(280, 330, 40, 40, 5));
    webs.add(new SpiderWeb(620, 220, 40, 40, 5));
    webs.add(new SpiderWeb(420, 280, 40, 40, 5));
    webs.add(new SpiderWeb(20, 450, 40, 40, 5));
    webs.add(new SpiderWeb(300, 400, 40, 40, 5));
    webs.add(new SpiderWeb(740, 400, 40, 40, 5));
    webs.add(new SpiderWeb(740, 20, 40, 40, 5));
    webs.add(new SpiderWeb(480, 60, 40, 40, 5));
    webs.add(new SpiderWeb(180, 20, 40, 40, 5));
    webs.add(new SpiderWeb(500, 200, 40, 40, 5));
    webs.add(new SpiderWeb(100, 250, 40, 40, 5));

    gates.add(new Gate(0, 200, 130, 10, 3000));   
    gates.add(new Gate(260, 80, 60, 10, 2500));  
    gates.add(new Gate(620, 160, 50, 10, 2000));  
    gates.add(new Gate(580, 290, 80, 10, 3500));  
    gates.add(new Gate(300, 440, 60, 10, 2000));  
    gates.add(new Gate(420, 100, 90, 10, 2500));  
  }

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

  // 効果アイテムの配置
  effectItems = new ArrayList<Item>();
  Attack a = new Attack();
  a.x = 650;
  a.y = 400;
  effectItems.add(a);
  Defense d = new Defense();
  d.x = 500;
  d.y = 450;
  effectItems.add(d);
  Move_buff mb = new Move_buff();
  mb.x = 50;
  mb.y = 400;
  effectItems.add(mb);
  Move_debuff md = new Move_debuff();
  md.x = 700;
  md.y = 100;
  effectItems.add(md);
}

void draw() {
  if (ui.difficulty == 0) {
    background(15, 105, 135);
  } else {
    background(100, 30, 100);
  }

  stroke(255);
  strokeWeight(3);
  noFill();
  rect(0, 0, width, MAP_HEIGHT);

  noStroke();

  stroke(180);
  strokeWeight(3);
  line(0, MAP_HEIGHT, width, MAP_HEIGHT);

  if (ui.gameState == 0) {
    ui.display();
    return;
  }

  for (Wall w : walls) {
    if (ui.difficulty == 0) {
      fill(230, 80, 230);
      stroke(100, 0, 100);
    } else {
      fill(255, 255, 0);
      stroke(200, 200, 0);
    }
    rect(w.x, w.y, w.w, w.h);
    noStroke();
  }

  if (ui.difficulty == 0) {
    for (IceFloor ice : ices) ice.display();
    for (Magma magma : magmas) magma.display();
    for (InvincibilityZone iz : invincZones) iz.display();
  } else {
    for (Gate g : gates) {
      g.update();
      g.display();
    }
    for (Puddle p : puddles) p.display();
    for (SpiderWeb web : webs) web.display();
  }

  for (Item item : items) {
    fill(255, 215, 0);
    ellipse(item.x, item.y, 20, 20);
  }

  for (int i = 0; i < effectItems.size(); i++) {
    Item ei = effectItems.get(i);
    ei.display();
  }

  if (ui.gameState == 1) {
    player.speed = 4;
    player.speed *= speedEffect;

    if (ui.difficulty == 0) {
      for (IceFloor ice : ices) {
        if (dist(player.x, player.y, ice.x, ice.y) < (player.size / 2) + ice.r) {
          player.speed *= ice.fastRate;
        }
      }
    } else {
      for (Puddle p : puddles) {
        if (player.x > p.x && player.x < p.x + p.w && player.y > p.y && player.y < p.y + p.h) {
          player.speed *= p.slowRate;
        }
      }
      for (SpiderWeb web : webs) {
        if (player.x + player.size/2 > web.x && player.x - player.size/2 < web.x + web.w &&
            player.y + player.size/2 > web.y && player.y - player.size/2 < web.y + web.h) {
          isTrapped = true;
        }
      }
      if (isTrapped) {
        player.speed = 0;
        if (webEscapeCount >= 2) {
          isTrapped = false;
          webEscapeCount = 0;
        }
      }
    }

    float prevX = player.x;
    float prevY = player.y;

    player.move();

    boolean hitWall = false;
    float pr = player.size / 2;
    for (Wall w : walls) {
      if (player.x + pr > w.x && player.x - pr < w.x + w.w &&
        player.y + pr > w.y && player.y - pr < w.y + w.h) {
        hitWall = true;
      }
    }

    if (ui.difficulty == 1) {
      for (Gate g : gates) {
        if (!g.Open && player.x + pr > g.x && player.x - pr < g.x + g.w &&
            player.y + pr > g.y && player.y - pr < g.y + g.h) {
          hitWall = true;
        }
      }
    }

    if (hitWall) {
      player.x = prevX;
      player.y = prevY;
    }

    for (int i = items.size() - 1; i >= 0; i--) {
      Item item = items.get(i);
      if (dist(player.x, player.y, item.x, item.y) < (player.size / 2) + 10) {
        items.remove(i);

        getSound.play();
        ui.treasureCount++;
        ui.score += 100;

        if (ui.treasureCount >= ui.totalTreasure) {
          ui.score += 500;
          ui.score += ui.time * 10;

          clearSound.play();

          ui.showMessage("すべての宝を集めた！");
          ui.gameState = 2;
        } else {
          ui.showMessage("宝を入手！ (" +
            ui.treasureCount +
            "/" +
            ui.totalTreasure +
            ")");
        }
      }
    }

    for (int i = effectItems.size() - 1; i >= 0; i--){
      Item ei = effectItems.get(i);
      if (ei.hit()){
        ei.effect();
        effectItems.remove(i);
      }
    }

    if (ui.difficulty == 0) {
      for (Magma magma : magmas) {
        if (dist(player.x, player.y, magma.x, magma.y) < (player.size / 2) + magma.r) {
          if (!isInvincible) {
            playerHp -= magma.dmgVal;
            ui.score -= 20;

            if (ui.score < 0) {
              ui.score = 0;
            }
            if (playerHp <= 0) ui.gameState = 3;
          }
        }
      }

      for (InvincibilityZone iz : invincZones) {
        if (player.x + player.size/2 > iz.x && player.x - player.size/2 < iz.x + iz.w &&
          player.y + player.size/2 > iz.y && player.y - player.size/2 < iz.y + iz.h) {
          isInvincible = true;
          invincTimer = millis();
        }
      }

      if (isInvincible && millis() - invincTimer > invincZones.get(0).timeLimit) {
        isInvincible = false;
      }
    }

    for (Enemy enemy : enemies) {
  enemy.move(player);

  if (enemy.hitPlayer(player) && !isInvincible) {
    if (barrier > 0) {
      barrier--;

      ui.showMessage("バリアで防いだ！");

      isInvincible = true;
      invincTimer = millis();

    } else {
      gameOverSound.play();
      ui.gameState = 3;
      break;
    }
  }
}
  }

  player.display();

  if (playerHp <= 0) {
    fill(50, 200);
    ellipse(player.x, player.y, player.size, player.size);
  } else if (isInvincible) {
    fill(255, 150);
    ellipse(player.x, player.y, player.size, player.size);
  } else if (isTrapped) {
    fill(255, 0, 0, 100);
    ellipse(player.x, player.y, player.size + 10, player.size + 10);
  }

  for (Enemy enemy : enemies) {
  enemy.display();
}

  ui.display();
}

void keyPressed() {
  if (ui.gameState == 0) {
    if (key == ENTER || key == RETURN) {
      restartGame();
      startSound.play();
      ui.showMessage("ゲームスタート！");
    }
    return;
  }

  if (ui.gameState == 1) {
    player.setMove(keyCode, true);

    if (ui.difficulty == 1 && isTrapped && key == ' ') {
      webEscapeCount++;
    }
  }
}

void keyReleased() {
  if (ui.gameState == 1) {
    player.setMove(keyCode, false);
  }
}

void mousePressed() {
  if (ui.gameState == 0) {
    if (mouseX >= width/2-110 &&
      mouseX <= width/2+110 &&
      mouseY >= 230 &&
      mouseY <= 285) {

      restartGame();
      startSound.play();
      ui.showMessage("ゲームスタート！");
    }
    else if (mouseX >= width/2-110 &&
      mouseX <= width/2+110 &&
      mouseY >= 305 &&
      mouseY <= 360) {
      ui.gameState = 4;
    }
    else if (mouseX >= width/2-110 &&
      mouseX <= width/2+110 &&
      mouseY >= 380 &&
      mouseY <= 435) {
      System.exit(0);
    }
  }
  else if (ui.gameState == 4) {
    if (mouseX>=width/2+20 &&
      mouseX<=width/2+180 &&
      mouseY>=150 &&
      mouseY<=185) {
      ui.difficulty++;
      if (ui.difficulty>1) {
        ui.difficulty=0;
      }
    }
    if (mouseX>=width/2-110 &&
      mouseX<=width/2+110 &&
      mouseY>=240 &&
      mouseY<=295) {
      ui.gameState=5;
    }
    if (mouseX>=width/2-110 &&
      mouseX<=width/2+110 &&
      mouseY>=320 &&
      mouseY<=375) {
      ui.gameState=6;
    }
    if (mouseX>=width/2-110 &&
      mouseX<=width/2+110 &&
      mouseY>=420 &&
      mouseY<=475) {
      ui.gameState=0;
    }
  }
  else if (ui.gameState == 3) {
    if (mouseX >= width/2-95 &&
      mouseX <= width/2+95 &&
      mouseY >= 260 &&
      mouseY <= 315) {
      restartGame();
      startSound.play();
    } else if (mouseX >= width/2-95 &&
      mouseX <= width/2+95 &&
      mouseY >= 340 &&
      mouseY <= 395) {
      ui.gameState = 0;
    }
  }
  else if (ui.gameState == 2) {
    if (mouseX >= width/2-95 &&
      mouseX <= width/2+95 &&
      mouseY >= 240 &&
      mouseY <= 295) {
      restartGame();
      startSound.play();
    }
    else if (mouseX >= width/2-95 &&
      mouseX <= width/2+95 &&
      mouseY >= 320 &&
      mouseY <= width/2+375) {
      ui.gameState = 0;
    }
  } else if (ui.gameState == 5) {
    if (mouseX >= width/2-110 &&
      mouseX <= width/2+110 &&
      mouseY >= 450 &&
      mouseY <= 505) {
      ui.gameState = 4;
    }
  } else if (ui.gameState == 6) {
    if (mouseX >= width/2-110 &&
      mouseX <= width/2+110 &&
      mouseY >= 450 &&
      mouseY <= 505) {
      ui.gameState = 4;
    }
  }
}

void restartGame() {
  initMap();

  if (ui.difficulty == 0) {
    player = new Player(50, 50);
  } else {
    player = new Player(40, 40);
  }

  // 選択された難易度に合わせて敵を作り直す
  initEnemies();

  ui.gameState = 1;

  playerHp = 100;
  isInvincible = false;
  invincTimer = 0;

  barrier = 0;
  speedEffect = 1.0;

  isTrapped = false;
  webEscapeCount = 0;

  ui.time = 120;
  ui.score = 0;
  ui.treasureCount = 0;
  ui.frameCounter = 0;
}

void updateEnemyCount() {
  int count = 0;

  for (Enemy enemy : enemies) {
    if (enemy.alive) {
      count++;
    }
  }

  ui.enemyCount = count;
}
