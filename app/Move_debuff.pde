class Move_debuff extends Item {
  
  Move_debuff(){
    super();
  }  
  
  void effect(){
    player.speed *= 0.9;
  }
}
