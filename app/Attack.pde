class Attack extends Item {

  Attack() {
    super(0);
  }

  void effect() {
    boolean defeated = false;

    // 生きている敵を1体だけ倒す
    for (Enemy enemy : enemies) {
      if (enemy.alive) {
        enemy.defeat();
        defeated = true;
        break;
      }
    }

    updateEnemyCount();

    if (defeated) {
      ui.showMessage("敵を1体撃退した！");
    } else {
      ui.showMessage("敵はもういない！");
    }
  }
}
