import 'package:flutter/material.dart';
import 'package:mozhi_frontend/constants/app_constants.dart';
import 'package:mozhi_frontend/models/chat_message.dart';
import 'package:mozhi_frontend/widgets/chat_bubble.dart';
import 'package:mozhi_frontend/widgets/app_drawer.dart';
import 'package:mozhi_frontend/services/auth_service.dart';
import 'package:mozhi_frontend/screens/auth_screen.dart';
import 'package:mozhi_frontend/screens/settings_screen.dart';

/// HomeScreen - The main chat interface
///
/// Features:
/// - Top bar with menu, logo, and profile/signup button
/// - Chat messages area with ChatBubble widgets
/// - Input field with attachment and voice buttons
/// - Empty state shows large M logo
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final AuthService _authService = AuthService();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _messageController.addListener(_onTextChanged);
    _authService.addListener(_onAuthChanged);
  }

  @override
  void dispose() {
    _messageController.removeListener(_onTextChanged);
    _authService.removeListener(_onAuthChanged);
    _messageController.dispose();
    super.dispose();
  }

  void _onAuthChanged() {
    if (mounted) setState(() {});
  }

  void _onTextChanged() {
    final isCurrentlyTyping = _messageController.text.trim().isNotEmpty;
    if (isCurrentlyTyping != _isTyping) {
      setState(() {
        _isTyping = isCurrentlyTyping;
      });
    }
  }

  /// Send a message and simulate AI response
  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      // Add user message
      _messages.add(
        ChatMessage(
          text: _messageController.text,
          isUser: true,
          timestamp: DateTime.now(),
        ),
      );
    });

    final userMessage = _messageController.text;
    _messageController.clear();

    // Simulate AI response after delay
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _messages.add(
            ChatMessage(
              text:
                  'This is a demo response to: "$userMessage"\n\nMozhii AI will respond here once connected to the backend.',
              isUser: false,
              timestamp: DateTime.now(),
            ),
          );
        });
      }
    });
  }

  void _startVoiceInput() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Voice input coming soon')));
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      isScrollControlled: true,
      builder: (context) => _AttachmentOptionsSheet(
        onOptionTap: (option) {
          Navigator.pop(context);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('$option coming soon')));
        },
      ),
    );
  }

  /// Show logout confirmation dialog
  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Log out',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Are you sure you want to log out?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Close dialog
              await _authService.logout();
              if (mounted) {
                setState(() {
                  _messages.clear();
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logged out successfully')),
                );
              }
            },
            child: Text(
              'Log out',
              style: TextStyle(color: Colors.red.shade400),
            ),
          ),
        ],
      ),
    );
  }

  /// Show user profile bottom sheet
  void _showUserProfileSheet() {
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
                        'User Profile',
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
                  // Profile header with avatar
                  _buildProfileHeader(),
                  const SizedBox(height: 32),
                  // Account section
                  _buildUserSectionHeader('Account'),
                  const SizedBox(height: 8),
                  _buildUserSettingsCard([
                    _buildUserSettingsItem(
                      icon: Icons.mail_outline,
                      title: 'Email',
                      trailing: Text(
                        _authService.userEmail,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.5),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 24),
                  // App section
                  _buildUserSectionHeader('App'),
                  const SizedBox(height: 8),
                  _buildUserSettingsCard([
                    _buildUserSettingsItem(
                      icon: Icons.info_outline,
                      title: 'About Mozhii',
                      trailing: Icon(
                        Icons.chevron_right,
                        color: Colors.white.withValues(alpha: 0.3),
                        size: 20,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        _showAboutDialog();
                      },
                    ),
                    _buildUserDivider(),
                    _buildUserSettingsItem(
                      icon: Icons.description_outlined,
                      title: 'Terms of Use',
                      trailing: Icon(
                        Icons.chevron_right,
                        color: Colors.white.withValues(alpha: 0.3),
                        size: 20,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Terms of Use coming soon')),
                        );
                      },
                    ),
                    _buildUserDivider(),
                    _buildUserSettingsItem(
                      icon: Icons.privacy_tip_outlined,
                      title: 'Privacy Policy',
                      trailing: Icon(
                        Icons.chevron_right,
                        color: Colors.white.withValues(alpha: 0.3),
                        size: 20,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Privacy Policy coming soon')),
                        );
                      },
                    ),
                  ]),
                  const SizedBox(height: 32),
                  // Logout button
                  _buildUserLogoutButton(),
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
              _authService.userInitial,
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
          _authService.userName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        // Email as subtitle
        Text(
          _authService.userEmail,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.5),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 16),
        // Edit profile button
        OutlinedButton(
          onPressed: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Edit profile coming soon')),
            );
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

  /// Section header text for user profile sheet
  Widget _buildUserSectionHeader(String title) {
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

  /// Card container for user settings items
  Widget _buildUserSettingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(children: children),
    );
  }

  /// Divider for user settings
  Widget _buildUserDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Divider(
        color: Colors.white.withValues(alpha: 0.1),
        height: 1,
      ),
    );
  }

  /// Settings item for user profile sheet
  Widget _buildUserSettingsItem({
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

  /// Logout button for user profile sheet
  Widget _buildUserLogoutButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          _showLogoutConfirmation();
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: 0.15),
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

  /// Show about dialog
  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            ShaderMask(
              shaderCallback: (bounds) =>
                  AppConstants.logoGradient.createShader(bounds),
              child: const Text(
                'M',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Mozhii',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: const Text(
          'Tamil AI Assistant\n\nVersion 1.0.0\n\nMozhii helps you communicate and learn in Tamil with the power of AI.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: Colors.white70)),
          ),
        ],
      ),
    );
  }

  /// Navigate to auth screen
  Future<void> _navigateToAuth({bool isSignUp = true}) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (context) => AuthScreen(isSignUp: isSignUp)),
    );
    if (result == true && mounted) {
      setState(() {
        _messages.clear(); // Clear chat history on login
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Welcome, ${_authService.userName}!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // Full AppDrawer widget - ChatGPT style
      drawer: AppDrawer(
        isLoggedIn: _authService.isLoggedIn,
        userName: _authService.userName,
        userEmail: _authService.userEmail,
        userInitial: _authService.userInitial,
        onLoginTap: () => _navigateToAuth(),
        onNewChat: () {
          setState(() => _messages.clear());
        },
        onSettingsTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const SettingsScreen()),
          );
        },
        onLogoutTap: () => _showLogoutConfirmation(),
        onTermsTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Terms of Use coming soon')),
          );
        },
        onPrivacyTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Privacy Policy coming soon')),
          );
        },
        chatHistory: const [], // TODO: Connect to actual chat history
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
             Color.fromARGB(255, 0, 4, 8),
               Color.fromARGB(255, 3, 18, 40), // Very dark blue-black
              Color.fromARGB(255, 8, 31, 73),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top Bar
              _buildTopBar(),

              // Chat Area
              Expanded(
                child: _messages.isEmpty
                    ? _buildEmptyState()
                    : _buildChatList(),
              ),

              // Input Area
              _buildInputArea(),
            ],
          ),
        ),
      ),
    );
  }

  /// Build top navigation bar
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Menu Button - Double line style like ChatGPT
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _scaffoldKey.currentState?.openDrawer(),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 44,
                height: 44,
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 20,
                      height: 2,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: 14,
                      height: 2,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Logo
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

          // Sign up / Profile Button
          _authService.isLoggedIn
              ? Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      _showUserProfileSheet();
                    },
                    borderRadius: BorderRadius.circular(20),
                    splashColor: Colors.white.withValues(alpha: 0.2),
                    highlightColor: Colors.white.withValues(alpha: 0.1),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        color: AppConstants.buttonBlue,
                      ),
                      child: Center(
                        child: Text(
                          _authService.userInitial,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : GestureDetector(
                  onTap: () => _navigateToAuth(isSignUp: true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppConstants.buttonBlue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Sign up',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  /// Build empty state with large logo
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ShaderMask(
            shaderCallback: (bounds) =>
                AppConstants.logoGradient.createShader(bounds),
            child: const Text(
              'M',
              style: TextStyle(
                fontSize: 120,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Ask me anything...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  /// Build chat messages list
  Widget _buildChatList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        return ChatBubble(message: _messages[index]);
      },
    );
  }

  /// Build message input area - ChatGPT style
  Widget _buildInputArea() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Attachment Button (+ icon) with ripple effect
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _showAttachmentOptions,
              borderRadius: BorderRadius.circular(20),
              splashColor: Colors.white.withValues(alpha: 0.2),
              highlightColor: Colors.white.withValues(alpha: 0.1),
              child: Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.only(right: 8, bottom: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add, color: Colors.white70, size: 24),
              ),
            ),
          ),

          // Input Field with mic and send
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Text Input
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      decoration: const InputDecoration(
                        hintText: 'Ask anything',
                        hintStyle: TextStyle(
                          color: Colors.white38,
                          fontSize: 16,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                      maxLines: 4,
                      minLines: 1,
                    ),
                  ),

                  // Mic button (always visible)
                  GestureDetector(
                    onTap: _startVoiceInput,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Icon(
                        Icons.mic_none,
                        color: Colors.white.withValues(alpha: 0.4),
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Send Button - dull when empty, blooms instantly when typing
          GestureDetector(
            onTap: _isTyping ? _sendMessage : null,
            child: Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.only(bottom: 4),
              decoration: BoxDecoration(
                gradient: _isTyping ? AppConstants.logoGradient : null,
                color: _isTyping ? null : Colors.white.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_upward,
                color: _isTyping
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.3),
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Attachment options bottom sheet - ChatGPT style
class _AttachmentOptionsSheet extends StatefulWidget {
  final Function(String) onOptionTap;

  const _AttachmentOptionsSheet({required this.onOptionTap});

  @override
  State<_AttachmentOptionsSheet> createState() =>
      _AttachmentOptionsSheetState();
}

class _AttachmentOptionsSheetState extends State<_AttachmentOptionsSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) =>
                          AppConstants.logoGradient.createShader(bounds),
                      child: const Text(
                        'Mozhii',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Divider
              Divider(color: Colors.white.withValues(alpha: 0.1), height: 1),
              // Options list
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: [
                    _buildOption(
                      icon: Icons.auto_awesome_outlined,
                      title: 'Create image',
                      subtitle: 'Visualize anything',
                      delay: 0,
                    ),
                    _buildOption(
                      icon: Icons.lightbulb_outline,
                      title: 'Thinking',
                      subtitle: 'Think longer for better answers',
                      delay: 1,
                    ),
                    _buildOption(
                      icon: Icons.rocket_launch_outlined,
                      title: 'Deep research',
                      subtitle: 'Get a detailed report',
                      delay: 2,
                    ),
                    _buildOption(
                      icon: Icons.language,
                      title: 'Web search',
                      subtitle: 'Find real-time news and info',
                      delay: 3,
                    ),
                    _buildOption(
                      icon: Icons.school_outlined,
                      title: 'Study and learn',
                      subtitle: 'Learn a new concept',
                      delay: 4,
                    ),
                    _buildOption(
                      icon: Icons.attach_file_outlined,
                      title: 'Add files',
                      subtitle: 'Analyze or summarize',
                      delay: 5,
                    ),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required int delay,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 200 + (delay * 50)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 10 * (1 - value)),
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: () => widget.onOptionTap(title),
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            children: [
              // Icon without background
              SizedBox(
                width: 32,
                height: 32,
                child: Icon(
                  icon,
                  color: Colors.white.withValues(alpha: 0.85),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              // Text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 13,
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
}
