library shapes;

import "vector.dart";

abstract class Shape {
	Vector pos;

	Shape(this.pos);

	bool contains(Vector point);
}

class Line extends Shape {
	Vector dir;

	Line(Vector from, Vector to) : super(from) {
		dir = to - from;
	}

	contains(Vector point) {
		Vector r = (dir / (point - pos));
		return r.x == r.y;
	}

	num intersection(Line l) {
		return (l.dir.x * (pos.y - l.pos.y) - l.dir.y * (pos.x - l.pos.x)) / (l.dir.y * dir.x - l.dir.x * dir.y);
	}

	toString() => "$pos + λ * $dir";
}

class Circle extends Shape {
	int radius;

	Circle(Vector pos, this.radius) : super(pos);

	contains(Vector point) => (point - pos).length < radius;
}

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

	Map _lines;

	Rectangle(Vector pos, this.width, this.height) : super(pos);

	get left => pos.x - width / 2;
	get right => pos.x + width / 2;
	get bottom => pos.y - height / 2;
	get top => pos.y + height / 2;

	get lowerLeft => new Vector(left, bottom);
	get lowerRight => new Vector(right, bottom);
	get upperLeft => new Vector(left, top);
	get upperRight => new Vector(right, top);

	get corners => [lowerLeft, lowerRight, upperLeft, upperRight];

	get leftLine => new Line(lowerLeft, upperLeft);
	get topLine => new Line(upperLeft, upperRight);
	get rightLine => new Line(upperRight, lowerRight);
	get bottomLine => new Line(lowerRight, lowerLeft);

	get lines {
		if (_lines == null) {
			_lines = {
				Side.LEFT: new Line(lowerLeft, upperLeft),
				Side.TOP: new Line(upperLeft, upperRight),
				Side.RIGHT: new Line(upperRight, lowerRight),
				Side.BOTTOM: new Line(lowerRight, lowerLeft)
			};
		}
		return _lines;
	}

	contains(Vector point) {
		if (point.x >= left && point.y >= bottom && point.x <= right && point.y <= top) return true;
		else return false;
	}

	Side adjacentSideTo(Circle c) {
		List<Side> sides = [];

		if (c.pos.x > pos.x) sides.add(Side.LEFT);
	else if (c.pos.x < pos.x) sides.add(Side.RIGHT);

		if (c.pos.y > pos.y) sides.add(Side.TOP);
	else if (c.pos.y < pos.y) sides.add(Side.BOTTOM);
	}


}