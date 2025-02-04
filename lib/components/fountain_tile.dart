import 'package:flutter/material.dart';

import '../pages/fountain_details_page.dart';

class FountainTile extends StatelessWidget {
  final Map fountain;
  final Locale locale;

  const FountainTile({super.key, required this.fountain, required this.locale});

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

    // Choisir le titre en fonction de la langue sélectionnée
    String title;
    if (locale.languageCode == 'fr') {
      title = fountain['nomfr'] ?? 'No Title';
    } else if (locale.languageCode == 'nl') {
      title = fountain['nomnl'] ?? 'No Title';
    } else {
      title = 'No Title';
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                FountainDetailsPage(fountain: fountain, locale: locale),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(8.0), // Ajouter un espace autour des tiles
        decoration: BoxDecoration(
          color: Theme.of(context)
              .cardColor, // Utiliser la couleur du thème pour les tiles
          borderRadius: BorderRadius.circular(16), // Bords arrondis
          border: Border.all(color: Colors.black, width: 1), // Bordure noire
          boxShadow: [
            BoxShadow(
              color: Colors.grey
                  .withOpacity(0.5), // Ombre pour mettre en valeur les tiles
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // décalage de l'ombre
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (photoUrl != null)
              Flexible(
                flex: 3,
                fit: FlexFit.tight,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(
                          16)), // Bords arrondis en haut de l'image
                  child: Image.network(
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
                  ),
                ),
              )
            else
              const Flexible(
                flex: 3,
                fit: FlexFit.tight,
                child: Icon(Icons.image_not_supported),
              ),
            Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Couleur du texte
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
