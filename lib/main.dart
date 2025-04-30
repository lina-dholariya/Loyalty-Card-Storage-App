import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'widgets/card_form.dart';
import 'widgets/card_item.dart';
import 'widgets/expense_tracker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('loyalty_cards');
  await Hive.openBox('expenses');
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const LoyaltyCardHome(),
    const ExpenseTracker(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: 'Cards',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.money),
            label: 'Expenses',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
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
            icon: const Icon(Icons.add, size: 28),
            tooltip: 'Add New Card',
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
