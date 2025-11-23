import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zichat/storage/ai_config_storage.dart';

class AiConfigPage extends StatefulWidget {
  const AiConfigPage({super.key});

  @override
  State<AiConfigPage> createState() => _AiConfigPageState();
}

class _AiConfigPageState extends State<AiConfigPage> {
  String _provider = 'openai'; // 'openai' | 'gemini'
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _apiKeyController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _personaController = TextEditingController();

  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    final config = await AiConfigStorage.loadGlobalConfig();
    if (!mounted) return;
    if (config != null) {
      _provider = config.provider;
      _urlController.text = config.apiBaseUrl;
      _apiKeyController.text = config.apiKey;
      _modelController.text = config.model;
      _personaController.text = config.persona;
    }
    setState(() {
      _loading = false;
    });
  }

  Future<void> _saveConfig() async {
    setState(() {
      _saving = true;
    });
    final config = AiGlobalConfig(
      provider: _provider,
      apiBaseUrl: _urlController.text.trim(),
      apiKey: _apiKeyController.text.trim(),
      model: _modelController.text.trim(),
      persona: _personaController.text.trim(),
    );
    await AiConfigStorage.saveGlobalConfig(config);
    if (!mounted) return;
    setState(() {
      _saving = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('AI 配置已保存')),
    );
  }

  @override
  void dispose() {
    _urlController.dispose();
    _apiKeyController.dispose();
    _modelController.dispose();
    _personaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color bg = Color(0xFFEFEFF4);
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        top: true,
        bottom: true,
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 480),
            color: bg,
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: _loading
                      ? const Center(child: CircularProgressIndicator())
                      : _buildBody(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 52,
      color: const Color(0xFFEFEFF4),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            padding: const EdgeInsets.all(8),
            icon: SvgPicture.asset(
              'assets/icon/common/go-back.svg',
              width: 12,
              height: 20,
            ),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'AI 配置',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1D2129),
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: _saving ? null : _saveConfig,
            child: _saving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text(
                    '保存',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF07C160),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 16),
      children: [
        _buildHintCard(),
        const SizedBox(height: 12),
        _buildProviderCard(),
        const SizedBox(height: 12),
        _buildTextFieldCard(
          label: 'API 地址',
          hint: '例如 https://api.openai.com/v1 或 代理地址',
          controller: _urlController,
        ),
        const SizedBox(height: 12),
        _buildTextFieldCard(
          label: 'API Key',
          hint: 'sk- 开头的密钥，仅保存在本机',
          controller: _apiKeyController,
          obscureText: true,
        ),
        const SizedBox(height: 12),
        _buildTextFieldCard(
          label: '模型名称',
          hint: '例如 gpt-4o, gpt-4.1, gemini-1.5-pro',
          controller: _modelController,
        ),
        const SizedBox(height: 12),
        _buildPersonaCard(),
      ],
    );
  }

  Widget _buildHintCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Text(
        '在这里配置 OpenAI / Gemini 兼容的 API 地址、Key 和模型。\n这些配置只保存在本机，不会上传到服务器。',
        style: const TextStyle(
          fontSize: 13,
          color: Color(0xFF86909C),
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildProviderCard() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          _buildProviderTile('OpenAI / 兼容接口', 'openai'),
          const Divider(height: 0, indent: 16, color: Color(0xFFE5E6EB)),
          _buildProviderTile('Gemini / Google AI', 'gemini'),
        ],
      ),
    );
  }

  Widget _buildProviderTile(String label, String value) {
    final bool selected = _provider == value;
    return InkWell(
      onTap: () {
        setState(() {
          _provider = value;
        });
      },
      child: SizedBox(
        height: 52,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF1D2129),
                ),
              ),
              Icon(
                selected ? Icons.radio_button_checked : Icons.radio_button_off,
                color: selected
                    ? const Color(0xFF07C160)
                    : const Color(0xFF86909C),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFieldCard({
    required String label,
    required String hint,
    required TextEditingController controller,
    bool obscureText = false,
  }) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF4E5969),
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                fontSize: 14,
                color: Color(0xFFB8C0CC),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: Color(0xFFE5E6EB), width: 0.8),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: Color(0xFFE5E6EB), width: 0.8),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: Color(0xFF07C160), width: 1),
              ),
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonaCard() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '自定义人设 / 性格',
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFF4E5969),
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 120,
            child: TextField(
              controller: _personaController,
              maxLines: null,
              expands: true,
              decoration: InputDecoration(
                hintText: '例如：
- 你是一个熟悉产品和代码的朋友
- 说话口语化、直接一点、别太官方',
                hintStyle: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFFB8C0CC),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide:
                      const BorderSide(color: Color(0xFFE5E6EB), width: 0.8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide:
                      const BorderSide(color: Color(0xFFE5E6EB), width: 0.8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide:
                      const BorderSide(color: Color(0xFF07C160), width: 1),
                ),
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              ),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            '这里是叠加在内置系统提示词上的人设描述，可随时修改。',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFFB8C0CC),
            ),
          ),
        ],
      ),
    );
  }
}
