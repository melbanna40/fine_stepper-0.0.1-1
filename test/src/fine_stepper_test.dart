import 'package:fine_stepper/fine_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final steps = [
    StepItem(
      builder: (context) => StepBuilder(
        child: Text('Step ${FineStepper.of(context).stepIndex}'),
      ),
    ),
    StepItem(
      builder: (context) => StepBuilder(
        child: Text('Step ${FineStepper.of(context).stepIndex}'),
      ),
    ),
    StepItem(
      builder: (context) => StepBuilder(
        child: Text('Step ${FineStepper.of(context).stepIndex}'),
      ),
    ),
  ];

  test(
    'FineSteppers fails when steps is empty',
    () {
      expect(() => FineStepper(steps: const []), throwsAssertionError);
    },
  );

  testWidgets(
    'Steps forward',
    (tester) async {
      await tester.pumpWidget(MaterialApp(home: FineStepper(steps: steps)));

      expect(find.text('Step 0'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.navigate_next));
      await tester.pump();
      expect(find.text('Step 1'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.navigate_next));
      await tester.pump();
      expect(find.text('Step 2'), findsOneWidget);
    },
  );

  testWidgets(
    'Calls onFinish on last step',
    (tester) async {
      var onFinishCalled = false;
      await tester.pumpWidget(
        MaterialApp(
          home: FineStepper(
            onFinish: () async {
              onFinishCalled = true;
            },
            steps: steps,
          ),
        ),
      );
      final BuildContext context = tester.element(find.byType(StepBuilder).last);

      for (var i = 0; i < FineStepper.of(context).stepCount; i++) {
        final text = i == FineStepper.of(context).stepCount - 1 //
            ? 'Finish'
            : 'Next';
        await tester.tap(find.text(text));
        await tester.pump();
      }
      expect(onFinishCalled, true);
    },
  );

  testWidgets(
    'onFinish does not get called twice (when finishing is true)',
    (tester) async {
      var onFinishCalledCount = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: FineStepper(
            onFinish: () async {
              onFinishCalledCount++;
              await Future<void>.delayed(const Duration(seconds: 1));
            },
            steps: steps,
          ),
        ),
      );
      final BuildContext context = tester.element(find.byType(StepBuilder).last);

      for (var i = 0; i < FineStepper.of(context).stepCount; i++) {
        final text = i == FineStepper.of(context).stepCount - 1 //
            ? 'Finish'
            : 'Next';
        await tester.tap(find.text(text));
        await tester.pump();
      }
      expect(onFinishCalledCount, 1);
      await tester.tap(find.text('Finish'));
      await tester.pump();
      expect(onFinishCalledCount, 1);

      await tester.pump(const Duration(seconds: 1));
    },
  );

  testWidgets(
    'Cannot Step back on first step',
    (tester) async {
      await tester.pumpWidget(MaterialApp(home: FineStepper(steps: steps)));
      final BuildContext context = tester.element(find.byType(StepBuilder).last);
      final stepIndex = FineStepper.of(context).stepIndex;
      expect(stepIndex, 0);

      await tester.tap(find.byIcon(Icons.navigate_before));
      await tester.pump();
      expect(stepIndex, 0);
    },
  );
}
