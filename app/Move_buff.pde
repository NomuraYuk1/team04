class Move_buff extends Item {
  
  Move_buff(){
    super();
  }
  
  void effect(){
    speedEffect *= 1.1;
    ui.showMessage("スピードアップ！");
  }
}
