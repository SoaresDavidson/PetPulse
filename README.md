# PetPulse 🐾

PetPulse é um aplicativo iOS nativo moderno desenvolvido em **SwiftUI** para o gerenciamento de pets, agendamentos de serviços, notificações e controle de estoque de petshops. O ecossistema é composto por um aplicativo móvel e uma integração flexível de backend utilizando **Node-RED** com banco de dados **CouchDB / Cloudant**.

O aplicativo adota a arquitetura **MVVM (Model-View-ViewModel)** com injeção global de estados e reatividade em tempo real por meio de `EnvironmentObject`.

---

## 📱 Funcionalidades Principais

O ecossistema é dividido em duas áreas de acesso dinâmico configuráveis a partir da tela inicial:

### 1. Área do Cliente (Tutor)
*   **Fichas de Pets (Pet Cards)**: Exibição estilizada dos pets do tutor com dados como nome, raça, idade, número de vacinas e identificação da loja que cadastrou o animal.
*   **Ficha Médica & Histórico**: Visualização de informações de saúde detalhadas, histórico completo de vacinas aplicadas e edição cadastral direta do pet (PUT).
*   **Fluxo de Agendamento Interativo**: Formulário com seleção de estabelecimento parceiro, carrossel de serviços (preços e durações), calendário integrado e grade de seleção de horários livres.
*   **Central de Notificações**: Aba dedicada com badges de mensagens não lidas e ações de deslizar (swipe) para marcar notificações como lidas.
*   **Perfil do Tutor**: Visualização e edição dinâmica dos dados de contato e endereço (sincronizados via PUT).

### 2. Área do Petshop
*   **Controle da Fila de Atendimento**: Dashboard em tempo real contendo a fila diária de banhos, tosas, vacinações e consultas.
*   **Gestão Geral de Pets**: Lista de todos os pets cadastrados na base do petshop com suporte a adição de novos pets (POST), edição completa de registros (PUT) e exclusão lógica de fichas (DELETE).
*   **Gestão de Serviços & Estoque**: Controle interno dos procedimentos oferecidos e controle dos itens de consumo disponíveis em estoque.

---

## 🛠️ Arquitetura e Estrutura do Projeto

O projeto segue a estrutura padrão de desenvolvimento Apple Swift:

```
PetPulse/
├── Models/              # Definições de estruturas de dados e decodificação
│   ├── Pet.swift
│   ├── PetShop.swift
│   ├── Tutor.swift
│   ├── agendamento.swift
│   ├── VacinaPet.swift
│   ├── Notificacao.swift
│   └── APIConfig.swift  # Configuração centralizada do IP do servidor
├── ViewModels/          # Lógica de negócios e chamadas HTTP assíncronas (async/await)
│   ├── TutorViewModel.swift
│   ├── PetshopViewModel.swift
│   ├── PetViewModel.swift
│   ├── AgendamentoViewModel.swift
│   └── NotificacaoViewModel.swift
└── Views/               # Componentes e Telas em SwiftUI
    ├── TelaInicialView.swift
    ├── ClienteHomeView.swift
    ├── PetshopHomeView.swift
    ├── PetCardView.swift
    ├── PetDetalhesView.swift
    └── AgendamentoSheetView.swift
```

---

## 🗄️ Modelagem de Dados

### Pet
Ficha individual contendo os dados de registro, espécie e vínculo médico:
```swift
struct Pet: Identifiable, Codable {
    let id: Int?
    let rev: String?
    var nome: String
    var species: Species
    var raca: String
    var dataNascimento: Date
    var vacinas: [VacinaPet]
    var informacoes_medicas: String
    var sexo: String?
    var imagem: String?
    var petshop: String? // Nome da clínica/petshop que cadastrou
}
```

### Scheduling (Agendamento)
Instância que vincula o tutor, o pet, o serviço, a data e o status do procedimento:
```swift
struct Scheduling: Identifiable, Codable {
    let id: Int?
    let rev: String?
    var tutorId: String
    var petId: Int
    var petshopId: String
    var serviceId: Int
    var dataHoraAgendamento: Date
    var statusServico: statusService
}
```

---

## 🌐 Integração com a API Backend (Node-RED)

Os endpoints de backend estão mapeados no arquivo central [RotasJSON](file:///Users/turma02-10/Documents/GitHub/PetPulse/RotasJSON). A base de rotas inclui:

| Método | Endpoint | Descrição |
| :--- | :--- | :--- |
| `GET` | `/petshops` | Retorna todos os petshops cadastrados |
| `POST` | `/tutores/:tutor_id/pets` | Cadastra um novo pet associado a um tutor |
| `PUT` | `/tutores/:tutor_id/pets/:pet_id` | Atualiza os dados de um pet |
| `DELETE` | `/tutores/:tutor_id/pets/:pet_id` | Exclui um pet do banco de dados |
| `POST` | `/agendamentos` | Cria um novo agendamento de serviço |
| `PUT` | `/notificacoes/:notificacao_id` | Altera status de uma notificação para lida |

---

## 🚀 Como Rodar o Projeto

### Pré-requisitos
1. **Xcode 15+** instalado no macOS.
2. Servidor backend Node-RED ativo e rodando.

### 1. Importar as Rotas do Node-RED
Importe o conteúdo do arquivo [RotasJSON](file:///Users/turma02-10/Documents/GitHub/PetPulse/RotasJSON) no painel do seu servidor Node-RED local para instanciar todos os fluxos e conexões com o Cloudant.

### 2. Configurar a URL Base
Abra o arquivo [APIConfig.swift](file:///Users/turma02-10/Documents/GitHub/PetPulse/PetPulse/Models/APIConfig.swift) no Xcode e atualize a propriedade `baseURL` com o endereço IP correto do seu servidor local:
```swift
@Published var baseURL: String = "http://<SEU_IP_AQUI>:1880"
```

### 3. Rodar no Xcode
1. Abra o arquivo `PetPulse.xcodeproj` no Xcode.
2. Selecione um simulador de dispositivo iOS (ex: iPhone 15 Pro).
3. Aperte `Cmd + R` para compilar e iniciar o aplicativo.
