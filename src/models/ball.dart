import "dart:math";

import "circle.dart";
import "physactor.dart";
import "rectangle.dart";
import "vector.dart";

class Ball extends PhysActor {

	Circle body;

	Level level;

	Vector vel;

	Ball(Vector pos, this.vel, this.level) : body = new Circle(pos, 15);

	act(int dt) {
		super.act(dt, resolve: (Vector newPos) {
			collides(Rectangle rect) {
				Vector closest = new Vector(newPos.x.clamp(rect.left, rect.right), newPos.y.clamp(rect.bottom, rect.top));
				return (newPos - closest).lengthSquared < pow(body.radius, 2);
			}

			Rectangle tempRect = level.rectangles.firstWhere(collides, orElse: () => null);
			bool player = false;
			if (tempRect == null) {
				Player tempPlayer = level.players.firstWhere((Player player) => collides(player.body), orElse: () => null);
				if (tempPlayer != null) tempRect = tempPlayer.body;
				player = true;
			}

			if (tempRect != null) {
				Vector reboundVel = new Vector.clone(vel);
				if (player) {
					reboundVel.x *= -1.1;
				} else reboundVel.y *= -1;
				vel = reboundVel;
				return true;
			}

			return false;
		});
	}

}
