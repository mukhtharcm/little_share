import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:little_share/shared/supabase.dart';

class ProfileView extends ConsumerWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(currentUser?.id ?? ""),
      ),
      body: Column(children: [
        ListTile(
          title: Text(currentUser?.role ?? ""),
        )
      ]),
    );
  }
}
