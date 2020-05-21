String expandDartSourceToHandleInput(String dartSource) {
  const inputHandlerImports = "import 'dart:html';";
  const inputSimulationCode = '''
var stdin = SpoofInput() as dynamic;

class SpoofInput {
  var inputText = "";
  var promptDiv = new DivElement()
    ..id='prompt';
  final promptInput = new TextInputElement()
    ..placeholder='Kirjoita tekstiä tähän'
    ..id='prompt-input';

  @override
  noSuchMethod(invocation) =>
  print('stdin.\${invocation.memberName.toString().replaceAll('Symbol("', '').replaceAll('")', '')} ei ole käytettävissä dartpadissa');

  handleInput(event) {
    if (event.keyCode == KeyCode.ENTER) {
      inputText = promptInput.value;
      promptDiv.remove();
    }
  }

  sleep(s) {
    final duration = Duration(seconds: s);
    return new Future.delayed(duration, () => s);
  }

  readLineSync() async {
    addInputElement();
    while (true) {
      if (querySelector('#prompt-input') == null) break;
      await sleep(1);
    }
    return inputText;
  }

  addInputElement() {
    promptDiv.style.padding = '8px';
    promptInput.style.width = '98%';

    document.body.append(promptDiv);
    promptDiv.append(promptInput);
    promptInput.onKeyPress.listen(handleInput);
    promptInput.select();
  }
}
''';

  // Add required inputs for input simulation
  dartSource = inputHandlerImports + dartSource;

  // TODO: filter out those that can't possibly match function syntax (check if unnecessary parentheses can be applied)
  final keywords = [
     // Cannot have parenthesis after: 'class','false','async','import','static',
     // 'show','as','enum','final','true'

    // Unchecked
    'in',
    'export','sync','extends','is','this','extension','library',
    'throw','break','external','mixin','case','factory','new','try',
    'null','typedef','on','var','const',
    'finally','operator','void','continue','part','covariant',
    'rethrow','with','default','get','return','yield','deferred','hide','set',
    'do','implements',
    // Can have parenthesis after:
    'catch','else','switch','await','super','for','while','if','assert',
  ];

  final foundFunctions = [];
  dartSource = dartSource.replaceAllMapped(
      RegExp(r'\b((\w+)\s*\(.*\))\s*{', multiLine: true), (match) {
    if (keywords.contains(match.group(2))) {
      return match.group(0);
    }
    foundFunctions.add(match.group(2));
    return '${match.group(1)} async {';
  });

  // add await for stdin calls
  dartSource = dartSource.replaceAllMapped(
      RegExp(r'\b(stdin\.)', multiLine: true), (match) {
    return 'await ${match.group(1)}';
  });

  // add await for any asynced functions
  foundFunctions.forEach((functionName) {
    dartSource = dartSource.replaceAllMapped(
        RegExp('\\b($functionName\\(.*\\))(?! async {)', multiLine: true), (match) {
      return 'await ${match.group(1)}';
    });
  });

  // Add input simulation code to dart source
  return dartSource + inputSimulationCode;
}
