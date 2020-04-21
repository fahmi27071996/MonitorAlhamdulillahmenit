import "package:flutter/material.dart";
import "./multiTouchGestureRecognizer.dart";

void main() => runApp(MultiTapButton());


class MultiTapButton extends StatelessWidget {

  final MultiTapButtonCallback onTapCallback;
  final int minTouches;
  final Color backgroundColor;
  final Color borderColor;
  var correctNumberOfTouches;

  MultiTapButton(this.backgroundColor, this.borderColor, this.minTouches, this.onTapCallback);

  void onTap(bool correctNumberOfTouches) {
    print("Tapped with " + correctNumberOfTouches.toString() + " finger(s)");
    this.onTapCallback(correctNumberOfTouches);
  }

  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(
    gestures: {
      MultiTouchGestureRecognizer: GestureRecognizerFactoryWithHandlers<
          MultiTouchGestureRecognizer>(
        () => MultiTouchGestureRecognizer(),
        (MultiTouchGestureRecognizer instance) {
          instance.minNumberOfTouches = this.minTouches;
          instance.onMultiTap = (correctNumberOfTouches) => this.onTap(correctNumberOfTouches);
        },
      ),
    },
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
        child: 
            Container(
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: this.backgroundColor,
                border: Border(
                  top: BorderSide(width: 1.0, color: borderColor),
                  left: BorderSide(width: 1.0, color: borderColor),
                  right: BorderSide(width: 1.0, color: borderColor),
                  bottom: BorderSide(width: 1.0, color: borderColor),
                ),
              ),
              child: Text("Tap with " + correctNumberOfTouches + " finger(s).", textAlign: TextAlign.center),
            ),
          ),
      ]),
    );
  }
}

typedef MultiTapButtonCallback = void Function(bool correctNumberOfTouches);