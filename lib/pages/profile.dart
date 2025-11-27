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
  String? fotoUrl; // null por enquanto, depois Firebase

  // Função reutilizável para campos do perfil
  Widget campoPerfil(String label, String valor, {bool mostrarSeta = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, color: Colors.grey)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 233, 230, 230),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(valor, style: const TextStyle(fontSize: 16)),
              if (mostrarSeta)
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                  color: Colors.grey,
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 250),
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
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

            // Seção Dados
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Dados',
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
            ),
            const Divider(),
            campoPerfil('Nome', nome),
            campoPerfil('Sobrenome', sobrenome),
            campoPerfil('CPF', cpf),
            campoPerfil('Data de Nascimento', dataNascimento),
            campoPerfil('Telefone', telefone),

            // Seção Segurança
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Segurança',
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
            ),
            const Divider(),
            campoPerfil('Senha', senha),
            campoPerfil('Alterar senha', '', mostrarSeta: true),
          ],
        ),
      ),
    );
  }
}
