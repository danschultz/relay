library frappe.hop_runner;

import 'package:hop/hop.dart';
import 'package:hop_unittest/hop_unittest.dart';
import 'package:guinness/guinness.dart';
import '../test/test_runner_reactables.dart' as test_runner_reactables;
import '../test/test_runner_transformers.dart' as test_runner_transformers;

void main(List args) {
  addTask("test", createUnitTestTask(() {
    test_runner_reactables.main();
    test_runner_transformers.main();

    // Hop doesn't work with Guinness's auto-run behavior. We need to initialize
    // it manually. Hop will run any specs that are found since Guinness is using
    // the unittest package.
    guinness.initSpecs();
  }));

  runHop(args);
}