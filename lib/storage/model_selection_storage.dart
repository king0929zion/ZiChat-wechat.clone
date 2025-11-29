import 'package:shared_preferences/shared_preferences.dart';
import 'package:zichat/config/ai_models.dart';

/// 模型选择存储
/// 
/// 保存用户选择的对话模型和图像生成模型
class ModelSelectionStorage {
  static const String _chatModelKey = 'selected_chat_model';
  static const String _imageModelKey = 'selected_image_model';
  static const String _useBuiltInApiKey = 'use_built_in_api';
  
  /// 保存选择的对话模型
  static Future<void> saveChatModel(ChatModel model) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_chatModelKey, model.id);
  }
  
  /// 获取选择的对话模型
  static Future<ChatModel> getChatModel() async {
    final prefs = await SharedPreferences.getInstance();
    final modelId = prefs.getString(_chatModelKey);
    
    if (modelId != null) {
      try {
        return AiModels.builtInChatModels.firstWhere((m) => m.id == modelId);
      } catch (_) {
        // 找不到则返回默认
      }
    }
    
    return AiModels.defaultChatModel;
  }
  
  /// 保存选择的图像模型
  static Future<void> saveImageModel(ImageModel model) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_imageModelKey, model.id);
  }
  
  /// 获取选择的图像模型
  static Future<ImageModel> getImageModel() async {
    final prefs = await SharedPreferences.getInstance();
    final modelId = prefs.getString(_imageModelKey);
    
    if (modelId != null) {
      try {
        return AiModels.builtInImageModels.firstWhere((m) => m.id == modelId);
      } catch (_) {
        // 找不到则返回默认
      }
    }
    
    return AiModels.defaultImageModel;
  }
  
  /// 设置是否使用内置 API
  static Future<void> setUseBuiltInApi(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_useBuiltInApiKey, value);
  }
  
  /// 获取是否使用内置 API
  static Future<bool> getUseBuiltInApi() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_useBuiltInApiKey) ?? true; // 默认使用内置
  }
}

