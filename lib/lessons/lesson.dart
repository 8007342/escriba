/// Placeholder lesson model. Real lessons (stroke order, reference glyphs,
/// scoring) arrive later; for now this only feeds the placeholder pages.
class Alphabet {
  const Alphabet({
    required this.name,
    required this.language,
    required this.sample,
  });

  final String name;
  final String language;

  /// A few characters to show as a preview.
  final String sample;
}

const sampleAlphabets = <Alphabet>[
  Alphabet(name: 'Latin', language: 'Español', sample: 'A a  B b  Ñ ñ'),
  Alphabet(name: 'Greek', language: 'Ελληνικά', sample: 'Α α  Β β  Γ γ'),
  Alphabet(name: 'Cyrillic', language: 'Русский', sample: 'А а  Б б  Ж ж'),
  Alphabet(name: 'Hiragana', language: '日本語', sample: 'あ い う え お'),
  Alphabet(name: 'Hangul', language: '한국어', sample: 'ㄱ ㄴ ㄷ ㅏ ㅓ'),
];
