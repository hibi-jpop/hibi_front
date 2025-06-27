import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:hidi/constants/sizes.dart';
import 'package:hidi/features/authentication/viewmodels/login_view_model.dart';
import 'package:hidi/features/authentication/viewmodels/signup_view_model.dart';
import 'package:hidi/features/main-screen/views/main_navigation_view.dart';

class LoginFormView extends ConsumerStatefulWidget {
  const LoginFormView({super.key});

  @override
  ConsumerState<LoginFormView> createState() => _LoginFormViewState();
}

class _LoginFormViewState extends ConsumerState<LoginFormView> {
  late final TextEditingController _EmailController = TextEditingController();
  late final TextEditingController _LoginController = TextEditingController();

  Map<String, dynamic> form = {};
  bool _isButtonDisable = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  bool _isNicknameValid() {
    return true;
  }

  void _isButtonValid() {
    setState(() {});
  }

  void _onSubmit() async {
    final state = ref.read(signUpForm.notifier).state;
    await ref.read(LoginProvider.notifier).login();
    if (mounted) {
      context.go('/${MainNavigationView.initialTab}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("HIBI")),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Sizes.size20),
        child: Column(
          children: [
            Text("LoginForm"),
            TextField(
              controller: _EmailController,
              onChanged: (value) => _isButtonValid(),
              decoration: InputDecoration(
                hintText: "Email",
                // errorText:  ,
                suffix: GestureDetector(
                  onTap: _onClearTap,
                  child: const FaIcon(FontAwesomeIcons.circleXmark),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
              ),
            ),

            GestureDetector(
              onTap: _isButtonDisable ? null : _onSubmit,
              child: FractionallySizedBox(
                widthFactor: 1,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Sizes.size5),
                    color:
                        _isButtonDisable
                            ? Colors.grey.shade400
                            : Colors.orange.shade300,
                  ),
                  child: AnimatedDefaultTextStyle(
                    style: TextStyle(
                      color:
                          _isButtonDisable
                              ? Colors.grey.shade300
                              : Colors.black,
                    ),
                    duration: Duration(milliseconds: 300),
                    child: Text("next", textAlign: TextAlign.center),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
