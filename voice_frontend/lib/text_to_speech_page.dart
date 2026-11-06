import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

const _fallbackTtsLanguages = <String>[
  // Common international languages
  'en-US',
  'en-GB',
  'es-ES',
  'fr-FR',
  'de-DE',
  'ar-SA',
  'zh-CN',

  // Indian languages and regional English
  'en-IN',
  'hi-IN', // Hindi
  'as-IN', // Assamese
  'bn-IN', // Bengali
  'brx-IN', // Bodo
  'gu-IN', // Gujarati
  'kn-IN', // Kannada
  'ks-IN', // Kashmiri
  'kok-IN', // Konkani
  'ml-IN', // Malayalam
  'mni-IN', // Manipuri
  'mr-IN', // Marathi
  'ne-IN', // Nepali
  'or-IN', // Odia
  'pa-IN', // Punjabi
  'sa-IN', // Sanskrit
  'sat-IN', // Santali
  'sd-IN', // Sindhi
  'ta-IN', // Tamil
  'te-IN', // Telugu
  'ur-IN', // Urdu
];

const _languageNames = <String, String>{
  'en-US': 'English (United States)',
  'en-GB': 'English (United Kingdom)',
  'en-IN': 'English (India)',
  'hi-IN': 'Hindi (India)',
  'as-IN': 'Assamese (India)',
  'bn-IN': 'Bengali (India)',
  'brx-IN': 'Bodo (India)',
  'gu-IN': 'Gujarati (India)',
  'kn-IN': 'Kannada (India)',
  'ks-IN': 'Kashmiri (India)',
  'kok-IN': 'Konkani (India)',
  'ml-IN': 'Malayalam (India)',
  'mni-IN': 'Manipuri (India)',
  'mr-IN': 'Marathi (India)',
  'ne-IN': 'Nepali (India)',
  'or-IN': 'Odia (India)',
  'pa-IN': 'Punjabi (India)',
  'sa-IN': 'Sanskrit (India)',
  'sat-IN': 'Santali (India)',
  'sd-IN': 'Sindhi (India)',
  'ta-IN': 'Tamil (India)',
  'te-IN': 'Telugu (India)',
  'ur-IN': 'Urdu (India)',
  'es-ES': 'Spanish (Spain)',
  'fr-FR': 'French (France)',
  'de-DE': 'German (Germany)',
  'ar-SA': 'Arabic (Saudi Arabia)',
  'zh-CN': 'Chinese (China)',
};

const _languageLabels = <String, String>{
  'af': 'Afrikaans',
  'am': 'Amharic',
  'ar': 'Arabic',
  'as': 'Assamese',
  'az': 'Azerbaijani',
  'be': 'Belarusian',
  'bg': 'Bulgarian',
  'bn': 'Bengali',
  'br': 'Breton',
  'brx': 'Bodo',
  'bs': 'Bosnian',
  'ca': 'Catalan',
  'ceb': 'Cebuano',
  'cs': 'Czech',
  'cy': 'Welsh',
  'da': 'Danish',
  'de': 'German',
  'el': 'Greek',
  'en': 'English',
  'eo': 'Esperanto',
  'es': 'Spanish',
  'et': 'Estonian',
  'eu': 'Basque',
  'fa': 'Persian',
  'fi': 'Finnish',
  'fil': 'Filipino',
  'fr': 'French',
  'ga': 'Irish',
  'gl': 'Galician',
  'gu': 'Gujarati',
  'ha': 'Hausa',
  'he': 'Hebrew',
  'hi': 'Hindi',
  'hr': 'Croatian',
  'hu': 'Hungarian',
  'hy': 'Armenian',
  'id': 'Indonesian',
  'is': 'Icelandic',
  'it': 'Italian',
  'ja': 'Japanese',
  'jv': 'Javanese',
  'ka': 'Georgian',
  'kk': 'Kazakh',
  'km': 'Khmer',
  'kn': 'Kannada',
  'ko': 'Korean',
  'kok': 'Konkani',
  'ks': 'Kashmiri',
  'ku': 'Kurdish',
  'ky': 'Kyrgyz',
  'lo': 'Lao',
  'lt': 'Lithuanian',
  'lv': 'Latvian',
  'mk': 'Macedonian',
  'ml': 'Malayalam',
  'mn': 'Mongolian',
  'mni': 'Manipuri',
  'mr': 'Marathi',
  'ms': 'Malay',
  'mt': 'Maltese',
  'my': 'Burmese',
  'nb': 'Norwegian Bokmål',
  'ne': 'Nepali',
  'nl': 'Dutch',
  'nn': 'Norwegian Nynorsk',
  'or': 'Odia',
  'pa': 'Punjabi',
  'pl': 'Polish',
  'ps': 'Pashto',
  'pt': 'Portuguese',
  'ro': 'Romanian',
  'ru': 'Russian',
  'sa': 'Sanskrit',
  'sat': 'Santali',
  'sd': 'Sindhi',
  'si': 'Sinhala',
  'sk': 'Slovak',
  'sl': 'Slovenian',
  'so': 'Somali',
  'sq': 'Albanian',
  'sr': 'Serbian',
  'su': 'Sundanese',
  'sv': 'Swedish',
  'sw': 'Swahili',
  'ta': 'Tamil',
  'te': 'Telugu',
  'th': 'Thai',
  'tr': 'Turkish',
  'uk': 'Ukrainian',
  'ur': 'Urdu',
  'uz': 'Uzbek',
  'vi': 'Vietnamese',
  'xh': 'Xhosa',
  'yi': 'Yiddish',
  'yo': 'Yoruba',
  'yue': 'Cantonese',
  'zh': 'Chinese',
  'zu': 'Zulu',
};

const _countryLabels = <String, String>{
  'AE': 'United Arab Emirates',
  'AR': 'Argentina',
  'AT': 'Austria',
  'AU': 'Australia',
  'BA': 'Bosnia and Herzegovina',
  'BD': 'Bangladesh',
  'BE': 'Belgium',
  'BG': 'Bulgaria',
  'BR': 'Brazil',
  'CA': 'Canada',
  'CH': 'Switzerland',
  'CL': 'Chile',
  'CN': 'China',
  'CO': 'Colombia',
  'CZ': 'Czechia',
  'DE': 'Germany',
  'DK': 'Denmark',
  'EE': 'Estonia',
  'EG': 'Egypt',
  'ES': 'Spain',
  'FI': 'Finland',
  'FR': 'France',
  'GB': 'United Kingdom',
  'GR': 'Greece',
  'HK': 'Hong Kong',
  'HR': 'Croatia',
  'HU': 'Hungary',
  'ID': 'Indonesia',
  'IE': 'Ireland',
  'IL': 'Israel',
  'IN': 'India',
  'IQ': 'Iraq',
  'IR': 'Iran',
  'IS': 'Iceland',
  'IT': 'Italy',
  'JP': 'Japan',
  'KE': 'Kenya',
  'KR': 'South Korea',
  'KW': 'Kuwait',
  'LK': 'Sri Lanka',
  'LT': 'Lithuania',
  'LV': 'Latvia',
  'MX': 'Mexico',
  'MY': 'Malaysia',
  'NG': 'Nigeria',
  'NL': 'Netherlands',
  'NO': 'Norway',
  'NZ': 'New Zealand',
  'PK': 'Pakistan',
  'PH': 'Philippines',
  'PL': 'Poland',
  'PT': 'Portugal',
  'RO': 'Romania',
  'RS': 'Serbia',
  'RU': 'Russia',
  'SA': 'Saudi Arabia',
  'SE': 'Sweden',
  'SG': 'Singapore',
  'SI': 'Slovenia',
  'SK': 'Slovakia',
  'TH': 'Thailand',
  'TR': 'Türkiye',
  'TW': 'Taiwan',
  'UA': 'Ukraine',
  'US': 'United States',
  'VN': 'Vietnam',
  'ZA': 'South Africa',
};

String _readableLanguageName(String locale) {
  final normalized = locale.replaceAll('_', '-');
  final exactName = _languageNames[locale] ?? _languageNames[normalized];
  if (exactName != null) return exactName;

  final parts = normalized.split('-').where((part) => part.isNotEmpty).toList();
  if (parts.isEmpty) return locale;

  final languageCode = parts.first.toLowerCase();
  final language = _languageLabels[languageCode];
  if (language == null) return locale;

  final region = parts.length > 1
      ? parts
            .skip(1)
            .firstWhere(
              (part) => _countryLabels.containsKey(part.toUpperCase()),
              orElse: () => '',
            )
      : '';
  final country = region.isEmpty ? null : _countryLabels[region.toUpperCase()];
  return country == null ? language : '$language ($country)';
}

class TextToSpeechPage extends StatefulWidget {
  const TextToSpeechPage({super.key});

  @override
  State<TextToSpeechPage> createState() => _TextToSpeechPageState();
}

class _TextToSpeechPageState extends State<TextToSpeechPage> {
  final FlutterTts _tts = FlutterTts();
  final TextEditingController _controller = TextEditingController();
  List<String> _languages = List.of(_fallbackTtsLanguages);
  String? _selectedLanguage = 'en-US';
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
        _status = 'Unable to play this text. Check the installed text-to-speech engine and language voice.';
      });
    });
  }

  Future<void> _initializeTts() async {
    try {
      await _tts.setSpeechRate(0.5);
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.0);
      final languages = await _tts.getLanguages;
      final available = languages.whereType<String>().toSet().toList();
      final merged = <String>{...available, ..._fallbackTtsLanguages}.toList()
        ..sort();
      if (!mounted) return;
      setState(() {
        _languages = merged;
        if (!merged.contains(_selectedLanguage)) {
          _selectedLanguage = merged.contains('en-US') ? 'en-US' : merged.first;
        }
      });
      await _tts.setLanguage(_selectedLanguage!);
      await _tts.setSpeechRate(0.5);
    } catch (error) {
      debugPrint('Could not load TTS languages: $error');
      if (mounted) {
        setState(() => _status = 'Using the built-in language list.');
      }
    }
  }

  Future<void> _toggleSpeaking() async {
    if (_isSpeaking) {
      await _tts.stop();
      return;
    }

    final text = _controller.text.trim();
    if (text.isEmpty) {
      setState(() => _status = 'Enter some text first.');
      return;
    }

    if (_selectedLanguage != null) await _tts.setLanguage(_selectedLanguage!);
    await _tts.setSpeechRate(0.5);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
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
              items: _languages
                  .map(
                    (language) => DropdownMenuItem(
                      value: language,
                      child: Text(_readableLanguageName(language)),
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
