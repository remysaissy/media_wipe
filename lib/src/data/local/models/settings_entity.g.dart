// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSettingsEntityCollection on Isar {
  IsarCollection<SettingsEntity> get settingsEntitys => this.collection();
}

const SettingsEntitySchema = CollectionSchema(
  name: r'SettingsEntity',
  id: -7271317039764597112,
  properties: {
    r'dbThemeMode': PropertySchema(
      id: 0,
      name: r'dbThemeMode',
      type: IsarType.string,
    ),
    r'debugDryRemoval': PropertySchema(
      id: 1,
      name: r'debugDryRemoval',
      type: IsarType.bool,
    ),
    r'hasInAppReview': PropertySchema(
      id: 2,
      name: r'hasInAppReview',
      type: IsarType.bool,
    ),
    r'hasPhotosAccess': PropertySchema(
      id: 3,
      name: r'hasPhotosAccess',
      type: IsarType.bool,
    ),
  },
  estimateSize: _settingsEntityEstimateSize,
  serialize: _settingsEntitySerialize,
  deserialize: _settingsEntityDeserialize,
  deserializeProp: _settingsEntityDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _settingsEntityGetId,
  getLinks: _settingsEntityGetLinks,
  attach: _settingsEntityAttach,
  version: '3.1.0+1',
);

int _settingsEntityEstimateSize(
  SettingsEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.dbThemeMode.length * 3;
  return bytesCount;
}

void _settingsEntitySerialize(
  SettingsEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.dbThemeMode);
  writer.writeBool(offsets[1], object.debugDryRemoval);
  writer.writeBool(offsets[2], object.hasInAppReview);
  writer.writeBool(offsets[3], object.hasPhotosAccess);
}

SettingsEntity _settingsEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SettingsEntity(
    debugDryRemoval: reader.readBoolOrNull(offsets[1]) ?? true,
    hasInAppReview: reader.readBoolOrNull(offsets[2]) ?? false,
    hasPhotosAccess: reader.readBoolOrNull(offsets[3]) ?? false,
    id: id,
  );
  object.dbThemeMode = reader.readString(offsets[0]);
  return object;
}

P _settingsEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readBoolOrNull(offset) ?? true) as P;
    case 2:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 3:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _settingsEntityGetId(SettingsEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _settingsEntityGetLinks(SettingsEntity object) {
  return [];
}

void _settingsEntityAttach(
  IsarCollection<dynamic> col,
  Id id,
  SettingsEntity object,
) {
  object.id = id;
}

extension SettingsEntityQueryWhereSort
    on QueryBuilder<SettingsEntity, SettingsEntity, QWhere> {
  QueryBuilder<SettingsEntity, SettingsEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SettingsEntityQueryWhere
    on QueryBuilder<SettingsEntity, SettingsEntity, QWhereClause> {
  QueryBuilder<SettingsEntity, SettingsEntity, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterWhereClause> idBetween(
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

extension SettingsEntityQueryFilter
    on QueryBuilder<SettingsEntity, SettingsEntity, QFilterCondition> {
  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  dbThemeModeEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'dbThemeMode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  dbThemeModeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'dbThemeMode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  dbThemeModeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'dbThemeMode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  dbThemeModeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'dbThemeMode',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  dbThemeModeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'dbThemeMode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  dbThemeModeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'dbThemeMode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  dbThemeModeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'dbThemeMode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  dbThemeModeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'dbThemeMode',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  dbThemeModeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'dbThemeMode', value: ''),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  dbThemeModeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'dbThemeMode', value: ''),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  debugDryRemovalEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'debugDryRemoval', value: value),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  hasInAppReviewEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'hasInAppReview', value: value),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  hasPhotosAccessEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'hasPhotosAccess', value: value),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
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

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  idLessThan(Id value, {bool include = false}) {
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

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition> idBetween(
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

extension SettingsEntityQueryObject
    on QueryBuilder<SettingsEntity, SettingsEntity, QFilterCondition> {}

extension SettingsEntityQueryLinks
    on QueryBuilder<SettingsEntity, SettingsEntity, QFilterCondition> {}

extension SettingsEntityQuerySortBy
    on QueryBuilder<SettingsEntity, SettingsEntity, QSortBy> {
  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  sortByDbThemeMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dbThemeMode', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  sortByDbThemeModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dbThemeMode', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  sortByDebugDryRemoval() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'debugDryRemoval', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  sortByDebugDryRemovalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'debugDryRemoval', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  sortByHasInAppReview() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasInAppReview', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  sortByHasInAppReviewDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasInAppReview', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  sortByHasPhotosAccess() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasPhotosAccess', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  sortByHasPhotosAccessDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasPhotosAccess', Sort.desc);
    });
  }
}

extension SettingsEntityQuerySortThenBy
    on QueryBuilder<SettingsEntity, SettingsEntity, QSortThenBy> {
  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  thenByDbThemeMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dbThemeMode', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  thenByDbThemeModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dbThemeMode', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  thenByDebugDryRemoval() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'debugDryRemoval', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  thenByDebugDryRemovalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'debugDryRemoval', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  thenByHasInAppReview() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasInAppReview', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  thenByHasInAppReviewDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasInAppReview', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  thenByHasPhotosAccess() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasPhotosAccess', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  thenByHasPhotosAccessDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasPhotosAccess', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension SettingsEntityQueryWhereDistinct
    on QueryBuilder<SettingsEntity, SettingsEntity, QDistinct> {
  QueryBuilder<SettingsEntity, SettingsEntity, QDistinct>
  distinctByDbThemeMode({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dbThemeMode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QDistinct>
  distinctByDebugDryRemoval() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'debugDryRemoval');
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QDistinct>
  distinctByHasInAppReview() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hasInAppReview');
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QDistinct>
  distinctByHasPhotosAccess() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hasPhotosAccess');
    });
  }
}

extension SettingsEntityQueryProperty
    on QueryBuilder<SettingsEntity, SettingsEntity, QQueryProperty> {
  QueryBuilder<SettingsEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SettingsEntity, String, QQueryOperations> dbThemeModeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dbThemeMode');
    });
  }

  QueryBuilder<SettingsEntity, bool, QQueryOperations>
  debugDryRemovalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'debugDryRemoval');
    });
  }

  QueryBuilder<SettingsEntity, bool, QQueryOperations>
  hasInAppReviewProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hasInAppReview');
    });
  }

  QueryBuilder<SettingsEntity, bool, QQueryOperations>
  hasPhotosAccessProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hasPhotosAccess');
    });
  }
}
