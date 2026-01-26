import 'package:flutter/material.dart';
import 'package:mozhi_frontend/constants/app_constants.dart';

/// AppDrawer - Navigation drawer matching ChatGPT style
///
/// Features:
/// - New Chat button at top
/// - Terms of Use, Privacy Policy, Settings links
/// - Sign up/login prompt at bottom (when logged out)
/// - User profile section (when logged in)
class AppDrawer extends StatelessWidget {
  final bool isLoggedIn;
  final String userName;
  final String userInitial;
  final VoidCallback onLoginTap;
  final VoidCallback? onNewChat;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onLogoutTap;
  final VoidCallback? onTermsTap;
  final VoidCallback? onPrivacyTap;
  final List<ChatHistoryItem> chatHistory;

  const AppDrawer({
    super.key,
    required this.isLoggedIn,
    required this.userName,
    required this.userInitial,
    required this.onLoginTap,
    this.onNewChat,
    this.onSettingsTap,
    this.onLogoutTap,
    this.onTermsTap,
    this.onPrivacyTap,
    this.chatHistory = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppConstants.primaryDarkBlue,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),

            // New Chat Button
            _buildNewChatButton(context),

            // Divider
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Divider(color: Colors.white24, height: 24),
            ),

            // Menu Links
            _buildMenuLink(
              context,
              'Terms of Use',
              onTap: () {
                Navigator.pop(context);
                onTermsTap?.call();
              },
            ),
            _buildMenuLink(
              context,
              'Privacy Policy',
              onTap: () {
                Navigator.pop(context);
                onPrivacyTap?.call();
              },
            ),
            _buildMenuLink(
              context,
              'Settings',
              onTap: () {
                Navigator.pop(context);
                onSettingsTap?.call();
              },
            ),

            // Spacer to push bottom content down
            const Spacer(),

            // Bottom Section
            _buildBottomSection(context),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  /// Build new chat button with edit/pencil icon
  Widget _buildNewChatButton(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          onNewChat?.call();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Edit/Pencil icon
              SizedBox(
                width: 24,
                height: 24,
                child: CustomPaint(painter: _EditIconPainter()),
              ),
              const SizedBox(width: 12),
              const Text(
                'New chat',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build menu link item
  Widget _buildMenuLink(
    BuildContext context,
    String title, {
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }

  /// Build bottom section with login prompt or user profile
  Widget _buildBottomSection(BuildContext context) {
    if (isLoggedIn) {
      return _buildLoggedInSection(context);
    } else {
      return _buildLoggedOutSection(context);
    }
  }

  /// Build logged out section with sign up prompt
  Widget _buildLoggedOutSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Description text
          Text(
            'Save your chat history, share chats, and personalize your experience.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),

          // Sign up button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
                onLoginTap();
              },
              borderRadius: BorderRadius.circular(28),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: AppConstants.buttonBlue,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: const Text(
                  'Sign up or log in',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build logged in section with user profile
  Widget _buildLoggedInSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // User avatar
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppConstants.logoGradient,
            ),
            child: Center(
              child: Text(
                userInitial,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // User name
          Expanded(
            child: Text(
              userName,
              style: const TextStyle(color: Colors.white, fontSize: 15),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Logout button
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Colors.white.withValues(alpha: 0.5),
              size: 20,
            ),
            onPressed: () {
              Navigator.pop(context);
              onLogoutTap?.call();
            },
          ),
        ],
      ),
    );
  }
}

/// Custom painter for edit/pencil icon like ChatGPT
class _EditIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Draw pencil body (diagonal line)
    final path = Path();
    path.moveTo(size.width * 0.75, size.height * 0.1);
    path.lineTo(size.width * 0.15, size.height * 0.7);
    path.lineTo(size.width * 0.1, size.height * 0.9);
    path.lineTo(size.width * 0.3, size.height * 0.85);
    path.lineTo(size.width * 0.9, size.height * 0.25);

    canvas.drawPath(path, paint);

    // Draw small line for pencil tip
    canvas.drawLine(
      Offset(size.width * 0.15, size.height * 0.7),
      Offset(size.width * 0.3, size.height * 0.85),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Model for chat history items
class ChatHistoryItem {
  final String id;
  final String title;
  final DateTime timestamp;
  final VoidCallback? onTap;

  const ChatHistoryItem({
    required this.id,
    required this.title,
    required this.timestamp,
    this.onTap,
  });
}
