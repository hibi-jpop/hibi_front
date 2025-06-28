import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hidi/constants/sizes.dart';
import 'package:hidi/features/authentication/viewmodels/signup_view_model.dart';
import 'package:hidi/features/authentication/views/nickname_view.dart';

class PasswordView extends ConsumerStatefulWidget {
  const PasswordView({super.key});

  @override
  ConsumerState<PasswordView> createState() => _PasswordViewState();
}

class _PasswordViewState extends ConsumerState<PasswordView> {
  late final TextEditingController _passwordController =
      TextEditingController();

  String _password = "";
  bool _isButtonDisable = true;
  bool _isObscure = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  String? _isPasswordValid() {
    List<String> errors = [];

    if (_password.isEmpty) return null;

    if (_password.length < 8) {
      errors.add("최소 8글자 이상");
    }

    return errors.isEmpty ? null : errors.join('\n');
  }

  void _toggleObscrueText() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  void _isButtonValid() {
    setState(() {
      _password = _passwordController.text;
      _isButtonDisable = _password.isEmpty || _isPasswordValid() != null;
    });
  }

  void _onSubmit() {
    final state = ref.read(signUpForm.notifier).state;
    ref.read(signUpForm.notifier).state = {...state, "password": _password};
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NicknameView()),
    );
  }

  void _onClearTap() {
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("HIBI")),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Sizes.size20),
        child: Column(
          children: [
            Text("password"),
            TextField(
              controller: _passwordController,
              obscureText: _isObscure,
              onChanged: (value) => _isButtonValid(),
              decoration: InputDecoration(
                hintText: "password",
                errorText: _isPasswordValid(),
                suffix: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: _onClearTap,
                      child: const FaIcon(FontAwesomeIcons.circleXmark),
                    ),
                    GestureDetector(
                      onTap: _toggleObscrueText,
                      child:
                          _isObscure
                              ? FaIcon(FontAwesomeIcons.eye)
                              : FaIcon(FontAwesomeIcons.eyeSlash),
                    ),
                  ],
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
