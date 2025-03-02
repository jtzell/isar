import 'package:isar/isar.dart';
import 'package:isar_test/common.dart';
import 'package:test/test.dart';

part 'change_field_nullability_test.g.dart';

@Collection()
@Name('Col')
class Col1 {
  int? id;

  String? value;

  Col1(this.id, this.value);

  @override
  operator ==(other) => other is Col1 && id == other.id && value == other.value;
}

@Collection()
@Name('Col')
class Col2 {
  int? id;

  late String value;

  Col2(this.id, this.value);

  @override
  operator ==(other) => other is Col2 && id == other.id && value == other.value;
}

void main() {
  isarTest('Change field nullability', () async {
    final isar1 = await openTempIsar([Col1Schema]);
    await isar1.writeTxn((isar) {
      return isar.col1s.putAll([Col1(1, 'a'), Col1(2, null)]);
    });
    expect(await isar1.close(), true);

    final isar2 = await openTempIsar([Col2Schema], name: isar1.name);
    await qEqual(isar2.col2s.where().findAll(), [Col2(1, 'a'), Col2(2, '')]);
    await isar2.writeTxn((isar) {
      return isar.col2s.put(Col2(1, 'c'));
    });
    expect(await isar2.close(), true);

    final isar3 = await openTempIsar([Col1Schema], name: isar1.name);
    await qEqual(isar3.col1s.where().findAll(), [Col1(1, 'c'), Col1(2, null)]);
    expect(await isar3.close(), true);
  });
}
