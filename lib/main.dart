import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'widgets/card_form.dart';
import 'widgets/card_item.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('loyalty_cards');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loyalty Card Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const LoyaltyCardHome(),
    );
  }
}

class LoyaltyCardHome extends StatefulWidget {
  const LoyaltyCardHome({super.key});

  @override
  State<LoyaltyCardHome> createState() => _LoyaltyCardHomeState();
}

class _LoyaltyCardHomeState extends State<LoyaltyCardHome> {
  final Box _cardBox = Hive.box('loyalty_cards');
  List<Map<String, dynamic>> _cards = [];

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  void _loadCards() {
    setState(() {
      _cards = _cardBox.values
          .map((card) => Map<String, dynamic>.from(card))
          .toList();
    });
  }

  void _addCard(Map<String, dynamic> card) {
    _cardBox.add(card);
    _loadCards();
  }

  void _showAddCardDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Loyalty Card'),
        content: CardForm(onSubmit: _addCard),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loyalty Card Manager'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddCardDialog,
          ),
        ],
      ),
      body: _cards.isEmpty
          ? const Center(child: Text('No cards added yet'))
          : ListView.builder(
              itemCount: _cards.length,
              itemBuilder: (context, index) {
                final card = _cards[index];
                return CardItem(
                  card: card,
                  onUse: () {
                    setState(() {
                      card['lastUsed'] = DateTime.now().toIso8601String();
                      _cardBox.putAt(index, card);
                    });
                  },
                );
              },
            ),
    );
  }
}
