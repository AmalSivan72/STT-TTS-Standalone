import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'speech_to_text_page.dart';
import 'text_to_speech_page.dart';

void main() => runApp(const VoiceApp());

class VoiceApp extends StatelessWidget {
  const VoiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voice Tools',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const VoiceHomePage(),
    );
  }
}

class VoiceHomePage extends StatefulWidget {
  const VoiceHomePage({super.key});

  @override
  State<VoiceHomePage> createState() => _VoiceHomePageState();
}

class _VoiceHomePageState extends State<VoiceHomePage> {
  int _selectedIndex = 0;

  // Keep each page's state alive so language loading and user choices do not
  // restart whenever the user switches tabs.
  final List<Widget> _pages = const [
    SpeechToTextPage(key: PageStorageKey('speechToText')),
    _LegacyTextToSpeechPage(key: PageStorageKey('textToSpeech')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Voice Tools')),
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.mic_none),
            selectedIcon: Icon(Icons.mic),
            label: 'Speech to text',
          ),
          NavigationDestination(
            icon: Icon(Icons.record_voice_over_outlined),
            selectedIcon: Icon(Icons.record_voice_over),
            label: 'Text to speech',
          ),
        ],
      ),
    );
  }
}

class _LegacyTextToSpeechPage extends StatefulWidget {
  const _LegacyTextToSpeechPage({super.key});

  @override
  State<_LegacyTextToSpeechPage> createState() =>
      _LegacyTextToSpeechPageState();
}

class _LegacyTextToSpeechPageState extends State<_LegacyTextToSpeechPage> {
  final FlutterTts _tts = FlutterTts();
  final TextEditingController _controller = TextEditingController();
  List<String> _languages = [];
  String? _selectedLanguage;
  bool _isSpeaking = false;
  String? _status;

  @override
  void initState() {
    super.initState();
    _initializeTts();
    _tts.setSpeechRate(0.5);
    _tts.setVolume(1.0);
    _tts.setPitch(1.0);
    _tts.setStartHandler(() {
      if (mounted) setState(() => _isSpeaking = true);
    });
    _tts.setCompletionHandler(() {
      if (mounted) setState(() => _isSpeaking = false);
    });
    _tts.setCancelHandler(() {
      if (mounted) setState(() => _isSpeaking = false);
    });
    _tts.setErrorHandler((_) {
      if (!mounted) return;
      setState(() {
        _isSpeaking = false;
        _status = 'Unable to play this text.';
      });
    });
  }

  Future<void> _initializeTts() async {
    final languages = await _tts.getLanguages;
    final available = languages.whereType<String>().toSet().toList();
    available.sort();
    if (!mounted) return;
    setState(() {
      _languages = available;
      _selectedLanguage = available.contains('en-US')
          ? 'en-US'
          : available.firstOrNull;
    });
    if (_selectedLanguage != null) await _tts.setLanguage(_selectedLanguage!);
  }

  Future<void> _toggleSpeaking() async {
    if (_isSpeaking) {
      await _tts.stop();
      if (mounted) setState(() => _isSpeaking = false);
      return;
    }

    final text = _controller.text.trim();
    if (text.isEmpty) {
      setState(() => _status = 'Enter some text first.');
      return;
    }

    if (_selectedLanguage != null) await _tts.setLanguage(_selectedLanguage!);
    setState(() => _status = null);
    await _tts.speak(text);
  }

  @override
  void dispose() {
    _tts.stop();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Text to Speech',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _isSpeaking
                  ? 'Speaking… tap again to stop'
                  : 'Type something, then tap the speaker',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _selectedLanguage,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Speech language',
                border: OutlineInputBorder(),
              ),
              hint: Text(
                _languages.isEmpty ? 'Loading languages…' : 'Select a language',
              ),
              items: _languages
                  .map(
                    (language) => DropdownMenuItem(
                      value: language,
                      child: Text(language),
                    ),
                  )
                  .toList(),
              onChanged: _isSpeaking
                  ? null
                  : (value) => setState(() => _selectedLanguage = value),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: _controller,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  hintText: 'Enter text to speak…',
                  filled: true,
                  fillColor: colorScheme.surfaceContainerHighest,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(20),
                ),
              ),
            ),
            if (_status != null) ...[
              const SizedBox(height: 12),
              Text(
                _status!,
                textAlign: TextAlign.center,
                style: TextStyle(color: colorScheme.error),
              ),
            ],
            const SizedBox(height: 20),
            Center(
              child: FloatingActionButton.large(
                onPressed: _toggleSpeaking,
                backgroundColor: _isSpeaking
                    ? colorScheme.error
                    : colorScheme.primary,
                foregroundColor: _isSpeaking
                    ? colorScheme.onError
                    : colorScheme.onPrimary,
                tooltip: _isSpeaking ? 'Stop speaking' : 'Speak text',
                child: Icon(
                  _isSpeaking ? Icons.stop : Icons.volume_up,
                  size: 34,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
