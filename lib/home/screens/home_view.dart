import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:little_share/shared/supabase.dart';

class HomeView extends ConsumerWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Home"),
      // ),
      body: SafeArea(
        child: Center(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Card(
            //   child: ListTile(
            //     title: const Text("View Profile"),
            //     onTap: () {
            //       Routemaster.of(context).push("/profile");
            //     },
            //   ),
            // ),
            const Text(
              "Welcome Home!",
            ),
            TextButton(
                onPressed: () {
                  ref.read(userProvider.notifier).signOut();
                },
                child: const Text("Logout"))
          ],
        )),
      ),
    );
  }
}
