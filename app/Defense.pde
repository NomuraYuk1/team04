class Defense extends Item {

  Defense() {
    super(1);
  }

  void effect() {
    barrier++;
    ui.showMessage("バリアを獲得！");
  }
}
