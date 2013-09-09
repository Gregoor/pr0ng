import "shape.dart";
import "vector.dart";

class Side {
	final _value;
	const Side._internal(this._value);
	toString() => "Enum.$_value";

	static const Side
		BOTTOM = const Side._internal(0),
		TOP = const Side._internal(1),
		LEFT = const Side._internal(2),
		RIGHT = const Side._internal(3);
}

class Rectangle extends Shape {

	int width, height;

	Rectangle(Vector pos, this.width, this.height) : super(pos);

	get widthV => new Vector(width, 0);
	get heightV => new Vector(0, height);

	get halfWidthV => widthV.scale(.5);
	get halfHeightV => heightV.scale(.5);

	get left => pos.x - width / 2;
	get right => pos.x + width / 2;
	get bottom => pos.y - height / 2;
	get top => pos.y + height / 2;

	get lowerLeft => new Vector(left, bottom);
	get lowerRight => new Vector(right, bottom);
	get upperLeft => new Vector(left, top);
	get upperRight => new Vector(right, top);

	get corners => [lowerLeft, lowerRight, upperLeft, upperRight];

	contains(Vector point) {
		if (point.x >= left && point.y >= bottom && point.x <= right && point.y <= top) return true;
		else return false;
	}

	Side adjacentSideTo(Vector point) {
		if (point.x > pos.x) return Side.LEFT;
		if (point.x < pos.x) return Side.RIGHT;
		if (point.y > pos.y) return Side.TOP;
		if (point.y < pos.y) return Side.BOTTOM;
	}

}
