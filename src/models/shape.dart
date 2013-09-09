library shapes;

abstract class Shape {

	Vector pos;

	Shape(this.pos);

	bool contains(Vector point);

}