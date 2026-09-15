# MDF-30 — Mobile Dual-Drill FOB

Status: **candidate / unvalidated**

## 狙い

MDF-30は、Drill Rig ×2とFOB Coreを分散し、単発の迫撃砲着弾で複数の重要設備を同時に失う確率を下げるための最小構成候補である。

「30」は3つのcritical nodeを結ぶ正三角形の中心間距離30 mを表す。現時点では検証用の候補値であり、正式な標準寸法ではない。

## 基準配置

ローカル座標:

```text
                +Y / nominal front

       Drill A             Drill B
      (-15,25.98)--------- (15,25.98)
            \                /
             \    30 m      /
              \            /
               \          /
                FOB Core
                 (0,0)

                -Y / egress side
```

厳密値:

```text
FOB Core : (  0.000000,  0.000000)
Drill A  : (-15.000000, 25.980762)
Drill B  : ( 15.000000, 25.980762)
```

3点間の中心距離はすべて30 mになる。

## なぜ正三角形から始めるか

3つのcritical node間距離を同じにでき、配置を回転しても条件が変わらない。道路や敵方向に依存した左右非対称の案より、基準テンプレートとして比較しやすい。

ただし、最終形を必ず正三角形にするという意味ではない。Uralの導線やFOB build areaの実形状によって、等脚三角形・直線配置などが有利なら比較する。

## 30 mの位置づけ

Wardogs ZoneはL81のblast radiusを10 mとしているが、これはBULKHEAD公式値ではなく、FOB構造物に対する実効加害領域と同一とも確認できていない。

構造物をbounding circleで保守的に近似すると、一つの爆心が2構造物を同時に加害できないための十分条件は次になる。

```text
d > r_i + 2R + r_j
```

`R = 10 m`を仮置きした場合、中心間30 mは`r_i + r_j < 10 m`までの余裕を持つ。ただしfootprint半径も未確定なので、これは30 mを検証候補にする理由であって、成立証明ではない。

## 「冗長化」の範囲

MDF-30が狙うのは次の分離である。

- Drill Aへの着弾でDrill Bを同時に巻き込みにくくする
- Drillへの着弾でCoreまで同時に巻き込みにくくする
- Coreへの着弾でDrillを同時に失いにくくする

一方、Coreが破壊された後のDrill機能がCoreへ依存するなら、CoreはSPOFのままである。Core破壊試験が終わるまで「完全冗長」「二重化FOB」とは呼ばない。

## 想定運用

- Builder: 3〜4人
- Tool: Large Hammer
- Logistics: Ural 2〜3台
- Terrain: 一定面積の平地
- Vehicle doctrine: 荷下ろし後はUralをFOB中心から分散または離脱
- Withdrawal doctrine: 継続的なcounter-mortarを受けたら設備回収より車両・人員の離脱を優先

## Build sequence — 仮説

現時点では次を比較用の初期手順とする。時間最適化は実測後に行う。

1. Core設置と同時にUralを荷下ろし位置へ分散
2. Drill A / Drill Bのblueprintを並行配置
3. 3人編成ではCore担当を早期にDrillへ合流、4人編成ではDrillごとに2人を割り当てる案を比較
4. 稼働に必要なFuel等を投入
5. Uralを完成状態のfootprintから外し、離脱方向を確保

建築速度が人数に線形比例するとは仮定しない。

## 確定前に必要なP0検証

- FOB build areaの形状・寸法・footprint境界判定
- L81のCore/Drillに対する実効加害範囲
- Core破壊後のDrill挙動
- Drill×2のcooldown / output独立性
- Core / Drill Rigの実footprint

これらが揃った時点で、30 mを維持するか、必要最小離隔へ変更する。
