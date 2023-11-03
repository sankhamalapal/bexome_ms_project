class Languages {
  final int id;
  final String name;
  final String flag;
  final String languageCode;

  Languages(this.id, this.name, this.flag, this.languageCode);

  static List<Languages> languageList() {
    return <Languages>[
      Languages(1, 'Deutsch', '🇩🇪', 'de'),
      Languages(2, 'English', '🇺🇸', 'en')
    ];
  }
}
