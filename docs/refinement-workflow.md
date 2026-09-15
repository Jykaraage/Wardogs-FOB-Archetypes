# 精緻化ワークフロー

## 目的

CodexでFOB案を精緻化するときに、検索量や文章量だけを増やして「高品質」とみなさないための作業順序を定める。品質の基準は、設計判断を根拠まで遡れること、未確認事項が未確認のまま見えること、図面とデータから同じ配置を再生成できることに置く。

## 1. 既存の主張を先に棚卸しする

新しい案を書き始める前に、対象アーキタイプの`README.md`と`archetype.json`を読む。数値・仕様を次の3群へ分ける。

- 現行ビルドで確認済み
- 外部資料にはあるが自前未確認
- 設計上の仮定

この区別を保ったまま作業する。外部資料を追加しただけで`assumption`を`verified`へ昇格させない。

## 2. 変更したい設計判断を一文で置く

例:

> MDF-30の30 m離隔が、現行L81の構造物加害範囲とCore/Drillのfootprintに対して十分かを判定する。

この一文に答えるために必要な証拠だけを先に集める。FOB一般論や兵科一般論を無制限に増やさない。

## 3. 情報源は一次情報から当たる

検索順序は`docs/evidence-policy.md`に従う。公式情報が詳細仕様を公開していなければ、その事実を記録してゲーム内実測へ進む。

コミュニティDBやOSSの数値は有用だが、定義を確認する。特に次を同一視しない。

- blast radiusと構造物への実効加害半径
- visible meshとcollision footprint
- FOB build radiusとbuild areaの形状
- 現在値と過去パッチの値

## 4. 仮説は試験可能な形へ落とす

「たぶん安全」「十分離れている」ではなく、反証可能な条件へ変換する。

例:

```text
Given:
  L81 effective structure radius = R
  Core footprint = F_core
  Drill footprint = F_drill

Pass:
  任意の単一着弾点について、CoreとDrillの双方のexpanded footprintに同時包含されない。
```

必要な値が欠けていれば、設計を確定せず`docs/research-plan.md`の実測項目へ戻す。

## 5. データを先に更新し、文章と図面を後から生成する

数値や座標は`archetype.json`等の機械可読データをcanonical sourceにする。文章中・SVG中へ同じ定数を別々に手入力しない。

推奨順序:

```text
source / measurement
        ↓
data / archetype.json
        ↓
validator
        ↓
SVG detail / map overview
        ↓
README / report
```

## 6. 図面は「見栄え」より検証可能性を優先する

Detail SVGには、少なくとも寸法、footprint、threat envelope、build area境界、車両導線を必要に応じて別レイヤーで持たせる。

Overviewはゲーム内マップとの位置一致を目的にし、Detailの代用にしない。地図画像の誤差とアーキタイプ幾何の誤差を分離する。

## 7. 日本語は技術内容が固まった後に磨く

重要Markdownの新規作成・大幅改稿では、`skills/natural-japanese/SKILL.md`を読み、full相当の工程で推敲する。

機械検査の入口:

```bash
./scripts/check-docs.sh
```

個別ファイルだけ確認する場合:

```bash
./scripts/check-docs.sh archetypes/mdf-30/README.md docs/research-plan.md
```

このスクリプトは`natural-japanese`の`lint.py`、`outline.py`、`terms.py`を実行する。検出結果は自動修正命令ではない。技術的に必要な表現や留保を削って数値上の指摘だけを消さない。

## 8. Codexの完了判定

精緻化タスクを終える前に、最低限次を確認する。

- 変更した設計判断が何かを説明できる
- その判断を支えるsource IDまたはgame measurementがある
- 未確認値が`verified`として紛れ込んでいない
- JSONと文章で座標・単位・名称が一致する
- 図面をcanonical dataから再生成できる、またはその実装タスクが明示されている
- `scripts/check-docs.sh`のfindingを確認し、直す／残すを判断している

検証不能な点が残る場合は、推測で穴を埋めるのではなく`blocked`または`needs_validation`として残す。
