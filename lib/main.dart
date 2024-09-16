import 'dart:convert'; // Importação necessária para usar JSON
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart'; // Framework Flutter
import 'package:http/http.dart' as http; // Para realizar chamadas HTTP

void main() {
  runApp(const MyApp()); 
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Users', // Título do app
      theme: ThemeData(
        // Estilo geral da aplicação
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 36, 4, 58)), // Cor principal do app
        useMaterial3: true,
      ),
      home: const UserListScreen(), // Tela inicial do app
    );
  }
}

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<dynamic> users = []; // Lista para armazenar os usuários

  // Função para buscar os dados da API
  Future<void> fetchUsers() async {
    final response = await http.get(Uri.parse("https://jsonplaceholder.typicode.com/users"));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      setState(() {
        users = jsonResponse; // Atualiza a lista de usuários com os dados da API
      });
    } else {
      // Se a requisição falhar, imprime o status do erro
      if (kDebugMode) {
        print('Request failed with status: ${response.statusCode}.');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUsers(); // Busca os usuários quando o estado é inicializado
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Barra de título personalizada
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Users', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: users.isEmpty
          ? const Center(
              child: CircularProgressIndicator(), // Exibe um indicador de progresso enquanto os dados não carregam
            )
          : ListView.builder(
              itemCount: users.length, // Define o número de itens com base na lista de usuários
              itemBuilder: (BuildContext context, int index) {
                final user = users[index];

                return Card(
                  margin: const EdgeInsets.all(10.0), // Espaçamento ao redor de cada cartão
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0), // Cantos arredondados
                    side: const BorderSide(color: Colors.black12, width: 1), // Bordas suaves
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0), // Espaçamento interno do cartão
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // Alinhamento à esquerda
                      children: [
                        // Título e nome do usuário em RichText
                        _buildRichText('Name: ', user['name']),
                        const SizedBox(height: 8),
                        _buildRichText('Username: ', user['username']),
                        _buildRichText('Email: ', user['email']),
                        _buildRichText('Phone: ', user['phone']),
                        _buildRichText('Website: ', user['website']),
                        const SizedBox(height: 10),
                        const Text(
                          'Address:',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        _buildRichText('Street: ', user['address']['street']),
                        _buildRichText('Suite: ', user['address']['suite']),
                        _buildRichText('City: ', user['address']['city']),
                        _buildRichText('Zipcode: ', user['address']['zipcode']),
                        _buildRichText('Geo: Lat: ', user['address']['geo']['lat'] + ', Lng: ' + user['address']['geo']['lng']),
                        const SizedBox(height: 10),
                        const Text(
                          'Company:',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        _buildRichText('Name: ', user['company']['name']),
                        _buildRichText('Catchphrase: ', user['company']['catchPhrase']),
                        _buildRichText('BS: ', user['company']['bs']),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  // Função que constrói RichText para exibir título em negrito e valor em texto normal
  RichText _buildRichText(String title, String value) {
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: title,
            style: const TextStyle(
              fontWeight: FontWeight.bold, // Negrito para o título
              color: Colors.black87, // Cor preta
            ),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(
              fontWeight: FontWeight.normal, // Texto normal para o valor
              color: Colors.black54, // Cor levemente acinzentada
            ),
          ),
        ],
      ),
    );
  }
}
