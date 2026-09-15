# AGENTS.md

このリポジトリは、WARDOGSのFOBを「再現可能な設計アーキタイプ」として研究するためのものです。Codex等のエージェントは、実装や清書を始める前に本ファイルを読み、以下の規約に従ってください。

## 0. 最初に実行すること

submoduleを初期化します。

```bash
./scripts/bootstrap.sh
```

`skills/natural-japanese/SKILL.md`が読めることを確認してください。重要な日本語文書の新規作成・大幅改稿では、このSkillを読み、**full相当の工程**で推敲してください。軽微な誤字修正やJSON更新だけなら不要です。

## 1. 研究目的

主対象は、Ural 2〜3台、Large Hammerを持つBuilder 3〜4人で迅速に展開でき、敵砲迫の集中を受けた場合は損切りして転進できる小規模FOBです。

現時点の第一候補は`archetypes/mdf-30/`です。ただし、名称に含まれる`30`を含め、未実測値は確定仕様ではありません。

## 2. 根拠を分離する

情報は必ず次の階層で扱います。

1. `official` — BULKHEAD / WARDOGS公式
2. `in_game_verified` — 現行ビルドでの再現可能な実測
3. `extracted` — game data / collision等からの抽出
4. `community` — 攻略サイト・GitHub・Reddit等の観測
5. `assumption` — 設計仮説・暫定値

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

## 3. 設計原則

- **portable geometry**: 一定の平地なら平行移動・回転だけで再現できること。
- **critical-asset dispersion**: Drill Rig ×2とFOB Coreを一点に密集させないこと。
- **SPOFを誤魔化さない**: Drillを2基にしてもCore依存が残るなら「完全冗長」と呼ばないこと。
- **rapid build / rapid abandon**: 建築時間だけでなく、車両離脱と放棄判断を設計に含めること。
- **no truck-as-wall**: Uralを恒久防壁や基地構成要素として前提にしないこと。
- **data-driven**: blast radius、footprint、build radius、cost等を描画コードへ散在させないこと。

## 4. 図面の契約

図面は2層に分けます。

### Overview

ゲーム内Tactical Mapと整合する地図・座標系の上に、FOB位置、重要設備、build area、車両進入・離脱方向などを重ねます。

### Detail

ローカル座標系で作る詳細図です。SVGをcanonical sourceとし、必要に応じてPNGへレンダリングします。最低限、次を表現できる設計にします。

- 1 m基準のgrid / dimension
- structure footprint
- critical node中心
- threat / blast envelope
- Ural ingress / unload / egress
- Builder担当またはBuild Stage

PNGを設計原本にしないでください。

## 5. 日本語ドキュメントの品質

技術内容を正しくした後、`skills/natural-japanese/SKILL.md`に従って文章を整えます。特に次を重視します。

- 結論が見出しから読めること
- 事実・推定・仮説を文章上でも区別すること
- 同じ粒度の箇条書きを機械的に並べないこと
- 不必要な煽り、曖昧な断定、AI的な総括語を避けること
- 技術用語は精度を優先し、必要な箇所だけ説明すること

文体改善のために技術的留保を削除してはいけません。

## 6. 外部コード・画像

第三者repoは、調査・設計の参考とコード再利用を分けて扱います。

- `apollyon-sys/wardogs-calculator`: MITだが、WARDOGS由来の画像等はMIT対象外と明記されている。
- `Bernardo-Andreatta/wardogs-fob-builder`: UI/ワークフローの参考候補。ライセンス確認前にコードをコピーしない。
- `coji/natural-japanese`: MIT。固定コミットをsubmoduleとして利用する。

WARDOGSのマップ画像やゲームassetをrepoへ取り込む場合は、公開repoで再配布可能かを別途確認してください。

## 7. 完了条件

FOB案を「確定」へ進めるPRは、少なくとも以下を満たす必要があります。

- 主要寸法と脅威半径にsource/statusがある
- 重要設備間距離を機械的に再計算できる
- FOB build area内に収まることを検証できる
- 3人/4人の建築手順が記録されている
- Ural 2台/3台の双方について物流成立性が確認されている
- 放棄・転進時の車両導線が図面にある
- OverviewとDetailの両方が作れる
- 日本語文書が`natural-japanese`の検査を通っている
