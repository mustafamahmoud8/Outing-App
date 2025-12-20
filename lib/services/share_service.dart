import 'package:share_plus/share_plus.dart';

class ShareService {
  static Future<void> sharePlace({
    required String name,
    required String location,
    required double rating,
    String? price,
  }) async {
    final text = '''
Check out this amazing place!

📍 $name
📌 $location
⭐ $rating/5.0
${price != null ? '💰 $price EGP' : ''}

Shared from Outing App
''';

    await Share.share(text, subject: 'Amazing Place - $name');
  }

  static Future<void> sharePlan({
    required String planName,
    required List<Map<String, dynamic>> places,
    required double totalBudget,
  }) async {
    final placesText = places.map((p) => '• ${p['name']} at ${p['time']}').join('\n');
    
    final text = '''
My Outing Plan: $planName

Places to visit:
$placesText

Total Budget: $totalBudget EGP

Created with Outing App
''';

    await Share.share(text, subject: 'My Outing Plan');
  }
}
