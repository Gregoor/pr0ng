import "dart:math";

import "physactor.dart";
import "shapes.dart";
import "vector.dart";

class Ball extends PhysActor {

	Circle body;

	Level level;

	Vector vel;

	Ball(this.level, Vector pos, this.vel) : body = new Circle(pos, 15);

	act(int dt) {
		super.act(dt, resolve: (Vector newPos) {
			collides(Rectangle rect) {
				Vector closest = new Vector(newPos.x.clamp(rect.left, rect.right), newPos.y.clamp(rect.bottom, rect.top));
				return (newPos - closest).lengthSquared < pow(body.radius, 2);
			}

			Rectangle tempRect = level.rectangles.firstWhere(collides, orElse: () => null);
			Player tempPlayer;
			if (tempRect == null) {
				tempPlayer = level.players.firstWhere((Player player) => collides(player.body), orElse: () => null);
				if (tempPlayer != null) tempRect = tempPlayer.body;
			}

			if (tempRect != null) {
				Line m2m = new Line(body.pos, tempRect.pos);
				num smallestScalar;
				Side appendentSide;
				tempRect.lines.forEach((Side s, Line l) {
					num scalar = m2m.intersection(l);
					if (smallestScalar == null || scalar <= smallestScalar) {
						smallestScalar = scalar;
						appendentSide = s;
					}
				});

				Vector reboundVel = new Vector.clone(vel);
				if ([Side.LEFT, Side.RIGHT].contains(appendentSide)) reboundVel.y *= -1;
				else reboundVel.x *= -1;
				vel = reboundVel;


				if (tempPlayer != null && tempPlayer.vel != new Vector.zero()) {
					print(tempPlayer.vel);
					vel += (vel - tempPlayer.vel).scale(.1);
				}

				return true;
			}

			return false;
		});
	}

}
