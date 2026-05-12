// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp()); // Correção const
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Correção const

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Biblioteca - Cadastro de Livros',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple, 
        ),
      ),
      home: const BookRegistrationPage(), // Correção const
    );
  }
}

class BookRegistrationPage extends StatefulWidget {
  const BookRegistrationPage({super.key}); // Correção const

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
        
        // Verifica se a tela ainda existe antes de atualizar
        if (!mounted) return; 

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
          
          if (!mounted) return; // Correção de BuildContext assíncrono

          setState(() {
            _books.add({
              'id': json.decode(response.body)['_id']?.toString() ?? '',
              'title': _titleController.text,
              'author': _authorController.text,
            });
            _titleController.clear();
            _authorController.clear();
          });

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
        
        if (!mounted) return; // Correção de BuildContext assíncrono

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

  void _abrirJanelinhaCadastro() {
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
              const Text('Cadastrar novo livro', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.grey),
                onPressed: () => Navigator.of(context).pop(), 
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min, 
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
                  backgroundColor: Colors.deepPurple, 
                  foregroundColor: Colors.white,              
                  fixedSize: const Size(180, 45), 
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Salvar Livro', style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 10), 
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, 
      
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min, 
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2), // Correção do Opacity
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.menu_book_rounded, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 12), 
            Text(
              'Minha Biblioteca', 
              style: GoogleFonts.poppins( 
                fontWeight: FontWeight.w700, 
                color: Colors.white, 
                letterSpacing: 1.0,
                fontSize: 22,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent, 
        centerTitle: true,
        elevation: 0, 
      ),
      
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _abrirJanelinhaCadastro,
        backgroundColor: Colors.deepPurpleAccent, 
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Adicionar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.deepPurple.shade900, 
              Colors.indigo.shade500,     
              Colors.blue.shade400,       
            ],
          ),
        ),
        child: SafeArea( 
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 80.0, vertical: 20.0),
            child: _books.isEmpty 
              ? const Center(child: Text('Nenhum livro na biblioteca ainda. 📚', style: TextStyle(fontSize: 18, color: Colors.white70)))
              : ListView.builder(
                  itemCount: _books.length,
                  itemBuilder: (context, index) {
                    return Card( 
                      elevation: 4, 
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.deepPurple.withValues(alpha: 0.1), // Correção do Opacity
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.auto_stories, color: Colors.deepPurple), 
                          ),
                          title: Text(_books[index]['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
                          subtitle: Text('Autor: ${_books[index]['author']!}', style: const TextStyle(color: Colors.black54)),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
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
        ),
      ),
    );
  }
}