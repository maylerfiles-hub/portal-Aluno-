import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'splashpage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(const PortalApp());
}

class PortalApp extends StatelessWidget {
  const PortalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portal do Aluno',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2456A6)),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      home: const SplashPage(child: LoginPage()),
    );
  }
} // Fim da classe App

// Validação simples para a atividade, sem verificar se o email existe
String? validarEmail(String? valor) {
  final email = (valor ?? '').trim();
  if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) {
    return 'Informe um e-mail válido.';
  }
  return null;
}

String? validarSenha(String? valor) {
  if ((valor ?? '').length < 8) {
    return 'Forneça uma senha com pelo menos 8 caracteres.';
  }
  return null;
}

// Estrutura visual compartilhada pelas duas telas
class PaginaFormulario extends StatelessWidget {
  const PaginaFormulario({
    super.key,
    required this.titulo,
    required this.subtitulo,
    required this.formulario,
  });

  final String titulo;
  final String subtitulo;
  final Widget formulario;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Instituto Horizonte')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    Icons.school_outlined,
                    size: 56,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    titulo,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(subtitulo),
                  const SizedBox(height: 24),
                  formulario,
                  const SizedBox(height: 16),
                  const Text(
                    'Projeto Didático - Sem acesso real',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _senha = TextEditingController();
  bool _ocultarSenha = true;

  void _entrar() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    _senha.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Login simulado! Nenhuma autenticação foi realizada.'),
      ),
    );
  }

  Future<void> _abrirCadastro() async {
    _senha.clear();
    final email = await Navigator.of(context).push<String>(
      MaterialPageRoute<String>(builder: (context) => const CadastroPage()),
    );
    if (!mounted || email == null) return;
    _email.text = email;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Cadastro simulado! E-mail preenchido para testar o login.',
        ),
      ),
    );
  }

  @override
  void dispose() {
    _email.dispose();
    _senha.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PaginaFormulario(
      titulo: 'Portal do Aluno',
      subtitulo: 'Entre para continuar seus estudos.',
      formulario: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autocorrect: false,
              decoration: const InputDecoration(
                labelText: 'E-mail',
                prefixIcon: Icon(Icons.email_outlined),
              ),
              validator: validarEmail,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _senha,
              obscureText: _ocultarSenha,
              autocorrect: false,
              enableSuggestions: false,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _entrar(),
              decoration: InputDecoration(
                labelText: 'Senha',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  tooltip: _ocultarSenha ? 'Mostrar senha' : 'Ocultar senha',
                  icon: Icon(
                    _ocultarSenha ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() => _ocultarSenha = !_ocultarSenha);
                  },
                ),
              ),
              validator: validarSenha,
            ),
            const SizedBox(height: 24),
            FilledButton(onPressed: _entrar, child: const Text('Entrar')),
            TextButton(
              onPressed: _abrirCadastro,
              child: const Text('Não tem conta? Cadastre-se'),
            ),
          ],
        ),
      ),
    );
  }
}

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _formKey = GlobalKey<FormState>();
  final _nome = TextEditingController();
  final _email = TextEditingController();
  final _senha = TextEditingController();
  final _confirmacao = TextEditingController();

  void _cadastrar() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    Navigator.of(context).pop(_email.text.trim());
  }

  @override
  void dispose() {
    _nome.dispose();
    _email.dispose();
    _senha.dispose();
    _confirmacao.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PaginaFormulario(
      titulo: 'Crie sua conta',
      subtitulo: 'Comece sua jornada no Instituto Horizonte.',
      formulario: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nome,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(labelText: 'Nome'),
              validator: (valor) {
                if ((valor ?? '').trim().isEmpty) {
                  return 'Informe seu nome.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autocorrect: false,
              decoration: const InputDecoration(labelText: 'E-mail'),
              validator: validarEmail,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _senha,
              obscureText: true,
              autocorrect: false,
              enableSuggestions: false,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(labelText: 'Senha'),
              validator: validarSenha,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _confirmacao,
              obscureText: true,
              autocorrect: false,
              enableSuggestions: false,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _cadastrar(),
              decoration: const InputDecoration(labelText: 'Confirmar senha'),
              validator: (valor) {
                if (valor != _senha.text) {
                  return 'As senhas não coincidem.';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            FilledButton(onPressed: _cadastrar, child: const Text('Cadastrar')),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Já tenho conta. Voltar ao login'),
            ),
          ],
        ),
      ),
    );
  }
}
