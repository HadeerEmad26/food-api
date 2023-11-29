import 'package:api_part2/core/database/api/api.dart';
import 'package:api_part2/core/database/cache/cache_helper.dart';
import 'package:api_part2/core/services/service_locator.dart';
import 'package:api_part2/feature/auth/data/model/login_model.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  final Dio dio = Dio(BaseOptions(baseUrl: EndPoint.baseUrl));

  void login() async {
    emit(LoginLoadingState());
    try {
      var response = await getIt<Dio>().post(
        EndPoint.login,
        data: {
          "email": "hadeere378@gmail.com",
          "password": "hadeer1234",
        },
      );
      // print(response.statusCode);
      // print(response.data);
      var loginModel = LoginModel.fromJson(response.data);
      await CacheHelper.prefs.setString('token', loginModel.token);

      print(loginModel.message);
      Map<String, dynamic> decodedToken = JwtDecoder.decode(loginModel.token);
      print(decodedToken['id']);
      await CacheHelper.prefs.setString('id', decodedToken['id']);

      emit(LoginSuccessState());
    } catch (error) {
      print(error.toString());
      emit(LoginErrorState());
    }
  }

  void logout() async {
    emit(LogoutLoadingState());
    try {
      var response = await getIt<Dio>().get(
        EndPoint.logout,
        options: Options(
          headers: {
            'token': 'FOODAPI ${CacheHelper.prefs.getString('token')} '
          },
        ),
      );
      print(response.data['message']);
      emit(LogoutSuccessState());
    } catch (error) {
      print(error.toString());
      emit(LogoutErrorState());
    }
  }

  void changePassword() async {
    emit(ChangePasswordLoadingState());
    try {
      var response = await getIt<Dio>().patch(
        EndPoint.changePaswword,
        data: {
          "oldPass": "hadeer123",
          "newPass": "hadeer1234",
          "confirmPassword": "hadeer1234"
        },
        options: Options(
          headers: {
            'token': 'FOODAPI  ${CacheHelper.prefs.getString('token')} '
          },
        ),
      );
      print(response.data['message']);
      emit(ChangePasswordSuccessState());
    } catch (error) {
      print(error.toString());
      emit(ChangePasswordErrorState());
    }
  }

  void deleteChef() async {
    emit(DeleteLoadingState());
    try {
      var response = await getIt<Dio>().delete(
        EndPoint.deleteChef,
        queryParameters: {
          'id': CacheHelper.prefs.getString('id'),
        },
        options: Options(
          headers: {
            'token': 'FOODAPI  ${CacheHelper.prefs.getString('token')} '
          },
        ),
      );
      print(response.data);
      emit(DeleteSuccessState());
    } catch (error) {
      print(error.toString());
      emit(DeleteErrorState());
    }
  }
}
