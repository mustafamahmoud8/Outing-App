import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:outing/providers/group_provider.dart';
import 'package:outing/providers/user_profile_provider.dart';
import 'package:outing/theme/app_colors.dart';
import 'package:outing/views/chats/live_map_screen.dart';
import 'package:outing/services/permission_service.dart';
import 'dart:io';

class CommunityChatScreen extends StatefulWidget {
  const CommunityChatScreen({super.key});

  @override
  State<CommunityChatScreen> createState() => _CommunityChatScreenState();
}

class _CommunityChatScreenState extends State<CommunityChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    _addWelcomeMessage();
  }

  void _addWelcomeMessage() {
    _messages.add({
      'text': 'Welcome to Community Chat! Create or join a group to start chatting with friends.',
      'isSystem': true,
      'timestamp': DateTime.now(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<GroupProvider>(
          builder: (context, groupProvider, child) {
            return Text(
              groupProvider.currentGroup != null
                  ? groupProvider.currentGroup!.name
                  : 'Community Chat',
            );
          },
        ),
        actions: [
          Consumer<GroupProvider>(
            builder: (context, groupProvider, child) {
              if (groupProvider.currentGroup != null) {
                return Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.map),
                      tooltip: 'Live Map',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LiveMapScreen(),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.group),
                      tooltip: 'Members',
                      onPressed: () => _showMembersDialog(),
                    ),
                  ],
                );
              }
              return IconButton(
                icon: const Icon(Icons.add),
                tooltip: 'Create/Join Group',
                onPressed: () => _showGroupDialog(),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Group Info Banner
          Consumer<GroupProvider>(
            builder: (context, groupProvider, child) {
              if (groupProvider.currentGroup == null) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  color: AppColors.primary.withOpacity(0.1),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: AppColors.primary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'No active group',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Create or join a group to start chatting',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => _showGroupDialog(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Get Started'),
                      ),
                    ],
                  ),
                );
              }

              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '👥',
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Group ID: ${groupProvider.currentGroup!.id}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${groupProvider.currentGroup!.memberNames.length} members',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.share, color: Colors.white),
                      onPressed: () => _shareGroupId(groupProvider.currentGroup!.id),
                    ),
                  ],
                ),
              );
            },
          ),

          // Messages List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                if (message['isSystem'] == true) {
                  return _buildSystemMessage(message['text']);
                }
                return _buildMessageBubble(
                  message['text'],
                  message['senderName'] ?? 'User',
                  message['isMe'] ?? false,
                );
              },
            ),
          ),

          // Input Area
          Consumer<GroupProvider>(
            builder: (context, groupProvider, child) {
              if (groupProvider.currentGroup == null) {
                return const SizedBox();
              }

              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadowLight,
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.location_on, color: AppColors.primary),
                      tooltip: 'Share Location',
                      onPressed: () => _shareLocation(),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: AppColors.background,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: const BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.send, color: Colors.white),
                        onPressed: _sendMessage,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSystemMessage(String text) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.textSecondary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildMessageBubble(String text, String senderName, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          gradient: isMe ? AppColors.primaryGradient : null,
          color: isMe ? null : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMe)
              Text(
                senderName,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            if (!isMe) const SizedBox(height: 4),
            Text(
              text,
              style: TextStyle(
                color: isMe ? Colors.white : AppColors.textPrimary,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final userProfile = Provider.of<UserProfileProvider>(context, listen: false);
    
    setState(() {
      _messages.add({
        'text': text,
        'senderName': userProfile.fullName,
        'isMe': true,
        'timestamp': DateTime.now(),
      });
    });

    _messageController.clear();
  }

  Future<void> _shareLocation() async {
    try {
      // Check and request location permission
      final hasPermission = await PermissionService.requestLocationWithDialog(context);
      
      if (!hasPermission) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Location permission is required to share your location'),
              backgroundColor: AppColors.error,
            ),
          );
        }
        return;
      }

      // Ensure location services are enabled
      final serviceEnabled = await PermissionService.ensureLocationServiceEnabled(context);
      
      if (!serviceEnabled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please enable location services'),
              backgroundColor: AppColors.error,
            ),
          );
        }
        return;
      }

      // Get current location
      final position = await PermissionService.getCurrentLocation();
      
      if (position == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to get your location'),
              backgroundColor: AppColors.error,
            ),
          );
        }
        return;
      }

      // Add location message
      if (mounted) {
        setState(() {
          _messages.add({
            'text': '📍 Shared live location (${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)})',
            'isSystem': true,
            'timestamp': DateTime.now(),
            'location': {
              'latitude': position.latitude,
              'longitude': position.longitude,
            },
          });
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location shared with group!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      print('Error sharing location: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sharing location: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _showGroupDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Group Options'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.add_circle, color: AppColors.primary),
              title: const Text('Create New Group'),
              onTap: () {
                Navigator.pop(context);
                _showCreateGroupDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.group_add, color: AppColors.secondary),
              title: const Text('Join Existing Group'),
              onTap: () {
                Navigator.pop(context);
                _showJoinGroupDialog();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateGroupDialog() {
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Group'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Group Name',
            hintText: 'e.g., Weekend Outing',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty) {
                final groupProvider = Provider.of<GroupProvider>(context, listen: false);
                final userProfile = Provider.of<UserProfileProvider>(context, listen: false);
                
                await groupProvider.createGroup(nameController.text, userProfile.fullName);
                
                if (mounted) {
                  Navigator.pop(context);
                  setState(() {
                    _messages.add({
                      'text': 'Group created! Share ID: ${groupProvider.currentGroup!.id}',
                      'isSystem': true,
                      'timestamp': DateTime.now(),
                    });
                  });
                }
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showJoinGroupDialog() {
    final idController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Join Group'),
        content: TextField(
          controller: idController,
          decoration: const InputDecoration(
            labelText: 'Group ID',
            hintText: 'Enter 6-digit code',
          ),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (idController.text.isNotEmpty) {
                final groupProvider = Provider.of<GroupProvider>(context, listen: false);
                final userProfile = Provider.of<UserProfileProvider>(context, listen: false);
                
                await groupProvider.joinGroup(idController.text, userProfile.fullName);
                
                if (mounted) {
                  Navigator.pop(context);
                  setState(() {
                    _messages.add({
                      'text': 'Joined group successfully!',
                      'isSystem': true,
                      'timestamp': DateTime.now(),
                    });
                  });
                }
              }
            },
            child: const Text('Join'),
          ),
        ],
      ),
    );
  }

  void _showMembersDialog() {
    final groupProvider = Provider.of<GroupProvider>(context, listen: false);
    final profileProvider = Provider.of<UserProfileProvider>(context, listen: false);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Group Members'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: groupProvider.currentGroup!.memberNames.map((name) {
            // Check if this is the current user
            final isCurrentUser = name == profileProvider.fullName;
            
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.primary.withOpacity(0.1),
                backgroundImage: isCurrentUser && profileProvider.profilePicturePath != null
                    ? FileImage(File(profileProvider.profilePicturePath!))
                    : null,
                child: isCurrentUser && profileProvider.profilePicturePath == null
                    ? Text(
                        name.isNotEmpty ? name[0].toUpperCase() : 'U',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : Text(
                        name.isNotEmpty ? name[0].toUpperCase() : 'U',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
              title: Text(name),
            );
          }).toList(),
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

  void _shareGroupId(String groupId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Group ID: $groupId (Share with friends!)'),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
