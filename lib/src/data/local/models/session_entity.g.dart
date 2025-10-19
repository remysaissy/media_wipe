// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSessionEntityCollection on Isar {
  IsarCollection<SessionEntity> get sessionEntitys => this.collection();
}

const SessionEntitySchema = CollectionSchema(
  name: r'SessionEntity',
  id: 7472964409236372477,
  properties: {
    r'sessionMonth': PropertySchema(
      id: 0,
      name: r'sessionMonth',
      type: IsarType.long,
    ),
    r'sessionYear': PropertySchema(
      id: 1,
      name: r'sessionYear',
      type: IsarType.long,
    ),
  },
  estimateSize: _sessionEntityEstimateSize,
  serialize: _sessionEntitySerialize,
  deserialize: _sessionEntityDeserialize,
  deserializeProp: _sessionEntityDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'assetsToDrop': LinkSchema(
      id: 856888003175909294,
      name: r'assetsToDrop',
      target: r'AssetEntity',
      single: false,
    ),
    r'refineAssetsToDrop': LinkSchema(
      id: 6562243709689098450,
      name: r'refineAssetsToDrop',
      target: r'AssetEntity',
      single: false,
    ),
    r'assetInReview': LinkSchema(
      id: 5649504400608978674,
      name: r'assetInReview',
      target: r'AssetEntity',
      single: true,
    ),
  },
  embeddedSchemas: {},
  getId: _sessionEntityGetId,
  getLinks: _sessionEntityGetLinks,
  attach: _sessionEntityAttach,
  version: '3.1.0+1',
);

int _sessionEntityEstimateSize(
  SessionEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _sessionEntitySerialize(
  SessionEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.sessionMonth);
  writer.writeLong(offsets[1], object.sessionYear);
}

SessionEntity _sessionEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SessionEntity(
    id: id,
    sessionMonth: reader.readLong(offsets[0]),
    sessionYear: reader.readLong(offsets[1]),
  );
  return object;
}

P _sessionEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _sessionEntityGetId(SessionEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _sessionEntityGetLinks(SessionEntity object) {
  return [object.assetsToDrop, object.refineAssetsToDrop, object.assetInReview];
}

void _sessionEntityAttach(
  IsarCollection<dynamic> col,
  Id id,
  SessionEntity object,
) {
  object.id = id;
  object.assetsToDrop.attach(
    col,
    col.isar.collection<AssetEntity>(),
    r'assetsToDrop',
    id,
  );
  object.refineAssetsToDrop.attach(
    col,
    col.isar.collection<AssetEntity>(),
    r'refineAssetsToDrop',
    id,
  );
  object.assetInReview.attach(
    col,
    col.isar.collection<AssetEntity>(),
    r'assetInReview',
    id,
  );
}

extension SessionEntityQueryWhereSort
    on QueryBuilder<SessionEntity, SessionEntity, QWhere> {
  QueryBuilder<SessionEntity, SessionEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SessionEntityQueryWhere
    on QueryBuilder<SessionEntity, SessionEntity, QWhereClause> {
  QueryBuilder<SessionEntity, SessionEntity, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<SessionEntity, SessionEntity, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterWhereClause> idBetween(
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

extension SessionEntityQueryFilter
    on QueryBuilder<SessionEntity, SessionEntity, QFilterCondition> {
  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  idGreaterThan(Id value, {bool include = false}) {
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

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition> idBetween(
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

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  sessionMonthEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'sessionMonth', value: value),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  sessionMonthGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'sessionMonth',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  sessionMonthLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'sessionMonth',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  sessionMonthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'sessionMonth',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  sessionYearEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'sessionYear', value: value),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  sessionYearGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'sessionYear',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  sessionYearLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'sessionYear',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  sessionYearBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'sessionYear',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension SessionEntityQueryObject
    on QueryBuilder<SessionEntity, SessionEntity, QFilterCondition> {}

extension SessionEntityQueryLinks
    on QueryBuilder<SessionEntity, SessionEntity, QFilterCondition> {
  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  assetsToDrop(FilterQuery<AssetEntity> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'assetsToDrop');
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  assetsToDropLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'assetsToDrop', length, true, length, true);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  assetsToDropIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'assetsToDrop', 0, true, 0, true);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  assetsToDropIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'assetsToDrop', 0, false, 999999, true);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  assetsToDropLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'assetsToDrop', 0, true, length, include);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  assetsToDropLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'assetsToDrop', length, include, 999999, true);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  assetsToDropLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
        r'assetsToDrop',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  refineAssetsToDrop(FilterQuery<AssetEntity> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'refineAssetsToDrop');
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  refineAssetsToDropLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
        r'refineAssetsToDrop',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  refineAssetsToDropIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'refineAssetsToDrop', 0, true, 0, true);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  refineAssetsToDropIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'refineAssetsToDrop', 0, false, 999999, true);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  refineAssetsToDropLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'refineAssetsToDrop', 0, true, length, include);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  refineAssetsToDropLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
        r'refineAssetsToDrop',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  refineAssetsToDropLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
        r'refineAssetsToDrop',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  assetInReview(FilterQuery<AssetEntity> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'assetInReview');
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  assetInReviewIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'assetInReview', 0, true, 0, true);
    });
  }
}

extension SessionEntityQuerySortBy
    on QueryBuilder<SessionEntity, SessionEntity, QSortBy> {
  QueryBuilder<SessionEntity, SessionEntity, QAfterSortBy>
  sortBySessionMonth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionMonth', Sort.asc);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterSortBy>
  sortBySessionMonthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionMonth', Sort.desc);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterSortBy> sortBySessionYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionYear', Sort.asc);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterSortBy>
  sortBySessionYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionYear', Sort.desc);
    });
  }
}

extension SessionEntityQuerySortThenBy
    on QueryBuilder<SessionEntity, SessionEntity, QSortThenBy> {
  QueryBuilder<SessionEntity, SessionEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterSortBy>
  thenBySessionMonth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionMonth', Sort.asc);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterSortBy>
  thenBySessionMonthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionMonth', Sort.desc);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterSortBy> thenBySessionYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionYear', Sort.asc);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterSortBy>
  thenBySessionYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionYear', Sort.desc);
    });
  }
}

extension SessionEntityQueryWhereDistinct
    on QueryBuilder<SessionEntity, SessionEntity, QDistinct> {
  QueryBuilder<SessionEntity, SessionEntity, QDistinct>
  distinctBySessionMonth() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sessionMonth');
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QDistinct>
  distinctBySessionYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sessionYear');
    });
  }
}

extension SessionEntityQueryProperty
    on QueryBuilder<SessionEntity, SessionEntity, QQueryProperty> {
  QueryBuilder<SessionEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SessionEntity, int, QQueryOperations> sessionMonthProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sessionMonth');
    });
  }

  QueryBuilder<SessionEntity, int, QQueryOperations> sessionYearProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sessionYear');
    });
  }
}
