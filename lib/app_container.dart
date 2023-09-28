import 'package:flutter/material.dart';

class AppContainer extends StatelessWidget {
  final Widget child;
  const AppContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: getSize(context),
        ),
        child: child,
      ),
    );
  }

  double getSize(BuildContext context) {
    double sizeWidth = MediaQuery.of(context).size.width;
    if (sizeWidth < 576) {
      return double.infinity;
    } else if (sizeWidth >= 576 && sizeWidth < 768) {
      return 540;
    } else if (sizeWidth >= 768 && sizeWidth < 992) {
      return 720;
    } else if (sizeWidth >= 992 && sizeWidth < 1200) {
      return 960;
    } else if (sizeWidth >= 1200 && sizeWidth < 1400) {
      return 1140;
    } else {
      return 1320;
    }
  }
}
