
import 'package:flutter_test/flutter_test.dart';

// 1. Pastikan import ini sesuai dengan "name:" di pubspec.yaml kamu
// Jika di pubspec.yaml namanya "amiibo_app", gunakan "amiibo_app".
// Jika namanya "latres", gunakan "latres".
import 'package:amiibo_app/main.dart'; 

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // 2. Ubah ini menjadi MyApp() karena di main.dart nama class-nya adalah MyApp
    // Jangan gunakan amiibo_app() karena itu bukan nama class.
    await tester.pumpWidget(const MyApp());

    // ... sisa kode di bawahnya biarkan saja atau sesuaikan ...
  });
}