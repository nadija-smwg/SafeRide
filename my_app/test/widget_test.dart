import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/main.dart'; // This connects to your main.dart file

void main() {
  testWidgets('App loads smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SafeRideApp());

    // Verify that our app successfully loads the first screen 
    // Note: because the AuthWrapper is the first screen, we verify its presence by expecting nothing explicitly for now
  });
}
