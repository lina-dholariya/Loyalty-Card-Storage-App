import 'package:flutter/material.dart';

class CardForm extends StatefulWidget {
  final Function(Map<String, dynamic>) onSubmit;

  const CardForm({super.key, required this.onSubmit});

  @override
  State<CardForm> createState() => _CardFormState();
}

class _CardFormState extends State<CardForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _numberController = TextEditingController();
  final _expiryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Add New Loyalty Card',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Card Name',
                hintText: 'e.g. Starbucks Rewards',
              ),
              validator: (value) => value?.isEmpty ?? true ? 'Please enter card name' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _numberController,
              decoration: const InputDecoration(
                labelText: 'Card Number',
                hintText: 'e.g. 1234567890',
              ),
              validator: (value) => value?.isEmpty ?? true ? 'Please enter card number' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _expiryController,
              decoration: const InputDecoration(
                labelText: 'Expiry Date',
                hintText: 'MM/YY',
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Please enter expiry date';
                final parts = value!.split('/');
                if (parts.length != 2) return 'Please use MM/YY format';
                return null;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  widget.onSubmit({
                    'name': _nameController.text,
                    'number': _numberController.text,
                    'expiry': _expiryController.text,
                    'lastUsed': DateTime.now().toIso8601String(),
                  });
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Add Card',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
