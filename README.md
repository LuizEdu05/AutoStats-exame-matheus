# 🚗 AutoStats - Gestão Financeira de Veículos

Aplicativo Flutter para cálculo do Custo Total de Propriedade (TCO) de veículos, desenvolvido para a disciplina de **Desenvolvimento de Sistemas Móveis e Distribuídos**.

## 📋 Descrição do Projeto

O **AutoStats** é um aplicativo mobile que auxilia proprietários de veículos no gerenciamento financeiro, permitindo o cálculo do custo real de propriedade através do registro de despesas e consulta do valor de mercado do veículo via API FIPE.

### Funcionalidades Principais:
- ✅ **Cadastro de veículo** com persistência local
- ✅ **Registro de despesas** por categoria (Abastecimento, Manutenção, Impostos)
- ✅ **Consulta de valor FIPE** via API pública
- ✅ **Dashboard analítico** com métricas financeiras
- ✅ **Histórico completo** de gastos
- ✅ **UI responsiva** com feedback visual

## 🏗️ Arquitetura Adotada

O projeto segue uma arquitetura **simplificada em camadas**, focando na separação de responsabilidades

Passo a Passo para Execução
Pré-requisitos:
Flutter SDK 3.0 ou superior

Dispositivo físico ou emulador configurado

Conexão com internet (para consulta FIPE)

Passos:
Clone o repositório:

bash
git clone https://github.com/seu-usuario/autostats.git
cd autostats
Instale as dependências:

bash
flutter pub get
Execute o aplicativo:

bash
flutter run
Para build de release:

bash
flutter build apk --release

Testando Funcionalidades:
Cadastre um veículo:

Na tela inicial, clique em "Cadastrar Veículo"

Informe modelo, ano e quilometragem

Clique em "Salvar"

Adicione despesas:

Na tela inicial, clique em "Adicionar Despesa"

Selecione tipo, informe descrição e valor

Clique em "Salvar Despesa"

Consulte valor FIPE:

Com um veículo cadastrado, clique em "Consultar FIPE"

Aguarde a consulta à API

Veja o valor estimado na tela