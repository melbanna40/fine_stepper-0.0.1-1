import 'package:flutter/material.dart';

/// {@template formBuilder}
/// Builder that wraps a form and exposes a callback
/// for validating and saving the form
/// {@endtemplate}
class FormBuilder extends StatefulWidget {
  /// {@macro formBuilder}
  const FormBuilder({
    required this.builder,
    super.key,
  });

  /// returns a widget wrapped around [Form] and passed to it
  /// a callback for for validating and saving the form
  final Widget Function(bool Function() validateAndSaveForm) builder;

  @override
  State<FormBuilder> createState() => _FormBuilderState();
}

class _FormBuilderState extends State<FormBuilder> {
  final formKey = GlobalKey<FormState>();

  bool _validateAndSubmitForm() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      // hide the keyboard if open
      FocusScope.of(context).unfocus();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: widget.builder(_validateAndSubmitForm),
    );
  }
}
