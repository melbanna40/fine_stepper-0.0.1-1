import 'package:fine_stepper/src/helper_widgets/form_builder.dart';
import 'package:fine_stepper/src/stepper_controls.dart';
import 'package:flutter/material.dart';

/// Layout for [StepBuilder] and [StepperControls]
///
/// when [StepLayout.column], step content and controls will be laid out in a column,
/// taking the minimum height
///
/// when [StepLayout.stack], step content will take the available height,
/// and controls will be stacked on top of the content, aligned to bottomCenter
enum StepLayout {
  /// step content and controls will be laid out in a column,
  /// taking the minimum height
  column,

  /// step content will take the available height,
  /// and controls will be stacked on top of the content, aligned to bottomCenter
  stack,
}

/// {@template StepBuilder}
/// StepBuilder
/// {@endtemplate}
class StepBuilder extends StatelessWidget {
  /// {@macro StepBuilder}
  const StepBuilder({
    required this.child,
    this.layout = StepLayout.stack,
    this.childAlignment = Alignment.topCenter,
    this.controlsPadding,
    this.shouldStepForward,
    this.nextText,
    this.backText,
    this.finishText,
    super.key,
  });

  /// The widget below this widget in the tree.
  final Widget child;

  /// {@template StepBuilder.layout}
  /// layout for the child and [StepperControls]
  /// {@endtemplate}
  final StepLayout layout;

  /// {@template StepBuilder.childAlignment}
  /// Child alignment when layout is [StepLayout.stack],
  ///
  /// defaults to [Alignment.center]
  /// {@endtemplate}
  final Alignment childAlignment;

  /// {@template StepBuilder.controlsPadding}
  /// Controls padding
  ///
  /// defaults to `EdgeInsets.all(16)`
  /// {@endtemplate}
  final EdgeInsets? controlsPadding;

  /// If we should step forward to the next step
  ///
  /// useful if you want to validate a form or check for some conditions before stepping forward
  final bool Function()? shouldStepForward;

  /// set Title for the next button
  final String? nextText;

  /// set Title for the back button
  final String? backText;

  /// set Title for the finish button
  final String? finishText;

  @override
  Widget build(BuildContext context) {
    switch (layout) {
      case StepLayout.stack:
        return Stack(
          children: [
            Align(
              alignment: childAlignment,
              child: child,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: controlsPadding ?? const EdgeInsets.all(16),
                child: StepperControls(
                  shouldStepForward: shouldStepForward,
                  nextText: nextText,
                  backText: backText,
                  finishText: finishText,
                ),
              ),
            ),
          ],
        );

      case StepLayout.column:
        return SingleChildScrollView(
          child: Column(
            children: [
              child,
              Padding(
                padding: controlsPadding ?? const EdgeInsets.all(16),
                child: StepperControls(
                  shouldStepForward: shouldStepForward,
                  nextText: nextText,
                  backText: backText,
                  finishText: finishText,
                ),
              ),
            ],
          ),
        );
    }
  }
}

/// {@template FormStepBuilder}
/// A variant of StepBuilder that steps forward only if the current form content is validated
/// {@endtemplate}
class FormStepBuilder extends StatelessWidget {
  /// {@macro FormStepBuilder}
  const FormStepBuilder({
    required this.child,
    this.layout = StepLayout.stack,
    this.childAlignment = Alignment.topCenter,
    this.controlsPadding,
    this.nextText,
    this.backText,
    this.finishText,
    super.key,
  });

  /// The widget below this widget in the tree.
  final Widget child;

  /// {@macro StepBuilder.layout}
  final StepLayout layout;

  /// {@macro StepBuilder.childAlignment}
  final Alignment childAlignment;

  /// {@macro StepBuilder.controlsPadding}
  final EdgeInsets? controlsPadding;

  /// set Title for the next button
  final String? nextText;

  /// set Title for the back button
  final String? backText;

  /// set Title for the finish button
  final String? finishText;

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      builder: (validateAndSaveForm) {
        return StepBuilder(
          childAlignment: childAlignment,
          layout: layout,
          shouldStepForward: validateAndSaveForm,
          controlsPadding: controlsPadding,
          nextText: nextText,
          backText: backText,
          finishText: finishText,
          child: child,
        );
      },
    );
  }
}
