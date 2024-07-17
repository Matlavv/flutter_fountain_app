import 'package:flutter/material.dart';

class FountainDetailsPage extends StatelessWidget {
  final Map fountain;
  final Locale locale;

  const FountainDetailsPage(
      {super.key, required this.fountain, required this.locale});

  @override
  Widget build(BuildContext context) {
    // Choisir les textes en fonction de la langue sélectionnée
    String title;
    String specloc;
    String adrvois;

    if (locale.languageCode == 'fr') {
      title = fountain['nomfr'] ?? 'No Title';
      specloc = fountain['speclocfr'] ?? 'No Location';
      adrvois = fountain['adrvoisfr'] ?? 'No Address';
    } else if (locale.languageCode == 'nl') {
      title = fountain['nomnl'] ?? 'No Title';
      specloc = fountain['speclocnl'] ?? 'No Location';
      adrvois = fountain['adrvoisnl'] ?? 'No Address';
    } else {
      title = 'No Title';
      specloc = 'No Location';
      adrvois = 'No Address';
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (fountain['photo'] != null && fountain['photo']['url'] != null)
              Image.network(fountain['photo']['url']),
            const SizedBox(height: 8.0),
            Text(specloc),
            const SizedBox(height: 8.0),
            Text(adrvois),
          ],
        ),
      ),
    );
  }
}
