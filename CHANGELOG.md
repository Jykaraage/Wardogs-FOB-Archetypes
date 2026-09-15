# Changelog

## v2.0.0-pre — 2026-09-15

### Changed

- 設計対象を「単一FOBの耐久性」から「分散したFOBシステムの効果継続性」へ変更。
- blast radius中心の評価に加え、shell camera等による`targeting footprint`と`sensor exposure`を導入。
- `TTE / TTD / TTR / PAR / CAR / CAV`をv2の評価指標として追加。
- `asset redundancy`より`site redundancy`を上位概念として扱う方針へ変更。
- Drill / fire support / spawn / logisticsを可能な限り別failure domainへ分離。
- Uralを静的基地構成物ではなくpulsed logistics nodeとして扱う。
- rebuild-in-placeよりdisplacement / effect regenerationを優先する暫定SOPを追加。
- terrain independentとterrain blindを区別し、portable template + terrain exploitationの二層設計へ変更。

### Added

- `docs/doctrine-v2.md`
- `archetypes/mdf-55/`
- `archetypes/ptf-2/`
- `archetypes/fsn/`

### Reclassified

- `MDF-30`は廃止せず、single-blast separationのbaseline / benchmarkへ位置づけを変更。

### Pre-release limitations

次の値は未確定であり、v2正式版までにゲーム内検証が必要。

- MDF-55の最終離隔
- PTF-2のCell間距離
- shell camera / SPH-2の実効targeting footprint
- Core破壊後のDrill依存
- displacement triggerの定量閾値
