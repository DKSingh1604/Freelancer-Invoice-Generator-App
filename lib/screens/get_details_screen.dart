import 'package:fig_app/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GetDetailsScreen extends StatefulWidget {
  const GetDetailsScreen({super.key});

  @override
  State<GetDetailsScreen> createState() => _GetDetailsScreenState();
}

class _GetDetailsScreenState extends State<GetDetailsScreen> {
  final List<_QuestionStep> _steps = [
    _QuestionStep(
      question: 'What should we call you? (Nickname)',
      hint: 'e.g. Sam',
      icon: Icons.tag_faces,
      key: 'nickname',
    ),
    _QuestionStep(
      question: 'What is your full name?',
      hint: 'e.g. Samuel Johnson',
      icon: Icons.person,
      key: 'fullname',
    ),
    _QuestionStep(
      question: 'What is your company name?',
      hint: 'e.g. Acme Corp',
      icon: Icons.business,
      key: 'company',
    ),
  ];
  int _currentStep = 0;
  final Map<String, String> _answers = {};
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _nextStep() async {
    final answer = _controller.text.trim();
    if (answer.isEmpty) return;
    setState(() async {
      _answers[_steps[_currentStep].key] = answer;
      _controller.clear();
      if (_currentStep < _steps.length - 1) {
        _currentStep++;
      } else {
        // All done, upload to Supabase
        final user = Supabase.instance.client.auth.currentUser;
        if (user != null) {
          await Supabase.instance.client.from('users').upsert({
            'id': user.id,
            'nickname': _answers['nickname'] ?? '',
            'full_name': _answers['fullname'] ?? '',
            'company': _answers['company'] ?? '',
          });
        }
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                backgroundColor: Colors.deepPurple.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                  side: BorderSide(color: Colors.deepPurple.shade200, width: 2),
                ),
                title: Row(
                  children: [
                    Icon(Icons.celebration, color: Colors.deepPurple, size: 28),
                    const SizedBox(width: 8),
                    const Text(
                      'Thank you!',
                      style: TextStyle(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                content: Text(
                  "Details saved! \n\nNickname: '${_answers['nickname']}'\nFull Name: '${_answers['fullname']}'\nCompany: '${_answers['company']}'\n\n[Details can be changed in future.]",
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
                actions: [
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 10,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => DashboardScreen(
                                nickname: _answers['nickname'] ?? '',
                                fullname: _answers['fullname'] ?? '',
                                company: _answers['company'] ?? '',
                              ),
                        ),
                      );
                    },
                    child: const Text(
                      'OK',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
        );
      }
    });
    // Scroll to bottom for new message
    Future.delayed(const Duration(milliseconds: 200), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Let’s get to know you!'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.deepPurple,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFB388FF), Color(0xFF7C4DFF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFF3E5F5), Color(0xFFE1BEE7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(24),
                    children: [
                      for (int i = 0; i <= _currentStep; i++)
                        _ChatBubble(
                          icon: _steps[i].icon,
                          text: _steps[i].question,
                          isBot: true,
                        ),
                      for (int i = 0; i < _currentStep; i++)
                        _ChatBubble(
                          text: _answers[_steps[i].key] ?? '',
                          isBot: false,
                        ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurple.withOpacity(0.08),
                        blurRadius: 16,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            hintText: _steps[_currentStep].hint,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: Color(0xFF7C4DFF),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: Color(0xFF7C4DFF),
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          onSubmitted: (_) => _nextStep(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7C4DFF),
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(14),
                          elevation: 4,
                          shadowColor: Colors.deepPurple.withOpacity(0.2),
                        ),
                        onPressed: _nextStep,
                        child: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestionStep {
  final String question;
  final String hint;
  final IconData icon;
  final String key;
  const _QuestionStep({
    required this.question,
    required this.hint,
    required this.icon,
    required this.key,
  });
}

class _ChatBubble extends StatelessWidget {
  final String text;
  final IconData? icon;
  final bool isBot;
  const _ChatBubble({required this.text, this.icon, this.isBot = false});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color:
              isBot ? Colors.deepPurple.withOpacity(0.12) : Colors.deepPurple,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (isBot && icon != null) ...[
              Icon(icon, color: Colors.deepPurple, size: 22),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Text(
                text,
                style: TextStyle(
                  color: isBot ? Colors.deepPurple.shade900 : Colors.white,
                  fontWeight: isBot ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
