Player player;
Enemy enemy;

void setup() {
  size(800, 600);

  player = new Player(100, 100);
  enemy = new Enemy(400, 300);
}

void draw() {
  background(240);

  player.move();
  player.display();

  enemy.move();
  enemy.display();

  if (enemy.hitPlayer(player)) {
    fill(255, 0, 0);
    textSize(50);
    text("GAME OVER", 250, 300);
    noLoop();
  }
}
