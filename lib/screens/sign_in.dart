import 'package:flutter/material.dart';
import 'package:form/db/database.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _hidePas = true;

  final _formKey = GlobalKey<FormState>();

  final dbHelper = DBHelper.instance;

  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  final _emailFocus = FocusNode();
  final _passFocus = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    _emailFocus.dispose();
    _passFocus.dispose();

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
        title: Text('Sign In'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/persons');
            },
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
                focusNode: _emailFocus,
                controller: _emailController,
                validator: _valiateEmail,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.go,
                decoration: _inputDecoretion(
                  labelText: 'Email*',
                  hintText: 'Введи Email',
                  prefixIcon: Icon(Icons.person),
                ),
                onFieldSubmitted: (_) {
                  _fieldFocusChange(
                      context: context,
                      currentFocus: _emailFocus,
                      nextFocus: _passFocus);
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                focusNode: _passFocus,
                controller: _passController,
                maxLength: 12,
                obscureText: _hidePas,
                validator: _valiatePass,
                textInputAction: TextInputAction.done,
                decoration: _inputDecoretion(
                  labelText: 'Password*',
                  hintText: 'Введи пароль',
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
                  //
                },
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
                  Text('Немає аккаунту?'),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/sign_up');
                    },
                    child: Text('Раєстрація'),
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
      await signIn(_emailController.text, _passController.text);
      // await signUp(personData);
      print('succer reg');
      // Navigator.pushReplacementNamed(context, '/persons');
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

  String? _valiateEmail(String? value) {
    if (value == null || value.length < 5 && !value.contains('@')) {
      return 'Заповніть це поле';
    } else {
      return null;
    }
  }

  String? _valiatePass(String? value) {
    if (value == null || value.length < 6) {
      return 'Заповніть це поле';
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

  Future<void> signIn(String email, String password) async {
    bool noLogin = true;
    try {
      List<Map<String, dynamic>> rows = await dbHelper.queryAllRows();
      email = email.toLowerCase().trim();
      password = password.trim();
      for (var row in rows) {
        if (row['email'] == email && row['password'] == password) {
          Navigator.of(context).pushReplacementNamed('/persons');
          noLogin = false;
        }
      }
      if (noLogin) {
        _showDialog();
      }
    } catch (e) {
      print('Sign Up Error! $e');
    }
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.red[400],
          title: Text(
            'Такого персонажа в нашій БД немає',
            style: TextStyle(fontSize: 20),
          ),
          content: Text('Перевірте ваш логін та пароль'),
          actions: [
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.black87),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Вибачте, начальніка, зараз перевірю'),
            ),
          ],
        );
      },
    );
  }
}
