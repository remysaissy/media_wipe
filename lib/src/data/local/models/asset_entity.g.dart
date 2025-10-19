// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAssetEntityCollection on Isar {
  IsarCollection<AssetEntity> get assetEntitys => this.collection();
}

const AssetEntitySchema = CollectionSchema(
  name: r'AssetEntity',
  id: 6375768891807151342,
  properties: {
    r'assetId': PropertySchema(id: 0, name: r'assetId', type: IsarType.string),
    r'creationDate': PropertySchema(
      id: 1,
      name: r'creationDate',
      type: IsarType.dateTime,
    ),
  },
  estimateSize: _assetEntityEstimateSize,
  serialize: _assetEntitySerialize,
  deserialize: _assetEntityDeserialize,
  deserializeProp: _assetEntityDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _assetEntityGetId,
  getLinks: _assetEntityGetLinks,
  attach: _assetEntityAttach,
  version: '3.1.0+1',
);

int _assetEntityEstimateSize(
  AssetEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.assetId.length * 3;
  return bytesCount;
}

void _assetEntitySerialize(
  AssetEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.assetId);
  writer.writeDateTime(offsets[1], object.creationDate);
}

AssetEntity _assetEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AssetEntity(
    assetId: reader.readString(offsets[0]),
    creationDate: reader.readDateTime(offsets[1]),
    id: id,
  );
  return object;
}

P _assetEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _assetEntityGetId(AssetEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _assetEntityGetLinks(AssetEntity object) {
  return [];
}

void _assetEntityAttach(
  IsarCollection<dynamic> col,
  Id id,
  AssetEntity object,
) {
  object.id = id;
}

extension AssetEntityQueryWhereSort
    on QueryBuilder<AssetEntity, AssetEntity, QWhere> {
  QueryBuilder<AssetEntity, AssetEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AssetEntityQueryWhere
    on QueryBuilder<AssetEntity, AssetEntity, QWhereClause> {
  QueryBuilder<AssetEntity, AssetEntity, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<AssetEntity, AssetEntity, QAfterWhereClause> idNotEqualTo(
    Id id,
  ) {
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

  QueryBuilder<AssetEntity, AssetEntity, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AssetEntity, AssetEntity, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AssetEntity, AssetEntity, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension AssetEntityQueryFilter
    on QueryBuilder<AssetEntity, AssetEntity, QFilterCondition> {
  QueryBuilder<AssetEntity, AssetEntity, QAfterFilterCondition> assetIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'assetId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AssetEntity, AssetEntity, QAfterFilterCondition>
  assetIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'assetId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AssetEntity, AssetEntity, QAfterFilterCondition> assetIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'assetId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AssetEntity, AssetEntity, QAfterFilterCondition> assetIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'assetId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AssetEntity, AssetEntity, QAfterFilterCondition>
  assetIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'assetId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AssetEntity, AssetEntity, QAfterFilterCondition> assetIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'assetId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AssetEntity, AssetEntity, QAfterFilterCondition> assetIdContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'assetId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AssetEntity, AssetEntity, QAfterFilterCondition> assetIdMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'assetId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AssetEntity, AssetEntity, QAfterFilterCondition>
  assetIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'assetId', value: ''),
      );
    });
  }

  QueryBuilder<AssetEntity, AssetEntity, QAfterFilterCondition>
  assetIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'assetId', value: ''),
      );
    });
  }

  QueryBuilder<AssetEntity, AssetEntity, QAfterFilterCondition>
  creationDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'creationDate', value: value),
      );
    });
  }

  QueryBuilder<AssetEntity, AssetEntity, QAfterFilterCondition>
  creationDateGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'creationDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AssetEntity, AssetEntity, QAfterFilterCondition>
  creationDateLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'creationDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AssetEntity, AssetEntity, QAfterFilterCondition>
  creationDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'creationDate',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AssetEntity, AssetEntity, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<AssetEntity, AssetEntity, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AssetEntity, AssetEntity, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AssetEntity, AssetEntity, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension AssetEntityQueryObject
    on QueryBuilder<AssetEntity, AssetEntity, QFilterCondition> {}

extension AssetEntityQueryLinks
    on QueryBuilder<AssetEntity, AssetEntity, QFilterCondition> {}

extension AssetEntityQuerySortBy
    on QueryBuilder<AssetEntity, AssetEntity, QSortBy> {
  QueryBuilder<AssetEntity, AssetEntity, QAfterSortBy> sortByAssetId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assetId', Sort.asc);
    });
  }

  QueryBuilder<AssetEntity, AssetEntity, QAfterSortBy> sortByAssetIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assetId', Sort.desc);
    });
  }

  QueryBuilder<AssetEntity, AssetEntity, QAfterSortBy> sortByCreationDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'creationDate', Sort.asc);
    });
  }

  QueryBuilder<AssetEntity, AssetEntity, QAfterSortBy>
  sortByCreationDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'creationDate', Sort.desc);
    });
  }
}

extension AssetEntityQuerySortThenBy
    on QueryBuilder<AssetEntity, AssetEntity, QSortThenBy> {
  QueryBuilder<AssetEntity, AssetEntity, QAfterSortBy> thenByAssetId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assetId', Sort.asc);
    });
  }

  QueryBuilder<AssetEntity, AssetEntity, QAfterSortBy> thenByAssetIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assetId', Sort.desc);
    });
  }

  QueryBuilder<AssetEntity, AssetEntity, QAfterSortBy> thenByCreationDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'creationDate', Sort.asc);
    });
  }

  QueryBuilder<AssetEntity, AssetEntity, QAfterSortBy>
  thenByCreationDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'creationDate', Sort.desc);
    });
  }

  QueryBuilder<AssetEntity, AssetEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AssetEntity, AssetEntity, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension AssetEntityQueryWhereDistinct
    on QueryBuilder<AssetEntity, AssetEntity, QDistinct> {
  QueryBuilder<AssetEntity, AssetEntity, QDistinct> distinctByAssetId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'assetId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AssetEntity, AssetEntity, QDistinct> distinctByCreationDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'creationDate');
    });
  }
}

extension AssetEntityQueryProperty
    on QueryBuilder<AssetEntity, AssetEntity, QQueryProperty> {
  QueryBuilder<AssetEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AssetEntity, String, QQueryOperations> assetIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'assetId');
    });
  }

  QueryBuilder<AssetEntity, DateTime, QQueryOperations> creationDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'creationDate');
    });
  }
}
