import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:text_field_mask_and_validation/mask_decorator.dart';
import 'package:text_field_mask_and_validation/validator.dart';

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
  late final MaskDecorator _phoneController;
  final ValueNotifier<String> text = ValueNotifier('');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _phoneController = MaskDecorator(mask: '(##) # ####-####');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _phoneController.dispose();
    super.dispose();
  }

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
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  labelText: 'Phone',
                ),
                validator: (value) => Validator.validate(
                  value,
                  r'^\(\d{2}\) \d \d{4}-\d{4}$',
                  'Please enter a valid number',
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
          if (_key.currentState!.validate())
            {text.value = _phoneController.text}
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
