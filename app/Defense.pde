class Defense extends Item {
  
  Defense(){
    super();
  }
  
  void effect(){
    barrier++;
    ui.showMessage("バリアを獲得！");
  }
}
