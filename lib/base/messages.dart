import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mains/base/text_style.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isUser;
  final ThemeData theme;
  final bool isTyping;
  final VoidCallback? onPlay;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isUser,
    required this.theme,
    this.isTyping = false,
    this.onPlay,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isUser) _buildAvatar(),
        Flexible(
          child: Container(
            margin: EdgeInsets.only(
              top: 8,
              bottom: 8,
              left: isUser ? 50 : 8,
              right: isUser ? 8 : 50,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: isUser ? Colors.red : const Color(0xFFECECEC),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(isUser ? 18 : 4),
                bottomRight: Radius.circular(isUser ? 4 : 18),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(2, 4),
                ),
              ],
            ),
            child:
                isTyping
                    ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TypingDots(
                          color: isUser ? Colors.white : Colors.black87,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "Thinking",
                          style: TextStyles.lato(
                            fontSize: Get.width * 0.03,
                            fontWeight: FontWeight.w800,
                            color: isUser ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    )
                    : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: Text(
                            message,
                            style: TextStyles.lato(
                              fontSize: Get.width * 0.03,
                              fontWeight: FontWeight.w800,
                              color: isUser ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                        if (!isUser && onPlay != null) ...[
                          const SizedBox(width: 8),
                          IconButton(
                            icon: Icon(Icons.play_arrow, color: Colors.orange),
                            tooltip: 'Play with Sarvam',
                            onPressed: onPlay,
                          ),
                        ],
                      ],
                    ),
          ),
        ),
        const SizedBox(width: 8),
        if (isUser) _buildAvatar(),
      ],
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color:
            isUser
                ? theme.colorScheme.primaryContainer
                : theme.colorScheme.secondaryContainer,
        shape: BoxShape.circle,
      ),
      child:
          isUser
              ? const Icon(Icons.person, size: 18, color: Colors.red)
              : Image.asset(
                "assets/images/Mains_logo.png",
                height: Get.width * 0.07,
                color: Colors.red,
              ),
    );
  }
}

class TypingDots extends StatefulWidget {
  final Color color;

  const TypingDots({super.key, required this.color});

  @override
  _TypingDotsState createState() => _TypingDotsState();
}

class _TypingDotsState extends State<TypingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation1;
  late Animation<double> _animation2;
  late Animation<double> _animation3;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();

    _animation1 = Tween<double>(begin: 0, end: 8).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.33, curve: Curves.easeInOut),
      ),
    );
    _animation2 = Tween<double>(begin: 0, end: 8).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.53, curve: Curves.easeInOut),
      ),
    );
    _animation3 = Tween<double>(begin: 0, end: 8).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.73, curve: Curves.easeInOut),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildDot(Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          width: 6,
          height: 6 + animation.value,
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(3),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildDot(_animation1),
        _buildDot(_animation2),
        _buildDot(_animation3),
      ],
    );
  }
}
