import 'dart:convert';

import 'package:demo25/models/remote/auth.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

class FCUserAdapter extends TypeAdapter<FCUser> {
  @override
  final typeId = 0;

  @override
  FCUser read(BinaryReader reader) {
    return FCUser.fromJson(
      Map<String, dynamic>.of(
        json.decode(reader.read() as String) as Map<String, dynamic>,
      ),
    );
  }

  @override
  void write(BinaryWriter writer, FCUser obj) {
    writer.write(json.encode(obj.toJson()));
  }
}
