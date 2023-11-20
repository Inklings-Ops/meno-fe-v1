import 'package:flutter_hooks/flutter_hooks.dart';

import '../../domain/inputs/inputs.dart';

IEmail useEmail() {
  final controller = useTextEditingController();
  final result = useState(IEmail(controller.text));

  useValueChanged<String, void>(controller.text, (String newValue, __) {
    result.value = IEmail(newValue);
  });

  return result.value;
}

IFullName useFullName() {
  final controller = useTextEditingController();
  final result = useState(IFullName(controller.text));

  useValueChanged<String, void>(controller.text, (String newValue, __) {
    result.value = IFullName(newValue);
  });

  return result.value;
}

IPassword usePassword() {
  final controller = useTextEditingController();
  final result = useState(IPassword(controller.text));

  useValueChanged<String, void>(controller.text, (String newValue, __) {
    result.value = IPassword(newValue);
  });

  return result.value;
}
