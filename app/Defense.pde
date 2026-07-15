class Defense extends Item {
  int barrier = 0;
  
  Defense(){
    super();
  }
  
  void effect(){
    barrier++;
  }
}
