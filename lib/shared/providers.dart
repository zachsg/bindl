import 'package:bindl/shared/user.dart';
import 'package:bindl/survey/survey_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final surveyProvider = ChangeNotifierProvider((ref) => SurveyController());

final userProvider = ChangeNotifierProvider((ref) => UserController());
