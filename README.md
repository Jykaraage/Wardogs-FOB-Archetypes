# Wardogs FOB Archetypes

Current pre-release: **v2.0.0-pre**

WARDOGSで使用するFOB（Forward Operating Base）を、**再現可能なアーキタイプ**として設計・検証・共有するための研究リポジトリです。

当面の対象は、Ural 2〜3台とLarge Hammerを持つ3〜4人で短時間に立ち上げ、敵の砲迫が集中した場合は早期に放棄・転進できる小規模FOBです。恒久要塞ではなく、投下資源・構築時間・損失時の影響を抑えた機動的な前線拠点を扱います。

## v2.0.0-preの設計転換

v1系では、FOB CoreとDrill Rig ×2を迫撃砲1発で同時損傷しにくい距離へ分散する`MDF-30`を最初の研究対象としていました。

v2では、FOB単体の耐久性よりも**分散したシステムとして効果を継続・再生成できるか**を上位目標にします。

主な変更点:

- `blast footprint`だけでなく、shell camera等による`targeting footprint`を考える
- 規定距離ではなく、一観測機会で何個のcritical assetが露呈するかを`CAV`として評価する
- Drill×2のasset dispersionより、複数サイトによるsite redundancyを上位概念にする
- Drill / fire support / spawn / logisticsを可能な限り別failure domainへ分ける
- Uralは基地構成物ではなく、短時間の搬入・離脱を行うpulsed logisticsとして扱う
- rebuild-in-placeより、放棄・転進とeffect regenerationを優先する
- portable geometryを維持しつつ、実配置では地形による遮蔽・分断を利用する

詳細は[`docs/doctrine-v2.md`](docs/doctrine-v2.md)を参照してください。

## Archetype family

| ID | 構成 | 目的 | 状態 |
|---|---|---|---|
| [`MDF-30`](archetypes/mdf-30/) | Core ×1 + Drill ×2 / 30 m triangle | single-blast separationの比較基準 | benchmark / unvalidated |
| [`MDF-55`](archetypes/mdf-55/) | Core ×1 + Drill ×2 / outer-ring | 同一FOB内でtarget densityを下げる | v2 candidate |
| [`PTF-2`](archetypes/ptf-2/) | Core ×2 + Drill ×1 × 2 sites | site redundancy / effect continuity | v2 primary candidate |
| [`FSN`](archetypes/fsn/) | fire-support-only node | offensive signatureをDrillから分離 | v2 supporting candidate |

`30`や`55`などの数値は現時点では**検証候補**です。現行ビルドで未確認の仕様を確定値として扱いません。

## v2 evaluation metrics

FOBの生存時間だけでなく、次を計測します。

- `TTE` — Time To Effect
- `TTD` — Time To Displace
- `TTR` — Time To Restore
- `PAR` — Players At Risk
- `CAR` — Cash At Risk
- `CAV` — Critical Assets Visible

特に`TTR`と`CAV`を、分散設計の主要指標として扱います。

## Evidence policy

情報は次の順で信頼します。

1. BULKHEAD / WARDOGS公式情報
2. 現行ゲームビルドでの実測
3. ゲームデータ・collision等からの抽出値
4. コミュニティの観測・攻略情報
5. 仮説・設計上の便宜的な値

数値や仕様には、可能な限り`source_type`、`observed_at`、`game_build`、`confidence`を付けます。一次情報で確認できない値は`assumption`として分離します。詳細は[`docs/evidence-policy.md`](docs/evidence-policy.md)を参照してください。

現代戦の公開資料はゲーム仕様の一次情報ではありません。設計概念の参考に使う場合も、`official doctrine`、`lessons learned`、`professional analysis`を区別します。

## Repository layout

```text
.
├─ VERSION
├─ CHANGELOG.md
├─ AGENTS.md
├─ docs/
│  ├─ doctrine-v2.md
│  ├─ design-principles.md
│  ├─ evidence-policy.md
│  ├─ refinement-workflow.md
│  ├─ research-plan.md
│  └─ tooling.md
├─ archetypes/
│  ├─ mdf-30/
│  │  ├─ README.md
│  │  └─ archetype.json
│  ├─ mdf-55/
│  │  └─ README.md
│  ├─ ptf-2/
│  │  └─ README.md
│  └─ fsn/
│     └─ README.md
├─ data/
│  ├─ source-register.md
│  └─ measurements.example.json
├─ skills/
│  └─ natural-japanese -> ../vendor/natural-japanese/skills/natural-japanese
└─ vendor/
   └─ natural-japanese/       # pinned git submodule
```

## Setup

`natural-japanese`は固定コミットのsubmoduleとして取り込み、`skills/natural-japanese`から参照します。

```bash
./scripts/bootstrap.sh
```

手動で行う場合は次のとおりです。

```bash
git submodule update --init --recursive
```

## Working rules

- 「ゲーム内で確認した事実」と「設計上の仮説」を混ぜない。
- 変更されやすいゲーム仕様をコードへ直書きせず、データとして外出しする。
- 配置は絶対座標ではなくローカル座標で定義し、任意地点へ平行移動・回転可能にする。
- Overviewはゲーム内と一致するマップ画像／座標系を使い、Detailは1 m単位で寸法・footprint・危険域を読める図にする。
- single-siteの見栄えや耐久性ではなく、failure domain、TTR、CAVまで含めて比較する。
- mobile assetを既知の砲撃地点へ残し続けない。
- 重要な日本語ドキュメントは`skills/natural-japanese`で推敲・検査する。
- WARDOGSのゲーム画像・マップタイル等は、ライセンスを確認せず第三者コードのライセンス対象とみなさない。

## Current validation priorities

v2候補を絞る前に、少なくとも次を現行ビルドで確認します。

1. FOB build zoneの形状・境界・FOB間最小距離
2. L81 / SPH-2の構造物に対する実効加害範囲
3. shell camera等による実効targeting footprint
4. active Drillの敵map / UI上の露呈
5. Core破壊後のDrill依存
6. Drill Rigのcooldown / output独立性
7. Builder 3人/4人のTTE
8. Ural 2台/3台の物流成立性とTTD
9. MDF-30 / MDF-55 / PTF-2のTTR・CAR・CAV比較

`v2.0.0-pre`は設計原則のpre-releaseです。未確認値を確定仕様へ昇格させません。
