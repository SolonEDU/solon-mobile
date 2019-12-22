// import 'dart:io';
import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:Solon/api/rsa_pem.dart';
import 'package:flutter/services.dart';

class EncryptPassword {
  Future<String> loadPublicKey() async {
      return await rootBundle.loadString('assets/public.pem');
  }

  Future<String> loadPrivateKey() async {
      return await rootBundle.loadString('assets/private.pem');
  }

  Future<String> encryptPassword(String plainText) async {
    var rsaKeyHelper = new RsaKeyHelper();
    final RSAPublicKey publicKey = rsaKeyHelper.parsePublicKeyFromPem(await loadPublicKey());
    final RSAPrivateKey privKey = rsaKeyHelper.parsePrivateKeyFromPem(await loadPrivateKey());

    final encrypter = Encrypter(RSA(publicKey: publicKey, privateKey: privKey));

    final encrypted = encrypter.encrypt(plainText);
    final decrypted = encrypter.decrypt(encrypted);

    return encrypted.toString();
    // print(decrypted); // Lorem ipsum dolor sit amet, consectetur adipiscing elit
    // print(encrypted.base64); // kO9EbgbrSwiq0EYz0aBdljHSC/rci2854Qa+nugbhKjidlezNplsEqOxR+pr1RtICZGAtv0YGevJBaRaHS17eHuj7GXo1CM3PR6pjGxrorcwR5Q7/bVEePESsimMbhHWF+AkDIX4v0CwKx9lgaTBgC8/yJKiLmQkyDCj64J3JSE=
  }
}