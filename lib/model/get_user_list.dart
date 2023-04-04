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
          'dcf6d4e038dc3cabfc01b65dadecc420f79713f0c9da1124da70e085c10d75434300f07bf82fe41270e71e98d9fd45dd29d438e7d977491bd1511f294c1940b07d042d2b5f190c87eae838cb86319d4de88674406cb6244aae223572db6d214506092b5b1008d5962c96471e61934b2908db11ea6a7fa65a52881be5e6902a0b')
      .setSelfSigned(status: true);

  users = Users(client);
}

Future<User> get_user_name_from_id(String id) async {
  final target = await users.get(userId: id);
  return target;
}
