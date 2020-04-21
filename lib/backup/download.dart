import 'dart:io';
import 'package:jiyu/backup/readJson.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:jiyu/auth/login.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';

void download() async {
  AuthProvider().currentUserId().then((String uid) async {
    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(uid + "/" + "details.json");
    try {
      final String downloadUrl = await firebaseStorageRef.getDownloadURL();
      final downloadData = await http.get(downloadUrl);
      String databasePath = await getDatabasesPath();
      final File file = File("$databasePath/details.json");
      if (file.existsSync()) {
        file.delete();
      }
      file.create();
      final StorageFileDownloadTask task = firebaseStorageRef.writeToFile(file);
      final int byteCount = (await task.future).totalByteCount;
      var bodyBytes = downloadData.bodyBytes;
      final String name = await firebaseStorageRef.getName();
      final String path = await firebaseStorageRef.getPath();
      print(
        'Success!Downloaded $name Url: $downloadUrl'
        '\npath: $path \nBytes Count :: $byteCount',
      );
      readJson();
    } catch (e) {
      print(e);
    }
  });
}
