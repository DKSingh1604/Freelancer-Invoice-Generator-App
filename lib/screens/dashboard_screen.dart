import 'package:fig_app/models/client_model.dart';
import 'package:fig_app/models/invoice_model.dart';
import 'package:fig_app/repositories/auth_repository.dart';
import 'package:fig_app/repositories/client_repository.dart';
import 'package:fig_app/repositories/invoice_repository.dart';
import 'package:fig_app/screens/login_screen.dart';
import 'package:fig_app/screens/profile_screen.dart';
import 'package:fig_app/screens/settings_screen.dart';
import 'package:fig_app/utils/client_card.dart';
import 'package:fig_app/utils/invoice_tile.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardScreen extends StatefulWidget {
  final String nickname;
  final String fullname;
  final String company;
  const DashboardScreen({
    super.key,
    required this.nickname,
    required this.fullname,
    required this.company,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _authRepository = AuthRepository();
  List<Client> clients = [];
  List<Invoice> invoices = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final fetchedClients = await ClientRepository().fetchClients();
      final fetchedInvoices = await InvoiceRepository().fetchRecentInvoices();

      setState(() {
        clients = fetchedClients;
        invoices = fetchedInvoices;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.deepPurple, width: 2),
                  ),
                  child: const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: Colors.deepPurple),
                  ),
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: 'Open profile menu',
              ),
        ),
        title: const Text('Dashboard'),
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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reload',
            onPressed: () {
              setState(() {
                _loading = true;
              });
              _fetchData();
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFB388FF), Color(0xFF7C4DFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      color: Colors.deepPurple,
                      size: 40,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'User Profile',
                    style: TextStyle(
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                // Navigate to profile
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => ProfileScreen(
                          nickname: widget.nickname,
                          fullname: widget.fullname,
                          company: widget.company,
                        ),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                // Navigate to settings
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
            ),
            //RECENT INVOICES
            ListTile(
              leading: const Icon(Icons.description),
              title: const Text('Recent Invoices'),
              onTap: () {
                // Navigate to settings
              },
            ),
            //RECENT CLIENTS
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Recent Clients'),
              onTap: () {
                // Navigate to settings
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                _authRepository.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          DefaultTabController(
            length: 2,
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFB388FF), Color(0xFF7C4DFF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const TabBar(
                    indicatorColor: Colors.white,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white70,
                    tabs: [
                      Tab(icon: Icon(Icons.people), text: 'Clients'),
                      Tab(icon: Icon(Icons.receipt_long), text: 'Invoices'),
                    ],
                  ),
                ),
                Expanded(
                  child:
                      _loading
                          ? const Center(child: CircularProgressIndicator())
                          : TabBarView(
                            children: [
                              //CLIENTS TAB
                              clients.isEmpty
                                  ? const Center(
                                    child: Text('No clients found'),
                                  )
                                  : ListView.builder(
                                    itemCount: clients.length,
                                    itemBuilder:
                                        (context, index) =>
                                            ClientCard(client: clients[index]),
                                  ),
                              //INVOICES TAB
                              invoices.isEmpty
                                  ? const Center(
                                    child: Text('No invoices found'),
                                  )
                                  : ListView.builder(
                                    itemCount: invoices.length,
                                    itemBuilder:
                                        (context, index) => InvoiceTile(
                                          invoice: invoices[index],
                                        ),
                                  ),
                            ],
                          ),
                ),
              ],
            ),
          ),
          _ExpandableAddButton(
            onAddInvoice: () {
              // TODO: Navigate to create invoice screen
            },
            onAddClient: () {
              // TODO: Navigate to add client screen
            },
          ),
        ],
      ),
    );
  }

  void _showMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white.withOpacity(0.93),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder:
          (context) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.person, color: Colors.deepPurple),
                  title: const Text('Profile'),
                  onTap: () {
                    // Navigate to profile
                    Navigator.pop(context);
                    // Add your navigation logic here
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings, color: Colors.deepPurple),
                  title: const Text('Settings'),
                  onTap: () {
                    Navigator.pop(context);
                    // Add your navigation logic here
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.deepPurple),
                  title: const Text('Logout'),
                  onTap: () {
                    Navigator.pop(context);
                    _authRepository.signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
    );
  }
}

class _ExpandableAddButton extends StatefulWidget {
  final VoidCallback onAddInvoice;
  final VoidCallback onAddClient;
  const _ExpandableAddButton({
    required this.onAddInvoice,
    required this.onAddClient,
  });

  @override
  State<_ExpandableAddButton> createState() => _ExpandableAddButtonState();
}

class _ExpandableAddButtonState extends State<_ExpandableAddButton>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late AnimationController _controller;
  late Animation<double> _expandAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _expandAnim = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _expanded = !_expanded;
      if (_expanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 32,
      left: 0,
      right: 0,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 200, // Ensure enough height for expanded buttons
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // Add Invoice Button
            Positioned(
              bottom: 80,
              child: FadeTransition(
                opacity: _expandAnim,
                child: ScaleTransition(
                  scale: _expandAnim,
                  child: Visibility(
                    visible: _expanded,
                    child: GestureDetector(
                      onTap: () {
                        _toggle();
                        widget.onAddInvoice();
                      },
                      child: _ActionButton(
                        icon: Icons.receipt_long,
                        label: 'Add Invoice',
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Add Client Button
            Positioned(
              bottom: 150,
              child: FadeTransition(
                opacity: _expandAnim,
                child: ScaleTransition(
                  scale: _expandAnim,
                  child: Visibility(
                    visible: _expanded,
                    child: GestureDetector(
                      onTap: () {
                        _toggle();
                        widget.onAddClient();
                      },
                      child: _ActionButton(
                        icon: Icons.person_add,
                        label: 'Add Client',
                        color: Colors.teal,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Main Add Button
            GestureDetector(
              onTap: _toggle,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(
                  horizontal: 36,
                  vertical: 18,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepPurple.withOpacity(0.18),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                  border: Border.all(color: Colors.deepPurple, width: 2),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedRotation(
                      turns: _expanded ? 0.125 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: const Icon(
                        Icons.add,
                        color: Colors.deepPurple,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _expanded ? 'Close' : 'Add',
                      style: const TextStyle(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.9),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.18),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 22),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
