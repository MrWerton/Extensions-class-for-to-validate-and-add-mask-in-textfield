import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> _key = GlobalKey();
  final phoneMask = '(###) ###-####';
  final _controller = MaskedTextController(mask: '(##) # ####-####');
  final ValueNotifier<String> text = ValueNotifier('');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Form(
              key: _key,
              child: TextFormField(
                controller: _controller,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
                validator: (value) => RegexValidator.validate(
                  value,
                  r'^\(\d{2}\) \d \d{4}-\d{4}$',
                  'Please enter a valid number address',
                ),
              ),
            ),
            ValueListenableBuilder(
                valueListenable: text,
                builder: (context, value, _) {
                  return Text(
                    '$value',
                    style: Theme.of(context).textTheme.headlineMedium,
                  );
                }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          if (_key.currentState!.validate()) {text.value = _controller.text}
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

//class for to validate field value with regex that is passed in params
class RegexValidator {
  static String? validate(
      String? value, String regexPattern, String errorMessage) {
    if (value == null || value.isEmpty) {
      return 'Please enter some text';
    }

    final regex = RegExp(regexPattern);
    if (!regex.hasMatch(value)) {
      return errorMessage;
    }

    return null;
  }
}
//class for add mask in text field

class MaskedTextController extends TextEditingController {
  final String mask;
  final RegExp _maskRegExp;

  MaskedTextController({required this.mask, String? text})
      : _maskRegExp = RegExp(mask.replaceAll('#', r'\d')),
        super(text: text) {
    addListener(_onChanged);
  }

  void _onChanged() {
    final nonMaskedValue = text!.replaceAll(RegExp('[^0-9]'), '');
    String maskedText = '';
    var maskIndex = 0;
    for (var i = 0; i < nonMaskedValue.length; i++) {
      if (maskIndex >= mask.length) {
        break;
      }
      if (mask[maskIndex] == '#') {
        maskedText += nonMaskedValue[i];
        maskIndex++;
      } else {
        maskedText += mask[maskIndex];
        maskIndex++;
        i--;
      }
    }
    value = TextEditingValue(
      text: maskedText,
      selection: TextSelection.fromPosition(
        TextPosition(offset: maskedText.length),
      ),
    );
  }

  bool isValid() {
    return _maskRegExp.hasMatch(text!);
  }
}
