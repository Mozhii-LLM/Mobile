import 'package:flutter/material.dart';
import 'package:mozhi_frontend/constants/app_constants.dart';

/// AppDrawer - Navigation drawer for the app
///
/// Features:
/// - User profile section (logged in) or Sign in prompt (logged out)
/// - New Chat button
/// - Chat history list
/// - Settings navigation
/// - Logout option
class AppDrawer extends StatelessWidget {
  final bool isLoggedIn;
  final String userName;
  final String userInitial;
  final VoidCallback onLoginTap;
  final VoidCallback? onNewChat;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onLogoutTap;
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
    this.chatHistory = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppConstants.primaryDarkBlue,
      child: SafeArea(
        child: Column(
          children: [
            // Header with logo
            _buildHeader(),

            const SizedBox(height: 8),

            // New Chat Button
            _buildNewChatButton(context),

            const Divider(color: Colors.white24, height: 24),

            // Chat History Section
            Expanded(
              child: chatHistory.isEmpty
                  ? _buildEmptyHistory()
                  : _buildChatHistoryList(context),
            ),

            const Divider(color: Colors.white24, height: 1),

            // Bottom Section - User Profile / Login
            _buildBottomSection(context),
          ],
        ),
      ),
    );
  }

  /// Build header with logo
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          // Gradient M logo
          ShaderMask(
            shaderCallback: (bounds) =>
                AppConstants.logoGradient.createShader(bounds),
            child: const Text(
              'M',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mozhii',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Tamil AI Assistant',
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build new chat button
  Widget _buildNewChatButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
            onNewChat?.call();
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white24),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.add, color: Colors.white, size: 22),
                SizedBox(width: 12),
                Text(
                  'New Chat',
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
      ),
    );
  }

  /// Build empty history state
  Widget _buildEmptyHistory() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 48,
            color: Colors.white.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 12),
          Text(
            'No chat history',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Start a new conversation',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.3),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  /// Build chat history list
  Widget _buildChatHistoryList(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      itemCount: chatHistory.length,
      itemBuilder: (context, index) {
        final chat = chatHistory[index];
        return _ChatHistoryTile(
          item: chat,
          onTap: () {
            Navigator.pop(context);
            chat.onTap?.call();
          },
        );
      },
    );
  }

  /// Build bottom section with user profile or login prompt
  Widget _buildBottomSection(BuildContext context) {
    return Column(
      children: [
        // Settings
        ListTile(
          leading: const Icon(Icons.settings_outlined, color: Colors.white70),
          title: const Text(
            'Settings',
            style: TextStyle(color: Colors.white70, fontSize: 15),
          ),
          onTap: () {
            Navigator.pop(context);
            onSettingsTap?.call();
          },
        ),

        // User profile or Sign in
        if (isLoggedIn) ...[
          const Divider(color: Colors.white24, height: 1),
          ListTile(
            leading: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppConstants.buttonBlue,
                border: Border.all(color: Colors.white38, width: 1),
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
            title: Text(
              userName,
              style: const TextStyle(color: Colors.white, fontSize: 15),
              overflow: TextOverflow.ellipsis,
            ),
            trailing: IconButton(
              icon: const Icon(Icons.logout, color: Colors.white54, size: 20),
              onPressed: () {
                Navigator.pop(context);
                onLogoutTap?.call();
              },
              tooltip: 'Logout',
            ),
          ),
        ] else ...[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                  onLoginTap();
                },
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: AppConstants.buttonBlue,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Text(
                    'Sign in',
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
          ),
        ],

        const SizedBox(height: 8),
      ],
    );
  }
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

/// Chat history tile widget
class _ChatHistoryTile extends StatelessWidget {
  final ChatHistoryItem item;
  final VoidCallback? onTap;

  const _ChatHistoryTile({required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              const Icon(
                Icons.chat_bubble_outline,
                color: Colors.white54,
                size: 18,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _formatTime(item.timestamp),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.4),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${time.day}/${time.month}/${time.year}';
  }
}
