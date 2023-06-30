import 'dart:async';
import 'dart:convert';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:sqlpro/models/employee.dart';
import 'package:sqlpro/notifications/slogan_notification.dart';
import 'package:sqlpro/pages/results_page.dart';
import 'package:sqlpro/services/myslq_service.dart';
import 'package:sqlpro/services/openAi_service.dart';
import 'package:sqlpro/widgets/animated_text.dart';
import 'package:sqlpro/widgets/logo.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> with TickerProviderStateMixin {
  late final AnimationController _logoAnimationController;
  late final AnimationController _contentAnimationController;
  late final Animation<double> _logoAnimation;
  late final Animation<double> _contentAnimation;
  late final Timer _timer;

  MySqlConnection? _connection;
  OpenAI? _openAI;

  String _prompt = '';

  bool _showSlogan = false;
  bool _showcontent = false;
  bool _isLoading = false;

  List<Employee> _employees = [];

  Map<String, dynamic> _graphResults = {};

  @override
  void initState() {
    _initDB();
    _initOpenAI();
    _logoAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _contentAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _logoAnimation = Tween(begin: 0.0, end: -70.0).animate(
      CurvedAnimation(
        parent: _logoAnimationController,
        curve: Curves.ease,
      ),
    );
    _contentAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentAnimationController,
        curve: Curves.easeIn,
      ),
    );
    _logoAnimationController.addStatusListener(_animationListener);
    _timer = Timer(
      const Duration(seconds: 3),
      () => _logoAnimationController.forward(),
    );
    super.initState();
  }

  void _animationListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) setState(() => _showSlogan = true);
  }

  Future<void> _initDB() async {
    final _sqlConnection = await MySqlDatabase.connectDatabase();
    _connection = _sqlConnection;
  }

  Future<void> _initOpenAI() async {
    final _openAIConnection = await OpenAIService.initialize();
    _openAI = _openAIConnection;
  }

  Future<String> _getSQLQuery() async {
    final CTResponse? _response = await _openAI!.onCompletion(
      request: CompleteText(
        prompt: _prompt +
            "\n\nTranslate the above into a precise SQL query where your database is called employees. These are all the collums 'emp_no', 'birth_date', 'first_name', 'last_name', 'gender', 'hire_date'. Always return the output in full record inluding all columns. An example is this: ' SELECT emp_no,first_name,last_name,TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) AS age FROM employees ORDER BY RAND() LIMIT 10;  '",
        model: Model.textDavinci3,
        maxTokens: 60,
      ),
    );

    final String _query = _response!.choices[0].text;

    return _query;
  }

  Future<void> _fetchDataFromDatabase(String query) async {
    final _results = await _connection!.query(query);

    if (_results.isNotEmpty) {
      print(_prompt.contains('chart'));
      if (_prompt.contains('chart')) {
        for (ResultRow row in _results) {
          final CTResponse? _response = await _openAI!.onCompletion(
            request: CompleteText(
              prompt: '{id: ${row[0]}, birthdate: ${row[1]}, firstName: ${row[2]}, lastName: ${row[3]}, gender:  ${row.length == 4 ? 'not known' : row[4]}, hiredate: ${row.length == 4 ? 'not known' : row[5]} }' +
                  "\n\n Now according to the prompt: '$_prompt', extract the right x and y values for the chart and and give the right titles to each of the axis. you will extract the data from the above json map. Provide your output in a json format like: {\"xVal\": [4,5,3], \"yVal\": [3,4,5], \"xTitle\": \"title1\", \"yTitle\": \"title2\"} , The x and y values should only be in numbers",
              model: Model.textDavinci3,
              maxTokens: 60,
            ),
          );
          final String _result = _response!.choices[0].text;

          final Map<String, dynamic> _json = jsonDecode(_result.substring(1));

          _graphResults = _json;
        }
      } else {
        late Employee _employee;
        for (ResultRow row in _results) {
          _employee = Employee(
            id: row[0].toString(),
            birthdate: row[1].toString(),
            firstName: row[2].toString(),
            lastName: row[3].toString(),
            gender: row[4].toString(),
            hireDate: row.length == 5 ? 'unknown' : row[5].toString(),
          );
        }
        _employees.add(_employee);
      }
    }
  }

  Future<void> _doTheMagic() async {
    setState(() => _isLoading = true);
    final String _query = await _getSQLQuery();
    await _fetchDataFromDatabase(_query);
    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _logoAnimationController.removeStatusListener(_animationListener);
    _logoAnimationController.dispose();
    _contentAnimationController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: NotificationListener(
        onNotification: (SloganNotification n) {
          setState(() => _showcontent = true);
          _contentAnimationController.forward();
          return true;
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                AnimatedBuilder(
                  animation: _logoAnimationController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _logoAnimation.value),
                      child: const SQLPROLogo(),
                    );
                  },
                ),
                const SizedBox(height: 30),
                _showSlogan == false
                    ? const SizedBox()
                    : Transform.translate(
                        offset: const Offset(0, -20),
                        child: const SQLSlogan(),
                      ),
              ],
            ),
            const SizedBox(height: 30),
            _showcontent == false
                ? const SizedBox()
                : ScaleTransition(
                    scale: _contentAnimation,
                    child: Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.2,
                          height: MediaQuery.of(context).size.height / 4,
                          child: TextField(
                            maxLines: 7,
                            maxLength: 200,
                            style: const TextStyle(color: Colors.white),
                            onChanged: (value) =>
                                setState(() => _prompt = value),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[900],
                              hintText:
                                  'Ex: Give me the highest payed employee',
                              hintStyle: const TextStyle(color: Colors.white),
                              counterStyle:
                                  const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.6,
                          child: ElevatedButton(
                            onPressed: _prompt.isEmpty
                                ? () =>
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('Type your request first'),
                                      ),
                                    )
                                : () async {
                                    await _doTheMagic();
                                    if (_isLoading == false) {
                                      if (context.mounted) {
                                        final bool? _emptyList =
                                            await Navigator.of(context)
                                                .push<bool>(
                                          MaterialPageRoute(
                                            builder: (context) => ResultsPage(
                                              employess: _employees,
                                              graphResults: _graphResults,
                                            ),
                                          ),
                                        );

                                        if (_emptyList == true) {
                                          _employees = [];
                                          _prompt = '';
                                        }
                                        ;
                                      }
                                    }
                                  },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(40),
                                  ),
                                ),
                              ),
                            ),
                            child: _isLoading == true
                                ? const CupertinoActivityIndicator(
                                    radius: 12,
                                  )
                                : const Text(
                                    'Request',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
