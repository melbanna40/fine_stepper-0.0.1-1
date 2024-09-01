import 'package:fine_stepper/src/helper_widgets/dismiss_focus_overlay.dart';
import 'package:fine_stepper/src/indicator_options.dart';
import 'package:fine_stepper/src/step_item.dart';
import 'package:flutter/material.dart';

part 'stepper_controller.dart';

class _StepperProvider extends InheritedNotifier<StepperController> {
  const _StepperProvider({
    required super.child,
    super.notifier,
  });
}

/// {@template FineStepper}
/// A Stepper widget that offers an easy api for creating and managing steps
/// {@endtemplate}
class FineStepper extends StatefulWidget {
  /// {@macro FineStepper}
  const FineStepper({
    required this.steps,
    this.onFinish,
    this.indicatorOptions = const IndicatorOptions(),
    super.key,
  }) : assert(steps.length != 0, 'Steps cannot be empty');

  /// List of [StepItem] to build at each step
  final List<StepItem> steps;

  /// {@macro StepperController.onFinish}
  final Future<void> Function()? onFinish;

  /// Options for the stepper indicator
  final IndicatorOptions indicatorOptions;

  /// Get the closest [StepperController] in the widget tree
  static StepperController of(BuildContext context) {
    // ignore: prefer_asserts_with_message
    assert(_debugCheckHasStepperController(context));
    return context.dependOnInheritedWidgetOfExactType<_StepperProvider>()!.notifier!;
  }

  static bool _debugCheckHasStepperController(BuildContext context) {
    // ignore: prefer_asserts_with_message
    assert(() {
      if (context.dependOnInheritedWidgetOfExactType<MediaQuery>() == null) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary('No FineStepper widget ancestor found.'),
          ErrorDescription(
            '${context.widget.runtimeType} widgets require a FineStepper widget ancestor.',
          ),
          context.describeWidget('The specific widget that could not find a FineStepper ancestor was'),
          context.describeOwnershipChain('The ownership chain for the affected widget is'),
          ErrorHint(
            'No FineStepper ancestor could be found starting from the context '
            'that was passed to FineStepper.of(). This can happen because you '
            'have not added a FineStepper Widget '
            'or it can happen if the '
            'context you use comes from a widget above those widgets.',
          ),
        ]);
      }
      return true;
    }());
    return true;
  }

  @override
  State<FineStepper> createState() => _FineStepperState();
}

class _FineStepperState extends State<FineStepper> {
  late final controller = StepperController(
    stepCount: widget.steps.length,
    onFinish: widget.onFinish,
  );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _StepperProvider(
      notifier: controller,
      child: ValueListenableBuilder(
        valueListenable: controller,
        builder: (context, state, __) {
          final currentStepIndex = state.currentStepIndex;
          return DismissFocusOverlay(
            child: Column(
              children: [
                _StepperIndicator(
                  currentStepIndex: currentStepIndex,
                  options: widget.indicatorOptions,
                ),
                Expanded(
                  child: widget.steps[currentStepIndex].builder(context),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StepperIndicator extends StatelessWidget {
  const _StepperIndicator({
    required this.currentStepIndex,
    this.options = const IndicatorOptions(),
  });

  final int currentStepIndex;
  final IndicatorOptions options;

  @override
  Widget build(BuildContext context) {
    final controller = FineStepper.of(context);
    return SizedBox(
      height: 80,
      child: ListView.separated(
        controller: controller._scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: controller.stepCount,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) => const SizedBox(
          width: 50,
          child: Divider(
            indent: 4,
            endIndent: 4,
          ),
        ),
        itemBuilder: (context, index) {
          final isCompleted = index < currentStepIndex;
          final isCurrent = index == currentStepIndex;
          final isPrev = index == currentStepIndex - 1;

          return GestureDetector(
            onTap: isPrev ? controller.stepBack : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted
                    ? options.completedStepColor ?? Theme.of(context).colorScheme.primary
                    : isCurrent
                        ? options.activeStepColor ?? Theme.of(context).colorScheme.primary
                        : options.stepColor ?? Colors.grey[400],
              ),
              child: AnimatedCrossFade(
                firstChild: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    Icons.done,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                secondChild: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ),
                firstCurve: const Interval(0, 0.6, curve: Curves.fastOutSlowIn),
                secondCurve: const Interval(0.4, 1, curve: Curves.fastOutSlowIn),
                crossFadeState: isCompleted //
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                duration: const Duration(milliseconds: 200),
              ),
            ),
          );
        },
      ),
    );
  }
}
