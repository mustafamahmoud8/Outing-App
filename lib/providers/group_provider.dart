import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Group {
  final String id;
  final String name;
  final List<String> memberIds;
  final List<String> memberNames;
  final DateTime createdAt;
  String? meetingPoint;

  Group({
    required this.id,
    required this.name,
    required this.memberIds,
    required this.memberNames,
    required this.createdAt,
    this.meetingPoint,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'memberIds': memberIds,
        'memberNames': memberNames,
        'createdAt': createdAt.toIso8601String(),
        'meetingPoint': meetingPoint,
      };

  factory Group.fromJson(Map<String, dynamic> json) => Group(
        id: json['id'],
        name: json['name'],
        memberIds: List<String>.from(json['memberIds']),
        memberNames: List<String>.from(json['memberNames']),
        createdAt: DateTime.parse(json['createdAt']),
        meetingPoint: json['meetingPoint'],
      );
}

class GroupProvider with ChangeNotifier {
  List<Group> _groups = [];
  Group? _currentGroup;
  static const String _storageKey = 'user_groups';

  List<Group> get groups => _groups;
  Group? get currentGroup => _currentGroup;

  GroupProvider() {
    _loadGroups();
  }

  Future<void> _loadGroups() async {
    final prefs = await SharedPreferences.getInstance();
    final groupsJson = prefs.getString(_storageKey);
    if (groupsJson != null) {
      final List<dynamic> decoded = json.decode(groupsJson);
      _groups = decoded.map((g) => Group.fromJson(g)).toList();
      notifyListeners();
    }
  }

  Future<void> _saveGroups() async {
    final prefs = await SharedPreferences.getInstance();
    final groupsJson = json.encode(_groups.map((g) => g.toJson()).toList());
    await prefs.setString(_storageKey, groupsJson);
  }

  String generateGroupId() {
    return DateTime.now().millisecondsSinceEpoch.toString().substring(7);
  }

  Future<void> createGroup(String groupName, String userName) async {
    final groupId = generateGroupId();
    final group = Group(
      id: groupId,
      name: groupName,
      memberIds: [DateTime.now().millisecondsSinceEpoch.toString()],
      memberNames: [userName],
      createdAt: DateTime.now(),
    );
    
    _groups.add(group);
    _currentGroup = group;
    await _saveGroups();
    notifyListeners();
  }

  Future<void> joinGroup(String groupId, String userName) async {
    // In a real app, this would sync with backend
    // For now, we'll create a local group
    final existingGroup = _groups.where((g) => g.id == groupId).firstOrNull;
    
    if (existingGroup != null) {
      existingGroup.memberNames.add(userName);
      existingGroup.memberIds.add(DateTime.now().millisecondsSinceEpoch.toString());
      _currentGroup = existingGroup;
    } else {
      final group = Group(
        id: groupId,
        name: 'Group $groupId',
        memberIds: [DateTime.now().millisecondsSinceEpoch.toString()],
        memberNames: [userName],
        createdAt: DateTime.now(),
      );
      _groups.add(group);
      _currentGroup = group;
    }
    
    await _saveGroups();
    notifyListeners();
  }

  void setCurrentGroup(Group group) {
    _currentGroup = group;
    notifyListeners();
  }

  Future<void> leaveGroup(String groupId) async {
    _groups.removeWhere((g) => g.id == groupId);
    if (_currentGroup?.id == groupId) {
      _currentGroup = null;
    }
    await _saveGroups();
    notifyListeners();
  }

  Future<void> setMeetingPoint(String location) async {
    if (_currentGroup != null) {
      _currentGroup!.meetingPoint = location;
      await _saveGroups();
      notifyListeners();
    }
  }
}
