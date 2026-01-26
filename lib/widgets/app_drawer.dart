import 'package:flutter/material.dart';
import 'package:mozhi_frontend/constants/app_constants.dart';

/// AppDrawer - Navigation drawer with different states
///
/// Logged Out: New chat, Terms, Privacy, Settings, Sign up button
/// Logged In: Search bar, New chat button, Chat history, Profile
class AppDrawer extends StatefulWidget {
  final bool isLoggedIn;
  final String userName;
  final String userEmail;
  final String userInitial;
  final VoidCallback onLoginTap;
  final VoidCallback? onNewChat;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onLogoutTap;
  final VoidCallback? onTermsTap;
  final VoidCallback? onPrivacyTap;
  final List<ChatHistoryItem> chatHistory;
  final Function(ChatHistoryItem)? onChatTap;

  const AppDrawer({
    super.key,
    required this.isLoggedIn,
    required this.userName,
    required this.userEmail,
    required this.userInitial,
    required this.onLoginTap,
    this.onNewChat,
    this.onSettingsTap,
    this.onLogoutTap,
    this.onTermsTap,
    this.onPrivacyTap,
    this.chatHistory = const [],
    this.onChatTap,
  });

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ChatHistoryItem> get _filteredChats {
    if (_searchQuery.isEmpty) return widget.chatHistory;
    return widget.chatHistory
        .where(
          (chat) =>
              chat.title.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppConstants.primaryDarkBlue,
      child: SafeArea(
        child: widget.isLoggedIn
            ? _buildLoggedInDrawer(context)
            : _buildLoggedOutDrawer(context),
      ),
    );
  }

  /// ========== LOGGED OUT DRAWER ==========
  Widget _buildLoggedOutDrawer(BuildContext context) {
    return Column(
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
            widget.onTermsTap?.call();
          },
        ),
        _buildMenuLink(
          context,
          'Privacy Policy',
          onTap: () {
            Navigator.pop(context);
            widget.onPrivacyTap?.call();
          },
        ),
        _buildMenuLink(
          context,
          'Settings',
          onTap: () {
            Navigator.pop(context);
            widget.onSettingsTap?.call();
          },
        ),

        const Spacer(),

        // Sign up prompt
        _buildSignUpPrompt(context),

        const SizedBox(height: 24),
      ],
    );
  }

  /// ========== LOGGED IN DRAWER ==========
  Widget _buildLoggedInDrawer(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),

        // Search bar + New Chat button row
        _buildSearchRow(context),

        const SizedBox(height: 12),

        // Mozhii main option (like ChatGPT in the screenshot)
        _buildMozhiiOption(context),

        const SizedBox(height: 8),

        // Your chats section
        Expanded(child: _buildChatHistorySection(context)),

        // Divider before profile
        const Divider(color: Colors.white24, height: 1),

        // Profile section at bottom
        _buildProfileSection(context),

        const SizedBox(height: 8),
      ],
    );
  }

  /// Mozhii main option (like ChatGPT option in screenshot)
  Widget _buildMozhiiOption(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
            widget.onNewChat?.call();
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                // Mozhii logo
                ShaderMask(
                  shaderCallback: (bounds) =>
                      AppConstants.logoGradient.createShader(bounds),
                  child: const Text(
                    'M',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Mozhii',
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

  /// Search bar + New Chat button
  Widget _buildSearchRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          // Search bar
          Expanded(
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 14),
                  Icon(
                    Icons.search,
                    color: Colors.white.withValues(alpha: 0.5),
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                      decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: TextStyle(
                          color: Colors.white.withValues(alpha: 0.4),
                          fontSize: 15,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      onChanged: (value) {
                        setState(() => _searchQuery = value);
                      },
                    ),
                  ),
                  if (_searchQuery.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Icon(
                          Icons.close,
                          color: Colors.white.withValues(alpha: 0.5),
                          size: 18,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 10),

          // New Chat button
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              widget.onNewChat?.call();
            },
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: SizedBox(
                  width: 22,
                  height: 22,
                  child: CustomPaint(painter: _EditIconPainter()),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Chat history section with "Your chats" header
  Widget _buildChatHistorySection(BuildContext context) {
    final chats = _filteredChats;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // "Your chats" header
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Text(
            'Your chats',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        // Chat list
        Expanded(
          child: chats.isEmpty
              ? _buildEmptyChats()
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    final chat = chats[index];
                    return _ChatHistoryTile(
                      item: chat,
                      onTap: () {
                        Navigator.pop(context);
                        widget.onChatTap?.call(chat);
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }

  /// Empty chats state
  Widget _buildEmptyChats() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 40,
            color: Colors.white.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 12),
          Text(
            _searchQuery.isEmpty ? 'No chats yet' : 'No matching chats',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.4),
              fontSize: 14,
            ),
          ),
          if (_searchQuery.isEmpty) ...[
            const SizedBox(height: 4),
            Text(
              'Start a new conversation',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.3),
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Profile section at bottom
  Widget _buildProfileSection(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          // Show profile options
          _showProfileMenu(context);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              // User avatar with gradient
              Container(
                width: 38,
                height: 38,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppConstants.logoGradient,
                ),
                child: Center(
                  child: Text(
                    widget.userInitial,
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
                  widget.userName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // More options icon
              Icon(
                Icons.more_horiz,
                color: Colors.white.withValues(alpha: 0.5),
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Show full settings bottom sheet (ChatGPT style)
  void _showProfileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            // Handle bar and header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Column(
                children: [
                  // Handle bar
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Header with title and close button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 40), // Spacer for centering
                      const Text(
                        'Settings',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Scrollable content
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  // Profile section
                  _buildProfileHeader(),
                  const SizedBox(height: 32),
                  // Account section
                  _buildSectionHeader('Account'),
                  const SizedBox(height: 8),
                  _buildSettingsCard([
                    _buildSettingsItem(
                      icon: Icons.mail_outline,
                      title: 'Email',
                      trailing: Text(
                        widget.userEmail,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.5),
                          fontSize: 14,
                        ),
                      ),
                    ),
                    _buildDivider(),
                    _buildSettingsItem(
                      icon: Icons.language,
                      title: 'Language',
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'English',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.5),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.chevron_right,
                            color: Colors.white.withValues(alpha: 0.3),
                            size: 20,
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.pop(context); // Close bottom sheet
                        Navigator.pop(context); // Close drawer
                        widget.onSettingsTap?.call();
                      },
                    ),
                  ]),
                  const SizedBox(height: 24),
                  // App section
                  _buildSectionHeader('App'),
                  const SizedBox(height: 8),
                  _buildSettingsCard([
                    _buildSettingsItem(
                      icon: Icons.info_outline,
                      title: 'About Mozhii',
                      trailing: Icon(
                        Icons.chevron_right,
                        color: Colors.white.withValues(alpha: 0.3),
                        size: 20,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        _showAboutDialog(context);
                      },
                    ),
                    _buildDivider(),
                    _buildSettingsItem(
                      icon: Icons.description_outlined,
                      title: 'Terms of Use',
                      trailing: Icon(
                        Icons.chevron_right,
                        color: Colors.white.withValues(alpha: 0.3),
                        size: 20,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        widget.onTermsTap?.call();
                      },
                    ),
                    _buildDivider(),
                    _buildSettingsItem(
                      icon: Icons.privacy_tip_outlined,
                      title: 'Privacy Policy',
                      trailing: Icon(
                        Icons.chevron_right,
                        color: Colors.white.withValues(alpha: 0.3),
                        size: 20,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        widget.onPrivacyTap?.call();
                      },
                    ),
                  ]),
                  const SizedBox(height: 32),
                  // Logout button
                  _buildLogoutButton(context),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Profile header with avatar, name, email
  Widget _buildProfileHeader() {
    return Column(
      children: [
        // Large avatar
        Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppConstants.logoGradient,
          ),
          child: Center(
            child: Text(
              widget.userInitial,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 32,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // User name
        Text(
          widget.userName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        // Email as subtitle
        Text(
          widget.userEmail,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.5),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 16),
        // Edit profile button
        OutlinedButton(
          onPressed: () {
            // TODO: Implement edit profile
            Navigator.pop(context);
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          ),
          child: const Text('Edit profile'),
        ),
      ],
    );
  }

  /// Section header text
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.5),
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// Card container for settings items
  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(children: children),
    );
  }

  /// Individual settings item
  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 22),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              if (trailing != null) trailing,
            ],
          ),
        ),
      ),
    );
  }

  /// Divider between settings items
  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 52),
      child: Divider(height: 1, color: Colors.white.withValues(alpha: 0.1)),
    );
  }

  /// Logout button
  Widget _buildLogoutButton(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pop(context); // Close bottom sheet
          Navigator.pop(context); // Close drawer
          widget.onLogoutTap?.call();
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout, color: Colors.red.shade400, size: 20),
              const SizedBox(width: 8),
              Text(
                'Log out',
                style: TextStyle(
                  color: Colors.red.shade400,
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

  /// About dialog
  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppConstants.logoGradient,
              ),
              child: const Center(
                child: Text(
                  'M',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Mozhii',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Version 1.0.0',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Mozhii is a Tamil language AI assistant designed to help you communicate and learn in Tamil.',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 14,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  /// ========== SHARED WIDGETS ==========

  /// New chat button (for logged out state)
  Widget _buildNewChatButton(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          widget.onNewChat?.call();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
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

  /// Menu link item (for logged out state)
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

  /// Sign up prompt (for logged out state)
  Widget _buildSignUpPrompt(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Save your chat history, share chats, and personalize your experience.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
                widget.onLoginTap();
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
}

/// Custom painter for edit/pencil icon
class _EditIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(size.width * 0.75, size.height * 0.1);
    path.lineTo(size.width * 0.15, size.height * 0.7);
    path.lineTo(size.width * 0.1, size.height * 0.9);
    path.lineTo(size.width * 0.3, size.height * 0.85);
    path.lineTo(size.width * 0.9, size.height * 0.25);

    canvas.drawPath(path, paint);

    canvas.drawLine(
      Offset(size.width * 0.15, size.height * 0.7),
      Offset(size.width * 0.3, size.height * 0.85),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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
              Icon(
                Icons.chat_bubble_outline,
                color: Colors.white.withValues(alpha: 0.5),
                size: 18,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item.title,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
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
