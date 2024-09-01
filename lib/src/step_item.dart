import 'package:fine_stepper/src/step_builders.dart';
import 'package:flutter/material.dart';

/// {@template StepItem}
/// A step item that has a builder for this step,
/// and an optional label
/// {@endtemplate}
class StepItem {
  /// {@macro StepItem}
  const StepItem({
    required this.builder,
    this.label,
  });

  /// Label for this step
  final String? label;

  /// Content Builder for this step
  ///
  /// usually a [StepBuilder] or [FormStepBuilder], but can be any custom widget
  /// for complex layout
  final Widget Function(BuildContext context) builder;
}
