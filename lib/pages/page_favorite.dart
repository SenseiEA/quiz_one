import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'drawer/drawer_header.dart';
import 'drawer/drawer_list_view.dart';
import 'favorites_service.dart';

class page_favorite extends StatefulWidget {
  const page_favorite({Key? key}) : super(key: key);

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<page_favorite> with SingleTickerProviderStateMixin {
  final FavoritesService _favoritesService = FavoritesService();
  List<Map<String, dynamic>> _favoritePokemon = [];
  List<Map<String, dynamic>> _filteredPokemon = [];
  bool _isLoading = true;
  bool _isRefreshing = false;
  String _searchQuery = "";
  String? _selectedType;
  String _sortOption = "name"; // Default sort by name
  bool _sortAscending = true;
  late AnimationController _controller;
  late Animation<Alignment> _topAlignmentAnimation;
  late Animation<Alignment> _bottomAlignmentAnimation;

  final TextEditingController _searchController = TextEditingController();

  final Map<String, Map<String, dynamic>> typeColors = {
    "normal": {"icon": Icons.circle, "color": Colors.grey, "background": Color(0xFFAAAAAA)},
    "fire": {"icon": Icons.local_fire_department, "color": Colors.red, "background": Color(0xFFFF6B43)},
    "water": {"icon": Icons.water_drop, "color": Colors.blue, "background": Color(0xFF3399FF)},
    "electric": {"icon": Icons.flash_on, "color": Colors.amber, "background": Color(0xFFFFD700)},
    "grass": {"icon": Icons.grass, "color": Colors.green, "background": Color(0xFF7AC74C)},
    "ice": {"icon": Icons.ac_unit, "color": Colors.cyanAccent, "background": Color(0xFF96D9D6)},
    "fighting": {"icon": Icons.sports_mma, "color": Colors.orange, "background": Color(0xFFC22E28)},
    "poison": {"icon": Icons.coronavirus, "color": Colors.purple, "background": Color(0xFFA33EA1)},
    "ground": {"icon": Icons.landscape, "color": Colors.brown, "background": Color(0xFFE2BF65)},
    "flying": {"icon": Icons.air, "color": Colors.indigo, "background": Color(0xFFA98FF3)},
    "psychic": {"icon": Icons.remove_red_eye, "color": Colors.deepPurple, "background": Color(0xFFF95587)},
    "bug": {"icon": Icons.bug_report, "color": Colors.lightGreen, "background": Color(0xFFA6B91A)},
    "rock": {"icon": Icons.terrain, "color": Colors.brown.shade300, "background": Color(0xFFB6A136)},
    "ghost": {"icon": Icons.nightlight_round, "color": Colors.deepPurpleAccent, "background": Color(0xFF735797)},
    "dragon": {"icon": Icons.whatshot, "color": Colors.indigoAccent, "background": Color(0xFF6F35FC)},
    "dark": {"icon": Icons.dark_mode, "color": Colors.black87, "background": Color(0xFF705746)},
    "steel": {"icon": Icons.build, "color": Colors.blueGrey, "background": Color(0xFFB7B7CE)},
    "fairy": {"icon": Icons.local_florist, "color": Colors.pinkAccent, "background": Color(0xFFD685AD)},
  };


  @override
  void initState() {
    super.initState();
    _fetchFavoritePokemon();

    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 4));
    _topAlignmentAnimation = TweenSequence<Alignment>(
      [
        TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(begin: Alignment.topLeft, end: Alignment.topRight),
          weight: 1,
        ),
        TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(begin: Alignment.topRight, end: Alignment.bottomRight),
          weight: 1,
        ),
        TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(begin: Alignment.bottomRight, end: Alignment.bottomLeft),
          weight: 1,
        ),
        TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(begin: Alignment.bottomLeft, end: Alignment.topLeft),
          weight: 1,
        ),
      ],
    ).animate(_controller);
    _bottomAlignmentAnimation = TweenSequence<Alignment>(
      [
        TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(begin: Alignment.bottomRight, end: Alignment.bottomLeft),
          weight: 1,
        ),
        TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(begin: Alignment.bottomLeft, end: Alignment.topLeft),
          weight: 1,
        ),
        TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(begin: Alignment.topLeft, end: Alignment.topRight),
          weight: 1,
        ),
        TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(begin: Alignment.topRight, end: Alignment.bottomRight),
          weight: 1,
        ),
      ],
    ).animate(_controller);

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _fetchFavoritePokemon() async {
    if (_isRefreshing) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final favoritePokemon = await _favoritesService.getFavoritePokemon();

      setState(() {
        _favoritePokemon = favoritePokemon;
        _applyFiltersAndSort();
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching favorite Pokemon: $e');
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load favorites: ${e.toString()}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _applyFiltersAndSort() {
    List<Map<String, dynamic>> result = List.from(_favoritePokemon);

    // Apply type filter
    if (_selectedType != null) {
      result = result.where((pokemon) =>
      pokemon['type'].toString().toLowerCase() == _selectedType!.toLowerCase()
      ).toList();
    }

    // Apply search query
    if (_searchQuery.isNotEmpty) {
      result = result.where((pokemon) =>
      pokemon['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
          pokemon['nickname'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
          pokemon['type'].toString().toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }
    // Apply sorting
    result.sort((a, b) {
      int compareResult;

      switch (_sortOption) {
        case "name":
          compareResult = a['name'].toString().toLowerCase().compareTo(b['name'].toString().toLowerCase());
          break;
        case "type":
          compareResult = a['type'].toString().toLowerCase().compareTo(b['type'].toString().toLowerCase());
          break;
        case "hp":
          compareResult = (a['hp'] as int).compareTo(b['hp'] as int);
          break;
        case "atk":
          compareResult = (a['atk'] as int).compareTo(b['atk'] as int);
          break;
        case "def":
          compareResult = (a['def'] as int).compareTo(b['def'] as int);
          break;
        default:
          compareResult = a['name'].toString().toLowerCase().compareTo(b['name'].toString().toLowerCase());
      }

      return _sortAscending ? compareResult : -compareResult;
    });

    setState(() {
      _filteredPokemon = result;
    });
  }

  Future<void> _refreshFavorites() async {
    setState(() {
      _isRefreshing = true;
    });

    try {
      await _fetchFavoritePokemon();
    } finally {
      setState(() {
        _isRefreshing = false;
      });
    }
  }

  Future<void> _removeFromFavorites(String pokemonId, String pokemonName) async {
    try {
      await _favoritesService.removeFromFavorites(pokemonId);

      setState(() {
        _favoritePokemon.removeWhere((pokemon) => pokemon['id'] == pokemonId);
        _applyFiltersAndSort();
      });

      if (mounted) {
        _favoritesService.showSuccessSnackBar(
            context,
            "$pokemonName removed from favorites"
        );
      }
    } catch (e) {
      print('Error removing from favorites: $e');

      if (mounted) {
        _favoritesService.showErrorSnackBar(
            context,
            "Failed to remove from favorites: ${e.toString()}"
        );
      }
    }
  }

  void _showPokemonDetails(Map<String, dynamic> pokemon) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: EdgeInsets.all(16),
            child: ListView(
              controller: scrollController,
              children: [
                // Handle indicator
                Center(
                  child: Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: EdgeInsets.only(bottom: 16),
                  ),
                ),

                // Pokemon image
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: _getTypeColor(pokemon['type'].toString().toLowerCase()),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: pokemon['image'],
                    fit: BoxFit.contain,
                    placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                  ),
                ),

                SizedBox(height: 16),

                // Pokemon nickname and name
                Text(
                  pokemon['nickname'],
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '#${pokemon['pokemonId']} ${pokemon['name']}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),

                // Type chip
                Container(
                  margin: EdgeInsets.symmetric(vertical: 12),
                  child: Wrap(
                    spacing: 8,
                    children: [
                      Chip(
                        backgroundColor: _getTypeColor(pokemon['type'].toString().toLowerCase()),
                        label: Text(
                          pokemon['type'].toString().toUpperCase(),
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),

                // Stats
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Stats', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      SizedBox(height: 8),

                      // HP Stat
                      Row(
                        children: [
                          SizedBox(
                            width: 80,
                            child: Text(
                              'HP',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Expanded(
                            child: LinearProgressIndicator(
                              value: (pokemon['hp'] as int) / 100,
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text('${pokemon['hp']}'),
                        ],
                      ),
                      SizedBox(height: 6),

                      // Attack Stat
                      Row(
                        children: [
                          SizedBox(
                            width: 80,
                            child: Text(
                              'Attack',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                          ),
                          Expanded(
                            child: LinearProgressIndicator(
                              value: (pokemon['atk'] as int) / 100,
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text('${pokemon['atk']}'),
                        ],
                      ),
                      SizedBox(height: 6),

                      // Defense Stat
                      Row(
                        children: [
                          SizedBox(
                            width: 80,
                            child: Text(
                              'Defense',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Expanded(
                            child: LinearProgressIndicator(
                              value: (pokemon['def'] as int) / 100,
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text('${pokemon['def']}'),
                        ],
                      ),
                    ],
                  ),
                ),

                // Description
                SizedBox(height: 16),
                Text('Description', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                SizedBox(height: 8),
                Text(
                  pokemon['description'],
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),

                // Remove from favorites button
                SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close sheet
                    _removeFromFavorites(pokemon['id'], pokemon['name']);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: Icon(Icons.favorite_border),
                  label: Text('Remove from Favorites', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showFilterSortBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle indicator
                  Center(
                    child: Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: EdgeInsets.only(bottom: 16),
                    ),
                  ),

                  Text(
                    "Filter & Sort",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 20),

                  // Type Filter
                  Text(
                    "Filter by Type",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 10),

                  Container(
                    height: 50,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: FilterChip(
                            label: Text("All Types"),
                            selected: _selectedType == null,
                            onSelected: (selected) {
                              if (selected) {
                                setModalState(() {
                                  _selectedType = null;
                                });
                              }
                            },
                            backgroundColor: Colors.grey[200],
                            selectedColor: Color(0xFFFFCC01),
                            checkmarkColor: Colors.black,
                          ),
                        ),
                        ...typeColors.entries.map((entry) {
                          String type = entry.key;
                          Map<String, dynamic> typeData = entry.value;

                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: FilterChip(
                              avatar: Icon(
                                typeData['icon'] as IconData,
                                color: _selectedType == type ? Colors.black : Colors.white,
                                size: 16,
                              ),
                              label: Text(
                                type.toUpperCase(),
                                style: TextStyle(
                                  color: _selectedType == type ? Colors.black : Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              selected: _selectedType == type,
                              onSelected: (selected) {
                                setModalState(() {
                                  _selectedType = selected ? type : null;
                                });
                              },
                              backgroundColor: typeData['background'] as Color,
                              selectedColor: Color(0xFFFFCC01),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                  // Sort Options
                  Text(
                    "Sort by",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 10),

                  Wrap(
                    spacing: 8,
                    children: [
                      ChoiceChip(
                        label: Text("Name"),
                        selected: _sortOption == "name",
                        onSelected: (selected) {
                          if (selected) {
                            setModalState(() {
                              _sortOption = "name";
                            });
                          }
                        },
                        backgroundColor: Colors.grey[200],
                        selectedColor: Color(0xFFFFCC01),
                      ),
                      ChoiceChip(
                        label: Text("Type"),
                        selected: _sortOption == "type",
                        onSelected: (selected) {
                          if (selected) {
                            setModalState(() {
                              _sortOption = "type";
                            });
                          }
                        },
                        backgroundColor: Colors.grey[200],
                        selectedColor: Color(0xFFFFCC01),
                      ),
                      ChoiceChip(
                        label: Text("HP"),
                        selected: _sortOption == "hp",
                        onSelected: (selected) {
                          if (selected) {
                            setModalState(() {
                              _sortOption = "hp";
                            });
                          }
                        },
                        backgroundColor: Colors.grey[200],
                        selectedColor: Color(0xFFFFCC01),
                      ),
                      ChoiceChip(
                        label: Text("Attack"),
                        selected: _sortOption == "atk",
                        onSelected: (selected) {
                          if (selected) {
                            setModalState(() {
                              _sortOption = "atk";
                            });
                          }
                        },
                        backgroundColor: Colors.grey[200],
                        selectedColor: Color(0xFFFFCC01),
                      ),
                      ChoiceChip(
                        label: Text("Defense"),
                        selected: _sortOption == "def",
                        onSelected: (selected) {
                          if (selected) {
                            setModalState(() {
                              _sortOption = "def";
                            });
                          }
                        },
                        backgroundColor: Colors.grey[200],
                        selectedColor: Color(0xFFFFCC01),
                      ),
                    ],
                  ),

                  SizedBox(height: 10),

                  // Sort Direction
                  Row(
                    children: [
                      Text("Sort Direction: "),
                      ChoiceChip(
                        label: Text("Ascending"),
                        selected: _sortAscending,
                        onSelected: (selected) {
                          if (selected) {
                            setModalState(() {
                              _sortAscending = true;
                            });
                          }
                        },
                        backgroundColor: Colors.grey[200],
                        selectedColor: Color(0xFFFFCC01),
                      ),
                      SizedBox(width: 8),
                      ChoiceChip(
                        label: Text("Descending"),
                        selected: !_sortAscending,
                        onSelected: (selected) {
                          if (selected) {
                            setModalState(() {
                              _sortAscending = false;
                            });
                          }
                        },
                        backgroundColor: Colors.grey[200],
                        selectedColor: Color(0xFFFFCC01),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  // Apply and Reset buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          setModalState(() {
                            _selectedType = null;
                            _sortOption = "name";
                            _sortAscending = true;
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Color(0xFFFFCC01)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text("Reset"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            // Apply the filter and sort options from the modal
                            _applyFiltersAndSort();
                          });
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFFFCC01),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text("Apply"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getTypeColor(String type) {
    final Map<String, Color> typeColors = {
      "normal": Color(0xFFAAAAAA),
      "fire": Color(0xFFFF6B43),
      "water": Color(0xFF3399FF),
      "electric": Color(0xFFFFD700),
      "grass": Color(0xFF7AC74C),
      "ice": Color(0xFF96D9D6),
      "fighting": Color(0xFFC22E28),
      "poison": Color(0xFFA33EA1),
      "ground": Color(0xFFE2BF65),
      "flying": Color(0xFFA98FF3),
      "psychic": Color(0xFFF95587),
      "bug": Color(0xFFA6B91A),
      "rock": Color(0xFFB6A136),
      "ghost": Color(0xFF735797),
      "dragon": Color(0xFF6F35FC),
      "dark": Color(0xFF705746),
      "steel": Color(0xFFB7B7CE),
      "fairy": Color(0xFFD685AD),
    };

    return typeColors[type] ?? Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 600;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Favorite Pokémon",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'DM-Sans',
          ),
        ),
        backgroundColor: Color(0xFFFFCC01),
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: _showFilterSortBottomSheet,
            tooltip: "Filter & Sort",
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshFavorites,
          ),
        ],
      ),
      body: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: const [
                      Color(0xffF6F3FD),
                      Color(0xffFFE2E5),
                      Color(0xffDFECB4),
                    ],
                    begin: _topAlignmentAnimation.value,
                    end: _bottomAlignmentAnimation.value,
                  )
              ),
              child: Column(
                children: [
                  // Search bar
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: "Search favorites...",
                        prefixIcon: Icon(Icons.search),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              _searchQuery = "";
                              _applyFiltersAndSort();
                            });
                          },
                        )
                            : null,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Color(0xFFFFCC01), width: 2),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                          _applyFiltersAndSort();
                        });
                      },
                    ),
                  ),

                  // Active filters display
                  if (_selectedType != null || _sortOption != "name" || !_sortAscending)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                _buildActiveFiltersText(),
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _selectedType = null;
                                  _sortOption = "name";
                                  _sortAscending = true;
                                  _applyFiltersAndSort();
                                });
                              },
                              child: Text("Clear All"),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red,
                                padding: EdgeInsets.zero,
                                minimumSize: Size(50, 30),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Content
                  Expanded(
                    child: _isLoading
                        ? Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFCC01)),
                      ),
                    )
                        : _filteredPokemon.isEmpty
                        ? _buildEmptyState()
                        : RefreshIndicator(
                      onRefresh: _refreshFavorites,
                      color: Color(0xFFFFCC01),
                      child: isWideScreen
                          ? GridView.builder(
                        padding: EdgeInsets.all(16),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: MediaQuery.of(context).size.width > 900 ? 3 : 2,
                          childAspectRatio: 0.8,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: _filteredPokemon.length,
                        itemBuilder: (context, index) {
                          final pokemon = _filteredPokemon[index];
                          return _buildPokemonCard(pokemon);
                        },
                      )
                          : ListView.builder(
                        padding: EdgeInsets.all(16),
                        itemCount: _filteredPokemon.length,
                        itemBuilder: (context, index) {
                          final pokemon = _filteredPokemon[index];
                          return _buildPokemonCard(pokemon);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
      ),
      //Copy here for drawer
      drawer: Drawer(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero, // Forces sharp 90° corners
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrwHeader(),
            DrwListView(currentRoute: "/favorite"),//Replace "home" with current route
          ],
        ),
      ),
    );
  }

  String _buildActiveFiltersText() {
    List<String> filters = [];

    if (_selectedType != null) {
      filters.add("Type: ${_selectedType!.toUpperCase()}");
    }

    if (_sortOption != "name" || !_sortAscending) {
      String sortName = "";
      switch (_sortOption) {
        case "name": sortName = "Name"; break;
        case "type": sortName = "Type"; break;
        case "hp": sortName = "HP"; break;
        case "atk": sortName = "Attack"; break;
        case "def": sortName = "Defense"; break;
      }

      filters.add("Sort: $sortName (${_sortAscending ? 'Asc' : 'Desc'})");
    }

    return filters.join(" • ");
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80,
            color: Colors.grey.shade400,
          ),
          SizedBox(height: 16),
          Text(
            "No Favorite Pokémon Yet",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Your favorite Pokémon will appear here",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/gallery');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFFCC01),
              foregroundColor: Colors.black,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: Icon(Icons.search),
            label: Text("Explore Pokémon"),
          ),
        ],
      ),
    );
  }

  Widget _buildPokemonCard(Map<String, dynamic> pokemon) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => _showPokemonDetails(pokemon),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pokemon Image
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: pokemon['image'],
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[200],
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              _getTypeColor(pokemon['type'].toString().toLowerCase())
                          ),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[200],
                      child: Icon(Icons.error, size: 40),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getTypeColor(pokemon['type'].toString().toLowerCase()),
                        borderRadius: BorderRadius.only(topRight: Radius.circular(12)),
                      ),
                      child: Text(
                        pokemon['type'].toString().toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Pokemon Info
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pokemon['nickname'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '#${pokemon['pokemonId']} ${pokemon['name']}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 28,
                    ),
                    onPressed: () => _removeFromFavorites(pokemon['id'], pokemon['name']),
                  ),
                ],
              ),
            ),

            // Stats preview
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                children: [
                  _buildStatChip("HP", pokemon['hp']),
                  SizedBox(width: 8),
                  _buildStatChip("ATK", pokemon['atk']),
                  SizedBox(width: 8),
                  _buildStatChip("DEF", pokemon['def']),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(String label, int value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          SizedBox(width: 4),
          Text(
            value.toString(),
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}