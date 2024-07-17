import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../components/fountain_tile.dart';

class HomePage extends StatefulWidget {
  final Function(Locale) onLocaleChange;

  const HomePage({super.key, required this.onLocaleChange});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List fountains = [];
  List filteredFountains = [];
  String selectedRegion = 'All';
  String selectedCommune = 'All';
  Locale selectedLocale = const Locale('fr');

  @override
  void initState() {
    super.initState();
    fetchFountains();
  }

  Future<void> fetchFountains() async {
    final response = await http.get(Uri.parse(
        'https://opendata.bruxelles.be/api/explore/v2.1/catalog/datasets/bxl_fontaines/records?limit=20'));
    if (response.statusCode == 200) {
      setState(() {
        fountains = json.decode(response.body)['results'];
        filteredFountains = fountains;
      });
    } else {
      print('Failed to load fountains');
    }
  }

  void filterFountains() {
    setState(() {
      filteredFountains = fountains.where((fountain) {
        bool matchesRegion =
            selectedRegion == 'All' || fountain['z_pcdd_fr'] == selectedRegion;
        bool matchesCommune =
            selectedCommune == 'All' || fountain['commune'] == selectedCommune;
        return matchesRegion && matchesCommune;
      }).toList();
    });
  }

  void changeLanguage(Locale locale) {
    setState(() {
      selectedLocale = locale;
    });
    widget.onLocaleChange(locale);
  }

  @override
  Widget build(BuildContext context) {
    String flagImage;
    if (selectedLocale.languageCode == 'fr') {
      flagImage = 'assets/images/fr_flag.png';
    } else if (selectedLocale.languageCode == 'nl') {
      flagImage = 'assets/images/nl_flag.png';
    } else {
      flagImage = 'assets/images/fr_flag.png';
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Fontaine app'),
            const Spacer(),
            DropdownButton<String>(
              value: selectedRegion,
              items: <String>['All', 'Pentagone', 'Louise', 'Laeken']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedRegion = newValue!;
                  filterFountains();
                });
              },
            ),
            const SizedBox(width: 8),
            DropdownButton<String>(
              value: selectedCommune,
              items: <String>['All', 'Bruxelles', 'Ixelles', 'Anderlecht']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedCommune = newValue!;
                  filterFountains();
                });
              },
            ),
            const SizedBox(width: 8),
            Image.asset(
              flagImage,
              width: 32,
              height: 32,
            ),
            IconButton(
              icon: const Icon(Icons.language),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Choose a language'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            title: const Text('Français'),
                            onTap: () {
                              changeLanguage(const Locale('fr'));
                              Navigator.of(context).pop();
                            },
                          ),
                          ListTile(
                            title: const Text('Nederlands'),
                            onTap: () {
                              changeLanguage(const Locale('nl'));
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      body: filteredFountains.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemCount: filteredFountains.length,
              itemBuilder: (context, index) {
                var fountain = filteredFountains[index];
                return FountainTile(fountain: fountain, locale: selectedLocale);
              },
            ),
    );
  }
}
