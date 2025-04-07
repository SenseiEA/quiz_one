import 'dart:convert';
import 'package:http/http.dart' as http;
import 'pokemon.dart'; // Import your Pokemon model

class PokeApiService {
  final String baseUrl = 'https://pokeapi.co/api/v2/pokemon';

  // Fetch a list of Pokémon names, types, and images
  Future<List<Pokemon>> fetchPokemonList(int limit) async {
    final response = await http.get(Uri.parse('$baseUrl?limit=$limit'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> results = data['results'];

      // Get the names and details for each Pokémon
      List<Pokemon> pokemonList = [];
      for (var pokemon in results) {
        final detailsResponse = await http.get(Uri.parse(pokemon['url']));
        if (detailsResponse.statusCode == 200) {
          final detailsData = json.decode(detailsResponse.body);
          // Convert the JSON response into Pokemon objects
          pokemonList.add(Pokemon.fromJson(detailsData));
        }
      }
      return pokemonList;
    } else {
      throw Exception('Failed to load Pokémon');
    }
  }
}
