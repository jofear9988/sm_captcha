import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  late final double width;
  late final double height;
  final Color beginColor;
  final Color endColor;
  final String text;
  final TextStyle textStyle;
  final Function()? onPress;
  final bool isEnabled;

  GradientButton(
      {Key? key,
        required this.width,
        required this.height,
        Color? beginColor,
        Color? endColor,
        required this.text,
        TextStyle? textStyle,
        this.onPress,
        this.isEnabled = true})
      : assert(width != null && height != null),
        assert(text != null),
        this.beginColor =
            beginColor ?? Colors.black45,
        this.endColor =
            endColor ?? Colors.black26,
        this.textStyle = TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onPress != null && isEnabled) {
          onPress!();
        }
      },
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        decoration: ShapeDecoration(
          shape: StadiumBorder(),
          gradient: LinearGradient(
            colors: isEnabled
                ? [beginColor, endColor]
                : [beginColor.withOpacity(0.6), endColor.withOpacity(0.6)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Text(
          text,
          style: isEnabled ? textStyle : textStyle.copyWith(color: textStyle.color?.withOpacity(0.6) ?? Colors.white60),
        ),
      ),
    );
  }
}
