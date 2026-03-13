import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/main.dart'; // This connects to your main.dart file

void main() {
  testWidgets('App loads smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SafeRideApp());

    // Verify that our app successfully loads the first screen by looking
    // for a word we know is on the Role Selection Screen.
    expect(find.text('Driver'), findsOneWidget);
    expect(find.text('Parent'), findsOneWidget);
  });
}
