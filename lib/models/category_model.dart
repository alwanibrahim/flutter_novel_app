class Category {
  final int id;
  final String name;
  final String description;
  final String icon;

  Category({
    required this.id,
    required this.name,
    this.description = '',
    this.icon = '',
  });

  // Dummy data
  static List<Category> categories = [
    Category(
      id: 1,
      name: 'Romance',
      description: 'Novel dengan tema percintaan dan hubungan romantis',
      icon: '❤️',
    ),
    Category(
      id: 2,
      name: 'Fantasy',
      description: 'Novel dengan dunia fantasi dan elemen magis',
      icon: '🧙‍♂️',
    ),
    Category(
      id: 3,
      name: 'Mystery',
      description: 'Novel dengan unsur misteri dan teka-teki',
      icon: '🔍',
    ),
    Category(
      id: 4,
      name: 'Horror',
      description: 'Novel dengan tema menakutkan dan menegangkan',
      icon: '👻',
    ),
    Category(
      id: 5,
      name: 'Sci-Fi',
      description: 'Novel dengan tema fiksi ilmiah dan teknologi futuristik',
      icon: '🚀',
    ),
  ];
}
