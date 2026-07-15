class Attack extends Item {
  
  Attack(){
    super();
  }
  
  void effect(){
    enemy.x = -1000;
    enemy.y = -1000;
  }
}
