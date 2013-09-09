library playerController;

import "../models/player.dart";
import "dart:html";

class Action {
	static const int UP = 0, DOWN = 1;
}

class PlayerController {
	Player p;

	int nr;

	PlayerController(this.p, this.nr);

	Set<Action> actions = new Set();

	keyEvent(int keyCode, bool upOrDown) {
		Action action;
		if (nr == 2) {
			switch (keyCode) {
				case KeyCode.UP:
					action = Action.UP;
					break;
				case KeyCode.DOWN:
					action = Action.DOWN;
					break;
			}
		} else if (nr == 1) {
			switch (keyCode) {
				case KeyCode.W:
					action = Action.UP;
					break;
				case KeyCode.S:
					action = Action.DOWN;
					break;
			}
		}

		if (action == null) return;

		if (upOrDown) actions.remove(action); else actions.add(action);
	}

	act(int dt) {
		actions.forEach((Action action) {
			switch (action) {
				case Action.UP:
					p.moveUp(dt);
					break;
				case Action.DOWN:
					p.moveDown(dt);
					break;
			}
		});
	}

}
