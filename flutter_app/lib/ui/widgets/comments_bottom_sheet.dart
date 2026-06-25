import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/comment_model.dart';
import '../../models/user_model.dart';
import '../../services/firestore_service.dart';
import '../../services/auth_service.dart';
import '../../core/constants.dart';
import 'package:google_fonts/google_fonts.dart';

class CommentsBottomSheet extends StatefulWidget {
  final String postId;
  final String postOwnerId;

  const CommentsBottomSheet({
    super.key,
    required this.postId,
    required this.postOwnerId,
  });

  @override
  State<CommentsBottomSheet> createState() => _CommentsBottomSheetState();
}

class _CommentsBottomSheetState extends State<CommentsBottomSheet> {
  final FirestoreService _db = FirestoreService();
  final TextEditingController _commentController = TextEditingController();
  bool _isSubmitting = false;

  void _submitComment() async {
    final currentUser = AuthService().currentUser;
    if (currentUser == null) return;

    final content = _commentController.text.trim();
    if (content.isEmpty) return;

    setState(() => _isSubmitting = true);

    // Capture before async gap to avoid BuildContext-across-async-gaps lint.
    final messenger = ScaffoldMessenger.of(context);
    final focusScope = FocusScope.of(context);

    try {
      final comment = CommentModel(
        postId: widget.postId,
        userId: currentUser.uid,
        content: content,
        createdAt: DateTime.now(),
      );

      await _db.addComment(comment);
      _commentController.clear();
      focusScope.unfocus();
      HapticFeedback.lightImpact();
    } catch (e) {
      debugPrint('Error adding comment: $e');
      messenger.showSnackBar(
        const SnackBar(content: Text('Failed to post comment. Please try again.')),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) return 'Just now';
        return '${difference.inMinutes}m';
      }
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    }
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.75, // Cover 75% of screen
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Drag Handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Replies',
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                  color: Colors.grey[600],
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Comments List
          Expanded(
            child: StreamBuilder<List<CommentModel>>(
              stream: _db.getPostComments(widget.postId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        Text(
                          'No replies yet',
                          style: TextStyle(color: Colors.grey[500], fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Start the conversation!',
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                      ],
                    ),
                  );
                }

                final comments = snapshot.data!;

                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 20),
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    return _buildCommentTile(comment);
                  },
                );
              },
            ),
          ),

          // Input Area
          Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 16, // keyboard support
              top: 12,
              left: 16,
              right: 16,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: isDark ? Colors.transparent : Colors.black.withAlpha(10),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                )
              ],
            ),
            child: Row(
              children: [
                // Input Field
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[800] : Colors.grey[100],
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: _commentController,
                      textCapitalization: TextCapitalization.sentences,
                      maxLines: null,
                      decoration: const InputDecoration(
                        hintText: 'Add a reply...',
                        hintStyle: TextStyle(color: Colors.grey),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: InputBorder.none,
                      ),
                      onChanged: (text) {
                        // Re-build just the send button state if we want real-time disable, 
                        // but simple setState for text length is overkill. 
                        // We rely on the _submitComment empty check instead for simplicity.
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                
                // Send Button
                Container(
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: _isSubmitting 
                        ? const SizedBox(
                            width: 20, height: 20, 
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                          )
                        : const Icon(Icons.arrow_upward, color: Colors.white),
                    onPressed: _isSubmitting ? null : _submitComment,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteComment(CommentModel comment) async {
    if (comment.commentId == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Yorumu sil'),
        content: const Text('Bu yorum kalıcı olarak silinecek. Emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('İptal'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: AppColors.diseased),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Sil'),
          ),
        ],
      ),
    );

    if (!context.mounted) return;
    if (confirm != true) return;

    // Context is guaranteed mounted by the check above; suppress false positive.
    // ignore: use_build_context_synchronously
    final messenger = ScaffoldMessenger.of(context);

    try {
      await _db.deleteComment(comment.commentId!);
      messenger.showSnackBar(
        const SnackBar(content: Text('Yorum silindi')),
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Silme başarısız: $e')),
      );
    }
  }

  Widget _buildCommentTile(CommentModel comment) {
    final currentUid = AuthService().currentUser?.uid;
    final isOwnComment = currentUid != null && currentUid == comment.userId;
    final isPostOwner = currentUid != null && currentUid == widget.postOwnerId;
    final isAccepted = comment.isAcceptedAnswer;

    return FutureBuilder<UserModel?>(
      future: _db.getUser(comment.userId),
      builder: (context, snapshot) {
        final author = snapshot.data;
        final bool isLoading = snapshot.connectionState == ConnectionState.waiting;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
          decoration: isAccepted
              ? BoxDecoration(
                  color: AppColors.healthy.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.healthy.withValues(alpha: 0.4),
                  ),
                )
              : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                if (isLoading)
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: AppColors.primaryLight.withValues(alpha: 0.2),
                  )
                else
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: AppColors.primaryLight.withValues(alpha: 0.2),
                    backgroundImage: author?.profileImageUrl != null
                        ? NetworkImage(author!.profileImageUrl!)
                        : null,
                    child: author?.profileImageUrl == null
                        ? const Icon(Icons.person, size: 20, color: AppColors.primary)
                        : null,
                  ),

                const SizedBox(width: 12),

                // Comment Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            isLoading
                                ? '...'
                                : (author?.name.isNotEmpty ?? false
                                    ? author!.name
                                    : 'User'),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _formatDate(comment.createdAt),
                            style: TextStyle(color: Colors.grey[500], fontSize: 12),
                          ),
                          if (isAccepted) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.healthy.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                '✓ Çözüm',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.healthy,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        comment.content,
                        style: const TextStyle(fontSize: 14, height: 1.3),
                      ),
                    ],
                  ),
                ),

                // Butonlar
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Kabul Et / Geri Al — sadece gönderi sahibi
                    if (isPostOwner)
                      IconButton(
                        icon: Icon(
                          isAccepted
                              ? Icons.check_circle
                              : Icons.check_circle_outline,
                          size: 20,
                          color: isAccepted
                              ? AppColors.healthy
                              : Colors.grey[400],
                        ),
                        tooltip: isAccepted ? 'Çözümü geri al' : 'Çözüm olarak işaretle',
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.only(left: 4),
                        onPressed: () async {
                          if (comment.commentId == null) return;
                          await _db.markAcceptedAnswer(
                              comment.commentId!, !isAccepted);
                        },
                      ),
                    // Sil — sadece kendi yorumunda
                    if (isOwnComment)
                      IconButton(
                        icon: Icon(
                          Icons.delete_outline,
                          size: 18,
                          color: AppColors.diseased.withValues(alpha: 0.7),
                        ),
                        tooltip: 'Yorumu sil',
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.only(left: 4),
                        onPressed: () => _deleteComment(comment),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
