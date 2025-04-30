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
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Card Name'),
            validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
          ),
          TextFormField(
            controller: _numberController,
            decoration: const InputDecoration(labelText: 'Card Number'),
            validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
          ),
          TextFormField(
            controller: _expiryController,
            decoration: const InputDecoration(labelText: 'Expiry Date (MM/YY)'),
            validator: (value) {
              if (value?.isEmpty ?? true) return 'Required';
              final parts = value!.split('/');
              if (parts.length != 2) return 'Invalid format';
              return null;
            },
          ),
          const SizedBox(height: 20),
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
            child: const Text('Add Card'),
          ),
        ],
      ),
    );
  }
}
