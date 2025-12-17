import 'package:flutter/material.dart';

class VehiclePage extends StatefulWidget {
  const VehiclePage({super.key});

  @override
  State<VehiclePage> createState() => _VehiclePageState();
}

class _VehiclePageState extends State<VehiclePage> {
  final TextEditingController _modeloController = TextEditingController();
  final TextEditingController _anoController = TextEditingController();
  final TextEditingController _placaController = TextEditingController();
  final TextEditingController _kmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro do Veículo'),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Icon(Icons.directions_car, size: 60, color: Colors.blue),
            const SizedBox(height: 20),
            
            TextField(
              controller: _modeloController,
              decoration: const InputDecoration(
                labelText: 'Modelo do Veículo',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.car_rental),
              ),
            ),
            
            const SizedBox(height: 16),
            
            TextField(
              controller: _anoController,
              decoration: const InputDecoration(
                labelText: 'Ano',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.calendar_today),
              ),
              keyboardType: TextInputType.number,
            ),
            
            const SizedBox(height: 16),
            
            TextField(
              controller: _placaController,
              decoration: const InputDecoration(
                labelText: 'Placa (opcional)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.confirmation_number),
              ),
            ),
            
            const SizedBox(height: 16),
            
            TextField(
              controller: _kmController,
              decoration: const InputDecoration(
                labelText: 'Quilometragem Atual',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.speed),
              ),
              keyboardType: TextInputType.number,
            ),
            
            const SizedBox(height: 32),
            
            ElevatedButton(
              onPressed: () {
                if (_modeloController.text.isNotEmpty && _anoController.text.isNotEmpty) {
                  Navigator.pop(context, {
                    'modelo': _modeloController.text,
                    'ano': int.parse(_anoController.text),
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.blue.shade800,
              ),
              child: const Text(
                'Salvar Veículo',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}