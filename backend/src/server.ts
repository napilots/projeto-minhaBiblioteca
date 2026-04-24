import express from 'express';
import mongoose from 'mongoose';
import cors from 'cors'; // <-- 1. Importando o porteiro
import Book from './models/book';
import book from './models/book';

const app = express();
const port = 3000;

// <-- 2. Avisando o servidor para liberar o acesso (Deixe antes das rotas!)
app.use(cors()); 
app.use(express.json());

const mongoURI = 'mongodb://admin:senha_segura@localhost:27017/';

mongoose.connect(mongoURI)
  .then(() => console.log('📦 Conectado com sucesso ao MongoDB do Docker!'))
  .catch((erro) => console.error('❌ Erro ao conectar no MongoDB:', erro));

// ... (O resto do seu código com as rotas continua igualzinho aqui para baixo)

// Rota de Leitura (Teste)
app.get('/', (req, res) => {
  res.send('🚀 API da Biblioteca rodando com TypeScript!');
});

// NOVA ROTA: Rota de Criação (POST)
app.post('/livros', async (req, res) => {
  try {
    // Pega o nome e autor que vieram do pedido
    const novoLivro = new book({
      nome: req.body.nome,
      autor: req.body.autor
    });
    
    // Salva no banco de dados do Docker
    await novoLivro.save(); 
    
    // Responde com sucesso (Status 201: Created) e mostra o livro salvo
    res.status(201).json(novoLivro); 
  } catch (erro) {
    res.status(500).json({ erro: 'Falha ao salvar o livro no banco de dados' });
  }
});

app.listen(port, () => {
  console.log(`Servidor rodando em http://localhost:${port}`);
});