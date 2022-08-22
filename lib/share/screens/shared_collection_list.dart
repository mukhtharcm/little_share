import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:little_share/share/controllers/shared_collection_list_controller.dart';
import 'package:little_share/share/models/share.dart';
import 'package:routemaster/routemaster.dart';

class SharedCollectionList extends ConsumerWidget {
  const SharedCollectionList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Shared",
                style: Theme.of(context).textTheme.headline5,
              ),
              const SizedBox(
                height: 16.0,
              ),
              Expanded(
                child: ref.watch(sharedCollectionsProvider).when(
                      loading: (() => const Center(
                            child: CircularProgressIndicator(),
                          )),
                      error: (error, stackTrace) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 128,
                                color: Theme.of(context).errorColor,
                              ),
                              Text(error.toString()),
                              // const SizedBox(
                            ],
                          ),
                        );
                      },
                      data: (data) {
                        return ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            SharedCollection collection = data[index];
                            // debugPrint("$index ${collection.id}");
                            return Card(
                              child: ListTile(
                                onTap: () {
                                  Routemaster.of(context).push(
                                      "/managecollection/${collection.id}");
                                },
                                title: Text(
                                  collection.title,
                                ),
                                subtitle: Text(
                                  collection.description,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: PopupMenuButton(
                                  itemBuilder: (context) => [
                                    const PopupMenuItem(
                                      value: "view",
                                      child: Text("View"),
                                    ),
                                    const PopupMenuItem(
                                      value: "share",
                                      child: Text("Share"),
                                    ),
                                    PopupMenuItem(
                                      value: "delete",
                                      child: const Text("Delete"),
                                      onTap: () => ref
                                          .read(
                                              sharedCollectionListPageControllerProvider)
                                          .removeSharedCollection(data[index]),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
              ),
              // Expanded(
              //   child:
              // ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text("Create New Collection"),
        onPressed: () {
          Routemaster.of(context).push("/newcollection");
        },
      ),
    );
  }
}
