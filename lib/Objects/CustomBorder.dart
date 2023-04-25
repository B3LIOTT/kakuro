import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomBorder extends BoxBorder {
  final Color color;
  double width;
  double voidSize;
  bool hasDiagonal;
  bool hasTop;
  bool hasBottom;
  bool hasLeft;
  bool hasRight;

  CustomBorder({this.color = Colors.black, this.width = 2, this.voidSize = 0, this.hasDiagonal = false, this.hasTop = true, this.hasBottom = true, this.hasLeft = true, this.hasRight = true});
  @override
  EdgeInsetsGeometry get dimensions => const EdgeInsets.all(0);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      getOuterPath(rect);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    Path path = Path();
    if (hasTop) {
      path.moveTo(rect.left + voidSize, rect.top);
      path.lineTo(rect.right - voidSize, rect.top);
    }
    if (hasRight) {
      path.moveTo(rect.right, rect.top + voidSize);
      path.lineTo(rect.right, rect.bottom - voidSize);
    }
    if (hasBottom) {
      path.moveTo(rect.right - voidSize, rect.bottom);
      path.lineTo(rect.left + voidSize, rect.bottom);
    }
    if (hasLeft) {
      path.moveTo(rect.left, rect.bottom - voidSize);
      path.lineTo(rect.left, rect.top + voidSize);
    }
    if (hasDiagonal) {
      path.moveTo(rect.left + voidSize, rect.top + voidSize);
      path.lineTo(rect.right - voidSize, rect.bottom - voidSize);}
    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect,
      {BorderRadius? borderRadius,
        BoxShape? shape = BoxShape.rectangle,
        TextDirection? textDirection}) {
    Paint paint = Paint()
      ..color = color
      ..strokeWidth = width
      ..style = PaintingStyle.stroke;

    Path path = getOuterPath(rect);

    canvas.drawPath(path, paint);
  }

  @override
  BoxBorder copyWith({
    BorderSide? top,
    BorderSide? right,
    BorderSide? bottom,
    BorderSide? left,
  }) {
    return CustomBorder();
  }

  @override
  bool get isUniform => false;

  @override
  BorderSide get top => BorderSide();

  @override
  BorderSide get bottom => BorderSide();

  @override
  ShapeBorder scale(double t) {
    return CustomBorder();
  }
}