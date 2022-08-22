import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:little_share/share/controllers/manage_collection_page_controller.dart';
import 'package:little_share/share/repositories/file_repository.dart';
import 'package:little_share/shared/supabase.dart';
import 'package:shimmer/shimmer.dart';

import '../models/file_model.dart';

class ManageCollectionView extends ConsumerStatefulWidget {
  const ManageCollectionView({Key? key, required this.collectionId})
      : super(key: key);

  final String? collectionId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ManageCollectionViewState();
}

class _ManageCollectionViewState extends ConsumerState<ManageCollectionView> {
  String statusText = "";
  int? currentFileIndex;
  bool isLoading = false;

  List<PlatformFile> localFileList = [];

  Future _pickFile() async {
    final fileResult = await FilePicker.platform.pickFiles(
      lockParentWindow: true,
      allowMultiple: false,
    );
    if (fileResult != null) {
      setState(() {
        localFileList.addAll(fileResult.files);
      });
    }
  }

  Future<String> uploadFile(PlatformFile file) async {
    var supabase = ref.read(supabaseProvider);
    var currentUser = ref.read(currentUserProvider);
    var currentTime = DateTime.now();
    var uploadPath =
        "user${currentUser?.id}/collection-${widget.collectionId}/${currentTime.millisecondsSinceEpoch}${file.name}";
    try {
      debugPrint("Uploading file ${file.name}");
      return await supabase.storage
          .from("files")
          .upload(uploadPath, File(file.path ?? ""))
          .then((value) {
        debugPrint("File uploaded");
        debugPrint(value);
        var downloadUrl =
            supabase.storage.from("files").getPublicUrl(uploadPath);
        debugPrint("Download url: $downloadUrl");
        return downloadUrl;
      });
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future uploadFiles() async {
    setState(() {
      isLoading = true;
    });
    for (final file in localFileList) {
      if (currentFileIndex != null) {
        setState(() {
          currentFileIndex = currentFileIndex! + 1;
        });
      } else {
        setState(() {
          currentFileIndex = 0;
        });
      }
      var downloadUrl = await uploadFile(file);
      setState(() {
        statusText = "Uploading file ${file.name}";
      });
      await saveFileToCollection(
          downloadUrl: downloadUrl,
          name: file.name,
          collectionId: widget.collectionId!);
    }
    setState(() {
      localFileList.clear();
      currentFileIndex = null;
      statusText = "";
      isLoading = false;
    });
  }

  Future saveFileToCollection(
      {required String downloadUrl,
      required String name,
      required String collectionId}) async {
    setState(() {
      statusText = "Saving file $name";
    });

    var supabase = ref.read(supabaseProvider);
    var file = FileModel(
      name: name,
      url: downloadUrl,
      collection_id: collectionId,
    );
    try {
      debugPrint("Saving file to collection");
      await supabase.from("files").insert(file.toMap()).then((value) {
        debugPrint("File saved to collection");
        debugPrint(value);
      });
      ref.refresh(fileRepositoryProvider);
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    // debugPrint(widget.collectionId);
    var currentSharedCollection =
        ref.watch(sharedCollectoinProvider("${widget.collectionId}"));

    var fileList = ref.watch(fileListProvider("${widget.collectionId}"));

    return Scaffold(
      // appBar: AppBar(title: Text(widget.collectionId ?? "")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              currentSharedCollection.when(error: (error, stackTrace) {
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
              }, loading: () {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer.fromColors(
                      highlightColor: Colors.white,
                      baseColor: Colors.grey.shade300,
                      child: Text(
                        "Title",
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Shimmer.fromColors(
                      highlightColor: Colors.white,
                      baseColor: Colors.grey.shade300,
                      child: Text(
                        "Description",
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                    ),
                  ],
                );
              }, data: (data) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      data.description,
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ],
                );
              }),
              const SizedBox(height: 8.0),
              Expanded(
                child: fileList.when(
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
                  loading: () {
                    return ListView.builder(
                      itemCount: 2,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Shimmer.fromColors(
                            highlightColor: Colors.white,
                            baseColor: Colors.grey.shade300,
                            child: const Text(
                              "Name",
                              // style: Theme.of(context).textTheme.headline5,
                            ),
                          ),
                          subtitle: Shimmer.fromColors(
                            highlightColor: Colors.white,
                            baseColor: Colors.grey.shade300,
                            child: const Text(
                              "Shared by:",
                              // style: Theme.of(context).textTheme.subtitle2,
                            ),
                          ),
                        );
                      },
                    );
                  },
                  data: (data) {
                    if (data.isEmpty && localFileList.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text("No files in this collection"),
                            TextButton(
                              onPressed: _pickFile,
                              child: const Text(
                                "Add Files",
                              ),
                            )
                          ],
                        ),
                      );
                    } else {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          if (localFileList.isNotEmpty)
                            Text(
                              "Not Uploaded Files",
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          if (localFileList.isNotEmpty)
                            Expanded(
                              child: ListView.builder(
                                itemCount: localFileList.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Card(
                                    child: ListTile(
                                      title: Text(localFileList[index].name),
                                      subtitle: currentFileIndex == index
                                          ? Text(statusText)
                                          : const Text(""),
                                      trailing: PopupMenuButton(
                                        itemBuilder: (context) {
                                          return [
                                            PopupMenuItem(
                                              value: "delete",
                                              child: const Text("Delete"),
                                              onTap: () {
                                                setState(() {
                                                  localFileList.remove(
                                                    localFileList[index],
                                                  );
                                                });
                                              },
                                            ),
                                          ];
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          if (data.isNotEmpty)
                            Text(
                              "Uploaded Files",
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          if (data.isNotEmpty)
                            Expanded(
                              child: ListView.builder(
                                itemCount: data.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    child: ListTile(
                                      title: Text(data[index].name),
                                      subtitle: Text(
                                        data[index].collection_id,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      persistentFooterButtons: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: isLoading ? null : uploadFiles,
          child: isLoading
              ? const CircularProgressIndicator(
                  color: Colors.white,
                )
              : const Text("Upload"),
        ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _pickFile,
        label: const Text("Add Files"),
      ),
    );
  }
}
