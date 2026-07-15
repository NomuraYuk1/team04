class Item {
  int x, y; 
  int item;
  int w, h;
  
  Item(){
    x = 30;//アイテムの出現位置（場所は固定にして出るアイテムをランダムにしたい？）
    y = 30;
    w = 20;
    h = 20;
  }
  
  void display(){
    rect(x, y, 20, 20);
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
  
  void effect(){
  }
}
