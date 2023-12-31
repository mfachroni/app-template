import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

class AppHelper {
  static Future<dynamic> showAppDialog({
    required BuildContext context,
    required Widget child,
    Color? barrierColor = Colors.black54,
  }) {
    ScrollController scrollController = ScrollController();
    return showGeneralDialog(
      context: context,
      barrierColor: barrierColor!,
      barrierLabel: '',
      barrierDismissible: true,
      // useSafeArea: true,
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return SafeArea(
          top: false,
          child: Builder(builder: (BuildContext context) {
            return child;
          }),
        );
      },
      transitionDuration: const Duration(milliseconds: 400),

      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
            transformHitTests: false,
            position: Tween<Offset>(
              begin: const Offset(0.0, -1.0),
              end: Offset.zero,
            ).chain(CurveTween(curve: Curves.bounceIn)).animate(animation),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Scaffold(
                extendBodyBehindAppBar: true,
                resizeToAvoidBottomInset: true,
                backgroundColor: Colors.transparent,
                body: Scrollbar(
                  thumbVisibility: true,
                  controller: scrollController,
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: GestureDetector(
                      onTap: () {},
                      child: child,
                    ),
                  ),
                ),
              ),
            ));
      },
    );
  }

  static Future<dynamic> showMessage(
    BuildContext context, {
    required AppMessageType type,
    String? title,
    String? message,
    Function()? onCancelBtnTap,
    Function()? onConfirmBtnTap,
  }) {
    QuickAlertType tmpType = QuickAlertType.info;
    
    if (type == AppMessageType.info) {
      tmpType = QuickAlertType.info;
    } else if (type == AppMessageType.error) {
      tmpType = QuickAlertType.error;
    } else if (type == AppMessageType.success) {
      tmpType = QuickAlertType.success;
    } else if (type == AppMessageType.warning) {
      tmpType = QuickAlertType.warning;
    }

    return QuickAlert.show(
      context: context,
      type: tmpType,
      text: message,
      title: title,
      width: 400,
      onCancelBtnTap: onCancelBtnTap,
      onConfirmBtnTap: onConfirmBtnTap,
    );
  }
}

enum AppMessageType { info, success, warning, error }
