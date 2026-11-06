import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

final _fallbackRecognitionLanguages = [
  LocaleName('en_US', 'English (United States)'),
  LocaleName('en_GB', 'English (United Kingdom)'),
  LocaleName('es_ES', 'Spanish (Spain)'),
  LocaleName('fr_FR', 'French (France)'),
  LocaleName('de_DE', 'German (Germany)'),
  LocaleName('ar_SA', 'Arabic (Saudi Arabia)'),
  LocaleName('zh_CN', 'Chinese (China)'),
  LocaleName('en_IN', 'English (India)'),
  LocaleName('hi_IN', 'Hindi (India)'),
  LocaleName('as_IN', 'Assamese (India)'),
  LocaleName('bn_IN', 'Bengali (India)'),
  LocaleName('brx_IN', 'Bodo (India)'),
  LocaleName('gu_IN', 'Gujarati (India)'),
  LocaleName('kn_IN', 'Kannada (India)'),
  LocaleName('ks_IN', 'Kashmiri (India)'),
  LocaleName('kok_IN', 'Konkani (India)'),
  LocaleName('ml_IN', 'Malayalam (India)'),
  LocaleName('mni_IN', 'Manipuri (India)'),
  LocaleName('mr_IN', 'Marathi (India)'),
  LocaleName('ne_IN', 'Nepali (India)'),
  LocaleName('or_IN', 'Odia (India)'),
  LocaleName('pa_IN', 'Punjabi (India)'),
  LocaleName('sa_IN', 'Sanskrit (India)'),
  LocaleName('sat_IN', 'Santali (India)'),
  LocaleName('sd_IN', 'Sindhi (India)'),
  LocaleName('ta_IN', 'Tamil (India)'),
  LocaleName('te_IN', 'Telugu (India)'),
  LocaleName('ur_IN', 'Urdu (India)'),
];

class SpeechToTextPage extends StatefulWidget {
  const SpeechToTextPage({super.key});

  @override
  State<SpeechToTextPage> createState() => _SpeechToTextPageState();
}

class _SpeechToTextPageState extends State<SpeechToTextPage> {
  final SpeechToText _speech = SpeechToText();
  List<LocaleName> _languages = _fallbackRecognitionLanguages;
  String? _selectedLocale = 'en_US';
  String _text = '';
  String _committedText = '';
  String _interimText = '';
  bool _shouldKeepListening = false;
  bool _isRestarting = false;
  bool _isListening = false;
  bool _isInitialized = false;
  String? _status;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeSpeech();
  }

  Future<void> _initializeSpeech() async {
    if (_isInitialized) return;

    _isInitialized = await _speech.initialize(
      onStatus: (status) {
        debugPrint('Speech recognition status: $status');
        if (!mounted) return;
        setState(() => _isListening = status == 'listening');
        if (_shouldKeepListening &&
            (status == 'notListening' || status == 'done')) {
          _restartListening();
        }
      },
      onError: (error) {
        debugPrint(
          'Speech recognition error: ${error.errorMsg} (${error.permanent ? 'permanent' : 'temporary'})',
        );
        if (!mounted) return;
        setState(() {
          _isListening = false;
          _status = 'Microphone error: ${error.errorMsg}';
        });
      },
      debugLogging: true,
    );

    debugPrint('Speech available: $_isInitialized');

    if (!_isInitialized) {
      if (mounted) {
        setState(
          () => _status = 'Speech unavailable. Check the Android microphone permission, emulator microphone mapping, and Google Speech Services.',
        );
      }
      return;
    }

    try {
      final deviceLanguages = await _speech.locales();
      final systemLocale = await _speech.systemLocale();
      if (!mounted) return;
      setState(() {
        if (deviceLanguages.isNotEmpty) {
          final ids = deviceLanguages.map((locale) => locale.localeId).toSet();
          for (final fallback in _fallbackRecognitionLanguages) {
            if (!ids.contains(fallback.localeId)) deviceLanguages.add(fallback);
          }
        }
        _languages = deviceLanguages.isEmpty
            ? List.of(_fallbackRecognitionLanguages)
            : deviceLanguages;
        final preferred = systemLocale?.localeId;
        if (_languages.any((locale) => locale.localeId == preferred)) {
          _selectedLocale = preferred;
        } else if (!_languages.any(
          (locale) => locale.localeId == _selectedLocale,
        )) {
          _selectedLocale = _languages.first.localeId;
        }
      });
    } catch (error) {
      debugPrint('Could not load speech languages: $error');
      if (mounted) {
        setState(() => _status = 'Using the built-in language list.');
      }
    }
  }

  Future<void> _toggleListening() async {
    if (_isListening) {
      _shouldKeepListening = false;
      await _speech.stop();
      return;
    }

    if (!_isInitialized) await _initializeSpeech();
    if (!_isInitialized) return;

    setState(() {
      _text = '';
      _committedText = '';
      _interimText = '';
      _status = null;
      _shouldKeepListening = true;
    });

    await _startListening();
  }

  Future<void> _startListening() async {
    if (!_shouldKeepListening || _speech.isListening) return;

    await _speech.listen(
      listenOptions: SpeechListenOptions(
        localeId: _selectedLocale,
        cancelOnError: false,
        partialResults: true,
        listenFor: const Duration(minutes: 30),
        pauseFor: const Duration(seconds: 30),
      ),
      onResult: (result) {
        if (!mounted) return;
        final words = result.recognizedWords.trim();
        setState(() {
          if (result.finalResult) {
            if (words.isNotEmpty) {
              _committedText = _appendRecognizedText(_committedText, words);
            }
            _interimText = '';
          } else {
            _interimText = words;
          }

          _text = _appendRecognizedText(_committedText, _interimText);
          _textController.text = _text;
          _textController.selection = TextSelection.collapsed(
            offset: _textController.text.length,
          );
        });
      },
    );
  }

  Future<void> _restartListening() async {
    if (_isRestarting || !_shouldKeepListening || !mounted) return;
    _isRestarting = true;
    try {
      await Future<void>.delayed(const Duration(milliseconds: 300));
      if (_shouldKeepListening && mounted) {
        await _startListening();
      }
    } finally {
      _isRestarting = false;
    }
  }

  String _appendRecognizedText(String existing, String addition) {
    if (existing.isEmpty) return addition;
    if (addition.isEmpty) return existing;
    return '$existing $addition';
  }

  @override
  void dispose() {
    _shouldKeepListening = false;
    _speech.stop();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text(
              'Speech to Text',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _isListening
                  ? 'Listening… tap again to stop'
                  : 'Tap the microphone to start',
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _selectedLocale,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Recognition language',
                border: OutlineInputBorder(),
              ),
              items: _languages
                  .map(
                    (locale) => DropdownMenuItem(
                      value: locale.localeId,
                      child: Text(locale.name),
                    ),
                  )
                  .toList(),
              onChanged: _isListening
                  ? null
                  : (value) => setState(() => _selectedLocale = value),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  controller: _textController,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  keyboardType: TextInputType.multiline,
                  onChanged: (value) => _text = value,
                  decoration: InputDecoration.collapsed(
                    hintText: 'Your speech will appear here, or paste text in any language.',
                  ),
                  style: const TextStyle(fontSize: 20),
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
            FloatingActionButton.large(
              onPressed: _toggleListening,
              backgroundColor: _isListening
                  ? colorScheme.error
                  : colorScheme.primary,
              foregroundColor: _isListening
                  ? colorScheme.onError
                  : colorScheme.onPrimary,
              tooltip: _isListening ? 'Stop listening' : 'Start listening',
              child: Icon(_isListening ? Icons.stop : Icons.mic, size: 34),
            ),
          ],
        ),
      ),
    );
  }
}
