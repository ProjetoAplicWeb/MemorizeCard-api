# 🃏 MemorizeCard

O **MemorizeCard** é um aplicativo de leitura de mangás por assinatura, com foco em títulos **licenciados** e de qualidade.  
Nosso objetivo é oferecer uma alternativa **legal e acessível** à pirataria, trazendo praticidade e valorizando o mercado editorial no Brasil.

---

## 📖 Índice
- [Sobre](#-sobre)
- [Funcionalidades](#-funcionalidades)
- [Tecnologias](#-tecnologias)
- [Instalação](#️-instalação)
- [Uso](#-uso)
- [API](#-api--endpoints)
- [Estrutura do Projeto](#-estrutura-do-projeto)
- [Contribuição](#-contribuição)

---

## 📌 Sobre
O **FlashCards** foi pensado para ajudar estudantes a aprenderem de forma ativa e organizada, permitindo:
- Criar **decks** por assunto (ex.: Física, História, Biologia).
- Adicionar **flashcards** com frente (pergunta/termo) e verso (resposta/explicação, imagens, links e anotações).
- Manter uma **biblioteca pessoal** de decks e marcar favoritos.
- Gerar cards automaticamente com **IA**: o usuário descreve um tema e recebe cards sugeridos para revisar/construir seu deck.
- Fazer anotações e editar os cards conforme o aprendizado evolui.

O foco é ser leve, intuitivo e adaptável ao fluxo de estudos do usuário — ideal para revisão espaçada e estudo ativo.

---

## ✨ Funcionalidades
- ✅ Criar/editar/remover decks.
- ✅ Criar/editar/remover cards dentro dos decks.
- ✅ Biblioteca do usuário com filtros e pesquisa.
- ✅ Favoritar / marcar cards como "pendentes".
- ✅ Integração com IA para geração de cards a partir de texto.
- ✅ Versionamento básico do conteúdo do card (histórico de edição — opcional).
- ✅ Autenticação de usuários (registro/login). 

---

## 🧰 Tecnologias
- **Back end:** Ruby 
- **Banco de dados:** MongoDB  
- **Front end:** React e TypeScript
- **Autenticação:** JWT 
- **IA:** integração com serviço externo (Gemini)
- **Ferramentas:**  Git

---

## 🛠️ Instalação

### Pré-requisitos
- JDK 17+  
- Maven  
- Node.js

### Passos
```bash
# Clone o repositório
git clone https://github.com/ProjetoAplicWeb/MemorizeCard-api.git

# Entre no diretório
cd MemorizeCard-api

# Instalar as dependencias do projeto
bundle install

# Rodar o projeto Ruby
bundle exec ruby main.rb

```
--- 

## 💡 Uso

### Rodando localmente:
bundle exec ruby main.rb

### Acesse em: 
http://localhost:8080    

--- 

## 💻 API — Endpoints

### Health
**GET** `/up` — health check da aplicação

### Autenticação
**POST** `/api/login` — Fazer login  
**POST** `/api/auth/google_oauth2/callback` — Autenticação via Google ID Token 

### Usuários
**POST** `/api/users` — Criar conta

### Decks (Api::DecksController)
**GET** `/api/decks` — Listar decks do usuário  
**GET** `/api/decks/:id` — Detalhes do deck (inclui cards)  
**POST** `/api/decks` — Criar deck  
**PATCH** `/api/decks/:id` — Atualizar deck  
**DELETE** `/api/decks/:id` — Remover deck  

### Cards (Api::CardsController)
**GET** `/api/decks/:deck_id/cards` — Listar cards de um deck  
**POST** `/api/decks/:deck_id/cards` — Criar card no deck  
**PATCH** `/api/cards/:id` — Atualizar card  
**DELETE** `/api/cards/:id` — Remover card  
**POST** `/api/cards/:id/done` — Marcar card como finalizado

--- 

## 🧱 Estrutura do projeto

```
app/
 ├── controllers/   # controllers (API controllers)
 ├── models/        # ActiveRecord models (Deck, Card, User, etc.)
 ├── serializers/   # serializers (ActiveModelSerializers ou fast_jsonapi)
 ├── services/      # classes de serviço (ex.: integração IA)
 ├── views/         # views (se usar HTML) — em API geralmente não usado
bin/                # bin/rails, executáveis do projeto
config/             # rotas, inicializadores, configurações do Rails
db/                 # migrations, schema.rb, seeds.rb
lib/                # código auxiliar, rake tasks
public/             # assets públicos
test/ or spec/      # testes (Minitest ou RSpec)
Gemfile             # gems do projeto
Dockerfile          # containerização
config.ru           # rackup
.rubocop.yml        # regras RuboCop
```

## 🤝 Contribuição

1. Ruby Faça um fork do repositório
2. Crie uma branch: git checkout -b feat/nome-da-feature
3. Adicione testes para a feature (se aplicável)
4. Commit: git commit -m "feat: adiciona geração de cards via IA"
5. Abra um Pull Request descrevendo as mudanças