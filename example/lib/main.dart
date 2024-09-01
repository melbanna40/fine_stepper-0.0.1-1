import 'package:fine_stepper/fine_stepper.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(colorSchemeSeed: const Color.fromARGB(255, 49, 255, 252)),
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Fine Stepper Example'),
        ),
        body: FineStepper(
          onFinish: () => Future.delayed(const Duration(seconds: 2)),
          steps: [
            StepItem(builder: buildColumnStep),
            StepItem(builder: buildStackStep),
            StepItem(builder: buildCustomStep),
            StepItem(builder: buildFormStep),
          ],
        ),
      ),
    );
  }

  Widget buildStackStep(BuildContext context) {
    return StepBuilder(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Step ${FineStepper.of(context).stepIndex + 1}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  'StepLayout: Stack',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 20,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  onChanged: (_) {},
                  value: false,
                  title: Text('Item $index'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildColumnStep(BuildContext context) {
    return StepBuilder(
      layout: StepLayout.column,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Step ${FineStepper.of(context).stepIndex + 1}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                'StepLayout: Column',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFormStep(BuildContext context) {
    return FormStepBuilder(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Step ${FineStepper.of(context).stepIndex + 1}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  'StepLayout: Stack',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextFormField(
              decoration: const InputDecoration(hintText: 'Example'),
              validator: (value) => (value?.isEmpty ?? true) ? 'Required Field' : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCustomStep(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Step ${FineStepper.of(context).stepIndex + 1}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                'Custom',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              FloatingActionButton(
                onPressed: () {
                  FineStepper.of(context).stepBack();
                },
                child: const Icon(Icons.arrow_back_ios),
              ),
              const Spacer(),
              FloatingActionButton(
                onPressed: () {
                  FineStepper.of(context).stepForward();
                },
                child: FineStepper.of(context).finishing
                    ? const CircularProgressIndicator.adaptive(backgroundColor: Colors.white)
                    : const Icon(Icons.arrow_forward_ios),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
