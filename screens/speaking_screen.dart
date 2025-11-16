import 'package:flutter/material.dart';
import '../services/ai_service.dart';
import '../services/audio_service.dart';

class SpeakingScreen extends StatefulWidget {
  const SpeakingScreen({Key? key}) : super(key: key);

  @override
  State<SpeakingScreen> createState() => _SpeakingScreenState();
}

class _SpeakingScreenState extends State<SpeakingScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final AudioService _audioService = AudioService();
  bool _isRecording = false;
  bool _isLoading = false;
  
  // This would be initialized with your actual API key and endpoint
  final AiService _aiService = AiService(
    apiKey: 'your-api-key',
    apiEndpoint: 'https://api.openai.com/v1/chat/completions',
  );

  @override
  void initState() {
    super.initState();
    _initializeServices();
    _addBotMessage('Salaam! I\'m your Somali language assistant. How can I help you practice today?');
  }

  Future<void> _initializeServices() async {
    await _audioService.initialize();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _audioService.dispose();
    super.dispose();
  }

  void _addMessage(String text, bool isUser) {
    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: isUser,
        timestamp: DateTime.now(),
      ));
    });
  }

  void _addBotMessage(String text) {
    _addMessage(text, false);
  }

  void _addUserMessage(String text) {
    _addMessage(text, true);
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _addUserMessage(text);
    _messageController.clear();

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _aiService.generateResponse(text);
      _addBotMessage(response);
    } catch (e) {
      _addBotMessage('Sorry, I encountered an error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleRecording() async {
    if (_isRecording) {
      setState(() {
        _isRecording = false;
      });
      
      final recordingPath = await _audioService.stopRecording();
      if (recordingPath != null) {
        setState(() {
          _isLoading = true;
        });
        
        try {
          final audioBase64 = await _audioService.getAudioAsBase64();
          if (audioBase64 != null) {
            final feedback = await _aiService.evaluatePronunciation(audioBase64);
            _addBotMessage(feedback);
          }
        } catch (e) {
          _addBotMessage('Sorry, I couldn\'t evaluate your pronunciation: $e');
        } finally {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } else {
      await _audioService.startRecording();
      setState(() {
        _isRecording = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speaking Practice'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Speaking Practice'),
                  content: const Text(
                    'Practice speaking Somali with our AI assistant. You can type messages or record your voice for pronunciation feedback.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              reverse: false,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ChatBubble(message: message);
              },
            ),
          ),
          if (_isLoading)
            const LinearProgressIndicator(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  offset: const Offset(0, -1),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(_isRecording ? Icons.stop : Icons.mic),
                  color: _isRecording ? Colors.red : null,
                  onPressed: _toggleRecording,
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: InputBorder.none,
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: message.isUser
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: TextStyle(
                color: message.isUser
                    ? Colors.white
                    : Theme.of(context).textTheme.bodyLarge?.color,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}',
              style: TextStyle(
                color: message.isUser
                    ? Colors.white70
                    : Theme.of(context).textTheme.bodySmall?.color,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
