# PTF-2 — Pulsed Twin FOB

Status: **v2 primary candidate / unvalidated**

## 目的

`PTF-2`は、Drill Rigを同一FOB Coreへ二重化するのではなく、二つの小規模FOB Cellへ分割して**site redundancy**を作る候補である。

狙いは「一つのFOBを硬くすること」ではない。一方のCellが発見・砲撃・放棄に至っても、もう一方がDrill効果を継続し、BuilderとUralが別Cellまたは次サイトへ転用できる状態を作る。

## 基本構成

```text
Cell A                         Cell B
+----------------+           +----------------+
| FOB Core       |           | FOB Core       |
| Drill A        |           | Drill B        |
| minimum extras |           | minimum extras |
+----------------+           +----------------+

      mobile spawn / Ural logisticsは可能な限り別位置
```

各Cellは最小構成を原則とし、壁・Mortar・AA・spawn vehicle等を「便利だから」という理由だけで追加しない。

## 設計原則

- Core ×2、Drill ×2を2サイトへ分割する
- Cell間距離はFOB最小間隔、地形、移動時間、敵観測範囲から決める
- Drill / fire support / spawn / logisticsを同じfailure domainへ集めない
- Uralはrapid unload後に離脱する
- Cell AがYELLOW/REDへ移行した場合、Cell Bまたはalternate siteのTTE/TTRを優先する
- 既設構造物を守り切ることを成功条件にしない

## v2評価指標

PTF-2はMDF-55に対して、少なくとも次を比較する。

- `TTR`: 一方のCell喪失後に同等Drill効果を復旧する時間
- `CAR`: 一回のtargeting cycleで失い得る投資額
- `CAV`: 一観測機会から把握され得るcritical asset数
- `PAR`: 二拠点維持によって拘束される人数
- `TTE`: Core追加により初動が遅くなりすぎないか

PTF-2は生存性が高くても、Builder 3〜4人という制約下で`PAR`や`TTE`が悪化しすぎるなら不採用とする。

## failure model

想定する状態遷移:

```text
A GREEN / B GREEN
      |
      | A acquired
      v
A YELLOW / B GREEN
      |
      | corrected fire established
      v
A RED / B GREEN
      |
      | mobile assets leave A
      v
A ABANDONED / B GREEN
      |
      | new alternate Cell generated
      v
A' GREEN / B GREEN
```

重要なのは、`A RED`の後にAを修理し続けるのではなく、敵が既知座標へ撃ち続けられる条件なら別地点へ効果を再生成すること。

## 未確定事項

- FOB同士の最小距離
- Cell間距離の最適値
- 追加Coreのcash / supply / build-time負担
- Drill active時のmap/UI上の露呈
- Builder 3人で二Cellを維持できるか
- Cell AからBまたはalternate siteへUralで移る時間

## 必須試験

1. MDF-55と同じ総Drill数で比較する
2. 同一条件で一方のCellへ間接射撃を入れる
3. Builder / Uralを生存させたまま別Cellへ移す
4. `TTE / TTD / TTR / PAR / CAR / CAV`を記録する
5. 追加Coreコストを含めた効果交換比を評価する

詳細な上位原則は[`../../docs/doctrine-v2.md`](../../docs/doctrine-v2.md)を参照する。
