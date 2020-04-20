import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:jiyu/auth/login.dart';
import 'package:jiyu/backup/createJson.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void upload() async {
  createJson();
  AuthProvider().currentUserId().then((String uid) async {
    String databasePath = await getDatabasesPath();
    final File upload = File("$databasePath/details.json");
    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(uid + "/" + basename(upload.path));
    final StorageUploadTask task = firebaseStorageRef.putFile(upload);
  });
}
