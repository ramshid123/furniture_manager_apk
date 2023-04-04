import 'package:dart_appwrite/dart_appwrite.dart';
import 'package:dart_appwrite/models.dart';
import 'package:wooodapp/main.dart';

late Users users;

Future<void> init_dart_appwrite() async {
  Client client = Client();
  client
      .setEndpoint(endPoint)
      .setProject('64296421a251168288ea')
      .setKey(
          '60aceace919666b05c8b0e674f105127c8d6e900e63044e278c421c4b1db45cb08db4361a84199ff8d691a81b1e635717148af4f470ec2818bd504ad14e5086de4b7567f142ea1ebe6354c0b4ce892e969a9ecf8b87531dae216b4cfc336cbb0bda6abce1b0f8cb10d8e1ebd7c76e8cbdc996c8bb3c66f56f9b7b2fc60e59981')
      .setSelfSigned(status: true);

  users = Users(client);
}

Future<User> get_user_name_from_id(String id) async {
  final target = await users.get(userId: id);
  return target;
}
