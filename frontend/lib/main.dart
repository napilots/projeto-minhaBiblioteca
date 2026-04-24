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

  // Função que envia o livro para o Banco de Dados
  Future<void> _addBook() async {
    if (_titleController.text.isNotEmpty && _authorController.text.isNotEmpty) {
      
      // IMPORTANTE: 'host.docker.internal' faz a ponte entre o Container e seu Windows
      final url = Uri.parse('http://host.docker.internal:3000/livros');

      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'nome': _titleController.text,   // Deve bater com o seu Model no Node
            'autor': _authorController.text,
          }),
        );

        if (response.statusCode == 201) {
          setState(() {
            _books.add({
              'title': _titleController.text,
              'author': _authorController.text,
            });
            _titleController.clear();
            _authorController.clear();
          });

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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Não foi possível falar com o servidor Node.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color verdeEscuro = Color(0xFF06402B);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minha Biblioteca', style: TextStyle(fontWeight:FontWeight.bold, color: verdeEscuro), ),
        backgroundColor: Colors.green,
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 80.0, vertical: 20.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Título',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _authorController,
              decoration: InputDecoration(
                labelText: 'Autor',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addBook,
              style: ElevatedButton.styleFrom(               
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,              
                fixedSize: const Size(180, 45), 
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Adicionar Livro'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _books.length,
                itemBuilder: (context, index) {
                  return Card( 
                    child: ListTile(
                      title: Text(_books[index]['title']!),
                      subtitle: Text('Autor: ${_books[index]['author']!}'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}