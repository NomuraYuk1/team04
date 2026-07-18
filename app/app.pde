Player player;
Enemy enemy;
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
ArrayList<Item> items;
ArrayList<Item> effectItems;
int barrier = 0;
float speedEffect = 1.0;

int playerHp = 100;
boolean isInvincible = false;
int invincTimer = 0;

void setup() {
  size(800, 720);
  frameRate(60);

  font = createFont("Yu Gothic", 20);
  textFont(font);

  ui = new UI();

  initMap();
  player = new Player(50, 50);
  enemy = new Enemy(400, 300);

  startSound = new SoundFile(this, "gamestart.mp3");
  getSound = new SoundFile(this, "takara_get.mp3");
  clearSound = new SoundFile(this, "clear.mp3");
  gameOverSound = new SoundFile(this, "gameover.mp3");
}

void initMap() {
  walls = new ArrayList<Wall>();
  gates = new ArrayList<Gate>();

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

  ices = new ArrayList<IceFloor>();
  ices.add(new IceFloor(350, 100, 30, 1.5));
  ices.add(new IceFloor(560, 250, 30, 1.5));
  ices.add(new IceFloor(340, 330, 30, 1.5));
  ices.add(new IceFloor(420, 450, 30, 1.5));

  magmas = new ArrayList<Magma>();
  magmas.add(new Magma(120, 100, 30, 1));
  magmas.add(new Magma(230, 230, 30, 1));
  magmas.add(new Magma(550, 140, 30, 1));
  magmas.add(new Magma(100, 480, 30, 1));
  magmas.add(new Magma(300, 400, 20, 1));

  invincZones = new ArrayList<InvincibilityZone>();
  invincZones.add(new InvincibilityZone(720, 20, 60, 5000));
  invincZones.add(new InvincibilityZone(20, 250, 60, 5000));
  invincZones.add(new InvincibilityZone(420, 140, 60, 5000));
  invincZones.add(new InvincibilityZone(600, 450, 50, 5000));

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
  background(15, 105, 135);

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
    fill(230, 80, 230);
    stroke(100, 0, 100);
    rect(w.x, w.y, w.w, w.h);
    noStroke();
  }
  for (IceFloor ice : ices) ice.display();
  for (Magma magma : magmas) magma.display();
  for (InvincibilityZone iz : invincZones) iz.display();

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

    for (IceFloor ice : ices) {
      if (dist(player.x, player.y, ice.x, ice.y) < (player.size / 2) + ice.r) {
        player.speed *= ice.fastRate;
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

    enemy.move();
    if (enemy.hitPlayer(player) && !isInvincible) {
      if (barrier > 0){
        barrier--;
        ui.showMessage("バリアで防いだ！");
        isInvincible = true;
        invincTimer = millis();
      }else{
        gameOverSound.play();
        ui.gameState = 3;
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
  player = new Player(50, 50);
  enemy = new Enemy(400, 300);
  ui = new UI();
  ui.gameState = 1;
  playerHp = 100;
  isInvincible = false;
  invincTimer = 0;
  barrier = 0;
  speedEffect = 1.0;
}
