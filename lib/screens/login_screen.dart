import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../data/admin_auth_repository.dart';
import '../widgets/admin_components.dart';
import '../widgets/feedback_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AdminAuthRepository _repository = AdminAuthRepository();
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false;
  bool _showPassword = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await _repository.signIn(_email.text, _password.text);
    } on FirebaseAuthException catch (e) {
      if (mounted) setState(() => _error = e.message ?? 'Đăng nhập thất bại.');
    } catch (e) {
      if (mounted) setState(() => _error = 'Không thể đăng nhập: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Tablet keeps a focused single-column sign-in; desktop web gets
          // the two-panel welcome layout.
          final wide = constraints.maxWidth >= 1120;
          return Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: wide ? 36 : 20,
                vertical: 24,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1020),
                child: wide
                    ? Row(
                        children: [
                          Expanded(child: _LoginWelcome()),
                          const SizedBox(width: 38),
                          Expanded(child: _loginCard()),
                        ],
                      )
                    : _loginCard(),
              ),
            ),
          );
        },
      ),
    ),
  );

  Widget _loginCard() => Card(
    margin: EdgeInsets.zero,
    color: Colors.white,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(26),
      side: const BorderSide(color: AppColors.line),
    ),
    child: Padding(
      padding: const EdgeInsets.all(26),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (MediaQuery.sizeOf(context).width < 800) ...[
              const BrandMark(),
              const SizedBox(height: 24),
            ],
            const Text(
              'Chào mừng trở lại',
              style: TextStyle(
                color: AppColors.navy,
                fontSize: 25,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 7),
            const Text(
              'Đăng nhập tài khoản quản trị để tiếp tục.',
              style: TextStyle(color: AppColors.muted, height: 1.5),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _email,
              enabled: !_busy,
              readOnly: false,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [
                AutofillHints.username,
                AutofillHints.email,
              ],
              autocorrect: false,
              decoration: const InputDecoration(
                labelText: 'Email quản trị',
                hintText: 'admin@example.com',
                prefixIcon: Icon(Icons.alternate_email_rounded),
              ),
              validator: (value) => value == null || !value.contains('@')
                  ? 'Vui lòng nhập email hợp lệ'
                  : null,
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: _password,
              enabled: !_busy,
              readOnly: false,
              obscureText: !_showPassword,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.password],
              decoration: InputDecoration(
                labelText: 'Mật khẩu',
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                suffixIcon: IconButton(
                  tooltip: _showPassword ? 'Ẩn mật khẩu' : 'Hiện mật khẩu',
                  onPressed: () =>
                      setState(() => _showPassword = !_showPassword),
                  icon: Icon(
                    _showPassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                ),
              ),
              validator: (value) => value == null || value.isEmpty
                  ? 'Vui lòng nhập mật khẩu'
                  : null,
              onFieldSubmitted: (_) => _submit(),
            ),
            if (_error != null) ...[
              const SizedBox(height: 14),
              ErrorBanner(message: _error!),
            ],
            const SizedBox(height: 21),
            FilledButton.icon(
              onPressed: _busy ? null : _submit,
              icon: _busy
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.login_rounded),
              label: Text(_busy ? 'Đang đăng nhập…' : 'Đăng nhập'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.verified_user_outlined,
                  size: 16,
                  color: AppColors.muted,
                ),
                SizedBox(width: 7),
                Flexible(
                  child: Text(
                    'Xác thực an toàn bằng Firebase Authentication',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.muted, fontSize: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

class _LoginWelcome extends StatelessWidget {
  const _LoginWelcome();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(22),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const BrandMark(),
        const SizedBox(height: 40),
        Container(
          width: 84,
          height: 84,
          decoration: BoxDecoration(
            color: AppColors.blue.withValues(alpha: .1),
            borderRadius: BorderRadius.circular(26),
          ),
          child: const Icon(
            Icons.groups_2_rounded,
            color: AppColors.blue,
            size: 44,
          ),
        ),
        const SizedBox(height: 25),
        const Text(
          'Quản lý sản phẩm\ndễ dàng hơn',
          style: TextStyle(
            color: AppColors.navy,
            fontSize: 34,
            height: 1.2,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          'Theo dõi sản phẩm, cập nhật giá và số lượng trong một nơi.',
          style: TextStyle(color: AppColors.muted, fontSize: 16, height: 1.6),
        ),
      ],
    ),
  );
}
