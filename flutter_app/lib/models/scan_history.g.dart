// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_history.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetScanHistoryCollection on Isar {
  IsarCollection<ScanHistory> get scanHistorys => this.collection();
}

const ScanHistorySchema = CollectionSchema(
  name: r'ScanHistory',
  id: -7298131417670308154,
  properties: {
    r'cloudImageUrl': PropertySchema(
      id: 0,
      name: r'cloudImageUrl',
      type: IsarType.string,
    ),
    r'confidence': PropertySchema(
      id: 1,
      name: r'confidence',
      type: IsarType.double,
    ),
    r'diseaseName': PropertySchema(
      id: 2,
      name: r'diseaseName',
      type: IsarType.string,
    ),
    r'firestoreId': PropertySchema(
      id: 3,
      name: r'firestoreId',
      type: IsarType.string,
    ),
    r'imagePath': PropertySchema(
      id: 4,
      name: r'imagePath',
      type: IsarType.string,
    ),
    r'plantType': PropertySchema(
      id: 5,
      name: r'plantType',
      type: IsarType.string,
    ),
    r'rawLabel': PropertySchema(
      id: 6,
      name: r'rawLabel',
      type: IsarType.string,
    ),
    r'scanDate': PropertySchema(
      id: 7,
      name: r'scanDate',
      type: IsarType.dateTime,
    ),
    r'userId': PropertySchema(
      id: 8,
      name: r'userId',
      type: IsarType.string,
    )
  },
  estimateSize: _scanHistoryEstimateSize,
  serialize: _scanHistorySerialize,
  deserialize: _scanHistoryDeserialize,
  deserializeProp: _scanHistoryDeserializeProp,
  idName: r'id',
  indexes: {
    r'userId': IndexSchema(
      id: -2005826577402374815,
      name: r'userId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'userId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'firestoreId': IndexSchema(
      id: 1863077355534729001,
      name: r'firestoreId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'firestoreId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _scanHistoryGetId,
  getLinks: _scanHistoryGetLinks,
  attach: _scanHistoryAttach,
  version: '3.1.0+1',
);

int _scanHistoryEstimateSize(
  ScanHistory object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.cloudImageUrl;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.diseaseName.length * 3;
  {
    final value = object.firestoreId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.imagePath.length * 3;
  bytesCount += 3 + object.plantType.length * 3;
  bytesCount += 3 + object.rawLabel.length * 3;
  bytesCount += 3 + object.userId.length * 3;
  return bytesCount;
}

void _scanHistorySerialize(
  ScanHistory object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.cloudImageUrl);
  writer.writeDouble(offsets[1], object.confidence);
  writer.writeString(offsets[2], object.diseaseName);
  writer.writeString(offsets[3], object.firestoreId);
  writer.writeString(offsets[4], object.imagePath);
  writer.writeString(offsets[5], object.plantType);
  writer.writeString(offsets[6], object.rawLabel);
  writer.writeDateTime(offsets[7], object.scanDate);
  writer.writeString(offsets[8], object.userId);
}

ScanHistory _scanHistoryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ScanHistory();
  object.cloudImageUrl = reader.readStringOrNull(offsets[0]);
  object.confidence = reader.readDouble(offsets[1]);
  object.diseaseName = reader.readString(offsets[2]);
  object.firestoreId = reader.readStringOrNull(offsets[3]);
  object.id = id;
  object.imagePath = reader.readString(offsets[4]);
  object.plantType = reader.readString(offsets[5]);
  object.rawLabel = reader.readString(offsets[6]);
  object.scanDate = reader.readDateTime(offsets[7]);
  object.userId = reader.readString(offsets[8]);
  return object;
}

P _scanHistoryDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readDateTime(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _scanHistoryGetId(ScanHistory object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _scanHistoryGetLinks(ScanHistory object) {
  return [];
}

void _scanHistoryAttach(
    IsarCollection<dynamic> col, Id id, ScanHistory object) {
  object.id = id;
}

extension ScanHistoryQueryWhereSort
    on QueryBuilder<ScanHistory, ScanHistory, QWhere> {
  QueryBuilder<ScanHistory, ScanHistory, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ScanHistoryQueryWhere
    on QueryBuilder<ScanHistory, ScanHistory, QWhereClause> {
  QueryBuilder<ScanHistory, ScanHistory, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterWhereClause> userIdEqualTo(
      String userId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'userId',
        value: [userId],
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterWhereClause> userIdNotEqualTo(
      String userId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [],
              upper: [userId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [userId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [userId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [],
              upper: [userId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterWhereClause>
      firestoreIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'firestoreId',
        value: [null],
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterWhereClause>
      firestoreIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'firestoreId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterWhereClause> firestoreIdEqualTo(
      String? firestoreId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'firestoreId',
        value: [firestoreId],
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterWhereClause>
      firestoreIdNotEqualTo(String? firestoreId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'firestoreId',
              lower: [],
              upper: [firestoreId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'firestoreId',
              lower: [firestoreId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'firestoreId',
              lower: [firestoreId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'firestoreId',
              lower: [],
              upper: [firestoreId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension ScanHistoryQueryFilter
    on QueryBuilder<ScanHistory, ScanHistory, QFilterCondition> {
  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition>
      cloudImageUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'cloudImageUrl',
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition>
      cloudImageUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'cloudImageUrl',
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition>
      cloudImageUrlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cloudImageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition>
      cloudImageUrlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cloudImageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition>
      cloudImageUrlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cloudImageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition>
      cloudImageUrlBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cloudImageUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition>
      cloudImageUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'cloudImageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition>
      cloudImageUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'cloudImageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition>
      cloudImageUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'cloudImageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition>
      cloudImageUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'cloudImageUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition>
      cloudImageUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cloudImageUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition>
      cloudImageUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'cloudImageUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition>
      confidenceEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'confidence',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition>
      confidenceGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'confidence',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition>
      confidenceLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'confidence',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition>
      confidenceBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'confidence',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition>
      diseaseNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'diseaseName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition>
      diseaseNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'diseaseName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition>
      diseaseNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'diseaseName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition>
      diseaseNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'diseaseName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition>
      diseaseNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'diseaseName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition>
      diseaseNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'diseaseName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition>
      diseaseNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'diseaseName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition>
      diseaseNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'diseaseName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition>
      diseaseNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'diseaseName',
        value: '',
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition>
      diseaseNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'diseaseName',
        value: '',
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition>
      firestoreIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'firestoreId',
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition>
      firestoreIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'firestoreId',
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition>
      firestoreIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'firestoreId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition>
      firestoreIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'firestoreId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition>
      firestoreIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'firestoreId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition>
      firestoreIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'firestoreId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition>
      firestoreIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'firestoreId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition>
      firestoreIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'firestoreId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition>
      firestoreIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'firestoreId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition>
      firestoreIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'firestoreId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition>
      firestoreIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'firestoreId',
        value: '',
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition>
      firestoreIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'firestoreId',
        value: '',
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition>
      imagePathEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition>
      imagePathGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition>
      imagePathLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition>
      imagePathBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'imagePath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition>
      imagePathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition>
      imagePathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition>
      imagePathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition>
      imagePathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'imagePath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition>
      imagePathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imagePath',
        value: '',
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition>
      imagePathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'imagePath',
        value: '',
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition>
      plantTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'plantType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition>
      plantTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'plantType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition>
      plantTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'plantType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition>
      plantTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'plantType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition>
      plantTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'plantType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition>
      plantTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'plantType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition>
      plantTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'plantType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition>
      plantTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'plantType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition>
      plantTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'plantType',
        value: '',
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition>
      plantTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'plantType',
        value: '',
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition> rawLabelEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rawLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition>
      rawLabelGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rawLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition>
      rawLabelLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rawLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition> rawLabelBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rawLabel',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition>
      rawLabelStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'rawLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition>
      rawLabelEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'rawLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition>
      rawLabelContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'rawLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition> rawLabelMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'rawLabel',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition>
      rawLabelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rawLabel',
        value: '',
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition>
      rawLabelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'rawLabel',
        value: '',
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition> scanDateEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'scanDate',
        value: value,
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition>
      scanDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'scanDate',
        value: value,
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition>
      scanDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'scanDate',
        value: value,
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition> scanDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'scanDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition> userIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition>
      userIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition> userIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition> userIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'userId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition>
      userIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition> userIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition> userIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition> userIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition>
      userIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: '',
      ));
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterFilterCondition>
      userIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userId',
        value: '',
      ));
    });
  }
}

extension ScanHistoryQueryObject
    on QueryBuilder<ScanHistory, ScanHistory, QFilterCondition> {}

extension ScanHistoryQueryLinks
    on QueryBuilder<ScanHistory, ScanHistory, QFilterCondition> {}

extension ScanHistoryQuerySortBy
    on QueryBuilder<ScanHistory, ScanHistory, QSortBy> {
  QueryBuilder<ScanHistory, ScanHistory, QAfterSortBy> sortByCloudImageUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cloudImageUrl', Sort.asc);
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterSortBy>
      sortByCloudImageUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cloudImageUrl', Sort.desc);
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterSortBy> sortByConfidence() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confidence', Sort.asc);
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterSortBy> sortByConfidenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confidence', Sort.desc);
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterSortBy> sortByDiseaseName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'diseaseName', Sort.asc);
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterSortBy> sortByDiseaseNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'diseaseName', Sort.desc);
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterSortBy> sortByFirestoreId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firestoreId', Sort.asc);
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterSortBy> sortByFirestoreIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firestoreId', Sort.desc);
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterSortBy> sortByImagePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePath', Sort.asc);
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterSortBy> sortByImagePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePath', Sort.desc);
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterSortBy> sortByPlantType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plantType', Sort.asc);
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterSortBy> sortByPlantTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plantType', Sort.desc);
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterSortBy> sortByRawLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawLabel', Sort.asc);
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterSortBy> sortByRawLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawLabel', Sort.desc);
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterSortBy> sortByScanDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scanDate', Sort.asc);
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterSortBy> sortByScanDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scanDate', Sort.desc);
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterSortBy> sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterSortBy> sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension ScanHistoryQuerySortThenBy
    on QueryBuilder<ScanHistory, ScanHistory, QSortThenBy> {
  QueryBuilder<ScanHistory, ScanHistory, QAfterSortBy> thenByCloudImageUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cloudImageUrl', Sort.asc);
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterSortBy>
      thenByCloudImageUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cloudImageUrl', Sort.desc);
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterSortBy> thenByConfidence() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confidence', Sort.asc);
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterSortBy> thenByConfidenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confidence', Sort.desc);
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterSortBy> thenByDiseaseName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'diseaseName', Sort.asc);
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterSortBy> thenByDiseaseNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'diseaseName', Sort.desc);
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterSortBy> thenByFirestoreId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firestoreId', Sort.asc);
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterSortBy> thenByFirestoreIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firestoreId', Sort.desc);
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterSortBy> thenByImagePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePath', Sort.asc);
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterSortBy> thenByImagePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePath', Sort.desc);
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterSortBy> thenByPlantType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plantType', Sort.asc);
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterSortBy> thenByPlantTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plantType', Sort.desc);
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterSortBy> thenByRawLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawLabel', Sort.asc);
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterSortBy> thenByRawLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawLabel', Sort.desc);
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterSortBy> thenByScanDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scanDate', Sort.asc);
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterSortBy> thenByScanDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scanDate', Sort.desc);
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterSortBy> thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QAfterSortBy> thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension ScanHistoryQueryWhereDistinct
    on QueryBuilder<ScanHistory, ScanHistory, QDistinct> {
  QueryBuilder<ScanHistory, ScanHistory, QDistinct> distinctByCloudImageUrl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cloudImageUrl',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QDistinct> distinctByConfidence() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'confidence');
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QDistinct> distinctByDiseaseName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'diseaseName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QDistinct> distinctByFirestoreId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'firestoreId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QDistinct> distinctByImagePath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'imagePath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QDistinct> distinctByPlantType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'plantType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QDistinct> distinctByRawLabel(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rawLabel', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QDistinct> distinctByScanDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'scanDate');
    });
  }

  QueryBuilder<ScanHistory, ScanHistory, QDistinct> distinctByUserId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId', caseSensitive: caseSensitive);
    });
  }
}

extension ScanHistoryQueryProperty
    on QueryBuilder<ScanHistory, ScanHistory, QQueryProperty> {
  QueryBuilder<ScanHistory, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ScanHistory, String?, QQueryOperations> cloudImageUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cloudImageUrl');
    });
  }

  QueryBuilder<ScanHistory, double, QQueryOperations> confidenceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'confidence');
    });
  }

  QueryBuilder<ScanHistory, String, QQueryOperations> diseaseNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'diseaseName');
    });
  }

  QueryBuilder<ScanHistory, String?, QQueryOperations> firestoreIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'firestoreId');
    });
  }

  QueryBuilder<ScanHistory, String, QQueryOperations> imagePathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'imagePath');
    });
  }

  QueryBuilder<ScanHistory, String, QQueryOperations> plantTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'plantType');
    });
  }

  QueryBuilder<ScanHistory, String, QQueryOperations> rawLabelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rawLabel');
    });
  }

  QueryBuilder<ScanHistory, DateTime, QQueryOperations> scanDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'scanDate');
    });
  }

  QueryBuilder<ScanHistory, String, QQueryOperations> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }
}
