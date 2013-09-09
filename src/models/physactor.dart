import "dart:math";
import "shape.dart";
import "vector.dart";

abstract class PhysActor {

	Shape body;
	Vector vel = new Vector.zero(), accel = new Vector.zero();

	/**
	 * Does basic speed calculations dependent on the given [dt] in ms.
	 * The [resolve] function is called each time a new position has been calculated.
	 * If resolve returns true the previous position will be set.
	 * After each call the acceleration is resetted to zero.
	 */
	act(num dt, {resolve: null}) {
		vel += accel.scale(dt);
		accel = new Vector.zero();
		Vector newPos = pos;
		boolean collision = false;
		const int STEP_SIZE = 1;
		for (num i = 0; i < dt; i+=STEP_SIZE) {
			pos = newPos;
			newPos += vel.scale(STEP_SIZE);
			if (resolve != null && resolve(newPos)) {
				collision = true;
				break;
			}
		}
		if (!collision) pos = newPos;
	}

	get pos => body.pos;

	set pos(Vector v) => body.pos = v;

}