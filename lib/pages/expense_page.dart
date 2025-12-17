import 'package:flutter/material.dart';

class ExpensePage extends StatefulWidget {
  const ExpensePage({super.key});

  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  String _selectedType = 'fuel';
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _valorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nova Despesa')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // TIPO
            DropdownButton<String>(
              value: _selectedType,
              items: const [
                DropdownMenuItem(value: 'fuel', child: Text('Abastecimento')),
                DropdownMenuItem(value: 'maintenance', child: Text('Manutenção')),
                DropdownMenuItem(value: 'taxes', child: Text('Impostos')),
                DropdownMenuItem(value: 'other', child: Text('Outros')),
              ],
              onChanged: (value) => setState(() => _selectedType = value!),
            ),
            
            const SizedBox(height: 20),
            
            // DESCRIÇÃO
            TextField(
              controller: _descricaoController,
              decoration: const InputDecoration(labelText: 'Descrição'),
            ),
            
            const SizedBox(height: 20),
            
            // VALOR
            TextField(
              controller: _valorController,
              decoration: const InputDecoration(labelText: 'Valor (R\$)'),
              keyboardType: TextInputType.number,
            ),
            
            const SizedBox(height: 30),
            
            // BOTÃO SALVAR
            ElevatedButton(
              onPressed: () {
                if (_valorController.text.isNotEmpty && _descricaoController.text.isNotEmpty) {
                  final valor = double.tryParse(_valorController.text) ?? 0.0;
                  Navigator.pop(context, {
                    'tipo': _selectedType,
                    'descricao': _descricaoController.text,
                    'valor': valor,
                  });
                }
              },
              child: const Text('Salvar Despesa'),
            ),
          ],
        ),
      ),
    );
  }
}