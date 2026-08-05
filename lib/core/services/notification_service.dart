import 'package:flutter/material.dart';

class NotificationService {
  NotificationService._();

  static final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static void showError(String message) {
    _showSnackBar(
      message: message,
      backgroundColor: const Color(0xFFD32F2F),
      icon: Icons.error_outline,
    );
  }

  static void showSuccess(String message) {
    _showSnackBar(
      message: message,
      backgroundColor: const Color(0xFF2E7D32),
      icon: Icons.check_circle_outline,
    );
  }

  static void showInfo(String message) {
    _showSnackBar(
      message: message,
      backgroundColor: const Color(0xFF0288D1),
      icon: Icons.info_outline,
    );
  }

  static void _showSnackBar({
    required String message,
    required Color backgroundColor,
    required IconData icon,
  }) {
    messengerKey.currentState?.removeCurrentSnackBar();
    messengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }
}
