import 'package:flutter/material.dart';
import 'package:mozhi_frontend/constants/app_constants.dart';
import 'package:mozhi_frontend/models/chat_message.dart';

/// ChatBubble - Displays a single chat message
///
/// Features:
/// - Different styling for user vs AI messages
/// - Avatar icon (M for AI, user initial for user)
/// - Copy and check icons for actions
/// - Rounded bubble design
class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        // User messages align right, AI messages align left
        mainAxisAlignment: message.isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AI Avatar (shown on left for AI messages)
          if (!message.isUser) ...[_buildAIAvatar(), const SizedBox(width: 8)],

          // Message Bubble
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isUser
                    ? AppConstants.chatBubbleUser
                    : AppConstants.chatBubbleAI,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Message Text
                  Text(
                    message.text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Action Icons
                  _buildActionIcons(),
                ],
              ),
            ),
          ),

          // User Avatar (shown on right for user messages)
          if (message.isUser) ...[const SizedBox(width: 8), _buildUserAvatar()],
        ],
      ),
    );
  }

  /// Build AI avatar with gradient M logo
  Widget _buildAIAvatar() {
    return Container(
      width: 32,
      height: 32,
      decoration: const BoxDecoration(
        color: AppConstants.mediumGray,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: ShaderMask(
          shaderCallback: (bounds) =>
              AppConstants.logoGradient.createShader(bounds),
          child: const Text(
            'M',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  /// Build user avatar with initial
  Widget _buildUserAvatar() {
    return Container(
      width: 32,
      height: 32,
      decoration: const BoxDecoration(
        color: AppConstants.buttonBlue,
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Text(
          'U', // TODO: Replace with actual user initial from AuthService
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  /// Build action icons (copy, check)
  Widget _buildActionIcons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.check, size: 14, color: Colors.white.withValues(alpha: 0.5)),
        const SizedBox(width: 8),
        Icon(
          Icons.copy_outlined,
          size: 14,
          color: Colors.white.withValues(alpha: 0.5),
        ),
      ],
    );
  }
}
