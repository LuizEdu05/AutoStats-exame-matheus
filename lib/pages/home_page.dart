import 'package:flutter/material.dart';
import 'vehicle_page.dart';
import 'expense_page.dart';
import 'fipe_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _modelo = 'Não cadastrado';
  int _ano = 0;
  double _total = 0.0;
  double _fipe = 0.0;
  
  // LISTA para armazenar despesas
  final List<Map<String, dynamic>> _despesas = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AutoStats'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // VEÍCULO
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Icon(Icons.directions_car, size: 50, color: Colors.blue),
                    const SizedBox(height: 10),
                    Text(_modelo, style: const TextStyle(fontSize: 20)),
                    if (_ano > 0) Text('Ano: $_ano'),
                    ElevatedButton(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const VehiclePage()),
                        );
                        if (result != null) {
                          setState(() {
                            _modelo = result['modelo'];
                            _ano = result['ano'];
                          });
                        }
                      },
                      child: const Text('Editar Veículo'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // MÉTRICAS
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          const Text('Custo Total'),
                          Text('R\$${_total.toStringAsFixed(2)}', 
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          const Text('Valor FIPE'),
                          Text(_fipe > 0 ? 'R\$${_fipe.toStringAsFixed(2)}' : 'N/A', 
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, 
                              color: _fipe > 0 ? Colors.green : Colors.grey)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // HISTÓRICO (se tiver despesas)
            if (_despesas.isNotEmpty) _buildHistorico(),

            const SizedBox(height: 20),

            // BOTÕES
            Column(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ExpensePage()),
                    );
                    
                    if (result != null && result['valor'] > 0) {
                      setState(() {
                        // Adiciona à lista
                        _despesas.add({
                          'tipo': result['tipo'],
                          'descricao': result['descricao'],
                          'valor': result['valor'],
                          'data': DateTime.now(),
                        });
                        
                        // Atualiza total
                        _total += result['valor'];
                      });
                      
                      // Mostra mensagem
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Despesa de R\$${result['valor']} adicionada!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Adicionar Despesa'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _modelo != 'Não cadastrado' 
                    ? () async {
                        final valor = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FipePage(modelo: _modelo, ano: _ano)),
                        );
                        if (valor != null) {
                          setState(() {
                            _fipe = valor;
                          });
                        }
                      }
                    : null,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('Consultar FIPE', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildHistorico() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Últimas Despesas:', 
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            
            const SizedBox(height: 10),
            
            // Mostra até 3 despesas
            ..._despesas.take(3).map((despesa) {
              return ListTile(
                leading: Icon(
                  _getIcon(despesa['tipo']),
                  color: _getColor(despesa['tipo']),
                ),
                title: Text(despesa['descricao']),
                subtitle: Text(_getTipoLabel(despesa['tipo'])),
                trailing: Text('R\$${despesa['valor'].toStringAsFixed(2)}'),
              );
            }).toList(),
            
            if (_despesas.length > 3)
              TextButton(
                onPressed: _verTodasDespesas,
                child: const Text('Ver todas...'),
              ),
          ],
        ),
      ),
    );
  }
  
  void _verTodasDespesas() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Todas as Despesas'),
        content: SizedBox(
          width: 300,
          height: 300,
          child: ListView.builder(
            itemCount: _despesas.length,
            itemBuilder: (context, index) {
              final despesa = _despesas[index];
              return ListTile(
                title: Text(despesa['descricao']),
                subtitle: Text(_getTipoLabel(despesa['tipo'])),
                trailing: Text('R\$${despesa['valor'].toStringAsFixed(2)}'),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }
  
  IconData _getIcon(String tipo) {
    switch (tipo) {
      case 'fuel': return Icons.local_gas_station;
      case 'maintenance': return Icons.build;
      case 'taxes': return Icons.receipt;
      default: return Icons.more_horiz;
    }
  }
  
  Color _getColor(String tipo) {
    switch (tipo) {
      case 'fuel': return Colors.blue;
      case 'maintenance': return Colors.orange;
      case 'taxes': return Colors.red;
      default: return Colors.grey;
    }
  }
  
  String _getTipoLabel(String tipo) {
    switch (tipo) {
      case 'fuel': return 'Abastecimento';
      case 'maintenance': return 'Manutenção';
      case 'taxes': return 'Impostos';
      default: return 'Outros';
    }
  }
}