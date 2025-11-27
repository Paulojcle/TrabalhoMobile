import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Variáveis que futuramente virão do Firebase
  String nome = 'Fulano';
  String sobrenome = 'Silva';
  String email = 'fulanodetal@email.com';
  String cpf = '001.002.003-4';
  String telefone = '77 9 9999-2211';
  String dataNascimento = '08/12/2003';
  String senha = '***********';
  String? fotoUrl; 

  // === FUNÇÃO REUTILIZÁVEL ORIGINAL (para campos de DADOS separados) ===
  Widget campoPerfil(String label, String valor, {bool mostrarSeta = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, color: Color(0xFF333333), fontWeight: FontWeight.bold)),
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

  // === FUNÇÃO PARA AS LINHAS AGRUPADAS (Sem fundo, com divisor interno) ===
  Widget _buildGroupedRow(String label, String valor, {bool mostrarSeta = true}) {
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
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      
      body: SingleChildScrollView(
        // Padding lateral ajustado
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
        child: Column(
          children: [
            // Avatar
            Center(
              child: CircleAvatar(
                radius: 40,
                backgroundImage: fotoUrl != null
                    ? NetworkImage(fotoUrl!)
                    : null,
                child: fotoUrl == null
                    ? const Icon(Icons.person, size: 40, color: Colors.black)
                    : null,
              ),
            ),
            const SizedBox(height: 15),
            // Nome e Email
            Text(
              nome,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              email,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            // Seção Dados (Mantém o estilo de cards separados)
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Dados',
                style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 51, 51, 51), fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(),
            campoPerfil('Nome', nome, mostrarSeta: false),
            campoPerfil('Sobrenome', sobrenome, mostrarSeta: false),
            campoPerfil('CPF', cpf, mostrarSeta: false),
            campoPerfil('Data de Nascimento', dataNascimento, mostrarSeta: false),
            campoPerfil('Telefone', telefone, mostrarSeta: false),

            // Seção Segurança
            const SizedBox(height: 20),
            
            // === CONTAINER BRANCO DE AGRUPAMENTO COM O TÍTULO INTERNO ===
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
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
                    // ==============================

                    // Item Senha (com divisor)
                    _buildGroupedRow('Senha', senha, mostrarSeta: false), 
                    
                    // Item Alterar Senha (sem divisor, é o último)
                    _buildGroupedRow('Alterar senha', '', mostrarSeta: true), 
                ],
              ),
            ),
            // ==========================================================
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}