import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Biblioteca - Cadastro de Livros',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF06402B), 
          primary: const Color(0xFF06402B),
        ),
      ),
      home: BookRegistrationPage(),
    );
  }
}

class BookRegistrationPage extends StatefulWidget {
  @override
  _BookRegistrationPageState createState() => _BookRegistrationPageState();
}

class _BookRegistrationPageState extends State<BookRegistrationPage> {
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  List<Map<String, String>> _books = [];

  @override
  void initState() {
    super.initState();
    _fetchBooks();
  }

  Future<void> _fetchBooks() async {
    final url = Uri.parse('http://localhost:3000/livros');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> dadosDoBanco = json.decode(response.body);
        
        setState(() {
          _books = dadosDoBanco.map<Map<String, String>>((livro) {
            return {
              'id': livro['_id']?.toString() ?? '', 
              'title': livro['nome']?.toString() ?? 'Nome não encontrado',
              'author': livro['autor']?.toString() ?? 'Autor não encontrado',
            };
          }).toList();
        });
      } else {
        debugPrint('Erro no servidor Node: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Erro de conexão ao buscar livros: $e');
    }
  }

  Future<void> _addBook() async {
    if (_titleController.text.isNotEmpty && _authorController.text.isNotEmpty) {
      final url = Uri.parse('http://localhost:3000/livros');

      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'nome': _titleController.text,   
            'autor': _authorController.text,
          }),
        );

        if (response.statusCode == 201) {
          setState(() {
            _books.add({
              'id': json.decode(response.body)['_id']?.toString() ?? '',
              'title': _titleController.text,
              'author': _authorController.text,
            });
            _titleController.clear();
            _authorController.clear();
          });

          // Fecha a janelinha flutuante automaticamente após salvar!
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Livro salvo no MongoDB! 🌿'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          debugPrint('Erro no servidor: ${response.body}');
        }
      } catch (e) {
        debugPrint('Erro de conexão: $e');
      }
    }
  }

  Future<void> _deleteBook(String id, int index) async {
    final url = Uri.parse('http://localhost:3000/livros/$id');

    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        setState(() {
          _books.removeAt(index);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Livro apagado da biblioteca! 🗑️'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } catch (e) {
      debugPrint('Erro ao deletar: $e');
    }
  }

  // --- NOVA FUNÇÃO: Cria a Janelinha Flutuante (Modal) ---
  void _abrirJanelinhaCadastro() {
    // Limpa os campos sempre que abrir a janela
    _titleController.clear();
    _authorController.clear();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Cadastrar Novo Livro', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.grey),
                onPressed: () => Navigator.of(context).pop(), // Botão de fechar (X)
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min, // Faz a janela ter o tamanho exato dos campos
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Título',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _authorController,
                decoration: InputDecoration(
                  labelText: 'Autor',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: _addBook,
                style: ElevatedButton.styleFrom(               
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,              
                  fixedSize: const Size(180, 45), 
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Salvar Livro', style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 10), // Dá um espacinho em baixo do botão
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color verdeEscuro = Color(0xFF06402B);
    
    return Scaffold(
      backgroundColor: Colors.grey[100], // Fundo levemente cinza para destacar os cards
      appBar: AppBar(
        title: const Text('Minha Biblioteca', style: TextStyle(fontWeight: FontWeight.bold, color: verdeEscuro)),
        backgroundColor: Colors.green,
        centerTitle: true,
        elevation: 0,
      ),
      
      // O botão que vai abrir a sua janelinha flutuante!
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _abrirJanelinhaCadastro,
        backgroundColor: verdeEscuro,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Adicionar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 80.0, vertical: 20.0),
        child: _books.isEmpty 
          ? const Center(child: Text('Nenhum livro na biblioteca ainda. 📚', style: TextStyle(fontSize: 18, color: Colors.grey)))
          : ListView.builder(
              itemCount: _books.length,
              itemBuilder: (context, index) {
                // Design de Card mais moderno
                return Card( 
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.book, color: Colors.green),
                      ),
                      title: Text(_books[index]['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      subtitle: Text('Autor: ${_books[index]['author']!}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        tooltip: 'Apagar',
                        onPressed: () {
                          _deleteBook(_books[index]['id']!, index);
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
      ),
    );
  }
}