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
  String selectedRegion = 'All';

  @override
  void initState() {
    super.initState();
    fetchFountains();
  }

  fetchFountains() async {
    final response = await http.get(Uri.parse(
        'https://opendata.bruxelles.be/api/explore/v2.1/catalog/datasets/bxl_fontaines/records?limit=20'));
    if (response.statusCode == 200) {
      setState(() {
        fountains = json.decode(response.body)['results'];
        print(fountains); // Debugging line
      });
    } else {
      print('Failed to load fountains');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fontaine app'),
        actions: [
          DropdownButton<String>(
            value: selectedRegion,
            items: <String>['All', 'Region 1', 'Region 2'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedRegion = newValue!;
              });
            },
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
                            widget.onLocaleChange(const Locale('fr'));
                            Navigator.of(context).pop();
                          },
                        ),
                        ListTile(
                          title: const Text('Nederlands'),
                          onTap: () {
                            widget.onLocaleChange(const Locale('nl'));
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
      body: GridView.builder(
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: fountains.length,
        itemBuilder: (context, index) {
          var fountain = fountains[index];
          return FountainTile(fountain: fountain);
        },
      ),
    );
  }
}
