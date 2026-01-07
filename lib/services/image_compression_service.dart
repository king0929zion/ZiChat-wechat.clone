import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;

/// 图片压缩服务
class ImageCompressionService {
  // 压缩配置常量
  static const int maxThumbnailWidth = 200;
  static const int maxThumbnailHeight = 200;
  static const int maxMessageWidth = 800;
  static const int maxMessageHeight = 800;
  static const int thumbnailQuality = 85;
  static const int messageQuality = 90;

  /// 压缩图片用于消息发送
  /// 返回压缩后的图片字节数据
  static Future<Uint8List> compressForMessage(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    return compressBytesForMessage(bytes);
  }

  /// 压缩图片字节数据用于消息发送
  static Future<Uint8List> compressBytesForMessage(Uint8List bytes) async {
    return _compressImage(
      bytes,
      maxWidth: maxMessageWidth,
      maxHeight: maxMessageHeight,
      quality: messageQuality,
    );
  }

  /// 生成缩略图
  static Future<Uint8List> generateThumbnail(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    return generateThumbnailFromBytes(bytes);
  }

  /// 从字节数据生成缩略图
  static Future<Uint8List> generateThumbnailFromBytes(Uint8List bytes) async {
    return _compressImage(
      bytes,
      maxWidth: maxThumbnailWidth,
      maxHeight: maxThumbnailHeight,
      quality: thumbnailQuality,
    );
  }

  /// 压缩图片的核心方法
  static Future<Uint8List> _compressImage(
    Uint8List bytes, {
    required int maxWidth,
    required int maxHeight,
    required int quality,
  }) async {
    try {
      // 解码图片
      img.Image? image = img.decodeImage(bytes);
      if (image == null) {
        return bytes; // 解码失败，返回原始数据
      }

      // 计算缩放比例
      final int width = image.width;
      final int height = image.height;
      final double scale = _calculateScale(
        width,
        height,
        maxWidth,
        maxHeight,
      );

      // 如果不需要缩放，只调整质量
      if (scale >= 1.0) {
        final encoded = img.encodeJpg(image, quality: quality);
        return Uint8List.fromList(encoded);
      }

      // 缩放图片
      final int newWidth = (width * scale).round();
      final int newHeight = (height * scale).round();

      // 使用高质量的缩放算法
      final resized = img.copyResize(
        image,
        width: newWidth,
        height: newHeight,
        interpolation: img.Interpolation.linear,
      );

      // 编码为 JPEG
      final encoded = img.encodeJpg(resized, quality: quality);
      return Uint8List.fromList(encoded);
    } catch (e) {
      // 压缩失败，返回原始数据
      return bytes;
    }
  }

  /// 计算缩放比例
  static double _calculateScale(
    int width,
    int height,
    int maxWidth,
    int maxHeight,
  ) {
    final double widthScale = maxWidth / width;
    final double heightScale = maxHeight / height;
    return widthScale < heightScale ? widthScale : heightScale;
  }

  /// 获取图片信息
  static Map<String, dynamic> getImageInfo(File imageFile) {
    final bytes = imageFile.readAsBytesSync();
    return getImageInfoFromBytes(bytes);
  }

  /// 从字节数据获取图片信息
  static Map<String, dynamic> getImageInfoFromBytes(Uint8List bytes) {
    try {
      final image = img.decodeImage(bytes);
      if (image == null) {
        return {
          'width': 0,
          'height': 0,
          'size': bytes.length,
          'format': 'unknown',
        };
      }

      return {
        'width': image.width,
        'height': image.height,
        'size': bytes.length,
        'format': _getImageFormat(imageFileExtension: ''),
      };
    } catch (e) {
      return {
        'width': 0,
        'height': 0,
        'size': bytes.length,
        'format': 'error',
      };
    }
  }

  /// 获取图片格式
  static String _getImageFormat({required String imageFileExtension}) {
    final ext = imageFileExtension.toLowerCase();
    if (ext == '.png') return 'png';
    if (ext == '.jpg' || ext == '.jpeg') return 'jpeg';
    if (ext == '.gif') return 'gif';
    if (ext == '.webp') return 'webp';
    if (ext == '.bmp') return 'bmp';
    return 'unknown';
  }

  /// 格式化文件大小
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
