import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';

class OpenAIService {
  static Future<OpenAI> initialize() async {
    final OpenAI _openAI = await OpenAI.instance.build(
      token: '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',
      baseOption: HttpSetup(
        receiveTimeout: const Duration(seconds: 20),
        connectTimeout: const Duration(seconds: 20),
      ),
      enableLog: true,
    );
    return _openAI;
  }
}
