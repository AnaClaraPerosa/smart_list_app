# 📱 SmartList — Organize suas listas de compras de forma simples 🛒

SmartList é um aplicativo mobile desenvolvido em **Flutter**, integrado a uma **API REST Ruby on Rails** com banco **PostgreSQL**.  
O objetivo do app é permitir que cada usuário crie e gerencie suas listas de compras de forma rápida, intuitiva e eficiente.

---

## 🛠 Tecnologias utilizadas

### **Frontend (Mobile)**

- Flutter
- Dart

### **Backend (API)**

- Ruby on Rails
- Devise (autenticação)
- PostgreSQL
- Docker (opcional)

---

## 🗄️ Estrutura do Banco de Dados

A API utiliza um banco **PostgreSQL** com as seguintes entidades:

### 🔹 **users**

- Armazena os dados de autenticação.
- Campos: `id`, `email`, `encrypted_password`, timestamps.

### 🔹 **shopping_lists**

- Cada usuário pode ter várias listas de compras.
- Campos: `id`, `name`, `user_id`, timestamps.

### 🔹 **items**

- Itens registrados dentro de uma lista.
- Campos: `id`, `name`, `quantity`, `purchased`, `shopping_list_id`.

---

## 📲 Como rodar o app Flutter

### 1️⃣ Clone o repositório

```bash
git clone https://github.com/seu-usuario/smart_list_app.git
cd smartlist-app
```

### 2️⃣ Instale as dependências

```bash
flutter pub get
```

### 3️⃣ Configure a URL da API  

No arquivo:  

´´´
lib/services/api_service.dart
´´´

Ajuste:

```dart
const String baseUrl = "http://localhost:3000";
```

Ou passe por parâmetro no run:

```bash
flutter run --dart-define=API_URL=http://192.xxx.x.xx:3000
```

### 4️⃣ Execute o app

```bash
flutter run
```

---

## 🌐 Como rodar a API Rails

> A API está em repositório separado.

### 1️⃣ Clone o projeto

```bash
git clone https://github.com/AnaClaraPerosa/SmartList.git
cd smartlist-api
```

### 2️ Instale as dependências

```bash
bundle install
```

### 3️⃣ Configure e crie o banco

```bash
rails db:create db:migrate db:seed
```

### 4️⃣ Inicie o servidor

```bash
rails s
```

A API estará disponível em:

´´´
<http://localhost:3000>

´´´

---

## 🐳 Rodando a API com Docker (opcional)

```bash
docker compose up --build
```

A API subirá automaticamente no container e o PostgreSQL será inicializado.

---

## 🎯 Objetivo do projeto

O SmartList foi criado para:

✔ Facilitar a criação de listas de compras  
✔ Permitir adicionar, editar e marcar itens como comprados  
✔ Oferecer autenticação segura de usuários  
✔ Criar um fluxo simples e intuitivo do início ao fim  

---

## 📌 Observações importantes

- App e API estão em repositórios separados.  
- Sempre inicie a API antes de abrir o app Flutter.  
- Ajuste a URL no `ApiService` conforme seu ambiente.  
