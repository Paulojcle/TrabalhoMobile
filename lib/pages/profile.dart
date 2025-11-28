import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'alterar_senha_page.dart'; // <--- IMPORTANTE: Importe a nova página aqui

// ... (Class UserProfile permanece igual) ...
class UserProfile {
  final String nome;
  final String sobrenome;
  final String email;
  final String cpf;
  final String telefone;
  final String dataNascimento;
  final String fotoUrl;

  UserProfile({
    required this.nome,
    required this.sobrenome,
    required this.email,
    this.cpf = 'N/A',
    this.telefone = 'N/A',
    this.dataNascimento = 'N/A',
    this.fotoUrl = '',
  });

  factory UserProfile.fromFirestore(Map<String, dynamic> data, String authEmail) {
    return UserProfile(
      nome: data['nome'] ?? 'Usuário',
      sobrenome: data['sobrenome'] ?? 'Não Informado',
      email: data['email'] ?? authEmail,
      cpf: data['cpf'] ?? 'Não informado',
      telefone: data['telefone'] ?? 'Não informado',
      dataNascimento: data['dataNascimento'] ?? 'Não informada',
      fotoUrl: data['fotoUrl'] ?? '',
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final User? firebaseUser = FirebaseAuth.instance.currentUser;
  late Future<UserProfile> _profileFuture;
  final String senhaOculta = '***********';

  @override
  void initState() {
    super.initState();
    if (firebaseUser != null) {
      _profileFuture = _fetchUserProfile(firebaseUser!.uid);
    } else {
      _profileFuture = Future.error('Usuário não logado.');
    }
  }

  Future<UserProfile> _fetchUserProfile(String uid) async {
    final doc = await FirebaseFirestore.instance.collection('usuario').doc(uid).get();
    String authEmail = firebaseUser?.email ?? 'Email indisponível';

    if (doc.exists) {
      return UserProfile.fromFirestore(doc.data()!, authEmail);
    } else {
      return UserProfile(
        nome: firebaseUser?.displayName ?? 'Usuário',
        sobrenome: 'Novo',
        email: authEmail,
      );
    }
  }

  Widget campoPerfil(String label, String valor, {bool mostrarSeta = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0), 
          child: Text(label, style: const TextStyle(fontSize: 16, color: Color(0xFF333333), fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(valor, style: const TextStyle(fontSize: 16, color: Color(0xFF7F7F7F))),
              if (mostrarSeta)
                const Icon(Icons.arrow_forward_ios, size: 20, color: Color(0xFFD9D9D9)),
            ],
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  // === ATUALIZADO: Agora aceita onTap ===
  Widget _buildGroupedRow(String label, String valor, {bool mostrarSeta = true, bool showDivider = true, VoidCallback? onTap}) {
    return InkWell( // Adicionado InkWell para clique
      onTap: onTap, 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(label, style: const TextStyle(fontSize: 16, color: Color(0xFF333333))),
                Row(
                  children: [
                    Text(valor, style: const TextStyle(fontSize: 16, color: Color(0xFF7F7F7F))),
                    if (mostrarSeta)
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Icon(Icons.arrow_forward_ios, size: 20, color: Color(0xFFD9D9D9)),
                      ),
                  ],
                ),
              ],
            ),
          ),
          if (showDivider)
            const Divider(height: 1, color: Color(0xFFEBEBEB), indent: 16, endIndent: 16),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (firebaseUser == null) {
      return const Center(child: Text('Acesso negado. Por favor, faça login.'));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: SafeArea( 
        child: FutureBuilder<UserProfile>(
          future: _profileFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Erro ao carregar dados: ${snapshot.error}'));
            }
            if (snapshot.hasData) {
              final UserProfile userProfile = snapshot.data!;
              
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                child: Column(
                  children: [
                    // Avatar
                    Center(
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: userProfile.fotoUrl.isNotEmpty
                            ? NetworkImage(userProfile.fotoUrl)
                            : null,
                        child: userProfile.fotoUrl.isEmpty
                            ? const Icon(Icons.person, size: 40, color: Colors.black)
                            : null,
                      ),
                    ),
                    const SizedBox(height: 15),
                    
                    // Nome e Email
                    Text(
                      '${userProfile.nome} ${userProfile.sobrenome}',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      userProfile.email,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 20),

                    // Dados
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Dados',
                        style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 51, 51, 51), fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Divider(),
                    campoPerfil('Nome', userProfile.nome, mostrarSeta: false),
                    campoPerfil('Sobrenome', userProfile.sobrenome, mostrarSeta: false),
                    campoPerfil('CPF', userProfile.cpf, mostrarSeta: false),
                    campoPerfil('Data de Nascimento', userProfile.dataNascimento, mostrarSeta: false),
                    campoPerfil('Telefone', userProfile.telefone, mostrarSeta: false),

                    const SizedBox(height: 20),
                    
                    // Segurança Container
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5, offset: const Offset(1, 1)),
                        ],
                      ),
                      child: Column(
                        children: [
                            Padding(
                                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                        'Segurança',
                                        style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 51, 51, 51), fontWeight: FontWeight.bold),
                                    ),
                                ),
                            ),
                            const Divider(height: 1, color: Color(0xFFEBEBEB)),
                            
                            _buildGroupedRow('Senha', senhaOculta, mostrarSeta: false, showDivider: true), 
                            
                            // === AÇÃO DE CLIQUE AQUI ===
                            _buildGroupedRow(
                              'Alterar senha', 
                              '', 
                              mostrarSeta: true, 
                              showDivider: false,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const AlterarSenhaPage()),
                                );
                              }
                            ), 
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            }
            return const Center(child: Text('Carregando...'));
          },
        ),
      ),
    );
  }
}