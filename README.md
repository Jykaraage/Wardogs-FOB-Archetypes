# Wardogs FOB Archetypes

WARDOGSで使用するFOB（Forward Operating Base）を、**再現可能なアーキタイプ**として設計・検証・共有するための研究リポジトリです。

当面の対象は、Ural 2〜3台とLarge Hammerを持つ3〜4人で短時間に立ち上げ、敵の砲迫が集中した場合は早期に放棄・転進できる小規模FOBです。恒久要塞ではなく、投下資源・構築時間・損失時の影響を抑えた機動的な前線拠点を扱います。

## 最初の研究テーマ

`MDF-30`（Mobile Dual-Drill FOB）を初期候補として検証します。

- FOB Core ×1
- Drill Rig ×2
- Drill RigとFOB Coreを、迫撃砲1発で複数の重要設備を同時損傷しにくい距離へ分散
- 一定の平地なら、回転・平行移動だけで同じ形を再現できる配置
- Ural 2〜3台、Builder 3〜4人で迅速に展開
- 車両を恒久構造物として使わず、荷下ろし後に離脱できる導線を確保
- ゲーム内マップ上のOverviewと、メートル単位のDetail図を分離

`30 m`などの数値は現時点では**検証候補**です。現行ビルドで未確認の仕様を確定値として扱いません。

## Evidence policy

情報は次の順で信頼します。

1. BULKHEAD / WARDOGS公式情報
2. 現行ゲームビルドでの実測
3. ゲームデータ・collision等からの抽出値
4. コミュニティの観測・攻略情報
5. 仮説・設計上の便宜的な値

数値や仕様には、可能な限り`source_type`、`observed_at`、`game_build`、`confidence`を付けます。一次情報で確認できない値は`assumption`として分離します。詳細は[`docs/evidence-policy.md`](docs/evidence-policy.md)を参照してください。

## Repository layout

```text
.
├─ AGENTS.md
├─ docs/
│  ├─ design-principles.md
│  ├─ evidence-policy.md
│  ├─ research-plan.md
│  └─ tooling.md
├─ archetypes/
│  └─ mdf-30/
│     ├─ README.md
│     └─ archetype.json
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
- 重要な日本語ドキュメントは`skills/natural-japanese`で推敲・検査する。
- WARDOGSのゲーム画像・マップタイル等は、ライセンスを確認せず第三者コードのライセンス対象とみなさない。

## Current status

`MDF-30`の確定前に、少なくとも迫撃砲の構造物に対する実効加害範囲、FOB build zoneの形状と境界、Drill Rigの挙動、Core破壊時の依存関係、複数Builderによる建築速度を現行ビルドで確認します。
