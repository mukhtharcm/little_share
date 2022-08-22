import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:little_share/share/models/file_model.dart';
import 'package:little_share/shared/supabase.dart';
import 'package:routemaster/routemaster.dart';

import '../../shared/utils.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  final searchController = TextEditingController();
  String errorText = "";

  final Debouncer _debouncer = Debouncer(milliseconds: 500);

  Future<List<FileModel>> getFiles() async {
    setState(() {
      errorText = "";
    });
    final supabase = ref.read(supabaseProvider);
    try {
      return await supabase
          .from("files")
          .select()
          .filter("collection_id", "eq", searchController.text)
          .then((value) {
        List<FileModel> fileList = [];
        value.forEach((file) {
          fileList.add(FileModel.fromMap(file));
        });
        setState(() {
          errorText = "";
        });
        return fileList;
      });
    } catch (e) {
      setState(() {
        errorText = "Please enter a Proper Id";
      });
      debugPrint(e.toString());
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Home"),
      // ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Home",
                style: Theme.of(context).textTheme.headline5,
              ),
              const SizedBox(
                height: 16.0,
              ),
              TextField(
                controller: searchController,
                enabled: true,
                onChanged: (value) {
                  _debouncer.run(() {
                    getFiles();
                  });
                },
                decoration: InputDecoration(
                  labelText: "Enter Code to View Files",
                  errorText: errorText.isNotEmpty ? errorText : null,
                  border: const OutlineInputBorder(),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: IconButton(
                      icon: const Icon(
                        Icons.search,
                      ),
                      onPressed: getFiles,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: FutureBuilder<List<FileModel>>(
                    future: getFiles(),
                    builder: ((context, snapshot) {
                      return ListView.builder(
                          itemCount: snapshot.data?.length,
                          itemBuilder: (context, index) {
                            final fileModel = snapshot.data?[index];
                            return Card(
                              child: ListTile(
                                title: Text(fileModel?.name ?? ""),
                              ),
                            );
                          });
                    })),
              )
            ],
          ),
        ),
      ),
      persistentFooterButtons: [
        TextButton(
          onPressed: (() async =>
              await ref.read(userProvider.notifier).signOut()),
          child: const Text("Logout"),
        ),
        TextButton(
            onPressed: () {
              Routemaster.of(context).push("/sharelist");
              debugPrint("Navigate to Upload");
            },
            child: const Text("View All Collections"))
      ],
      // floatingActionButton: FloatingActionButton(
      //   onPressed: (() async =>
      //       await ref.read(userProvider.notifier).signOut()),
      //   child: const Icon(Icons.logout),
      // ),
    );
  }
}
