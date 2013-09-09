import "shape.dart";
import "vector.dart";

class Circle extends Shape {

	int radius;

	Circle(Vector pos, this.radius) : super(pos);

	contains(Vector point) => (point - pos).length < radius;

}
