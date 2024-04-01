import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:homework1/screens/home_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homework1/utils/riverpod_providers.dart';

void main() {
  testWidgets('Pressing like updates likedNewsProvider', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: HomePage()));

    //TODO: fix test failure due to AppLocalization null value
    final element = tester.element(find.byType(HomePage));
    final container = ProviderScope.containerOf(element);
    final likedNewsProviderState = container.read(likedNewsProvider);
    expect(likedNewsProviderState, isEmpty);

    await tester.tap(find.byIcon(Icons.favorite).last);
    await tester.pump();

    expect(likedNewsProviderState, isNotEmpty);
    expect(likedNewsProviderState.length, equals(1));

    await tester.tap(find.byIcon(Icons.favorite).last);
    await tester.pump();

    expect(likedNewsProviderState, isEmpty);
  });
}
