import "dart:math";

import "ball.dart";
import "player.dart";
import "rectangle.dart";
import "vector.dart";

class Level {

	static const int WIDTH = 1000, HEIGHT = 600;

	List<Rectangle> rectangles;

	List<Player> players;

	Player p1, p2;

	Ball ball;

	int p1Points = 0, p2Points = 0;

	Player lastScorer = null;

	bool scoreChanged = true;

	Level() {
		rectangles = [
	new Rectangle(new Vector(WIDTH / 2, 5), WIDTH, 10),
	new Rectangle(new Vector(WIDTH / 2, HEIGHT - 5), WIDTH, 10)
	];

		num offset = .05;
		p1 = new Player(new Vector(WIDTH * offset, HEIGHT * .5), this);
		p2 = new Player(new Vector(WIDTH * (1 - offset), HEIGHT * .5), this);
		players = [p1, p2];

		spawnBall();
	}

	act(int dt) {
		players.forEach((Player player) => player.act(dt));
		ball.act(dt);

		num x = ball.pos.x, r = ball.body.radius;
		bool p2Scored = x + r < 0, p1Scored = x - r > WIDTH;
		if (p1Scored || p2Scored) {
			if (p1Scored) {
				lastScorer = p1;
			}
			if (p2Scored){
				lastScorer = p2;
			}
			lastScorer.points++;
			scoreChanged = true;

			spawnBall();
		}
	}

	spawnBall() {
		isInRange(num n, List ranges) {
			for (List range in ranges) {
				if (n > range[0] && n < range[1]) return true;
			}
		}
		Random r = new Random();
		num x = .3, y;

		do {
			y = r.nextDouble();
			if (r.nextBool()) y *= -1;
			if (r.nextBool()) x *= -1;
		} while(!isInRange(atan2(x, y), [[7 * PI / 4, 2 * PI], [0, PI / 4], [3 * PI / 4, 5 * PI / 4]]));
		if ((lastScorer == null && r.nextBool()) || lastScorer == p1) x = -1;

		ball = new Ball(new Vector(WIDTH / 2, HEIGHT / 2), new Vector(x, y).normalize().scale(.4), this);
	}

}