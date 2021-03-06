import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  PrimaryButton(
      {this.fontSize,
      this.labelFontWeight,
      this.onPressed,
      this.label,
      this.width,
      this.height,
      this.preload,
      this.colors,
      this.color,
      this.opacity = 0.4,
      @required this.icon,
      this.disabled = false,
      this.labalColor});
  final double opacity;
  final GestureTapCallback onPressed;
  final String label;
  final FontWeight labelFontWeight;
  final double width;
  final double height;
  final bool preload;
  final bool disabled;
  final double fontSize;
  final List<Color> colors;
  final Color labalColor;
  final Color color;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: disabled ? opacity : 1,
      child: Container(
        width: width ?? 255.0,
        height: height ?? 50.0,
        decoration: BoxDecoration(
          color: color ?? Theme.of(context).buttonColor,
          // color: Color.fromRGBO(0, 85, 255, 1),
          borderRadius: new BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            SizedBox(
              width: 10,
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                  onTap: disabled ? () {} : onPressed,
                  borderRadius: new BorderRadius.all(new Radius.circular(30.0)),
                  highlightColor: Theme.of(context)
                      .scaffoldBackgroundColor
                      .withOpacity(0.3),
                  splashColor: Theme.of(context)
                      .scaffoldBackgroundColor
                      .withOpacity(0.6),
                  child: Center(
                    child: (preload == null || preload == false)
                        ? AutoSizeText(
                            label,
                            style: TextStyle(
                                color:
                                    labalColor ?? Theme.of(context).splashColor,
                                fontSize: this.fontSize ?? 18,
                                fontWeight:
                                    this.labelFontWeight ?? FontWeight.w700),
                            maxLines: 1,
                          )
                        : Container(
                            child: CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Theme.of(context).splashColor)),
                            width: 21.0,
                            height: 21.0,
                            margin: EdgeInsets.only(left: 28, right: 28),
                          ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
