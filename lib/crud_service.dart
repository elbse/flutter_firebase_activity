import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:image_picker/image_picker.dart';

class PickedImage {
  final File file;
  final String url;
  PickedImage({required this.file, required this.url});
}

class CrudService {
  final CollectionReference items =
      FirebaseFirestore.instance.collection('items');

  // Cloud name = uu17u6pj. Replace the preset with the name of YOUR
  // unsigned upload preset (Cloudinary > Settings > Upload > Upload presets).
  final CloudinaryPublic _cloudinary = CloudinaryPublic(
    'uu17u6pj',
    'YOUR_UNSIGNED_PRESET',
    cache: false,
  );

  final ImagePicker _picker = ImagePicker();

  Future<PickedImage?> pickImageForAddItem() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return null;

    final file = File(pickedFile.path);

    final response = await _cloudinary.uploadFile(
      CloudinaryFile.fromFile(file.path),
    );
    return PickedImage(file: file, url: response.secureUrl);
  }

  // CREATE
  Future<void> addItemWithImage(
      String name, int quantity, String? imageUrl) async {
    await items.add({
      'name': name,
      'quantity': quantity,
      'image_url': imageUrl,
      'isFavorite': false,
      'createdAt': Timestamp.now(),
    });
  }

  // READ
  Stream<QuerySnapshot> getItems() {
    return items.orderBy('createdAt', descending: true).snapshots();
  }

  // READ - favorites only
  Stream<QuerySnapshot> getFavoriteItems() {
    return items.where('isFavorite', isEqualTo: true).snapshots();
  }

  // UPDATE
  Future<void> updateItem(String id, String name, int quantity) {
    return items.doc(id).update({
      'name': name,
      'quantity': quantity,
    });
  }

  // UPDATE - toggle favorite
  Future<void> toggleFavorite(String id, bool currentValue) {
    return items.doc(id).update({'isFavorite': !currentValue});
  }

  // DELETE
  Future<void> deleteItem(String id) {
    return items.doc(id).delete();
  }
}