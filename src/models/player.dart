import "dart:math";
import "level.dart";
import "vector.dart";
import "rectangle.dart";
import "physactor.dart";

class Player extends PhysActor {

	static const int START_WIDTH = 30, START_HEIGHT = 170;

	num force = .0005;

	Rectangle body;

	Level level;

	int points = 0;

	Player(Vector pos, this.level) : body = new Rectangle(pos, START_WIDTH, START_HEIGHT);

	act(int dt) {
		if (accel.length > 0 && accel.normalize() == vel.normalize().scale(-1)) {
			vel = new Vector.zero();
		}

		super.act(dt, resolve: (Vector newPos) {
			Rectangle newBody = new Rectangle(newPos, body.width, body.height);
			if (newBody.corners.any((Vector corner) => level.rectangles.any((Rectangle rectangle) => rectangle.contains(corner)))) {
				if (vel.length > .05) vel = vel.scale(-.5); // rebound
				else vel = new Vector.zero();
				return true;
			}
		});
		if (vel.length < .1) vel = new Vector.zero();
		else vel = vel.scale(pow(.99, dt));
	}

	moveUp(int dt) {
		move(-force * dt);
	}

	moveDown(int dt) {
		move(force * dt);
	}

	move(int force) {
		accel += new Vector(0, force);
	}

}
