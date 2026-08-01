import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_prototype/app/app.dart';

void main() {
  testWidgets('App renders correctly smoke test', (WidgetTester tester) async {
    // Build our app wrapped in ProviderScope and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: PrototypeApp(),
      ),
    );

    // Verify app title loads
    expect(find.text('Frontend Prototype'), findsOneWidget);
  });
}
