import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:little_share/shared/supabase.dart';
import 'package:routemaster/routemaster.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  bool _isLoading = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await ref.read(userProvider.notifier).login(
            email: _emailController.text,
            password: _passwordController.text,
          );
      // context.showSnackBar(message: 'Check your email for login link!');
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Login Success!')));
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
              "Sign In",
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
                onTap: _isLoading ? null : _signIn,
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
                      _isLoading ? 'Loading' : 'Login',
                      style: Theme.of(context).textTheme.button?.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ),
                )),

            TextButton(
                onPressed: () {
                  Routemaster.of(context).replace("/signup");
                },
                child: const Text('Create an Account')),
          ],
        ),
      ),
    ));
  }
}
