# MDF-55 — Mobile Dual-Drill FOB, outer-ring candidate

Status: **v2 candidate / unvalidated**

## 目的

`MDF-55`は、MDF-30の「単発blastで複数critical assetを同時損傷しにくくする」という狙いを維持しつつ、同一FOB内でcritical-node separationをさらに広げる候補である。

名称の`55`は仮称であり、FOB build areaが約60 m radiusというコミュニティ値を前提にした検証用ラベルにすぎない。現行ビルドでbuild areaの形状・境界を確定するまで正式寸法ではない。

## 設計原則

- FOB Core ×1
- Drill Rig ×2
- Drillはbuild area外縁付近へ配置する
- Drill A / BはCoreを挟んで大きく離す
- 完全な180度直線配置は必須としない
- 150〜165度程度のoblique配置を含め、地形と車両導線に応じて比較する
- Uralは荷下ろし後に離脱し、完成状態のcritical areaに残さない

概念図:

```text
       Drill A
          o

      ~50-55 m

            o Core

                  ~50-55 m

                         o Drill B
```

## MDF-30との差

MDF-30は規則的な30 m正三角形で、blast-separation条件を比較するbaselineとして扱う。

MDF-55では、正三角形の再現性よりも以下を優先する。

- `CAV`（一観測機会で露呈するcritical asset数）の低減
- build area内でのcritical-node separation最大化
- Ural ingress / egressの分離
- 既存地形への適応

## Pass / Fail候補

### Pass

- Core / Drillがbuild area内に収まる
- 重要設備間隔が検証済みblast条件を満たす
- 1台のUralが片側Drillへ接近しても、他のcritical nodeを塞がない
- 3〜4人でMDF-30と同程度のTTEを維持できる
- MDF-30よりCAVまたは同時targetabilityが低い

### Fail

- build radius制約で実質30 m級まで圧縮される
- Ural導線が長くなりTTE / TTDが悪化しすぎる
- shell cameraから結局3設備すべて容易に把握され、分散効果がない

## 必須検証

- FOB build areaの正確な形状・半径・境界判定
- Core / Drill footprint
- L81 / SPH-2の構造物加害範囲
- shell cameraからの実効targeting footprint
- MDF-30とのTTE / TTD / CAV比較

詳細な上位原則は[`../../docs/doctrine-v2.md`](../../docs/doctrine-v2.md)を参照する。
