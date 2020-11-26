import 'package:flutter/material.dart';

class Unsplash {
  String id;
  String description;
  String thumbnailURL;
  String downloadURL;
  String photographerName;
  String photographerProfile;
  Color color;
  String hdURL;
  String fourKURL;
  Color invertedColor;
  String blurHash;

  Unsplash(
      {this.id,
      this.downloadURL,
      this.hdURL,
      this.description,
      this.fourKURL,
      this.blurHash,
      this.photographerName,
      this.photographerProfile,
      this.thumbnailURL,
      this.color,
      this.invertedColor});

  static Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  factory Unsplash.fromJSON(Map<String, dynamic> rawUnsplash, int index) {
    return Unsplash(
      fourKURL: rawUnsplash['results'][index]['urls']['full'] as String,
      hdURL: rawUnsplash['results'][index]['urls']['regular'] as String,
      // invertedColor: hexToColor(CalculateComplimentaryColor.fromHex(
      //         C.HexColor(rawUnsplash['results'][index]['color'] ?? 'FFFFFF'))
      //     .toCssString()),
      color: hexToColor(
          (rawUnsplash['results'][index]['color'] ?? '#FFFFFF') as String),
      thumbnailURL: rawUnsplash['results'][index]['urls']['small'] as String,
      id: rawUnsplash['results'][index]['id'] as String,
      downloadURL: rawUnsplash['results'][index]['links']['download'] as String,
      photographerName: rawUnsplash['results'][index]['user']['name'] as String,
    );
  }

  factory Unsplash.fromJSONSingle(dynamic rawUnsplash) {
    return Unsplash(
      color: hexToColor(rawUnsplash['color'] ?? '#00E676'),
      thumbnailURL: (rawUnsplash['urls']['small'] as String),
      id: rawUnsplash['id'] as String,
      downloadURL: rawUnsplash['links']['download'] as String,
      photographerName: rawUnsplash['user']['name'] as String,
    );
  }

  factory Unsplash.creditFromJson(dynamic rawUnsplash) {
    return Unsplash(
      color: hexToColor(rawUnsplash['color'] ?? '#00E676'),
      id: rawUnsplash['id'] as String,
      blurHash: rawUnsplash['blur_hash'] ?? 'L5H2EC=PM+yV0g-mq.wG9c010J}I',
//      description: rawUnsplash['description'] as String,
      photographerProfile: rawUnsplash['user']['username'] as String,
      photographerName: rawUnsplash['user']['name'] as String,
    );
  }

  @override
  String toString() {
    return 'Unsplash{id: $id, thumbnailURL: $thumbnailURL, downloadURL: $downloadURL, photographerName: $photographerName, color: $color, invertedColor: $invertedColor}';
  }
}
