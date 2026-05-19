import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/responsive.dart';
import '../../l10n/app_localizations.dart';
import 'auth_state.dart';

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage>
    with SingleTickerProviderStateMixin {
  final _emailCtrl = TextEditingController(text: 'demo@buses.by');
  final _passCtrl = TextEditingController(text: 'demo123');
  String? _error;
  bool _busy = false;
  late final AnimationController _anim = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600),
  )..forward();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _anim.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l = AppL10n.of(context);
    setState(() {
      _busy = true;
      _error = null;
    });
    final ok = await ref
        .read(authStateProvider)
        .signIn(_emailCtrl.text.trim(), _passCtrl.text);
    if (!mounted) return;
    setState(() => _busy = false);
    if (!ok) setState(() => _error = l.t('auth_invalid'));
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final cs = Theme.of(context).colorScheme;
    final maxWidth = context.isCompact ? double.infinity : 420.0;
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: FadeTransition(
            opacity: _anim,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.08),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                  parent: _anim, curve: Curves.easeOutCubic)),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(Icons.directions_bus,
                        size: 72, color: cs.primary),
                    const SizedBox(height: 16),
                    Text(l.t('app_title'),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 24),
                    Text(l.t('auth_title'),
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    TextField(
                      key: const Key('auth_email_field'),
                      controller: _emailCtrl,
                      decoration: InputDecoration(
                        labelText: l.t('auth_email'),
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      key: const Key('auth_password_field'),
                      controller: _passCtrl,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: l.t('auth_password'),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (_error != null)
                      Text(_error!,
                          style: TextStyle(color: cs.error)),
                    const SizedBox(height: 16),
                    FilledButton(
                      key: const Key('auth_submit_button'),
                      onPressed: _busy ? null : _submit,
                      child: _busy
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2))
                          : Text(l.t('auth_signin')),
                    ),
                    const SizedBox(height: 12),
                    Text(l.t('auth_signup_hint'),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
