import express from 'express';
import mongoose from 'mongoose';
import cors from 'cors'; 
import book from './models/book';

const app = express();
const PORT = 3333; 

// Liberando o acesso (CORS)
app.use(cors()); 
app.use(express.json());

const mongoURI = 'mongodb://admin:senha_segura@localhost:27017/';

mongoose.connect(mongoURI)
  .then(() => console.log('📦 Conectado com sucesso ao MongoDB do Docker!'))
  .catch((erro) => console.error('❌ Erro ao conectar no MongoDB:', erro));

// Rota de Leitura (Teste)
app.get('/', (req, res) => {
  res.send('🚀 API da Biblioteca rodando com TypeScript!');
});

// Rota de Criação (POST)
app.post('/livros', async (req, res) => {
  try {
    const novoLivro = new book({
      nome: req.body.nome,
      autor: req.body.autor
    });
    
    await novoLivro.save(); 
    res.status(201).json(novoLivro); 
  } catch (erro) {
    res.status(500).json({ erro: 'Falha ao salvar o livro no banco de dados' });
  }
});

// Rota de Leitura (GET)
app.get('/livros', async (req, res) => {
  try {
    const listaDeLivros = await book.find(); 
    res.status(200).json(listaDeLivros);
  } catch (erro) {
    res.status(500).json({ erro: 'Falha ao buscar os livros no banco de dados' });
  }
});

// Rota de Deleção (DELETE)
app.delete('/livros/:id', async (req, res) => {
  try {
    const idDoLivro = req.params.id;
    await book.findByIdAndDelete(idDoLivro); 
    res.status(200).json({ mensagem: 'Livro deletado com sucesso!' });
  } catch (erro) {
    res.status(500).json({ erro: 'Falha ao deletar o livro' });
  }
});

// O SEGREDO DA REDE: 0.0.0.0 libera para o Flutter e o Navegador acessarem sem bloqueio
app.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 Servidor rodando perfeitamente na porta ${PORT}!`);
  console.log(`🔗 Teste no navegador: http://127.0.0.1:${PORT}/livros`);
});

