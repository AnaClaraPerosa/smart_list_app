# SmartList 📱🛒

SmartList é um aplicativo mobile desenvolvido em **Flutter**, integrado a uma **API REST em Ruby on Rails** com banco de dados **PostgreSQL**.  
O objetivo do app é facilitar a organização de listas de compras, permitindo que cada usuário crie suas próprias listas e adicione itens de forma prática.

---

## 🚀 Tecnologias utilizadas

- **Flutter** (frontend mobile)
- **Ruby on Rails** (backend/API)
- **PostgreSQL** (banco de dados)
- **Devise** (autenticação de usuários)

---

## 🗄️ Estrutura do Banco de Dados

A API utiliza um banco PostgreSQL com as seguintes tabelas principais:

- **users**  
  Armazena os dados de autenticação e informações dos usuários.  
  Campos principais: `id`, `email`, `encrypted_password`.

- **shopping_lists**  
  Representa uma lista de compras criada por um usuário.  
  Campos principais: `id`, `name`, `user_id`.

- **items**  
  Representa os itens que compõem uma lista de compras.  
  Campos principais: `id`, `name`, `quantity`, `shopping_list_id`.

---

## 📲 Como rodar o app Flutter

1. Clone o repositório:  
   git clone <https://github.com/seu-usuario/smart_list_app.git>  
   cd smartlist-app  

2. Instale as dependências do Flutter:  
   flutter pub get  

3. Configure a URL da API  
   No arquivo `lib/services/api_service.dart`, ajuste a variável `baseUrl` com a URL da sua API.  
   Exemplo para ambiente local:  
   const String baseUrl = "<http://localhost:3000>";  

   Você também pode rodar passando a URL dinamicamente:  
   flutter run --dart-define=API_URL=<http://192.xxx.x.xx:3000>  

4. Execute o aplicativo:  
   flutter run  

---

## 🌐 Como rodar a API (Rails)

> O repositório da API é separado deste app.

1. Clone e configure o projeto Rails:  
   git clone <https://github.com/AnaClaraPerosa/SmartList.git>  
   cd smartlist-api  

2. Instale as dependências:  
   bundle install  

3. Crie e rode o banco de dados:  
   rails db:create db:migrate db:seed  

4. Inicie o servidor Rails:  
   rails s  

   A API ficará disponível em <http://localhost:3000>  

---

## 🎯 Objetivo do projeto

O **SmartList** foi criado para facilitar o controle de listas de compras:  

- Cada usuário pode se cadastrar e gerenciar suas próprias listas.  
- Dentro de cada lista é possível adicionar e gerenciar itens.  
- A API garante segurança, persistência e escalabilidade para o app.  

---

## 📌 Observações

- O **app e a API estão em repositórios separados**, mas se comunicam via HTTP.  
- Certifique-se de iniciar a API antes de rodar o app.  
- Ajuste o IP/URL no `ApiService` conforme o ambiente (local ou produção).
