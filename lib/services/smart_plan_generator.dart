import 'package:flutter/material.dart';

class ScheduleItem {
  final String placeName;
  final String category;
  final TimeOfDay startTime;
  final Duration duration;
  final double price;
  final String location;

  ScheduleItem({
    required this.placeName,
    required this.category,
    required this.startTime,
    required this.duration,
    required this.price,
    required this.location,
  });

  TimeOfDay get endTime {
    final totalMinutes = startTime.hour * 60 + startTime.minute + duration.inMinutes;
    return TimeOfDay(hour: totalMinutes ~/ 60, minute: totalMinutes % 60);
  }

  String get timeRange {
    return '${_formatTime(startTime)} - ${_formatTime(endTime)}';
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour > 12 ? time.hour - 12 : (time.hour == 0 ? 12 : time.hour);
    final period = time.hour >= 12 ? 'PM' : 'AM';
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }
}

class SmartPlanGenerator {
  List<ScheduleItem> generateDailyPlan(List<Map<String, dynamic>> places) {
    if (places.isEmpty) return [];

    // Track scheduled places to avoid duplicates
    final Set<String> scheduledPlaceNames = {};
    
    // Categorize places
    final breakfast = places.where((p) => _isBreakfast(p) && !scheduledPlaceNames.contains(p['name'])).toList();
    final lunch = places.where((p) => _isLunch(p) && !scheduledPlaceNames.contains(p['name']) && !_isBreakfast(p)).toList();
    final dinner = places.where((p) => _isDinner(p) && !scheduledPlaceNames.contains(p['name']) && !_isBreakfast(p) && !_isLunch(p)).toList();
    final activities = places.where((p) => _isActivity(p) && !scheduledPlaceNames.contains(p['name'])).toList();
    final shopping = places.where((p) => _isShopping(p) && !scheduledPlaceNames.contains(p['name'])).toList();
    final entertainment = places.where((p) => _isEntertainment(p) && !scheduledPlaceNames.contains(p['name'])).toList();

    List<ScheduleItem> schedule = [];
    TimeOfDay currentTime = const TimeOfDay(hour: 9, minute: 0); // Start at 9 AM

    // Morning: Breakfast
    if (breakfast.isNotEmpty) {
      final place = breakfast.first;
      schedule.add(_createScheduleItem(
        place,
        currentTime,
        const Duration(hours: 1),
      ));
      scheduledPlaceNames.add(place['name']);
      currentTime = _addTime(currentTime, const Duration(hours: 1, minutes: 30));
    }

    // Late Morning: Activity/Museum
    if (activities.isNotEmpty) {
      final place = activities.first;
      schedule.add(_createScheduleItem(
        place,
        currentTime,
        const Duration(hours: 2),
      ));
      scheduledPlaceNames.add(place['name']);
      currentTime = _addTime(currentTime, const Duration(hours: 2, minutes: 30));
    }

    // Afternoon: Lunch
    if (lunch.isNotEmpty) {
      final place = lunch.first;
      schedule.add(_createScheduleItem(
        place,
        currentTime,
        const Duration(hours: 1, minutes: 30),
      ));
      scheduledPlaceNames.add(place['name']);
      currentTime = _addTime(currentTime, const Duration(hours: 2));
    }

    // Afternoon: Shopping/Entertainment
    if (shopping.isNotEmpty) {
      final place = shopping.first;
      schedule.add(_createScheduleItem(
        place,
        currentTime,
        const Duration(hours: 2),
      ));
      scheduledPlaceNames.add(place['name']);
      currentTime = _addTime(currentTime, const Duration(hours: 2, minutes: 30));
    } else if (entertainment.isNotEmpty) {
      final place = entertainment.first;
      schedule.add(_createScheduleItem(
        place,
        currentTime,
        const Duration(hours: 2),
      ));
      scheduledPlaceNames.add(place['name']);
      currentTime = _addTime(currentTime, const Duration(hours: 2, minutes: 30));
    }

    // Evening: Dinner
    if (dinner.isNotEmpty) {
      final place = dinner.first;
      schedule.add(_createScheduleItem(
        place,
        currentTime,
        const Duration(hours: 2),
      ));
      scheduledPlaceNames.add(place['name']);
      currentTime = _addTime(currentTime, const Duration(hours: 2, minutes: 30));
    }

    // Add remaining places (not already scheduled)
    final remaining = places.where((p) => 
      !scheduledPlaceNames.contains(p['name'])
    ).toList();

    for (var place in remaining) {
      if (currentTime.hour < 22) { // Don't schedule after 10 PM
        schedule.add(_createScheduleItem(
          place,
          currentTime,
          const Duration(hours: 1),
        ));
        scheduledPlaceNames.add(place['name']);
        currentTime = _addTime(currentTime, const Duration(hours: 1, minutes: 30));
      }
    }

    return schedule;
  }

  ScheduleItem _createScheduleItem(
    Map<String, dynamic> place,
    TimeOfDay startTime,
    Duration duration,
  ) {
    return ScheduleItem(
      placeName: place['name'] ?? 'Unknown',
      category: place['category'] ?? 'Other',
      startTime: startTime,
      duration: duration,
      price: (place['price'] ?? 0).toDouble(),
      location: place['location'] ?? '',
    );
  }

  TimeOfDay _addTime(TimeOfDay time, Duration duration) {
    final totalMinutes = time.hour * 60 + time.minute + duration.inMinutes;
    return TimeOfDay(hour: totalMinutes ~/ 60, minute: totalMinutes % 60);
  }

  bool _isBreakfast(Map<String, dynamic> place) {
    final name = (place['name'] ?? '').toLowerCase();
    final category = (place['category'] ?? '').toLowerCase();
    return category.contains('cafe') || 
           name.contains('coffee') || 
           name.contains('breakfast') ||
           name.contains('bakery');
  }

  bool _isLunch(Map<String, dynamic> place) {
    final category = (place['category'] ?? '').toLowerCase();
    return category.contains('restaurant') || category.contains('food');
  }

  bool _isDinner(Map<String, dynamic> place) {
    final category = (place['category'] ?? '').toLowerCase();
    return category.contains('restaurant') || category.contains('food');
  }

  bool _isActivity(Map<String, dynamic> place) {
    final category = (place['category'] ?? '').toLowerCase();
    return category.contains('museum') || 
           category.contains('park') || 
           category.contains('activity');
  }

  bool _isShopping(Map<String, dynamic> place) {
    final category = (place['category'] ?? '').toLowerCase();
    return category.contains('shopping') || category.contains('mall');
  }

  bool _isEntertainment(Map<String, dynamic> place) {
    final category = (place['category'] ?? '').toLowerCase();
    return category.contains('entertainment') || 
           category.contains('cinema') || 
           category.contains('theater');
  }
}
