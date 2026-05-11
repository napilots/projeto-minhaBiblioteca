# 📚 Aplicativo de Biblioteca

Este projeto utiliza uma arquitetura de **Monorepo**, separando o aplicativo visual (Frontend) da API de dados (Backend). O frontend foi reestruturado para rodar localmente, aproveitando o poder do Hot Reload para um desenvolvimento mais rápido.

## 📁 Estrutura de Pastas

- **/frontend:** Aplicativo web desenvolvido em Flutter/Dart. Contém toda a interface do usuário (UI), integração com a API e lógica de apresentação.
- **/backend:** API REST construída em Node.js com TypeScript, Express e MongoDB.

## 🛠️ Tecnologias Utilizadas

### Backend
- Node.js + TypeScript
- Express (servidor web)
- Mongoose (ODM para MongoDB)
- CORS (compartilhamento de recursos)

### Frontend
- Flutter & Dart (Web)
- Google Chrome (para depuração)

---

## 🚀 Como Rodar o Projeto

### Pré-requisitos Gerais
- **Node.js 18+** (para o backend)
- **Flutter SDK** instalado e configurado no PATH do sistema
- **Google Chrome** (para rodar a interface web)
- **Docker Desktop** (apenas para rodar o banco de dados MongoDB)
- **VS Code** com as extensões do Thunder Client e Flutter

---

## 1️⃣ Banco de Dados e Backend (Node.js + MongoDB)

### Passo 1: Iniciar o Banco de Dados (MongoDB via Docker)

Certifique-se de que o Docker está aberto na sua máquina e execute o comando abaixo para criar o banco de dados:

```bash
docker run -d -p 27017:27017 --name mongodb -e MONGO_INITDB_ROOT_USERNAME=admin -e MONGO_INITDB_ROOT_PASSWORD=senha_segura mongo
```

> **Nota:** Se o container `mongodb` já existir, basta iniciá-lo com `docker start mongodb`.

### Passo 2: Configurar e Rodar o Backend

Abra um terminal, navegue até a pasta do backend e instale as dependências:
```bash
cd backend
npm install
```

Execute o servidor:
```bash
npx ts-node src/server.ts
```

Você deverá ver no terminal:
```text
📦 Conectado com sucesso ao MongoDB do Docker!
🚀 API da Biblioteca rodando na porta 3000!
```

---

## 2️⃣ Frontend (Flutter Web)

Como o Flutter agora está instalado na sua máquina, você não precisa mais esperar contêineres carregarem. O processo é instantâneo.

### Passo 1: Preparar o ambiente

Abra um **novo terminal** (deixando o backend rodando no anterior) e navegue até a pasta do frontend:
```bash
cd frontend
flutter pub get
```

### Passo 2: Executar a Aplicação

Inicie o site no Google Chrome com o seguinte comando:
```bash
flutter run -d chrome
```

O Google Chrome abrirá automaticamente com o seu aplicativo de Biblioteca.

### ⚡ A Mágica do Hot Reload
Com o aplicativo rodando, você pode fazer alterações no código do Flutter no VS Code. Ao salvar o arquivo (`Ctrl + S`) ou apertar a tecla `r` no terminal, a interface visual será atualizada **imediatamente** no navegador, sem precisar reiniciar nada!

---

## 📋 Resumo de Portas e Endereços

| Componente | Porta/URL |
|-----------|-----|
| **Backend (API)** | `http://localhost:3000` |
| **Frontend (Web)** | Dinâmica (o Flutter informará a URL no terminal, ex: `localhost:5134`) |
| **MongoDB** | `mongodb://admin:senha_segura@localhost:27017/` |

---

## 🧪 Testando a API com Thunder Client

O Thunder Client é uma excelente ferramenta para testar rotas sem depender do frontend.

1. Abra a extensão no VS Code (ícone de raio ⚡).
2. Clique em **New Request**.

#### 📌 Rotas Disponíveis para Teste:

* **Listar Livros (GET):** `http://localhost:3000/livros`
* **Criar Livro (POST):** `http://localhost:3000/livros`
    * *Aba Body (JSON):* `{"nome": "Jantar Secreto", "autor": "Raphael Montes"}`
* **Deletar Livro (DELETE):** `http://localhost:3000/livros/COLOQUE_O_ID_AQUI`

---

## 🛑 Comandos Úteis

### Gerenciamento do Banco de Dados
```bash
# Iniciar o banco de dados (se já foi criado antes)
docker start mongodb

# Parar o banco de dados temporariamente
docker stop mongodb
```

### Limpeza e Manutenção do Frontend
Se a interface ficar em branco ou apresentar erros de cache no navegador, rode:
```bash
cd frontend
flutter clean
flutter pub get
flutter run -d chrome
```

---

## ⚠️ Resolução de Problemas

### Backend não conecta ao MongoDB
- Verifique se o Docker está aberto e o container do banco está rodando: `docker ps`
- Verifique se as senhas no `server.ts` batem com as do container.

### Erro "Cannot read properties of null (reading 'append')" no Frontend
- O cache do navegador está em conflito com o código do Flutter. Encerre o aplicativo no terminal (`q`), rode `flutter clean`, depois `flutter pub get` e rode novamente.

### Livros não aparecem na tela (Tela Branca)
- Garanta que o backend está rodando em outro terminal simultaneamente.
- Aperte `Ctrl + Shift + R` no Google Chrome para limpar o cache da página.