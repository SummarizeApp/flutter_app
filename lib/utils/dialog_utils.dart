
import 'package:flutter/material.dart';
import 'package:literate_app/global_components/custom_alert_content.dart';

showSimpleAlertModal(
  BuildContext context, {
  String? type,
  required String title,
  required String body,
  required String buttonText,
  void Function()? onPressButton,
  void Function()? onPressCancel,
  String? cancelButtonText,
}) {
  String svgName = "red-error";
  if (type == "unhappy") {
    svgName = "red-unhappy";
  } else if (type == "success") {
    svgName = "green-tick";
  }
  return showSimpleDialog(
    context,
    title: title,
    content: (BuildContext dialogContext) => CustomAlertContent(
      svgName: svgName,
      // type: type,
      body: body,
      buttonText: buttonText,
      onPressButton: onPressButton,
      onPressCancel: onPressCancel,
      cancelButtonText: cancelButtonText,
    ),
  );
}

Future<String?> showSimpleDialog(
  BuildContext context, {
  required String title,
  required Widget Function(BuildContext) content,
  void Function()? onClickOutsideFunc,
}) {
  return showDialog<String>(
    context: context,
    builder: (BuildContext _) => WillPopScope(
      onWillPop: () async {
        if (onClickOutsideFunc != null) {
          onClickOutsideFunc();
        }
        return false;
      },
      child: AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(80),
            bottomLeft: Radius.circular(80),
            bottomRight: Radius.circular(40),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
          textAlign: TextAlign.center,
        ),
        content: content(_),
      ),
    ),
  );
}
