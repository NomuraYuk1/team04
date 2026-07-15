class Item {
  int x, y; 
  int item;
  
  Item(){
    x = 30;//アイテムの出現位置（場所は固定にして出るアイテムをランダムにしたい？）
    y = 30;
  }
  
  void display(){
    rect(x, y, 20, 20);
  }
  
  boolean hit(){
    if (player.x < item.x + item.w &&
    player.x + player.w > item.x &&
    player.y < item.y + item.h &&
    player.y + player.h > item.y) {
    // アイテム取得
}
  }
  
  void effect(){
  }
}
