import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../application/auth_providers.dart';

class EmailVerificationScreen extends ConsumerStatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  ConsumerState<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState
    extends ConsumerState<EmailVerificationScreen> {
  Timer? _cooldownTimer;
  int _cooldownSeconds = 0;

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    super.dispose();
  }

  void _startCooldown() {
    setState(() {
      _cooldownSeconds = 60;
    });
    _cooldownTimer?.cancel();
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_cooldownSeconds <= 1) {
        timer.cancel();
        if (mounted) {
          setState(() {
            _cooldownSeconds = 0;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _cooldownSeconds--;
          });
        }
      }
    });
  }

  Future<void> _checkVerification() async {
    final verified =
        await ref.read(authControllerProvider.notifier).checkEmailVerified();
    if (!mounted) return;
    if (verified) {
      context.go(AppRoutes.home);
    } else {
      NotificationService.showInfo(context.l10n.emailNotVerifiedYet);
    }
  }

  Future<void> _resendEmail() async {
    if (_cooldownSeconds > 0) return;
    final sent = await ref
        .read(authControllerProvider.notifier)
        .resendVerificationEmail();
    if (!mounted) return;
    if (sent) {
      NotificationService.showSuccess(context.l10n.verificationEmailSent);
      _startCooldown();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.emailVerificationTitle)),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _checkVerification,
          child: ListView(
            padding: const EdgeInsets.all(24.0),
            children: [
              const SizedBox(height: 48),
              const Icon(
                Icons.mark_email_unread_outlined,
                size: 80,
                color: Colors.green,
              ),
              const SizedBox(height: 24),
              Text(
                l10n.emailVerificationSubtitle,
                textAlign: TextAlign.center,
                style: context.textTheme.bodyMedium,
              ),
              const SizedBox(height: 48),
              PrimaryButton(
                text: l10n.checkVerificationButton,
                onPressed: _checkVerification,
                isLoading: authState.isLoading,
              ),
              const SizedBox(height: 12),
              PrimaryButton(
                text: _cooldownSeconds > 0
                    ? l10n.resendCooldownText(_cooldownSeconds)
                    : l10n.resendEmailButton,
                onPressed: _cooldownSeconds > 0 ? null : _resendEmail,
                isLoading: false,
                isOutlined: true,
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () async {
                  await ref.read(authControllerProvider.notifier).signOut();
                  if (context.mounted) {
                    context.go(AppRoutes.login);
                  }
                },
                child: Text(l10n.logoutButton),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
