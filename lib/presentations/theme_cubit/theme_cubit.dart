

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:literate_app/theme/dark_theme.dart';

class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit() : super(darkTheme);
}
