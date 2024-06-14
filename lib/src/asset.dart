/// Enum for specifying the type of assets.
enum AssetType { image, font, file }

/// class representing an asset in the `pubspec.yaml` file.
class Asset {
  final String path;
  final AssetType type;

  /// Constructs a new instance of [Asset].
  Asset({
    required this.path,
    required this.type,
  });

  /// Convert the [Asset] object to a map.
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'path': path,
    };

    switch (type) {
      case AssetType.image:
        map['type'] = 'image';
        break;
      case AssetType.font:
        map['type'] = 'font';
        break;
      case AssetType.file:
        map['type'] = 'file';
        break;
    }

    return map;
  }

  /// Returns path of the asset.
  @override
  String toString() => path;
}
