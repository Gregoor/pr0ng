library items;

import "level.dart";
import "physactor.dart";
import "shapes.dart";
import "vector.dart";

abstract class Item extends PhysActor {
	Level level;
	Circle body;
	int lifetime = 3000;
	bool consumed = false;

	Vector accel = new Vector.zero();

	Item(this.level, Vector pos, this.accel) : body = new Circle(pos, 20);

	trigger();
}

class GrowItem extends Item {
	GrowItem(Level level, Vector pos, Vector accel) : super(level, pos, accel);

	act(int dt) {
		lifetime -= dt;
		super.act(dt, resolve: (Vector newPos) {
			Player p = level.players.firstWhere((Player p) => (pos - p.pos).lengthSquared <= pow(body.radius + p.body.radius, 2));
			if (p != null) {
			}
		});
	}
}