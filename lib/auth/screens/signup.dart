import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:little_share/shared/supabase.dart';
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

  Future<void> _signUp() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await ref.read(userProvider.notifier).signUp(
            _emailController.text,
            _passwordController.text,
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
