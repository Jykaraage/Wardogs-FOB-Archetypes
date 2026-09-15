# Wardogs FOB Archetypes

WARDOGSで使用するFOB（Forward Operating Base）を、**再現可能なアーキタイプ**として設計・検証・共有するためのリポジトリです。

当面の研究対象は、Ural 2〜3台とLarge Hammerを持つ3〜4人で短時間に立ち上げ、敵の砲迫が集中した場合は早期に放棄・転進できる小規模FOBです。恒久要塞ではなく、投下資源・構築時間・損失時の影響を抑えた機動的な前線拠点を扱います。

## 最初の研究テーマ

`MDF-30`（Mobile Dual-Drill FOB）を初期候補として検証します。

- FOB Core ×1
- Drill Rig ×2
- Drill RigとFOB Coreを、迫撃砲1発で複数の重要設備を同時損傷しにくい距離へ分散
- 一定の平地なら、回転・平行移動だけで同じ形を再現できる配置
- Ural 2〜3台、Builder 3〜4人で迅速に展開
- 車両を恒久構造物として使わず、荷下ろし後に離脱できる導線を確保
- ゲーム内マップ上のOverviewと、メートル単位のDetail図を分離

`30 m`などの数値は、現時点では**候補値**です。現行ビルドで未確認の仕様を確定値として扱いません。

## Evidence policy

情報は次の順で信頼します。

1. BULKHEAD / WARDOGS公式情報
2. 現行ゲームビルドでの実測
3. ゲームデータ・collision等からの抽出値
4. コミュニティの観測・攻略情報
5. 仮説・設計上の便宜的な値

数値や仕様には、可能な限り`source_type`、`observed_at`、`game_build`、`confidence`を付けます。一次情報で確認できない値は、`assumption`として分離します。

## Repository layout

```text
.
├─ AGENTS.md                  # Codex / agent向け作業規約
├─ docs/
│  ├─ design-principles.md    # FOBアーキタイプの設計原則
│  ├─ evidence-policy.md      # 根拠の優先順位と記録方式
│  ├─ research-plan.md        # ゲーム内実測の計画
│  └─ tooling.md              # マップ・詳細図の描画ツール調査
├─ archetypes/
│  └─ mdf-30/
│     ├─ README.md            # MDF-30候補案
│     └─ archetype.json       # 機械可読な設計パラメータ
├─ data/
│  └─ source-register.md      # 外部情報源の台帳
└─ skills/
   └─ natural-japanese/       # coji/natural-japaneseを固定版で取り込み
```

## Working rules

- 「ゲーム内で確認した事実」と「設計上の仮説」を混ぜない。
- 変更されやすいゲーム仕様をコードへ直書きせず、データとして外出しする。
- 配置は絶対座標ではなくローカル座標で定義し、任意地点へ平行移動・回転可能にする。
- Overviewはゲーム内と一致するマップ画像／座標系を使い、Detailは1 m単位で寸法・footprint・危険域を読める図にする。
- 文書の日本語は`skills/natural-japanese`を用いて最終校正する。

## Status

研究用の骨格を構築中です。`MDF-30`の確定前に、少なくとも迫撃砲の構造物に対する実効加害範囲、FOB build zone、Drill Rigの挙動、Core破壊時の依存関係を現行ビルドで再確認します。
