class Move_debuff extends Item {
  Player player;
  
  Move_debuff(){
    super();
    fill(255, 0, 0);
    rect(10, 10, 10, 10);
  }
  
  void hit(){
    if (player.x < 100){
      item = 2;
    }
  }
  
  void effect(){
    player.speed *= 0.9;
  }
}
