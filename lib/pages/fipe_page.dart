import 'package:flutter/material.dart';
import '../services/fipe_service.dart';

class FipePage extends StatefulWidget {
  final String modelo;
  final int ano;
  
  const FipePage({
    super.key,
    required this.modelo,
    required this.ano,
  });

  @override
  State<FipePage> createState() => _FipePageState();
}

class _FipePageState extends State<FipePage> {
  double? _valorFipe;
  bool _carregando = false;
  String? _erro;

  Future<void> _consultarFipe() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });

    try {
      final valor = await FipeService().consultarValor(
        modelo: widget.modelo,
        ano: widget.ano,
      );
      
      setState(() {
        _valorFipe = valor;
        _carregando = false;
      });
    } catch (e) {
      setState(() {
        _erro = 'Erro ao consultar: $e';
        _carregando = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.modelo != 'Não cadastrado') {
      _consultarFipe();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consulta FIPE'),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search, size: 80, color: Colors.blue),
            const SizedBox(height: 20),
            
            Text(
              'Consultando valor para:',
              style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
            ),
            
            const SizedBox(height: 10),
            
            Text(
              widget.modelo,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            
            if (widget.ano > 0)
              Text(
                'Ano: ${widget.ano}',
                style: const TextStyle(fontSize: 18),
              ),
            
            const SizedBox(height: 40),
            
            if (_carregando)
              const Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text('Consultando valor FIPE...'),
                ],
              )
            else if (_erro != null)
              Column(
                children: [
                  const Icon(Icons.error, size: 60, color: Colors.red),
                  const SizedBox(height: 20),
                  Text(
                    _erro!,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _consultarFipe,
                    child: const Text('Tentar Novamente'),
                  ),
                ],
              )
            else if (_valorFipe != null)
              Column(
                children: [
                  const Text(
                    'Valor estimado:',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'R\$${_valorFipe!.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, _valorFipe),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    ),
                    child: const Text('Usar este valor'),
                  ),
                ],
              )
            else
              const Text(
                'Cadastre um veículo primeiro',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }
}