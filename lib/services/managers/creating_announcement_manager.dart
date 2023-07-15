import 'dart:typed_data';

import 'package:appwrite/appwrite.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';

import '../../data/auth_repository.dart';
import '../../models/announcement_creating_data.dart';
import '../../models/models.dart';
import '../database_manager.dart';
import '../storage_manager.dart';

class CreatingAnnouncementManager {
  final Client client;
  final DatabaseManger dbManager;
  final FileStorageManager storageManager;
  final Account account;
  final _picker = ImagePicker();

  CreatingAnnouncementManager({required this.client})
      : dbManager = DatabaseManger(client: client),
        account = Account(client),
        storageManager = FileStorageManager(client: client);

  AnnouncementCreatingData creatingData = AnnouncementCreatingData();
  SubCategoryItem? currentItem;
  List<XFile> images = [];
  List<Uint8List> imagesAsBytes = [];
  Future? compressingImages;

  BehaviorSubject<LoadingStateEnum> creatingState =
      BehaviorSubject<LoadingStateEnum>.seeded(LoadingStateEnum.wait);

  String get prise => (creatingData.price ?? 0).toString();

  Future<List<XFile>> pickImages() async {
    final _images = await _picker.pickMultiImage();

    images.addAll(_images);

    compressingImages = compressImages(_images);
    return _images;
  }

  Future<void> compressImages(List<XFile> images) async {
    for (var image in images) {
      final bytes = await image.readAsBytes();
      final res = await _compressImage(bytes);
      imagesAsBytes.add(res);
    }
  }

  Future<Uint8List> _compressImage(Uint8List list) async =>
      await FlutterImageCompress.compressWithList(
        list,
        minWidth: 400,
        quality: 96,
      );

  void setCategory(String categoryId) => creatingData.categoryId = categoryId;

  void setSubcategory(String subcategoryId) =>
      creatingData.subcategoryId = subcategoryId;

  void setType(bool type) => creatingData.type = type;

  void setItem(SubCategoryItem? newItem, {String? name}) {
    currentItem =
        newItem ?? SubCategoryItem.withName(name!, creatingData.subcategoryId!)
          ..initialParameters();
    creatingData.itemName = currentItem!.name;
  }

  void setPlaceById(String id) => creatingData.placeId = id;

  void setImages(List<XFile> images) {
    creatingData.images = images.map((e) => e.path).toList();
  }

  void setDescription(String description) =>
      creatingData.description = description;

  void setPrice(String price) => creatingData.price = double.parse(price);

  void _setParameters() => creatingData.parameters =
      currentItem!.parameters.buildJsonFormatParameters();

  String get buildTitle => currentItem!.title;

  void setTitle(String title) => creatingData.title = title;

  void setInfoFormItem() {
    _setParameters();
  }

  void createAnnouncement() async {
    creatingState.add(LoadingStateEnum.loading);
    try {
      final user = await account.get();
      final uid = user.$id;
      await compressingImages;
      final List<String> urls = await uploadImages(imagesAsBytes);

      await dbManager.createAnnouncement(uid, urls, creatingData);

      images.clear();
      creatingData.clear;
      creatingState.add(LoadingStateEnum.success);
    } catch (e) {
      creatingState.add(LoadingStateEnum.fail);
      rethrow;
    }
  }

  Future<List<String>> uploadImages(List<Uint8List> bytesList) async =>
      await storageManager.uploadImages(bytesList);
}
