import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form/db/database.dart';
import 'package:form/model/person.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _hidePas = true;

  final _formKey = GlobalKey<FormState>();

  final dbHelper = DBHelper.instance;

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _storyController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();

  final _nameFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _storyFocus = FocusNode();
  final _passFocus = FocusNode();
  final _confirmPassFocus = FocusNode();
  final _countryFocus = FocusNode();

  List<String> _countries = ['Україна', 'США', 'Велика Британія', 'підарасія'];
  String _selectedCountry = '';

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _storyController.dispose();
    _passController.dispose();
    _confirmPassController.dispose();

    _nameFocus.dispose();
    _phoneFocus.dispose();
    _emailFocus.dispose();
    _storyFocus.dispose();
    _passFocus.dispose();
    _confirmPassFocus.dispose();
    _countryFocus.dispose();

    super.dispose();
  }

  InputDecoration _inputDecoretion({
    required String labelText,
    required String hintText,
    required Icon prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      // icon: Icon(Icons.person), // Іконка за межами поля вводу
      // helperText: 'Текст внизу під інпутом',
      // suffixIcon: Icon(Icons.abc), //можна зробить кнопкой IconButton
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
        borderSide: BorderSide(
          color: Colors.black54,
          width: 1.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
        borderSide: BorderSide(
          color: Colors.black,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
        borderSide: BorderSide(
          width: 1,
          color: Colors.red,
        ),
      ),
    );
  }

  var loader = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.person),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              TextFormField(
                // autofocus: true,
                focusNode: _nameFocus,
                controller: _nameController,
                keyboardType: TextInputType.name,
                validator: _validateName,
                textInputAction: TextInputAction.go,
                // (value) => (value == null || value.isEmpty) ? 'Name is required' : null,
                onFieldSubmitted: (_) {
                  _fieldFocusChange(
                      context: context,
                      currentFocus: _nameFocus,
                      nextFocus: _phoneFocus);
                },
                decoration: _inputDecoretion(
                  labelText: 'Full Name*',
                  hintText: 'Як тебе звати?',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: 15),
              TextFormField(
                focusNode: _phoneFocus,
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.go,
                decoration: _inputDecoretion(
                  labelText: 'Phone Number*',
                  hintText: 'Введи номер телефону?',
                  prefixIcon: Icon(Icons.person),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // ввод тільки чисел
                ],
                onFieldSubmitted: (_) {
                  _fieldFocusChange(
                      context: context,
                      currentFocus: _phoneFocus,
                      nextFocus: _emailFocus);
                },
                validator: (value) => (value != null && value.length > 6)
                    ? null
                    : 'Введіть справжній номер',
              ),
              SizedBox(height: 15),
              TextFormField(
                focusNode: _emailFocus,
                controller: _emailController,
                validator: _valiateEmail,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.go,
                decoration: _inputDecoretion(
                  labelText: 'Email',
                  hintText: 'ВВеди Email?',
                  prefixIcon: Icon(Icons.person),
                ),
                onFieldSubmitted: (_) {
                  _fieldFocusChange(
                      context: context,
                      currentFocus: _emailFocus,
                      nextFocus: _countryFocus);
                },
              ),
              SizedBox(height: 15),
              DropdownButtonFormField(
                focusNode: _countryFocus,
                items: _countries
                    .map((item) => DropdownMenuItem(
                          child: Text(item),
                          value: item,
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedCountry = value;
                    });
                  }
                },
                validator: (value) {
                  if (value == null) {
                    return 'Заповніть поле';
                  } else if (value == 'підарасія') {
                    return 'чмоням тут не раді!';
                  } else {
                    return null;
                  }
                },
                decoration: _inputDecoretion(
                  labelText: 'You Country',
                  hintText: 'Вибери країну',
                  prefixIcon: Icon(Icons.flag),
                ),
              ),
              SizedBox(height: 15),
              TextFormField(
                focusNode: _storyFocus,
                controller: _storyController,
                // maxLines: 3,
                textInputAction: TextInputAction.go,
                decoration: _inputDecoretion(
                  labelText: 'Life Story',
                  hintText: 'Хто ти по життю?)',
                  prefixIcon: Icon(Icons.person),
                ),
                maxLength: 100,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(100),
                ],
                onFieldSubmitted: (_) {
                  _fieldFocusChange(
                      context: context,
                      currentFocus: _storyFocus,
                      nextFocus: _passFocus);
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                focusNode: _passFocus,
                controller: _passController,
                maxLength: 12,
                obscureText: _hidePas,
                validator: _valiatePass,
                textInputAction: TextInputAction.go,
                decoration: _inputDecoretion(
                  labelText: 'Password*',
                  hintText: 'Придумай пароль до 12 символів)',
                  prefixIcon: Icon(Icons.person),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _hidePas = !_hidePas;
                      });
                    },
                    icon: _hidePas
                        ? Icon(Icons.visibility)
                        : Icon(Icons.visibility_off),
                  ),
                ),
                onFieldSubmitted: (_) {
                  _fieldFocusChange(
                      context: context,
                      currentFocus: _passFocus,
                      nextFocus: _confirmPassFocus);
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                onFieldSubmitted: (_) {
                  _submitForm();
                },
                focusNode: _confirmPassFocus,
                controller: _confirmPassController,
                maxLength: 12,
                obscureText: _hidePas,
                validator: _valiatePass,
                textInputAction: TextInputAction.done,
                decoration: _inputDecoretion(
                  labelText: 'Confirm Password*',
                  hintText: 'Повтори пароль)',
                  prefixIcon: Icon(Icons.person),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _hidePas = !_hidePas;
                      });
                    },
                    icon: _hidePas
                        ? Icon(Icons.visibility)
                        : Icon(Icons.visibility_off),
                  ),
                ),
              ),
              SizedBox(height: 15),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit Form'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.grey[700]),
                ),
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Є аккаунт?'),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/sign_in');
                    },
                    child: Text('Вхід'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _showDialog();

      final personData = Person(
        id: Random().nextInt(999999),
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        email: _emailController.text.toLowerCase().trim(),
        story: _storyController.text.trim(),
        country: _selectedCountry,
        password: _passController.text.trim(),
      );

      await signUp(personData);

      Navigator.pushReplacementNamed(context, '/persons');
    } else {
      _formErrorMessage('Ну ти й Василь... заповни форму нормально!');
    }
  }

  void _formErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 5),
        content: Text(
          message,
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.green[400],
          title: Text(
            'Реєстрація успішна',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          content: Text('Всі данні запимані в локальну БД вашого девайсу'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Ок'),
            ),
          ],
        );
      },
    );
  }

  String? _validateName(String? value) {
    final _nameExp = RegExp(r'^[A-Za-z]+$');

    if (value == null || value.isEmpty) {
      return 'Поле не повинно бути пустим';
    } else if (!_nameExp.hasMatch(value)) {
      return 'Чисел вводити не можна!';
    } else {
      return null;
    }
  }

  String? _valiateEmail(String? value) {
    if (value != null && value.length > 5 && !value.contains('@')) {
      return 'Заповніть це поле';
    } else {
      return null;
    }
  }

  String? _valiatePass(String? value) {
    if (value == null || value.length < 6) {
      return 'Заповніть це поле';
    } else if (_passController.text != _confirmPassController.text) {
      return 'Паролі не збіраються';
    } else {
      return null;
    }
  }

  void _fieldFocusChange({
    required BuildContext context,
    required FocusNode currentFocus,
    required FocusNode nextFocus,
  }) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  Future<void> signUp(Person data) async {
    Map<String, dynamic> row = {
      DBHelper.columnID: data.id,
      DBHelper.columnName: data.name,
      DBHelper.columnPhone: data.phone,
      DBHelper.columnEmail: data.email,
      DBHelper.columnPassword: data.password,
      DBHelper.columnStory: data.story,
      DBHelper.columnCountry: data.country,
    };

    try {
      await dbHelper.insert(row);
      Navigator.of(context).pushReplacementNamed('/persons');
    } catch (e) {
      print('Sign Up Error! $e');
    }
  }
}
