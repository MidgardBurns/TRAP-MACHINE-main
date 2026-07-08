import 'package:flutter_test/flutter_test.dart';

import 'package:trap_machine/main.dart';

void main() {
  testWidgets('renders the app menu', (WidgetTester tester) async {
    await tester.pumpWidget(const TrapMachineApp());

    expect(find.text('FEED'), findsOneWidget);
    expect(find.text('MAPA'), findsOneWidget);
    expect(find.text('INBOX'), findsOneWidget);
    expect(find.text('PERFIL'), findsOneWidget);
  });
}
