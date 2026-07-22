class Move_debuff extends Item {

  Move_debuff() {
    super(3);
  }

  void effect() {
    // 生きている敵すべての速度を下げる
    for (Enemy enemy : enemies) {
      if (enemy.alive) {
        enemy.speed *= 0.75;
      }
    }

    ui.showMessage("敵全体のスピードを低下！");
  }
}
