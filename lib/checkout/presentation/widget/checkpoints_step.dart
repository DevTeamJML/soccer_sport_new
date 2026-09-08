import 'package:cupertino_stepper/cupertino_stepper.dart';
import 'package:flutter/material.dart';

class CheckpointsStep extends StatefulWidget {
  final int currentStep;
  final List<String> checkPoints;

  CheckpointsStep({required this.currentStep, required this.checkPoints});

  @override
  State<CheckpointsStep> createState() => _CheckpointsStepState();
}

class _CheckpointsStepState extends State<CheckpointsStep> {
  late int currentStep;

  @override
  void initState() {
    currentStep = widget.currentStep;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   height: MediaQuery.of(context).size.height * 0.1,
    //   width: double.infinity,
    //   child: CupertinoStepper(
    //       type: StepperType.horizontal,
    //       currentStep: currentStep,
    //       onStepTapped: (step) => setState(() => currentStep = step),
    //       onStepCancel:
    //           currentStep > 0 ? () => setState(() => --currentStep) : null,
    //       onStepContinue:
    //           currentStep < 3 ? () => setState(() => ++currentStep) : null,
    //       // steps: [
    //       //   for (var i = 0; i < 3; ++i)
    //       //     _buildStep(
    //       //       title: Text('Step ${i + 1}'),
    //       //       isActive: i == currentStep,
    //       //       state: i == currentStep
    //       //           ? StepState.editing
    //       //           : i < currentStep
    //       //               ? StepState.complete
    //       //               : StepState.indexed,
    //       //     ),
    //       //   _buildStep(
    //       //     title: Text('Error'),
    //       //     state: StepState.error,
    //       //   ),
    //       //   _buildStep(
    //       //     title: Text('Disabled'),
    //       //     state: StepState.disabled,
    //       //   )
    //       // ],

    //       steps: widget.checkPoints.map((e) {
    //         int index = widget.checkPoints.indexOf(e);
    //         return _buildStep(
    //           title: Text(e),
    //           isActive: index <= currentStep,
    //           state: index == currentStep
    //               ? StepState.editing
    //               : index < currentStep
    //                   ? StepState.complete
    //                   : StepState.indexed,
    //         );
    //       }).toList()),
    // );

    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      width: double.infinity,
      child: Stepper(
          type: StepperType.horizontal,
          currentStep: currentStep,
          onStepTapped: (step) => setState(() => currentStep = step),
          onStepCancel:
              currentStep > 0 ? () => setState(() => --currentStep) : null,
          onStepContinue:
              currentStep < 3 ? () => setState(() => ++currentStep) : null,
          // steps: [
          //   for (var i = 0; i < 3; ++i)
          //     _buildStep(
          //       title: Text('Step ${i + 1}'),
          //       isActive: i == currentStep,
          //       state: i == currentStep
          //           ? StepState.editing
          //           : i < currentStep
          //               ? StepState.complete
          //               : StepState.indexed,
          //     ),
          //   _buildStep(
          //     title: Text('Error'),
          //     state: StepState.error,
          //   ),
          //   _buildStep(
          //     title: Text('Disabled'),
          //     state: StepState.disabled,
          //   )
          // ],

          steps: widget.checkPoints.map((e) {
            int index = widget.checkPoints.indexOf(e);
            return _buildStep(
              title: Text(e),
              isActive: index <= currentStep,
              state: index == currentStep
                  ? StepState.editing
                  : index < currentStep
                      ? StepState.complete
                      : StepState.indexed,
            );
          }).toList()),
    );
  }

  Step _buildStep({
    required Widget title,
    StepState state = StepState.indexed,
    bool isActive = false,
  }) {
    return Step(
        title: title, state: state, isActive: isActive, content: Container());
  }
}
