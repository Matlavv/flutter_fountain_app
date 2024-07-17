import 'package:flutter/material.dart';

class FountainDetailsPage extends StatelessWidget {
  final Map fountain;

  const FountainDetailsPage({super.key, required this.fountain});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(fountain['nomfr']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (fountain['photo'] != null && fountain['photo']['url'] != null)
              Image.network(fountain['photo']['url']),
            const SizedBox(height: 8.0),
            if (fountain['speclocfr'] != null) Text(fountain['speclocfr']),
            const SizedBox(height: 8.0),
            if (fountain['adrvoisfr'] != null) Text(fountain['adrvoisfr']),
          ],
        ),
      ),
    );
  }
}
