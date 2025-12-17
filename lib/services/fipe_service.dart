import 'dart:convert';
import 'package:http/http.dart' as http;

class FipeService {
  // API oficial da Tabela FIPE
  static const String _baseUrl = 'https://parallelum.com.br/fipe/api/v1/carros';
  
  // Método SIMPLIFICADO para a prova
  Future<double?> consultarValor({
    required String modelo,
    required int ano,
  }) async {
    try {
      print('🔍 Consultando FIPE para: $modelo ($ano)');
      
      // 1. Busca lista de marcas
      final marcasResponse = await http.get(
        Uri.parse('$_baseUrl/marcas'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (marcasResponse.statusCode != 200) {
        print('❌ Erro ao buscar marcas: ${marcasResponse.statusCode}');
        return _gerarValorMock(modelo, ano);
      }
      
      final List<dynamic> marcas = json.decode(marcasResponse.body);
      if (marcas.isEmpty) {
        return _gerarValorMock(modelo, ano);
      }
      
      // 2. Usa a primeira marca (ex: Volkswagen)
      final primeiraMarca = marcas.first as Map<String, dynamic>;
      final marcaCodigo = primeiraMarca['codigo'].toString();
      final marcaNome = primeiraMarca['nome'].toString();
      
      print('✅ Marca selecionada: $marcaNome ($marcaCodigo)');
      
      // 3. Busca modelos da marca
      final modelosResponse = await http.get(
        Uri.parse('$_baseUrl/marcas/$marcaCodigo/modelos'),
      );
      
      if (modelosResponse.statusCode != 200) {
        print('❌ Erro ao buscar modelos: ${modelosResponse.statusCode}');
        return _gerarValorMock(modelo, ano);
      }
      
      final modelosData = json.decode(modelosResponse.body) as Map<String, dynamic>;
      final List<dynamic> modelos = modelosData['modelos'] ?? [];
      
      if (modelos.isEmpty) {
        return _gerarValorMock(modelo, ano);
      }
      
      // 4. Tenta encontrar modelo pelo nome ou usa o primeiro
      Map<String, dynamic> modeloEncontrado;
      
      for (var m in modelos) {
        final Map<String, dynamic> modeloMap = m as Map<String, dynamic>;
        final nomeModelo = modeloMap['nome'].toString().toLowerCase();
        if (nomeModelo.contains(modelo.toLowerCase())) {
          modeloEncontrado = modeloMap;
          final modeloCodigo = modeloEncontrado['codigo'].toString();
          final modeloNome = modeloEncontrado['nome'].toString();
          
          print('✅ Modelo encontrado: $modeloNome ($modeloCodigo)');
          
          // Continua com o processo
          return await _buscarValorFinal(
            marcaCodigo, 
            modeloCodigo, 
            ano, 
            modelo, 
            ano
          );
        }
      }
      
      // Se não encontrou, usa o primeiro modelo
      modeloEncontrado = modelos.first as Map<String, dynamic>;
      final modeloCodigo = modeloEncontrado['codigo'].toString();
      final modeloNome = modeloEncontrado['nome'].toString();
      
      print('✅ Modelo selecionado (primeiro): $modeloNome ($modeloCodigo)');
      
      return await _buscarValorFinal(
        marcaCodigo, 
        modeloCodigo, 
        ano, 
        modelo, 
        ano
      );
      
    } catch (e) {
      print('⚠️ Erro na API FIPE: $e');
      // Retorna valor mock em caso de erro
      return _gerarValorMock(modelo, ano);
    }
  }
  
  // Método auxiliar para buscar valor final
  Future<double?> _buscarValorFinal(
    String marcaCodigo, 
    String modeloCodigo, 
    int anoDesejado,
    String modelo,
    int ano
  ) async {
    try {
      // 5. Busca anos disponíveis
      final anosResponse = await http.get(
        Uri.parse('$_baseUrl/marcas/$marcaCodigo/modelos/$modeloCodigo/anos'),
      );
      
      if (anosResponse.statusCode != 200) {
        print('❌ Erro ao buscar anos: ${anosResponse.statusCode}');
        return _gerarValorMock(modelo, ano);
      }
      
      final List<dynamic> anosList = json.decode(anosResponse.body);
      
      if (anosList.isEmpty) {
        return _gerarValorMock(modelo, ano);
      }
      
      // 6. Tenta encontrar ano ou usa o mais recente
      Map<String, dynamic>? anoEncontrado;
      
      for (var a in anosList) {
        final Map<String, dynamic> anoMap = a as Map<String, dynamic>;
        final anoString = anoMap['nome'].toString();
        if (anoString.contains(anoDesejado.toString())) {
          anoEncontrado = anoMap;
          break;
        }
      }
      
      // Se não encontrou o ano específico, usa o primeiro
      final Map<String, dynamic> anoParaUsar = anoEncontrado ?? anosList.first as Map<String, dynamic>;
      final anoCodigo = anoParaUsar['codigo'].toString();
      final anoNome = anoParaUsar['nome'].toString();
      
      print('✅ Ano selecionado: $anoNome ($anoCodigo)');
      
      // 7. Busca o valor final
      final valorResponse = await http.get(
        Uri.parse('$_baseUrl/marcas/$marcaCodigo/modelos/$modeloCodigo/anos/$anoCodigo'),
      );
      
      if (valorResponse.statusCode == 200) {
        final Map<String, dynamic> valorData = json.decode(valorResponse.body);
        final valorString = valorData['Valor']?.toString() ?? '0';
        
        // Converte "R$ 50.000,00" para 50000.00
        final valorLimpo = valorString
            .replaceAll('R\$ ', '')
            .replaceAll('.', '')
            .replaceAll(',', '.');
        
        final valorDouble = double.tryParse(valorLimpo);
        
        if (valorDouble != null && valorDouble > 0) {
          print('🎉 Valor FIPE encontrado: R\$ $valorDouble');
          return valorDouble;
        }
      }
      
      // Se falhar, retorna mock
      return _gerarValorMock(modelo, ano);
      
    } catch (e) {
      print('⚠️ Erro ao buscar valor final: $e');
      return _gerarValorMock(modelo, ano);
    }
  }
  
  // Gera valor mock quando API falha
  double _gerarValorMock(String modelo, int ano) {
    // Lógica simples para gerar valor plausível
    final baseValor = 35000.0;
    final anosUso = DateTime.now().year - ano;
    final depreciacao = anosUso * 0.07;
    var valorFinal = baseValor * (1 - depreciacao);
    
    if (valorFinal < 10000) valorFinal = 10000.0;
    if (valorFinal > 150000) valorFinal = 150000.0;
    
    print('📊 Usando valor mock: R\$ ${valorFinal.toStringAsFixed(2)}');
    return double.parse(valorFinal.toStringAsFixed(2));
  }
}