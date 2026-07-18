class Move_debuff extends Item {
  
  Move_debuff(){
    super();
  }  
  
  void effect(){
    enemy.speed *= 0.75;
    ui.showMessage("敵のスピードを低下！");
  }
}
