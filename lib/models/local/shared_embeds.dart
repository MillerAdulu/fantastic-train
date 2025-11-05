import 'package:isar_community/isar.dart';

part 'shared_embeds.g.dart';

@embedded
class FCLocalAttribute {
  FCLocalAttribute({
    this.ulid,
  });

  final String? ulid;
}

@embedded
class FCLocalProperty {
  FCLocalProperty({
    this.ulid,
  });

  final String? ulid;
}

@embedded
class FCLocalSignature {
  FCLocalSignature({
    this.ulid,
  });

  final String? ulid;
}
