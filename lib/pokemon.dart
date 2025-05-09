class Pokemon {
  final String name;
  final String type;
  final String image;

  Pokemon({required this.name, required this.type, required this.image});

  // Method to convert JSON into a Pokemon object
  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      name: json['name'],
      type: json['types'][0]['type']['name'],
      image: json['sprites']['front_default'],
    );
  }
}
