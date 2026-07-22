class Item {
  int x, y;
  int item;
  int w, h;

  // ★ 引数ありコンストラクタを追加
  Item(int type) {
    x = 30;
    y = 30;
    w = 20;
    h = 20;
    item = type;   // ← ここで種類をセット
  }

  void display() {
    switch(item) {
    case 0:  // Attack
      fill(255, 0, 0);   // 赤
      break;

    case 1:  // Defense
      fill(0, 0, 255);   // 青
      break;

    case 2:  // Move_buff
      fill(0, 255, 0);   // 緑
      break;

    case 3:  // Move_debuff
      fill(255, 255, 0); // 黄
      break;
    }
    rect(x, y, w, h);
  }

  boolean hit() {

    if (player.x - player.size/2 < x + w &&
      player.x + player.size/2 > x &&
      player.y - player.size/2 < y + h &&
      player.y + player.size/2 > y) {

      return true;
    }

    return false;
  }

  void effect() {
  }
}
