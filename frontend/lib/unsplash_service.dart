import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:frontend/unsplash.dart';
import 'package:unsplash_client/unsplash_client.dart';

class UnsplashService {
  Future<UnsplashClient> getClient() async {
//    QuerySnapshot query;
//    try {
//      query = await FirebaseFirestore.instance
//          .collection('uc')
//          .get(GetOptions(source: Source.cache));
//    } catch (_) {
//      query = await FirebaseFirestore.instance
//          .collection('uc')
//          .get(GetOptions(source: Source.serverAndCache));
//    }
//     (query.docs.first);
//    final snap = query.docs.first;
    UnsplashClient client = UnsplashClient(
      settings: ClientSettings(
          credentials: AppCredentials(
        accessKey: '4LCnSgMuGZ5hfItvmVvXNOR_Y_M4wHb78smO3ZuAl-s',

//              secretKey: 'Kfaf7pp1dkhQOIPq6b50SjswYytv0yEtlX1qp6NTZNM'
      )),
    );
    return client;
  }

  // triggerDownload(String photoID) async {
  //   if (!photoID.isNullOrBlank) {
  //     final client = await getClient();
  //     Photo photo = await client.photos.get(photoID).goAndGet();
  //     String downloadURL = photo.links.downloadLocation.toString();
  //     final k = client.settings.credentials.accessKey;
  //     await dio.get(downloadURL,
  //         options: Options(headers: {'Authorization': 'Client-ID $k'}));
  //   }
  // }

  // Future<String> getThumbnailByPhotoID(String photoID,
  //     {bool isPortrait}) async {
  //   final client = await getClient();
  //   try {
  //     var request = client.photos.get(photoID);
  //     Photo photo = await request.goAndGet();
  //     var url;
  //     if (Get.width >= 640)
  //       url = photo.urls.raw.resizePhoto(
  //         devicePixelRatio: Get.mediaQuery.devicePixelRatio.round(),
  //         fit: ResizeFitMode.fill,
  //         quality: 75,
  //         imgixParams: {'fill': 'blur'},
  //       );
  //     else
  //       url = photo.urls.regular.resizePhoto(
  //         quality: 70,
  //         height: 480,
  //         width: 480,
  //         devicePixelRatio: Get.mediaQuery.devicePixelRatio.round(),
  //         fit: ResizeFitMode.fill,
  //         imgixParams: {'fill': 'blur'},
  //       );
  //     return url.toString();
  //   } catch (_) {
  //     final photos = await client.photos
  //         .random(
  //         count: 1,
  //         contentFilter: ContentFilter.high,
  //         query: 'northern lights')
  //         .goAndGet();
  //     return photos.first.urls.small.path;
  //   }
  // }

  Future<Unsplash> getBackgroundByPhotoID(String photoID) async {
    final client = await getClient();

    try {
      var request = client.photos.get(photoID);
      Photo photo = await request.goAndGet();
      var url = photo.urls.regular.resizePhoto(
        imgixParams: {'fill': 'blur'},
        quality: 100,
      );
      return Unsplash(
          id: photoID,
          description: photo.description,
          photographerName: photo.user.name,
          thumbnailURL: url.toString(),
          hdURL: photo.user.username);
    } catch (e) {
      final photos = await client.photos
          .random(
              count: 1,
              contentFilter: ContentFilter.high,
              query: 'northern lights')
          .goAndGet();
      var photo = photos.first;
      return Unsplash(
          id: photoID,
          description: photo.description,
          photographerName: photo.user.name,
          thumbnailURL: photo.urls.small.toString(),
          hdURL: photo.user.username);
    }
  }

  Future<List<Unsplash>> searchAndGet30Photos(String query,
      {int page = 1, bool isLandscape = false}) async {
    try {
      final client = await getClient();
      var request1 = client.search.photos(query,
          contentFilter: ContentFilter.high,
          perPage: 30,
          page: 1,
          orderBy: PhotoOrder.relevant);
      var request2 = client.search.photos(query,
          contentFilter: ContentFilter.high,
          perPage: 30,
//          orientation: isLandscape
//              ? PhotoOrientation.landscape
//              : PhotoOrientation.portrait,
          page: 2,
          orderBy: PhotoOrder.relevant);
      List<Unsplash> photos = [];
      var data1 = await request1.go();
      var data2 = await request2.go();
      photos.addAll(await compute(decodeImages, data1.body));
      photos.addAll(await compute(decodeImages, data2.body));
      return photos;
    } catch (_) {
      return [];
    }
  }
}

List<Unsplash> decodeImages(String rawData) {
  List<Unsplash> photos = [];
  var data = json.decode(rawData);
//    String key = data.keys.first;
  photos = List<Unsplash>.from(data['results']
      .map((d) => Unsplash.fromJSONSingle(d.cast<String, dynamic>())));

//  List<> rawList=json.decode(data);
//  for (int i = 0; i < rawList.length; i++)
//    photos.add(Unsplash.fromJSONSingle(rawList[i]));
  return photos;
}
