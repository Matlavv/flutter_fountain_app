import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

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

    // Extraire les coordonnées de la fontaine
    double latitude = double.parse(fountain['wgs84_lat'].toString());
    double longitude = double.parse(fountain['wgs84_long'].toString());

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (fountain['photo'] != null && fountain['photo']['url'] != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Image.network(
                    fountain['photo']['url'],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error);
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 16.0),
              Text(
                specloc,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8.0),
              Text(
                adrvois,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                height: 300,
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: LatLng(latitude, longitude),
                    minZoom: 15.0,
                    maxZoom: 18.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: const ['a', 'b', 'c'],
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: LatLng(latitude, longitude),
                          width: 80.0,
                          height: 80.0,
                          child: const Icon(Icons.location_on, size: 40.0),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
