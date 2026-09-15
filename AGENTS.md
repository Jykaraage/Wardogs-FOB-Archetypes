# AGENTS.md

このリポジトリは、WARDOGSのFOBを「再現可能な設計アーキタイプ」として研究するためのものです。Codex等のエージェントは、実装や清書を始める前に本ファイルを読み、以下の規約に従ってください。

Current design line: **v2.0.0-pre**

## 0. 最初に実行すること

submoduleを初期化します。

```bash
./scripts/bootstrap.sh
```

`skills/natural-japanese/SKILL.md`が読めることを確認してください。重要な日本語文書の新規作成・大幅改稿では、このSkillを読み、**full相当の工程**で推敲してください。軽微な誤字修正やJSON更新だけなら不要です。

## 1. 研究目的

主対象は、Ural 2〜3台、Large Hammerを持つBuilder 3〜4人で迅速に展開でき、敵砲迫の集中を受けた場合は損切りして転進できる小規模FOBです。

v2では「単一FOBをどこまで硬くできるか」ではなく、**分散したeffect-generating nodesとmobile logisticsからなるシステムを、短時間で展開・放棄・再生成できるか**を研究します。

`MDF-30`はsingle-blast separationのbenchmarkとして残します。v2の主候補は`MDF-55`と`PTF-2`、補助候補は`FSN`です。名称に含まれる数値を含め、未実測値は確定仕様ではありません。

上位原則は`docs/doctrine-v2.md`を最初に読んでください。

## 2. 根拠を分離する

情報は必ず次の階層で扱います。

1. `official` — BULKHEAD / WARDOGS公式
2. `in_game_verified` — 現行ビルドでの再現可能な実測
3. `extracted` — game data / collision等からの抽出
4. `community` — 攻略サイト・GitHub・Reddit等の観測
5. `assumption` — 設計仮説・暫定値

現代戦の公開資料を使う場合は、さらに次を区別してください。

- `official_doctrine`
- `army_hosted_lessons_learned`
- `professional_analysis`

Army公式サイト上の文書であっても、本文が著者見解としているものを`official_doctrine`と呼ばないでください。

`community`や`assumption`を、文体だけで`official`のように見せないでください。矛盾する値を発見したら平均値を作らず、両方を記録して実測タスクに回します。

数値を追加・変更するときは、可能な限り次を残します。

- `value` / `unit`
- `source_id`
- `source_type`
- `observed_at`
- `game_build`
- `confidence`
- 検証方法または未検証理由

詳細は`docs/evidence-policy.md`を参照してください。

## 3. v2設計原則

### Portable geometry

一定の平地なら平行移動・回転だけで再現できる基準形を持ちます。ただし`terrain independent`を`terrain blind`と解釈しません。既存地形を使える場合は、遮蔽・分断・道路を利用してgeometryを変形します。

### Critical-asset dispersion

Drill Rig、FOB Core、fire support、spawn vehicle、Uralを一点へ密集させません。

### Targeting footprint

blast radiusだけで安全性を判定しません。一つの観測機会から何個のcritical assetがtargetableになるかを評価してください。

### Sensor exposure / CAV

一つのnodeを敵が捕捉したとき、同じ観測・修正サイクルから何個の重要資産が露呈するかを`CAV`として比較します。

### Site redundancy over asset redundancy

Drillを2基にしてもCore依存が残るなら完全冗長と呼びません。可能ならeffect sourceそのものを複数siteへ分割します。

### Failure-domain separation

原則:

```text
DRILL NODE != FIRE SUPPORT NODE
SPAWN NODE != PRIMARY DRILL NODE
URAL != STATIC FOB COMPONENT
```

例外を採用する場合は、追加コストではなく統合する合理的理由を記録してください。

### Rapid build / rapid abandon / rapid restore

建築時間だけでなく、車両離脱、放棄判断、別地点での効果復旧を設計に含めます。

### Pulsed logistics

Uralは荷下ろし後に離脱するmobile logistics nodeとして扱います。車両を防壁や固定倉庫として標準構成へ組み込みません。

### No rebuild-by-habit

既知の砲撃座標へ同じ設備を機械的に再建しません。敵の修正射撃が成立している場合はalternate siteへのeffect regenerationを比較してください。

### Data-driven

blast radius、targeting footprint、footprint、build radius、cost、FOB間距離等を描画コードへ散在させません。

## 4. v2評価指標

最低限、次を定義または測定します。

- `TTE` — Time To Effect
- `TTD` — Time To Displace
- `TTR` — Time To Restore
- `PAR` — Players At Risk
- `CAR` — Cash At Risk
- `CAV` — Critical Assets Visible

単一FOBのsurvival timeだけで設計を勝敗判定しないでください。

## 5. 図面の契約

図面は2層に分けます。

### Overview

ゲーム内Tactical Mapと整合する地図・座標系の上に、FOB/Cell位置、重要設備、build area、車両進入・離脱方向、alternate site、node間関係を重ねます。

### Detail

ローカル座標系で作る詳細図です。SVGをcanonical sourceとし、必要に応じてPNGへレンダリングします。最低限、次を表現できる設計にします。

- 1 m基準のgrid / dimension
- structure footprint
- critical node中心
- threat / blast envelope
- targeting / observation assumption
- Ural ingress / unload / egress
- Builder担当またはBuild Stage
- displacement direction

PNGを設計原本にしないでください。

## 6. アーキタイプ比較のルール

新しい案は最低でも既存baselineと同じ条件で比較します。

例:

```text
MDF-30 vs MDF-55
MDF-55 vs PTF-2
Drill-integrated FOB vs Drill + FSN
```

人数、車両数、Drill数、計測開始点を揃えずに「生存性が高い」「展開が速い」と結論しないでください。

## 7. 日本語ドキュメントの品質

技術内容を正しくした後、`skills/natural-japanese/SKILL.md`に従って文章を整えます。特に次を重視します。

- 結論が見出しから読めること
- 事実・推定・仮説を文章上でも区別すること
- 同じ粒度の箇条書きを機械的に並べないこと
- 不必要な煽り、曖昧な断定、AI的な総括語を避けること
- 技術用語は精度を優先し、必要な箇所だけ説明すること

文体改善のために技術的留保を削除してはいけません。

## 8. 外部コード・画像

第三者repoは、調査・設計の参考とコード再利用を分けて扱います。

- `apollyon-sys/wardogs-calculator`: MITだが、WARDOGS由来の画像等はMIT対象外と明記されている。
- `Bernardo-Andreatta/wardogs-fob-builder`: UI/ワークフローの参考候補。ライセンス確認前にコードをコピーしない。
- `coji/natural-japanese`: MIT。固定コミットをsubmoduleとして利用する。

WARDOGSのマップ画像やゲームassetをrepoへ取り込む場合は、公開repoで再配布可能かを別途確認してください。

## 9. 完了条件

FOB案を「確定」へ進めるPRは、少なくとも以下を満たす必要があります。

- 主要寸法と脅威半径にsource/statusがある
- blast footprintとtargeting footprintを混同していない
- 重要設備間距離を機械的に再計算できる
- FOB build area内に収まることを検証できる
- 3人/4人の建築手順が記録されている
- Ural 2台/3台の双方について物流成立性が確認されている
- 放棄・転進時の車両導線が図面にある
- `TTE / TTD / TTR / PAR / CAR / CAV`のうち、対象設計に必要な指標が比較できる
- OverviewとDetailの両方が作れる
- 日本語文書が`natural-japanese`の検査を通っている

検証不能な点が残る場合は、推測で穴を埋めず`blocked`または`needs_validation`として残してください。
