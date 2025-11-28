import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Modelo de dados simplificado para o perfil do usuário
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

  // Construtor que lê o documento do Firestore
  factory UserProfile.fromFirestore(Map<String, dynamic> data, String authEmail) {
    return UserProfile(
      nome: data['nome'] ?? 'Usuário',
      sobrenome: data['sobrenome'] ?? 'Não Informado',
      email: data['email'] ?? authEmail,
      // Você deve garantir que esses campos existam no Firestore se forem obrigatórios
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
    // Inicia a busca dos dados se o usuário estiver logado
    if (firebaseUser != null) {
      _profileFuture = _fetchUserProfile(firebaseUser!.uid);
    } else {
      // Se não houver usuário logado, retorna um erro ou perfil vazio
      _profileFuture = Future.error('Usuário não logado.');
    }
  }

  // Função para buscar os dados no Firestore
  Future<UserProfile> _fetchUserProfile(String uid) async {
    final doc = await FirebaseFirestore.instance.collection('usuario').doc(uid).get();
    String authEmail = firebaseUser?.email ?? 'Email indisponível';

    if (doc.exists) {
      return UserProfile.fromFirestore(doc.data()!, authEmail);
    } else {
      // Cria um perfil básico se o documento não for encontrado, usando o email do Auth
      return UserProfile(
        nome: firebaseUser?.displayName ?? 'Usuário',
        sobrenome: 'Novo',
        email: authEmail,
      );
    }
  }


  // === FUNÇÃO REUTILIZÁVEL ORIGINAL (para campos de DADOS separados) ===
  Widget campoPerfil(String label, String valor, {bool mostrarSeta = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Adiciona padding à esquerda (correção de alinhamento)
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
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                  color: Color(0xFFD9D9D9)
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  // === FUNÇÃO PARA AS LINHAS AGRUPADAS (Segurança) ===
  Widget _buildGroupedRow(String label, String valor, {bool mostrarSeta = true, bool showDivider = true}) {
    return Column(
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
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 20,
                      color: Color(0xFFD9D9D9)
                    ),
                ],
              ),
            ],
          ),
        ),
        
        // Divisor interno
        if (showDivider)
          const Divider(height: 1, color: Color(0xFFEBEBEB), indent: 16, endIndent: 16),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    
    // Se o usuário não estiver logado (e a AuthGuard falhou por algum motivo)
    if (firebaseUser == null) {
      return const Center(child: Text('Acesso negado. Por favor, faça login.'));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      
      // === CORREÇÃO DE LAYOUT: SAFEAREAD ===
      body: SafeArea( 
        // 4. FutureBuilder para dados assíncronos
        child: FutureBuilder<UserProfile>(
          future: _profileFuture,
          builder: (context, snapshot) {
            
            // Estado 1: Carregando
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            // Estado 2: Erro
            if (snapshot.hasError) {
              return Center(child: Text('Erro ao carregar dados: ${snapshot.error}'));
            }

            // Estado 3: Dados Prontos
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

                    // Seção Dados
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Dados',
                        style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 51, 51, 51), fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Divider(),
                    
                    // Mapeamento dos Dados (Usando o objeto carregado)
                    campoPerfil('Nome', userProfile.nome, mostrarSeta: false),
                    campoPerfil('Sobrenome', userProfile.sobrenome, mostrarSeta: false),
                    campoPerfil('CPF', userProfile.cpf, mostrarSeta: false),
                    campoPerfil('Data de Nascimento', userProfile.dataNascimento, mostrarSeta: false),
                    campoPerfil('Telefone', userProfile.telefone, mostrarSeta: false),

                    // Seção Segurança
                    const SizedBox(height: 20),
                    
                    // === CONTAINER BRANCO DE AGRUPAMENTO ===
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 5,
                            offset: const Offset(1, 1),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                            // Título Interno
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
                            
                            // Item Senha (Usando a string estática oculta)
                            _buildGroupedRow('Senha', senhaOculta, mostrarSeta: false, showDivider: true), 
                            
                            // Item Alterar Senha
                            _buildGroupedRow('Alterar senha', '', mostrarSeta: true, showDivider: false), 
                        ],
                      ),
                    ),
                    // ======================================
                    const SizedBox(height: 20),
                  ],
                ),
              );
            }
            
            // Fallback (deve ser tratado pelo hasError, mas é bom ter)
            return const Center(child: Text('Carregando...'));
          },
        ),
      ),
    );
  }
}