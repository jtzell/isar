import 'package:isar_generator/src/helper.dart';
import 'package:isar_generator/src/object_info.dart';
import 'package:dartx/dartx.dart';

String generateQueryLinks(ObjectInfo oi, List<ObjectInfo?> objects) {
  var code =
      'extension ${oi.dartName}QueryLinks on QueryBuilder<${oi.dartName}, ${oi.dartName}, QFilterCondition> {';
  for (var link in oi.links) {
    final targetOi = objects
        .firstWhere((e) => e!.dartName == link.targetCollectionDartName)!;
    code += '''
      QueryBuilder<${oi.dartName}, ${oi.dartName}, QAfterFilterCondition> ${link.dartName.decapitalize()}(FilterQuery<${link.targetCollectionDartName}> q) {
        return linkInternal(
          isar.${targetOi.accessor},
          q,
          '${link.isarName.esc}',
        );
      }''';
  }
  return '''
    $code
  }''';
}
