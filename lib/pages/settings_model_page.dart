import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zichat/config/api_secrets.dart';
import 'package:zichat/config/ai_models.dart';
import 'package:zichat/constants/app_colors.dart';
import 'package:zichat/storage/model_selection_storage.dart';

/// AI 模型选择设置页面
class SettingsModelPage extends StatefulWidget {
  const SettingsModelPage({super.key});

  @override
  State<SettingsModelPage> createState() => _SettingsModelPageState();
}

class _SettingsModelPageState extends State<SettingsModelPage> {
  bool _useBuiltInApi = true;
  ChatModel? _selectedChatModel;
  ImageModel? _selectedImageModel;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final useBuiltIn = await ModelSelectionStorage.getUseBuiltInApi();
    final chatModel = await ModelSelectionStorage.getChatModel();
    final imageModel = await ModelSelectionStorage.getImageModel();
    
    setState(() {
      _useBuiltInApi = useBuiltIn;
      _selectedChatModel = chatModel;
      _selectedImageModel = imageModel;
      _loading = false;
    });
  }

  Future<void> _setUseBuiltInApi(bool value) async {
    await ModelSelectionStorage.setUseBuiltInApi(value);
    setState(() {
      _useBuiltInApi = value;
    });
    HapticFeedback.selectionClick();
  }

  Future<void> _selectChatModel(ChatModel model) async {
    await ModelSelectionStorage.saveChatModel(model);
    setState(() {
      _selectedChatModel = model;
    });
    HapticFeedback.selectionClick();
  }

  Future<void> _selectImageModel(ImageModel model) async {
    await ModelSelectionStorage.saveImageModel(model);
    setState(() {
      _selectedImageModel = model;
    });
    HapticFeedback.selectionClick();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('AI 模型设置'),
        elevation: 0,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                // API 来源选择
                _buildSection(
                  title: 'API 来源',
                  children: [
                    _buildSwitchTile(
                      title: '使用内置 API',
                      subtitle: ApiSecrets.hasBuiltInChatApi
                          ? '已配置内置 API，可直接使用'
                          : '内置 API 未配置，请使用自定义 API',
                      value: _useBuiltInApi && ApiSecrets.hasBuiltInChatApi,
                      enabled: ApiSecrets.hasBuiltInChatApi,
                      onChanged: _setUseBuiltInApi,
                    ),
                  ],
                ),
                
                // 对话模型选择
                if (_useBuiltInApi && ApiSecrets.hasBuiltInChatApi) ...[
                  _buildSection(
                    title: '对话模型',
                    children: AiModels.builtInChatModels.map((model) {
                      return _buildModelTile(
                        title: model.name,
                        subtitle: model.description,
                        selected: _selectedChatModel?.id == model.id,
                        onTap: () => _selectChatModel(model),
                      );
                    }).toList(),
                  ),
                ],
                
                // 图像生成模型选择
                if (ApiSecrets.hasBuiltInImageApi) ...[
                  _buildSection(
                    title: '图像生成模型',
                    children: AiModels.builtInImageModels.map((model) {
                      return _buildModelTile(
                        title: model.name,
                        subtitle: model.description,
                        selected: _selectedImageModel?.id == model.id,
                        onTap: () => _selectImageModel(model),
                      );
                    }).toList(),
                  ),
                ],
                
                // 提示信息
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    _useBuiltInApi && ApiSecrets.hasBuiltInChatApi
                        ? '正在使用内置 API，无需额外配置即可使用 AI 功能。'
                        : '请在"AI 配置"中填写自定义 API 信息。',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Container(
          color: Colors.white,
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required bool enabled,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: AppColors.textSecondary,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: enabled ? onChanged : null,
        activeTrackColor: AppColors.primary,
      ),
    );
  }

  Widget _buildModelTile({
    required String title,
    required String subtitle,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
          color: selected ? AppColors.primary : AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: AppColors.textSecondary,
        ),
      ),
      trailing: selected
          ? Icon(Icons.check_circle, color: AppColors.primary)
          : Icon(Icons.circle_outlined, color: AppColors.divider),
      onTap: onTap,
    );
  }
}

