import 'package:get/get.dart';

class ImageController extends GetxController {
  var imagePath = Rxn<String>();  // Rxn to allow null values

  // Set image path
  void setImage(String path) {
    imagePath.value = path;  // Set the image path
  }

  // Clear the image
  void clearImage() {
    imagePath.value = null;  // Reset image path to null
  }
}
