import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'alterar_senha_page.dart';
import 'editar_perfil_page.dart';
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

  // Cores do Tema (Mesmas da ConfigurationPage para consistência)
  final Color _primaryColor = const Color(0xFF192C50);
  final Color _backgroundColor = const Color(0xFFF8F9FA);
  final Color _cardColor = Colors.white;
  final Color _textColor = const Color(0xFF333333);
  final Color _secondaryTextColor = Colors.grey[600]!;

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
        sobrenome: '',
        email: authEmail,
      );
    }
  }

  // === WIDGET PARA DADOS INDIVIDUAIS (ESTILO CARD) ===
  Widget campoPerfil(String label, String valor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0, bottom: 6), 
          child: Text(
            label, 
            style: TextStyle(
              fontSize: 14, 
              color: _secondaryTextColor, 
              fontWeight: FontWeight.w600
            )
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: _cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            valor, 
            style: TextStyle(
              fontSize: 16, 
              color: _textColor,
              fontWeight: FontWeight.w500
            )
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // === WIDGET PARA LINHAS AGRUPADAS (CLICÁVEIS OU NÃO) ===
  Widget _buildGroupedRow(String label, String valor, {bool mostrarSeta = true, bool showDivider = true, VoidCallback? onTap}) {
    return Material( // Material necessário para o efeito InkWell funcionar sobre o container branco
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap, 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label, 
                    style: TextStyle(fontSize: 15, color: _textColor, fontWeight: FontWeight.w500)
                  ),
                  Row(
                    children: [
                      Text(
                        valor, 
                        style: TextStyle(fontSize: 15, color: _secondaryTextColor)
                      ),
                      if (mostrarSeta)
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey[400]),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            if (showDivider)
              Divider(height: 1, color: Colors.grey[100], indent: 20, endIndent: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (firebaseUser == null) {
      return const Center(child: Text('Acesso negado. Por favor, faça login.'));
    }

    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea( 
        child: FutureBuilder<UserProfile>(
          future: _profileFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(color: _primaryColor));
            }
            if (snapshot.hasError) {
              return Center(child: Text('Erro ao carregar dados.', style: TextStyle(color: Colors.red[300])));
            }
            if (snapshot.hasData) {
              final UserProfile userProfile = snapshot.data!;
              
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
                child: Column(
                  children: [
                    // === SEÇÃO DE CABEÇALHO (AVATAR + NOME) ===
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 4),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey[200],
                            backgroundImage: userProfile.fotoUrl.isNotEmpty
                                ? NetworkImage(userProfile.fotoUrl)
                                : null,
                            child: userProfile.fotoUrl.isEmpty
                                ? Icon(Icons.person_rounded, size: 50, color: Colors.grey[400])
                                : null,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '${userProfile.nome} ${userProfile.sobrenome}',
                          style: TextStyle(
                            fontSize: 24, 
                            fontWeight: FontWeight.bold, 
                            color: _primaryColor,
                            letterSpacing: -0.5
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          userProfile.email,
                          style: TextStyle(fontSize: 14, color: _secondaryTextColor),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 40),

                    // === SEÇÃO DADOS PESSOAIS ===
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Dados Pessoais',
                            style: TextStyle(
                              fontSize: 20, 
                              color: _primaryColor, 
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          
                          // BOTÃO EDITAR
                          TextButton.icon(
                            onPressed: () async {
                              // Navega para a tela de edição e espera o retorno
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditarPerfilPage(perfilAtual: userProfile),
                                ),
                              );

                              // Se retornou 'true' (salvou), recarrega os dados
                              if (result == true) {
                                setState(() {
                                  _profileFuture = _fetchUserProfile(firebaseUser!.uid);
                                });
                              }
                            },
                            icon: Icon(Icons.edit_rounded, size: 18, color: _primaryColor),
                            label: Text("Editar", style: TextStyle(color: _primaryColor, fontWeight: FontWeight.bold)),
                            style: TextButton.styleFrom(
                              backgroundColor: _primaryColor.withOpacity(0.1),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Campos Individuais (Estilo Card)
                    campoPerfil('Nome', userProfile.nome),
                    campoPerfil('Sobrenome', userProfile.sobrenome),
                    campoPerfil('CPF', userProfile.cpf),
                    campoPerfil('Data de Nascimento', userProfile.dataNascimento),
                    campoPerfil('Telefone', userProfile.telefone),

                    const SizedBox(height: 10),
                    
                    // === SEÇÃO SEGURANÇA (CARD AGRUPADO) ===
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, bottom: 10),
                        child: Text(
                          'Segurança',
                          style: TextStyle(
                            fontSize: 20, 
                            color: _primaryColor, 
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),

                    // Container Agrupado
                    Container(
                      clipBehavior: Clip.hardEdge, // Garante que o ripple effect não vaze as bordas arredondadas
                      decoration: BoxDecoration(
                        color: _cardColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                            // Título Interno (Removido ou Simplificado se já tem o externo)
                            // Optei por remover o título interno duplicado para limpar o visual,
                            // já que temos o título "Segurança" do lado de fora agora.
                            
                            _buildGroupedRow('Senha', senhaOculta, mostrarSeta: false, showDivider: true), 
                            
                            // Ação de Alterar Senha
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
                    const SizedBox(height: 30),
                  ],
                ),
              );
            }
            return Center(child: CircularProgressIndicator(color: _primaryColor));
          },
        ),
      ),
    );
  }
}