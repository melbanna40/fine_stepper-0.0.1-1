part of 'fine_stepper.dart';

@immutable

/// {@template StepperState}
/// FineStepper State that holds the current state for the stepper
/// {@endtemplate}
class StepperState {
  /// {@macro StepperState}
  const StepperState({
    required this.currentStepIndex,
    required this.finishing,
  });

  /// Initial State value
  const StepperState.initial()
      : currentStepIndex = 0,
        finishing = false;

  /// The index for the current active step
  final int currentStepIndex;

  /// Wether the stepper is finishing all steps.
  ///
  /// i.e [StepperController.stepForward] is called on the last step
  final bool finishing;

  @override
  bool operator ==(covariant StepperState other) {
    if (identical(this, other)) return true;

    return other.currentStepIndex == currentStepIndex && other.finishing == finishing;
  }

  @override
  int get hashCode => currentStepIndex.hashCode ^ finishing.hashCode;

  /// Copy State with a new one
  StepperState copyWith({
    int? currentStepIndex,
    bool? finishing,
  }) {
    return StepperState(
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      finishing: finishing ?? this.finishing,
    );
  }
}


/// Stepper Controller that holds and manage a [StepperState] for the stepper
///
/// if [onFinish] is passed, then its called on the last step,
/// and [StepperState.finishing] will be true until this future resolves
/// {@template StepperController}
/// {@endtemplate}
class StepperController extends ValueNotifier<StepperState> {
  /// {@macro StepperController}
  StepperController({
    required this.stepCount,
    this.onFinish,
  }) : super(const StepperState.initial());

  /// Steps Count
  final int stepCount;

  /// {@template StepperController.onFinish}
  /// Optional callback to be executed on the last step
  ///
  /// [StepperState.finishing] will be true until this future resolves
  /// {@endtemplate}
  final Future<void> Function()? onFinish;

  /// Current Step Index
  int get stepIndex => value.currentStepIndex;

  /// Update current step Index
  set stepIndex(int index) {
    assert(
      index >= 0 && index < stepCount,
      'Invalid Index, Index must be between 0 and [stepCount]',
    );
    value = value.copyWith(currentStepIndex: index);
  }

  /// Check if this is the first step
  bool get isFirstStep => stepIndex == 0;

  /// Check if this is the last step
  bool get isLastStep => stepIndex == stepCount - 1;

  /// Check if the stepper is finishing
  /// i.e it the last step and finish is pressed
  bool get finishing => value.finishing;

  /// Scroll controller for the stepper indicators
  /// that is used for animating to current to step indicator
  final _scrollController = ScrollController();

  /// Make a step back
  ///
  /// if [isFirstStep] is true, then it will do nothing
  ///
  /// this will animate to the current step
  void stepBack() {
    if (isFirstStep) return;
    stepIndex = stepIndex - 1;
    _animateToCurrentStep();
  }

  /// Make a step forward
  ///
  /// if [isLastStep] is true, then it will update [finishing] flag to be true
  /// and call [onFinish], if passed.
  ///
  /// if [finishing] is true, it will do nothing
  ///
  /// this will animate to the current step
  Future<void> stepForward() async {
    if (finishing) return;

    if (isLastStep) {
      value = value.copyWith(finishing: true);
      await (onFinish?.call() ?? Future<void>.value());
      value = value.copyWith(finishing: false);
      return;
    }

    stepIndex = stepIndex + 1;
    _animateToCurrentStep();
  }

  /// Handle when a step is tapped
  ///
  /// for now, only a the previous step can be navigated to
  void onStepTapped(int index) {
    if (stepIndex - index == 1) {
      stepBack();
    }
  }

  void _animateToCurrentStep() {
    // we don't need to animate
    if (stepCount <= 5) return;

    _scrollController.animateTo(
      stepIndex * 40,
      duration: const Duration(milliseconds: 200),
      curve: Curves.bounceIn,
    );
  }
}
