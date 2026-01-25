import 'package:flutter/material.dart';
import 'package:mozhi_frontend/constants/app_constants.dart';
import 'package:mozhi_frontend/models/chat_message.dart';
import 'package:mozhi_frontend/widgets/chat_bubble.dart';
import 'package:mozhi_frontend/widgets/app_drawer.dart';
import 'package:mozhi_frontend/services/auth_service.dart';
import 'package:mozhi_frontend/screens/auth_screen.dart';

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
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Attachments coming soon')));
  }

  /// Navigate to auth screen
  Future<void> _navigateToAuth({bool isSignUp = true}) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (context) => AuthScreen(isSignUp: isSignUp)),
    );
    if (result == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Welcome, ${_authService.userName}!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // Full AppDrawer widget
      drawer: AppDrawer(
        isLoggedIn: _authService.isLoggedIn,
        userName: _authService.userName,
        userInitial: _authService.userInitial,
        onLoginTap: () => _navigateToAuth(),
        onNewChat: () {
          setState(() => _messages.clear());
        },
        onSettingsTap: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Settings coming soon')));
        },
        onLogoutTap: () async {
          await _authService.logout();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Logged out successfully')),
            );
          }
        },
        chatHistory: const [], // TODO: Connect to actual chat history
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppConstants.primaryDarkBlue,
              const Color(0xFF002A5C),
              AppConstants.primaryDarkBlue,
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
          // Menu Button
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white, size: 28),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
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
              ? GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profile menu coming soon')),
                    );
                  },
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

  /// Build message input area
  Widget _buildInputArea() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Attachment Button
          GestureDetector(
            onTap: _showAttachmentOptions,
            child: Container(
              width: 44,
              height: 44,
              margin: const EdgeInsets.only(right: 8),
              decoration: const BoxDecoration(
                color: AppConstants.inputBackground,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: Colors.white70, size: 24),
            ),
          ),

          // Input Field
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: AppConstants.inputBackground,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Text Input
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Ask anything...',
                        hintStyle: TextStyle(
                          color: Colors.white38,
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                      maxLines: 4,
                      minLines: 1,
                    ),
                  ),

                  // Voice or Send Button
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: _isTyping
                        ? GestureDetector(
                            key: const ValueKey('send'),
                            onTap: _sendMessage,
                            child: Container(
                              width: 36,
                              height: 36,
                              margin: const EdgeInsets.only(left: 8, bottom: 4),
                              decoration: const BoxDecoration(
                                gradient: AppConstants.logoGradient,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.arrow_upward,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          )
                        : IconButton(
                            key: const ValueKey('voice'),
                            icon: const Icon(
                              Icons.mic_none,
                              color: Colors.white70,
                            ),
                            onPressed: _startVoiceInput,
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
