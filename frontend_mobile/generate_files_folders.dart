import 'dart:io';

//'dart run <dartFileNameWithExtension>' to run a dart file from terminal
//example: 'dart run generate_files_folders.dart'

void main() async {
  // ignore: avoid_print
  print(
      'This script will generate the folder and file structure for Flutter 3. It will create some folders like assets, images, fonts, screens, controllers and some files like .env, .env.dev etc. You need .env, .env.dev, .env.example files when you use flutter_dotenv package.\n');

  var dirArray = [
    'assets',
    'assets/images',
    'assets/fonts',
    'assets/icons',
    'assets/data',
    'lib/screens',
    'lib/widgets',
    'lib/controllers',
    'lib/models',
    'lib/constant',
  ];

  for (var i = 0; i < dirArray.length; i++) {
    final myDir = Directory(dirArray[i]);
    var isThere = await myDir.exists();
    if (isThere) {
      // ignore: avoid_print
      print('${dirArray[i]} folder is already exist.');
    } else {
      var directory = await Directory(dirArray[i]).create(recursive: true);
      // ignore: avoid_print
      print('${directory.path} folder has been created.');
    }
  }

  var fileArray = [
    '.env',
    '.env.dev',
    '.env.example',
    'lib/controllers/default_controller.dart',
    'lib/constant/colors.dart',
    'lib/constant/variables.dart',
  ];
  for (var i = 0; i < fileArray.length; i++) {
    final myFile = File(fileArray[i]);
    var isThere = await myFile.exists();
    if (isThere) {
      // ignore: avoid_print
      print('${fileArray[i]} file is already exist.');
    } else {
      var file = await File(fileArray[i]).create(recursive: true);
      // ignore: avoid_print
      print('${file.path} file has been created.');
    }
  }

  // ignore: avoid_print
  print('\nPlease, check your project for those folders and files!\n');

  // ignore: avoid_print
  print(
      'This script is created by Alin (https://www.alinsworld.com/). [version: 1.0.1, date: 14-October-2023]');
}
