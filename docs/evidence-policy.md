# Evidence policy

## なぜ根拠を階層化するか

WARDOGSはEarly Access中で、公開情報・ゲームデータ由来の値・コミュニティ計測が短期間に食い違う可能性がある。FOB設計では数メートルの差や供給量の差が成立性を変えるため、出典の種類を隠したまま単一の「正解値」へまとめない。

## Source type

| source_type | 意味 | 原則的な扱い |
|---|---|---|
| `official` | BULKHEAD / WARDOGS公式発表 | 公開された範囲では最優先 |
| `in_game_verified` | 現行ビルドで再現した実測 | 実際の挙動を判断する主根拠 |
| `extracted` | game data / collision等からの抽出 | 実ゲーム挙動と照合する |
| `community` | 攻略サイト・OSS・掲示板等 | 仮説形成とクロスチェックに使う |
| `assumption` | 設計上の暫定値 | 未検証であることを明示する |

公式資料が沈黙しているゲーム内挙動では、`in_game_verified`を実務上の基準にしてよい。ただしパッチ後は再検証する。

## Confidence

`confidence`は出典の格ではなく、その主張が現在のゲームで正しいと考える確度を表す。

- `high`: 現行ビルドで複数回再現、または公式と実測が一致
- `medium`: 抽出値と複数の観測が一致するが、自前実測がない
- `low`: 単一コミュニティ情報、古いビルド、矛盾あり
- `unknown`: 未検証

## 最低限の記録項目

数値・仕様を設計判断に使う場合は、可能な限り次を残す。

```yaml
claim: L81 effective structure-damage radius
value: 10
unit: m
source_id: wardogs-zone-artillery
source_type: community
observed_at: 2026-09-15
game_build: unknown
confidence: low
status: needs_in_game_validation
notes: player-damage blast radiusと構造物加害範囲が同じとは限らない
```

## 「数字がある」ことと「設計に使える」ことは別

例えばコミュニティDBがL81のblast radiusを10 mと掲載していても、次は別問題である。

- 10 mがプレイヤーへのダメージ範囲か、構造物への加害範囲か
- 距離減衰後の微小ダメージまで含むか
- 建築物の中心、collision、visible meshのどこで判定されるか
- パッチで変更されていないか

したがって、`MDF-30`の重要設備間隔を確定するには、構造物を使ったゲーム内試験が必要になる。

## 矛盾するソースの扱い

値Aと値Bが食い違った場合は、平均・多数決で丸めない。

1. 両方を`data/source-register.md`または測定記録へ残す
2. build/dateの差を確認する
3. 定義の差（circle vs square、blast vs full damage等）を疑う
4. 現行ビルドで判定可能な試験を設計する
5. 結果が出るまで設計値は`assumption`として扱う

FOB build areaについて、コミュニティ資料に`60 m build circle`と`60 m square`の両表現が見られる場合も同様に扱う。

## 変更管理

Early Accessのパッチ後は、少なくとも以下の主張を再検証候補にする。

- FOB build area / FOB間最小距離
- Drill Rigのcost・cooldown・Core依存
- Uralのcargo capacity
- Build Suppliesの量
- Hammerの建築速度
- L81の弾道・blast・構造物damage

古い値を削除するのではなく、`valid_until`や`superseded_by`で履歴を追える形が望ましい。
