import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:little_share/shared/supabase.dart';
import 'package:little_share/shared/utils.dart';
import 'package:routemaster/routemaster.dart';

class SignUpView extends ConsumerStatefulWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpViewState();
}

class _SignUpViewState extends ConsumerState<SignUpView> {
  bool _isLoading = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _userNameController = TextEditingController();
  String _userNameErrorText = "";

  final Debouncer _debouncer = Debouncer(milliseconds: 500);

  Future _checkUserNameExist(String username) async {
    setState(() {
      _userNameErrorText = "";
      _isLoading = true;
    });
    try {
      return await ref
          .read(supabaseProvider)
          .from("profiles")
          .select()
          .filter("username", "eq", username)
          .then((value) {
        if (value.length > 0) {
          setState(() {
            _isLoading = false;
            _userNameErrorText = "Username already exist";
          });
          debugPrint("Username already exist");
          return true;
        } else {
          setState(() {
            _isLoading = false;
          });
          debugPrint("Username not exist");
          return false;
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> _signUp() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await ref.read(userProvider.notifier).signUp(
            email: _emailController.text,
            password: _passwordController.text,
            username: _userNameController.text,
          );
      // context.showSnackBar(message: 'Check your email for login link!');
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Sign Up Success')));
      _emailController.clear();
    } catch (error) {
      // context.showErrorSnackBar(message: error.toString());
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(title: const Text('Sign In')),
        body: Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Create an Account",
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.headline5,
            ),
            const SizedBox(
              height: 10,
            ),
            // const Text('Sign in via the magic link with your email below'),
            // const SizedBox(height: 18),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'email'),
            ),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),
            TextFormField(
              controller: _userNameController,
              onChanged: ((value) {
                _debouncer.run(() {
                  debugPrint(value);
                  _checkUserNameExist(_userNameController.text);
                });
              }),
              decoration: InputDecoration(
                  labelText: 'Username',
                  errorText: _userNameErrorText.isNotEmpty
                      ? _userNameErrorText
                      : null),
            ),
            const SizedBox(height: 18),
            GestureDetector(
                onTap: _isLoading ? null : _signUp,
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Center(
                    child: Text(
                      _isLoading ? 'Loading' : 'Sign Up',
                      style: Theme.of(context).textTheme.button?.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ),
                )),

            TextButton(
                onPressed: () {
                  Routemaster.of(context).replace("/login");
                },
                child: const Text('Already Have an Account?')),
          ],
        ),
      ),
    ));
  }
}
