// import 'package:appwrite/appwrite.dart';
// import 'package:appwrite/models.dart';
// import 'package:drb_app/globals.dart';
// import 'package:flutter/widgets.dart';

// enum AuthStatus {
//   uninitialized,
//   authenticated,
//   unauthenticated,
// }

// class AuthAPI extends ChangeNotifier {
//   Client client = Client();
//   late final Account account;
//   late User _currentUser;

//   AuthStatus _status = AuthStatus.uninitialized;

//   // Getter methods
//   User get currentUser => _currentUser;
//   AuthStatus get status => _status;
//   String? get username => _currentUser?.name;
//   String? get email => _currentUser?.email;
//   String? get userid => _currentUser?.$id;

//   // Constructor
//   AuthAPI() {
//     init();
//     loadUser();
//   }

//   // Initialize the Appwrite client
//   init() {
//     client.setEndpoint(appwriteUrl).setProject(appwriteId).setSelfSigned();
//     account = Account(client);
//     loadUser();
//   }

//   loadUser() async {
//     try {
//       final user = await account.get();
//       _status = AuthStatus.authenticated;
//       _currentUser = user;
//     } catch (e) {
//       _status = AuthStatus.unauthenticated;
//     } finally {
//       notifyListeners();
//     }
//   }

//   Future<User> createUser(
//       {required String email,
//       required String password,
//       required String name}) async {
//     try {
//       final user = await account.create(
//           userId: ID.unique(), email: email, password: password, name: name);
//       return user;
//     } finally {
//       notifyListeners();
//     }
//   }

//   Future<Session> createEmailSession(
//       {required String email, required String password}) async {
//     try {
//       final session =
//           await account.createEmailSession(email: email, password: password);
//       _currentUser = await account.get();
//       _status = AuthStatus.authenticated;
//       return session;
//     } finally {
//       notifyListeners();
//     }
//   }

//   // signInWithProvider({required String provider}) async {
//   //   try {
//   //     final session = await account.createOAuth2Session(provider: provider);
//   //     _currentUser = await account.get();
//   //     _status = AuthStatus.authenticated;
//   //     return session;
//   //   } finally {
//   //     notifyListeners();
//   //   }
//   // }

//   signOut() async {
//     try {
//       await account.deleteSession(sessionId: 'current');
//       _status = AuthStatus.unauthenticated;
//     } finally {
//       notifyListeners();
//     }
//   }

//   Future<Preferences> getUserPreferences() async {
//     return await account.getPrefs();
//   }

//   updatePreferences({required String bio}) async {
//     return account.updatePrefs(prefs: {'bio': bio});
//   }
// }
