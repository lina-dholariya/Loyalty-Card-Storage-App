import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/intl.dart';

class CardItem extends StatelessWidget {
  final Map<String, dynamic> card;
  final VoidCallback onUse;

  const CardItem({super.key, required this.card, required this.onUse});

  @override
  Widget build(BuildContext context) {
    final expiryParts = card['expiry'].split('/');
    final expiryDate = DateTime(
      int.parse('20${expiryParts[1]}'),
      int.parse(expiryParts[0]),
    );

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(card['name']),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Card Number: ${card['number']}'),
            Text('Expiry: ${DateFormat('MMM yyyy').format(expiryDate)}'),
            Text('Last Used: ${DateFormat('MMM d, yyyy').format(DateTime.parse(card['lastUsed']))}'),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.qr_code),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    QrImageView(
                      data: card['number'],
                      version: QrVersions.auto,
                      size: 200.0,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        onUse();
                        Navigator.pop(context);
                      },
                      child: const Text('Mark as Used'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
