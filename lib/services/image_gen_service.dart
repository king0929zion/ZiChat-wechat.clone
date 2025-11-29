import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:zichat/config/api_secrets.dart';
import 'package:zichat/config/ai_models.dart';

/// 图像生成服务
/// 
/// 使用 ModelScope API 生成图片
class ImageGenService {
  /// 生成图片
  /// 
  /// [prompt] 图片描述
  /// [model] 使用的模型，默认使用内置模型
  /// 
  /// 返回图片的 base64 编码，如果失败返回 null
  static Future<String?> generateImage({
    required String prompt,
    ImageModel? model,
  }) async {
    final useModel = model ?? AiModels.defaultImageModel;
    
    // 检查 API Key
    if (!ApiSecrets.hasBuiltInImageApi) {
      throw Exception('图像生成 API 未配置');
    }
    
    try {
      final url = '${ApiSecrets.imageBaseUrl}api/v1/models/${useModel.id}/text-to-image';
      
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${ApiSecrets.imageApiKey}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'input': {
            'prompt': prompt,
          },
          'parameters': {
            'size': '1024*1024',
            'n': 1,
          },
        }),
      ).timeout(const Duration(seconds: 60));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // ModelScope 返回格式处理
        if (data['output'] != null && data['output']['results'] != null) {
          final results = data['output']['results'] as List;
          if (results.isNotEmpty) {
            // 可能返回 URL 或 base64
            final result = results[0];
            if (result['url'] != null) {
              // 如果是 URL，下载图片并转为 base64
              return await _downloadAndEncode(result['url']);
            } else if (result['b64_image'] != null) {
              return result['b64_image'];
            }
          }
        }
        
        throw Exception('生成结果格式异常');
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? '生成失败: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
  
  /// 下载图片并转为 base64
  static Future<String> _downloadAndEncode(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return base64Encode(response.bodyBytes);
    }
    throw Exception('下载图片失败');
  }
  
  /// 检查服务是否可用
  static bool get isAvailable => ApiSecrets.hasBuiltInImageApi;
}

