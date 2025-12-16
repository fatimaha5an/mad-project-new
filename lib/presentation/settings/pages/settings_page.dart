import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spotify/domain/entities/authentication/user.dart';
import 'package:spotify/presentation/auth/pages/auth_page.dart';
import 'package:spotify/core/theme/color_scheme_cubit.dart';

// --- ALDRICH COLOR PALETTE (Control Deck) ---
class _AldrichColors {
  static const voidBlack = Color(0xFF001219);
  static const midnightGreen = Color(0xFF005F73);
  static const cambridgeBlue = Color(0xFF94D2BD);
  static const champagnePink = Color(0xFFE9D8A6);
  static const gamboge = Color(0xFFEE9B00);
  static const rubyRed = Color(0xFF9B2226);
}

class SettingsPage extends StatefulWidget {
  final UserEntity? userEntity;
  
  const SettingsPage({super.key, this.userEntity});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _autoPlayEnabled = true;

  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const AuthPage()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error signing out: $e"),
            backgroundColor: _AldrichColors.rubyRed,
          ),
        );
      }
    }
  }

  Future<void> _clearCache() async {
    // Simulated cache clear
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("/// CACHE PURGED SUCCESSFULLY"),
          backgroundColor: _AldrichColors.midnightGreen,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final email = widget.userEntity?.email ?? 
                  FirebaseAuth.instance.currentUser?.email ?? 
                  "user@quavo.io";

    return Scaffold(
      backgroundColor: _AldrichColors.voidBlack,
      appBar: AppBar(
        backgroundColor: _AldrichColors.voidBlack,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _AldrichColors.champagnePink),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "CONTROL DECK",
          style: TextStyle(
            color: _AldrichColors.champagnePink,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                // User Info Header
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    border: Border.all(color: _AldrichColors.midnightGreen),
                    color: _AldrichColors.midnightGreen.withOpacity(0.1),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: _AldrichColors.gamboge, width: 2),
                        ),
                        child: const Icon(Icons.person, color: _AldrichColors.gamboge),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "OPERATOR_ID",
                              style: TextStyle(
                                color: _AldrichColors.cambridgeBlue,
                                fontSize: 10,
                                letterSpacing: 1.5,
                                fontFamily: 'Monospace',
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              email,
                              style: const TextStyle(
                                color: _AldrichColors.champagnePink,
                                fontSize: 14,
                                fontFamily: 'Monospace',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Section: Display
                _buildSectionHeader("DISPLAY_SETTINGS"),
                BlocBuilder<ColorSchemeCubit, ColorSchemeState>(
                  builder: (context, state) {
                    return _buildToggleItem(
                      icon: state.isDark ? Icons.dark_mode : Icons.light_mode,
                      label: state.isDark ? "DARK_MODE" : "LIGHT_MODE",
                      value: state.isDark,
                      onChanged: (val) {
                        context.read<ColorSchemeCubit>().toggleScheme();
                      },
                    );
                  },
                ),
                _buildDivider(),

                // Section: Notifications
                _buildSectionHeader("NOTIFICATION_SETTINGS"),
                _buildToggleItem(
                  icon: Icons.notifications_outlined,
                  label: "PUSH_NOTIFICATIONS",
                  value: _notificationsEnabled,
                  onChanged: (val) => setState(() => _notificationsEnabled = val),
                ),
                _buildDivider(),

                // Section: Playback
                _buildSectionHeader("PLAYBACK_SETTINGS"),
                _buildToggleItem(
                  icon: Icons.play_circle_outline,
                  label: "AUTO_PLAY_NEXT",
                  value: _autoPlayEnabled,
                  onChanged: (val) => setState(() => _autoPlayEnabled = val),
                ),
                _buildDivider(),

                // Section: Data
                _buildSectionHeader("DATA_MANAGEMENT"),
                _buildActionItem(
                  icon: Icons.delete_outline,
                  label: "PURGE_CACHE",
                  onTap: _clearCache,
                ),
                _buildDivider(),

                // Section: Info
                _buildSectionHeader("SYSTEM_INFO"),
                _buildInfoItem("VERSION", "1.0.0-alpha"),
                _buildInfoItem("BUILD", "2024.12.16"),
                
                const SizedBox(height: 48),
              ],
            ),
          ),

          // Sign Out Button
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton(
                onPressed: _signOut,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: _AldrichColors.rubyRed, width: 2),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout, color: _AldrichColors.rubyRed),
                    SizedBox(width: 12),
                    Text(
                      "TERMINATE_SESSION",
                      style: TextStyle(
                        color: _AldrichColors.rubyRed,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        fontFamily: 'Monospace',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        "// $title",
        style: TextStyle(
          color: _AldrichColors.gamboge.withOpacity(0.8),
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
          fontFamily: 'Monospace',
        ),
      ),
    );
  }

  Widget _buildToggleItem({
    required IconData icon,
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: _AldrichColors.cambridgeBlue, size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: _AldrichColors.cambridgeBlue,
                fontSize: 14,
                fontFamily: 'Monospace',
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: _AldrichColors.gamboge,
            activeTrackColor: _AldrichColors.gamboge.withOpacity(0.3),
            inactiveThumbColor: _AldrichColors.midnightGreen,
            inactiveTrackColor: _AldrichColors.midnightGreen.withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: _AldrichColors.cambridgeBlue, size: 20),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: _AldrichColors.cambridgeBlue,
                  fontSize: 14,
                  fontFamily: 'Monospace',
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: _AldrichColors.midnightGreen),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: _AldrichColors.cambridgeBlue,
              fontSize: 12,
              fontFamily: 'Monospace',
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: _AldrichColors.midnightGreen,
              fontSize: 12,
              fontFamily: 'Monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      color: _AldrichColors.midnightGreen.withOpacity(0.3),
    );
  }
}
