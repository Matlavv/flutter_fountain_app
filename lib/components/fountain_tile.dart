import 'package:flutter/material.dart';

import '../pages/fountain_details_page.dart';

class FountainTile extends StatelessWidget {
  final Map fountain;

  const FountainTile({super.key, required this.fountain});

  @override
  Widget build(BuildContext context) {
    // Ajouter des logs pour vérifier les données
    print('Fountain data: $fountain');

    // Vérifier et construire l'URL de la photo si nécessaire
    String? photoUrl;
    if (fountain.containsKey('photo') && fountain['photo'] != null) {
      var photoData = fountain['photo'];
      if (photoData is Map &&
          photoData.containsKey('url') &&
          photoData['url'] != null) {
        // Utiliser l'URL de la photo directement depuis le champ 'url'
        photoUrl = photoData['url'];
      }
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FountainDetailsPage(fountain: fountain),
          ),
        );
      },
      child: Card(
        child: Column(
          children: [
            if (photoUrl != null)
              Image.network(
                photoUrl,
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
              )
            else
              const Icon(Icons.image_not_supported),
            if (fountain['nomfr'] != null) Text(fountain['nomfr']),
          ],
        ),
      ),
    );
  }
}
