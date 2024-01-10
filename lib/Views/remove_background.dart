import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'package:image/image.dart' as img; // For image loading and resizing
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

class RemoveBackground extends StatefulWidget {
  const RemoveBackground({super.key});

  @override
  State<RemoveBackground> createState() => _RemoveBackgroundState();
}

class _RemoveBackgroundState extends State<RemoveBackground> {
  bool loading = true;

  void loadModel() async {
    final interpreter = await tfl.Interpreter.fromAsset('models/1.tflite');
// Get model input and output shapes
    final inputShape = interpreter.getInputTensor(0).shape;
    final outputShape = interpreter.getOutputTensor(0).shape;
    var output =
        List.filled(outputShape[1] * outputShape[2], 0.0, growable: false);

// Allocate tensors
    interpreter.allocateTensors();

// Allocate memory for input and output tensors
//       var input = List.filled(
//           inputShape[1] * inputShape[2] * inputShape[3], 0.0,
//           growable: false);
    // var output =
    //     List.filled(outputShape[1] * outputShape[2], 0.0, growable: false);

// // Allocate tensors
//       interpreter.allocateTensors();

    // Load the image using the image library
    // final imageBytes = await File("assets/images/ali.jpg").readAsBytes();
    ByteData bytes = await rootBundle.load('assets/images/ali.jpg');

    // Uint8List imageBytes = bytes.buffer.asUint8List();

    final image = img.decodeImage(bytes.buffer.asUint8List());

    final inputTensor =
        imageToTensor(image!); // Implement imageToTensor function

    final outputTensor = List<double>.filled(1000, 0.0); // Fill with zeros
    interpreter.run(inputTensor, outputTensor);

//     imglib.Image? image1 = imglib.decodeImage(imageBytes);
//
// // Get model input shape
//
// // Resize the image using tflite_flutter's resizeImage function
//     imglib.Image resizedImage =
//         imglib.copyResize(image1!, width: 300, height: 300);
//
// // Convert the resized image to a list of pixel values
//     Uint8List imageBytes1 = resizedImage.getBytes(format: imglib.Format.rgb);
//
//     // List<double> inputData =
//     //     imageBytes1.map((value) => value.toDouble()).toList();
//     print(imageBytes1.shape);
//     List input = imageBytes1.reshape([1, 300, 300, 3]);
//
//     // print(input.shape);
//     List output1 = output.reshape([1, 10, 4]);
//
//     print(output1.shape);
//     //
//     interpreter.run(input, output1);
    // postProcessing(input, output);
    // } catch (Exception) {
    //   print(Exception.toString());
    // }
    // return output;
  }

  List<double> imageToTensor(img.Image image) {
    // Define input size expected by MobileNet V2 (usually 224x224)
    const inputSize = 224;

    // Resize the image to the input size
    img.Image resizedImage =
        img.copyResize(image, height: inputSize, width: inputSize);

    // Convert the image to a list of pixel values
    // List<int> imageData = img.getPixelData(resizedImage);
    List<int> imageData = resizedImage.getBytes().buffer.asInt32List();
    // Normalize pixel values to the range of 0-1
    List<double> normalizedImageData =
        imageData.map((value) => value / 255.0).toList();

    // final inputTensor = ImageToTensor(normalizedImageData).toTensor();

    // Create a 4D tensor with shape [1, inputSize, inputSize, 3]
    TensorBuffer buffer = TensorBuffer.createFixedSize(
        [1, inputSize, inputSize, 3], tfl.TfLiteType.float32);
    buffer.loadList(normalizedImageData, shape: [1, inputSize, inputSize, 3]);

    return buffer.getDoubleList();
  }

  // void postProcessing(List<dynamic> input, List<dynamic> output) async {
  //   // var output = loadModel();
  //   Uint8List maskBytes = output as Uint8List;
  //   imglib.Image maskImage =
  //       (await decodeImageFromList(maskBytes)) as imglib.Image;
  //
  //   Uint8List inputBytes = output as Uint8List;
  //   imglib.Image inputImage =
  //       (await decodeImageFromList(inputBytes)) as imglib.Image;
  //
  //   int maskWidth = maskImage.width;
  //   int maskHeight = maskImage.height;
  //
  //   List<double> maskValues;
  //
  //   // Iterate through each pixel of the mask
  //   for (int y = 0; y < maskHeight; y++) {
  //     for (int x = 0; x < maskWidth; x++) {
  //       // Get the mask value at (x, y)
  //       int maskValue = maskImage.getPixel(x, y);
  //
  //       // Apply thresholding or other processing as needed
  //       if (maskValue >= 0.5) {
  //         // Foreground pixel: preserve original value
  //         maskImage.setPixel(x, y, inputImage.getPixel(x, y));
  //       } else {
  //         // Background pixel: set to transparent
  //
  //         maskImage.setPixel(
  //             x,
  //             y,
  //             imglib.Color.fromRgba(
  //                 0, 0, 0, 0)); // Example of setting transparent value
  //       }
  //
  //       // Use the processed mask value to manipulate the original image
  //     }
  //   }
  //   imglib.Image outputImageWithTransparency =
  //       imglib.copyRotate(maskImage, 90); // Rotate if needed
  //   File('assets/images/ali.jpg').writeAsBytesSync(imglib.encodePng(maskImage));
  // }

  // void delayto() async {
  //   await Future.delayed(Duration(seconds: 1));
  //   setState(() {
  //     loading = false;
  //   });
  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          titleTextStyle: const TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.w500),
          title: const Text("Photo Editor"),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
        ),
        body: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.purpleAccent, Colors.deepOrange])),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset("assets/images/ali.jpg"),
                TextButton(
                    onPressed: () async {
                      setState(() {
                        loadModel();
                      });
                    },
                    child: const Text("Load Image"))
              ],
            ),
          ),
          // child: Center(
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       loading ? const CircularProgressIndicator() : const Text("Oops")
          //     ],
          //   ),
          // ),
        ));
  }
}
