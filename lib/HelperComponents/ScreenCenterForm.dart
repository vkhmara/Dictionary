import 'package:flutter/cupertino.dart';

class ScreenCenterForm extends StatelessWidget {
  final Widget _widget;
  final double width;

  ScreenCenterForm({@required Widget child, this.width = 200.0}) :
        _widget = child;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 0.15,),
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                color: Color(0xA0FFFFFF),
              ),
              padding: EdgeInsets.all(20.0),
              child: SizedBox(
                width: width,
                child: _widget,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
