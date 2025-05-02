// ignore: file_names
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
final class AlertBox extends StatelessWidget {
  final String message;
  final String? title;
  String? contentType = 'failure';
  AlertBox({super.key, required this.message, this.title, this.contentType});

  @override
  Widget build(BuildContext context) {
    return ShowDialog(message: message, title: title, contentType: contentType);
  }

  static showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // ignore: non_constant_identifier_names
  static ShowDialog({
    String? title,
    required String message,
    String? contentType,
  }) {
    return SnackBar(
      /// need to set following properties for best effect of awesome_snackbar_content
      ///
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: Container(
        constraints: const BoxConstraints(
          minHeight: 30,
          maxHeight: 60, // limit the max height here
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: AwesomeSnackbarContent(
          title: title ?? "",
          message: message,

          /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
          contentType:
              contentType == "info"
                  ? ContentType.help
                  : contentType == "success"
                  ? ContentType.success
                  : contentType == "warning"
                  ? ContentType.warning
                  : ContentType.failure,
          inMaterialBanner: true,
        ),
      ),
    );
  }
}
