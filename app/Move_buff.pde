class Move_buff extends Item {

  Move_buff() {
    super(2);
  }

  void effect() {
    speedEffect *= 1.1;
    ui.showMessage("スピードアップ！");
  }
}
