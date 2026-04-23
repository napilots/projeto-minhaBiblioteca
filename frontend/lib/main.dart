import 'package:flutter/material.dart';

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

  void _addBook() {
    if (_titleController.text.isNotEmpty && _authorController.text.isNotEmpty) {
      setState(() {
        _books.add({
          'title': _titleController.text,
          'author': _authorController.text,
        });
        _titleController.clear();
        _authorController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    
    const Color verdeEscuro = Color(0xFF06402B);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Minha Biblioteca', style: TextStyle(fontWeight:FontWeight.bold, color: verdeEscuro), ),
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
            SizedBox(height: 15),
            TextField(
              controller: _authorController,
              decoration: InputDecoration(
                labelText: 'Autor',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            SizedBox(height: 20),
            
            ElevatedButton(
              onPressed: _addBook,
              child: Text('Adicionar Livro'),
              style: ElevatedButton.styleFrom(               
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,              
                fixedSize: Size(180, 45), 
                side: BorderSide(color: Colors.transparent),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            
            SizedBox(height: 20),
            // O Expanded faz com que a lista ocupe o resto do espaço disponível
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