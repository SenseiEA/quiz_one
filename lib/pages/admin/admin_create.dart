import 'dart:typed_data';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quiz_one/pages/drawer/drawer_header.dart';
import 'package:quiz_one/pages/drawer/drawer_list_view.dart';
import 'package:quiz_one/pages/admin/admin_body.dart';

import '../drawer/drawer_header.dart';
import '../drawer/drawer_list_view.dart'; // Ensure PokemonAdminApp is here

class AddPokemonScreen extends StatefulWidget {
  const AddPokemonScreen({Key? key}) : super(key: key);

  @override
  State<AddPokemonScreen> createState() => _AddPokemonScreenState();
}

class _AddPokemonScreenState extends State<AddPokemonScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _name = TextEditingController();
  final TextEditingController _imageUrl = TextEditingController();
  final TextEditingController _description = TextEditingController();

  Uint8List? _customImageBytes;

  late final int _hpValue;
  late final int _atkValue;
  late final int _defValue;

  @override
  void initState() {
    super.initState();
    _hpValue = _generateRandomStat();
    _atkValue = _generateRandomStat();
    _defValue = _generateRandomStat();
  }

  int _generateRandomStat() => Random().nextInt(256);

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _customImageBytes = bytes;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      // Add Pokémon to database or backend logic here...

      // Navigate back to admin screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PokemonAdminApp()),
      );
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _imageUrl.dispose();
    _description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      drawer: const Drawer(
        child: Column(
          children: [
            DrwHeader(),
            Expanded(child: DrwListView(currentRoute: '/admin',)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                'Add Pokémon',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _name,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter a name' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _imageUrl,
                decoration: const InputDecoration(labelText: 'Image URL'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Upload Custom Image'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _description,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (value) => value == null || value.isEmpty ? 'Please enter a description' : null,
              ),
              const SizedBox(height: 20),
              _buildStatsBar('HP', _hpValue),
              _buildStatsBar('ATK', _atkValue),
              _buildStatsBar('DEF', _defValue),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Add Pokémon'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Add Pokémon'),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const PokemonAdminApp()),
          );
        },
      ),
    );
  }

  Widget _buildStatsBar(String label, int value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: $value'),
        LinearProgressIndicator(
          value: value / 255,
          backgroundColor: Colors.grey[300],
          color: Colors.blue,
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
