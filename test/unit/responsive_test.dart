import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bus_booking_pro/core/responsive.dart';

void main() {
  testWidgets('formFactor classifies widths', (tester) async {
    Future<FormFactor> capture(double width) async {
      late FormFactor seen;
      await tester.pumpWidget(
        MediaQuery(
          data: MediaQueryData(size: Size(width, 800)),
          child: Builder(
            builder: (ctx) {
              seen = ctx.formFactor;
              return const SizedBox();
            },
          ),
        ),
      );
      return seen;
    }

    expect(await capture(360), FormFactor.compact);
    expect(await capture(800), FormFactor.medium);
    expect(await capture(1600), FormFactor.expanded);
  });

  testWidgets('gridColumns adapts to width', (tester) async {
    Future<int> capture(double width) async {
      late int seen;
      await tester.pumpWidget(
        MediaQuery(
          data: MediaQueryData(size: Size(width, 800)),
          child: Builder(
            builder: (ctx) {
              seen = ctx.gridColumns(min: 1, max: 4);
              return const SizedBox();
            },
          ),
        ),
      );
      return seen;
    }

    expect(await capture(400), 1);
    expect(await capture(720), 2);
    expect(await capture(1000), 3);
    expect(await capture(1800), 4);
  });
}
