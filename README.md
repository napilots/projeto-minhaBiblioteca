# 📚 Aplicativo de Biblioteca

Este projeto utiliza uma arquitetura de **Monorepo**, separando o aplicativo visual (Frontend) da API de dados (Backend).

## 📁 Estrutura de Pastas

- **/frontend:** Aplicativo web desenvolvido em Flutter/Dart. Contém toda a interface do usuário (UI) e lógica de apresentação.
- **/backend:** API REST construída em Node.js com TypeScript, Express e MongoDB.

## 🛠️ Tecnologias Utilizadas

### Backend
- Node.js + TypeScript
- Express (servidor web)
- Mongoose (ODM para MongoDB)
- CORS (compartilhamento de recursos)

### Frontend
- Flutter & Dart
- Docker (containerização)
- Nginx (servidor web estático)

---

## 🚀 Como Rodar o Projeto

### Pré-requisitos Gerais
- **Node.js 18+** (para o backend)
- **npm** (gerenciador de pacotes)
- **MongoDB** rodando localmente (porta 27017)
- **Docker Desktop** (para o frontend)
- **Git** (para clonar o repositório, se necessário)

---

## 1️⃣ Backend (Node.js + TypeScript + MongoDB)

### Passo 1: Instalar Dependências

No terminal, navegue até a pasta do backend:
```bash
cd backend
```

Instale as dependências do Node.js:
```bash
npm install
```

### Passo 2: Configurar MongoDB

Certifique-se de que o MongoDB está rodando na sua máquina. Se estiver usando Docker, execute:

```bash
docker run -d -p 27017:27017 --name mongodb -e MONGO_INITDB_ROOT_USERNAME=admin -e MONGO_INITDB_ROOT_PASSWORD=senha_segura mongo
```

> **Nota:** As credenciais (admin/senha_segura) devem corresponder às configuradas em `src/server.ts`

### Passo 3: Iniciar o Servidor Backend

Execute o servidor:
```bash
npx ts-node src/server.ts
```

Você deverá ver no terminal:
```
📦 Conectado com sucesso ao MongoDB do Docker!
🚀 API da Biblioteca rodando na porta 3000!
```

**API estará disponível em:** `http://localhost:3000`

---

## 🧪 Testando a API com Thunder Client

O Thunder Client é uma extensão do VS Code para testar APIs REST de forma simples e intuitiva.

### Passo 1: Instalar Thunder Client

1. Abra o VS Code
2. Vá para a aba **Extensões** (Ctrl+Shift+X)
3. Pesquise por **Thunder Client**
4. Clique em **Instalar** (extensão oficial por Ranga Vadhineni)

### Passo 2: Abrir Thunder Client

1. Clique no ícone do Thunder Client na barra lateral do VS Code (parece um raio ⚡)
2. Clique em **New Request** para criar uma nova requisição

### Passo 3: Testar os Endpoints

#### 📌 Teste 1: GET - Verificar se a API está rodando
```
Método: GET
URL: http://localhost:3000
```
**Resultado esperado:**
```
🚀 API da Biblioteca rodando com TypeScript!
```

#### 📌 Teste 2: POST - Criar um novo livro
```
Método: POST
URL: http://localhost:3000/livros
Headers: 
  - Content-Type: application/json
Body (JSON):
{
  "nome": "O Senhor dos Anéis",
  "autor": "J.R.R. Tolkien"
}
```

#### 📌 Teste 3: GET - Listar todos os livros
```
Método: GET
URL: http://localhost:3000/livros
```

### 💡 Dicas Úteis

- **Salvar Requisições:** Clique em "Save Request" para guardar suas requisições no Thunder Client
- **Ver Resposta:** A resposta aparece no painel à direita em tempo real
- **Status da Requisição:** Você verá o status HTTP (200, 404, 500, etc.)

---

## 2️⃣ Frontend (Flutter/Dart com Docker)

### Passo 1: Construir a Imagem Docker

No terminal, navegue até a pasta do frontend:
```bash
cd frontend
```

Construa a imagem Docker:
```bash
docker build -t library-app-frontend .
```

> Este comando pode levar alguns minutos na primeira execução, pois precisa baixar o Flutter SDK.

### Passo 2: Executar o Container

Inicie o contêiner mapeando a porta:
```bash
docker run -d -p 8080:80 --name frontend-container library-app-frontend
```

### Passo 3: Acessar a Aplicação

Abra seu navegador e acesse:
```
http://localhost:8080
```

---

## 📋 Resumo de Portas

| Componente | Porta | URL |
|-----------|-------|-----|
| Backend (API) | 3000 | `http://localhost:3000` |
| Frontend (Web) | 8080 | `http://localhost:8080` |
| MongoDB | 27017 | `mongodb://admin:senha_segura@localhost:27017/` |

---

## 🛑 Comandos Úteis

### Parar e remover containers Docker
```bash
# Parar o container do frontend
docker stop frontend-container

# Remover o container
docker rm frontend-container

# Parar o MongoDB
docker stop mongodb

# Remover o MongoDB
docker rm mongodb
```

### Ver logs do backend
```bash
# Se ainda estiver rodando, veja os logs no terminal
# Ou execute novamente com ts-node
```

### Reconstruir imagem Docker (se fizer mudanças no frontend)
```bash
cd frontend
docker build -t library-app-frontend .
```

---

## ⚠️ Resolução de Problemas

### Backend não conecta ao MongoDB
- Verifique se o MongoDB está rodando: `docker ps`
- Verifique as credenciais em `src/server.ts`
- Certifique-se de que a porta 27017 está livre

### Erro ao rodar `npx ts-node`
- Reinstale as dependências: `npm install`
- Limpe cache do npm: `npm cache clean --force`
- Verifique se Node.js 18+ está instalado: `node --version`

### Frontend não carrega no navegador
- Verifique se o container está rodando: `docker ps`
- Verifique a porta: `http://localhost:8080`
- Reconstrua a imagem: `docker build -t library-app-frontend .`

---

## 📝 Notas Adicionais

- Este é um projeto **em desenvolvimento** (monorepo)
- O backend ainda está sendo implementado com mais rotas e funcionalidades
- O frontend é uma aplicação web responsiva
- Ambos os serviços podem rodar simultaneamente em portas diferentes

