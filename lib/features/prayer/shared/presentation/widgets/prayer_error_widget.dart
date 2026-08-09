import 'package:flutter/material.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../shared/widgets/error_state_widget.dart';

class PrayerErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const PrayerErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ErrorStateWidget(
      title: l10n.errorStateDefaultTitle,
      message: message,
      retryText: l10n.retryButton,
      onRetry: onRetry,
    );
  }
}
