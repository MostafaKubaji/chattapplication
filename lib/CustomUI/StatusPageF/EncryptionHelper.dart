import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pointycastle/api.dart' as crypto;
import 'package:pointycastle/export.dart' as rsa;
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:pointycastle/export.dart' as crypto;


class EncryptionHelper {
  crypto.AsymmetricKeyPair<crypto.PublicKey, crypto.PrivateKey> generateRSAKeyPair() {
    final keyGen = rsa.RSAKeyGenerator()
      ..init(crypto.ParametersWithRandom(
          rsa.RSAKeyGeneratorParameters(BigInt.from(65537), 2048, 64),
          crypto.SecureRandom("Fortuna")));

    return keyGen.generateKeyPair();
  }

  String encryptWithRSA(String plainText, crypto.RSAPublicKey publicKey) {
    final encrypter = rsa.RSAEngine()
      ..init(true, crypto.PublicKeyParameter<crypto.RSAPublicKey>(publicKey));

    final plainTextBytes = utf8.encode(plainText);
    final encryptedBytes = encrypter.process(Uint8List.fromList(plainTextBytes));

    return base64Encode(encryptedBytes);
  }

  String decryptWithRSA(String encryptedText, crypto.RSAPrivateKey privateKey) {
    final decrypter = rsa.RSAEngine()
      ..init(false, crypto.PrivateKeyParameter<crypto.RSAPrivateKey>(privateKey));

    final encryptedBytes = base64Decode(encryptedText);
    final decryptedBytes = decrypter.process(Uint8List.fromList(encryptedBytes));

    return utf8.decode(decryptedBytes);
  }
}
