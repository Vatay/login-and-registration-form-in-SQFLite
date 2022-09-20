// import 'package:equatable/equatable.dart';
// import 'package:bloc/bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:form/db/database.dart';
// import 'package:form/model/person.dart';

// part 'person_state.dart';

// class PersonCubit extends Cubit<PersonState> {
//   PersonCubit() : super(PersonInit());

//   final dbHelper = DBHelper.instance;
//   List<Person> personList = [];

//   Future<void> loadingUsers() async {
//     emit(PersonLoading());
//     try {
//       final List<Map<String, dynamic>> rows = await dbHelper.queryAllRows();
//       if (rows.length == 0) {
//         print('NO DATA BD');
//       } else {
//         for (var row in rows) {
//           personList.add(Person(
//             id: row["id"],
//             name: row["name"],
//             phone: row["phone"],
//             email: row["email"],
//             story: row["story"],
//             country: row["country"],
//             password: row["password"],
//           ));
//         }
//       }

//       emit(PersonLoaded(personList));
//     } catch (e) {
//       print("Error loaded data $e");
//     }
//   }

//   Future<void> signUp(Person data) async {
//     emit(PersonLoading());

//     Map<String, dynamic> row = {
//       DBHelper.columnID: data.id,
//       DBHelper.columnName: data.name,
//       DBHelper.columnPhone: data.phone,
//       DBHelper.columnEmail: data.email,
//       DBHelper.columnPassword: data.password,
//       DBHelper.columnStory: data.story,
//       DBHelper.columnCountry: data.country,
//     };
//     try {
//       await dbHelper.insert(row);
//       await loadingUsers();
//     } catch (e) {
//       print('Sign Up Error! $e');
//     }
//   }

//   Future<void> signIn({required String email, required String password}) async {
//     emit(PersonLoading());
//     await loadingUsers();
//     personList.map((person) {
//       if (person.email == email) {
//         if (person.password == password) {
//           // todo: go to page users list
//         }
//       }
//     });
//   }

//   Future<void> removePerson(int id) async {
//     emit(PersonLoading());
//     try {
//       await dbHelper.delete(id);
//       personList.removeWhere((element) => element.id == id);
//     } catch (e) {
//       print('Error delete! $e');
//     }
//   }
// }
