import 'package:crisp_chat/crisp_chat.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
   Chat({Key? key}) : super(key: key);
  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final String websiteID = 'd9c34ae3-8b6f-43ab-a0bb-1f76636113eb';
  late final CrispConfig config;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    print('Initializing Chat...');

    config = CrispConfig(websiteID: websiteID);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _openChat();
    });
  }

  Future<void> _openChat() async {
    try {
      setState(() => isLoading = true);
      print('Opening Crisp Chat...');

      await FlutterCrispChat.openCrispChat(config: config);
      print('Crisp Chat opened successfully.');

      FlutterCrispChat.setSessionString(
        key: "a_string",
        value: "Crisp Chat",
      );
      print('Session string set: a_string = Crisp Chat');

      FlutterCrispChat.setSessionInt(
        key: "a_number",
        value: 12345,
      );
      print('Session int set: a_number = 12345');

      await Future.delayed(const Duration(seconds: 5));
      final sessionId = await FlutterCrispChat.getSessionIdentifier();

      if (sessionId != null) {
        debugPrint('معرف الجلسة: $sessionId');
        print('Session ID retrieved: $sessionId');
      } else {
        debugPrint('لم يتم العثور على جلسة نشطة!');
        print('No active session found.');
      }
    } catch (e) {
      debugPrint('خطأ في فتح الدردشة: $e');
      print('Error opening chat: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل في فتح الدردشة: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
        print('Loading state set to false.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الدعم الفني'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading) ...[
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              const Text('يرجى الانتظار...'),
            ] else
              const Text('الدردشة جاهزة'),
          ],
        ),
      ),
    );
  }
}
