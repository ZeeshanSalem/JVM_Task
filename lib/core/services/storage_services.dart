import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseStorageServices {

  Future<String> uploadImage(File image) async {

    var fileName = image.path.split("/").last;
    final StorageReference storageRef =
        FirebaseStorage.instance.ref().child('studentProfile/$fileName');
    final StorageUploadTask uploadTask = storageRef.putFile(image);
    final StreamSubscription<StorageTaskEvent> streamSubscription =
        uploadTask.events.listen((event) {
      switch (event.type) {
        case StorageTaskEventType.success:
          print("File Uploaded");
          break;

        case StorageTaskEventType.progress:
          print("File Uploaded in progress");
          break;

        case StorageTaskEventType.failure:
          print("File Uploaded is fail");
          break;

        case StorageTaskEventType.pause:
          print("File Uploaded pause");
          break;

        case StorageTaskEventType.resume:
          print("File Uploaded is resume");
          break;
      }
      print("Event ${event.type}");
    });

    StorageTaskSnapshot snapshot = await uploadTask.onComplete;
    final imgUrl = await snapshot.ref.getDownloadURL();
    streamSubscription.cancel();
    return imgUrl;
  }
}
