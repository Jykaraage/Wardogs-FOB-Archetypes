# FOBアーキタイプ設計原則

Current line: **v2.0.0-pre**

## 目的は「強い基地」ではなく「効果を再生成できるシステム」

このリポジトリで扱うアーキタイプは、特定地点の地形を使った一点物の要塞ではない。一定の平地が確保できれば、ローカル座標で定義した配置を回転・平行移動して再現できることを基本とする。

ただしv2では、単一FOBの耐久性を最上位目標にしない。敵の観測・修正射撃が成立しても、Drill能力、spawn能力、物流能力を同時に失わず、別地点で短時間に効果を再生成できることを重視する。

詳細は[`doctrine-v2.md`](doctrine-v2.md)を参照する。

## terrain independentとterrain blindを分ける

アーキタイプは地形依存の遮蔽物や建物がなくても成立するportable geometryを持つ。

一方、実配置では地形を無視しない。建物、樹林、depression、berm、道路、industrial clutterなどが利用できるなら、最低離隔、build-area containment、Ural導線等の必須条件を壊さない範囲でgeometryを変形する。

したがって設計は二層に分ける。

1. portable template
2. terrain exploitation

## 小規模FOBは生存時間ではなくeffect / costで考える

主対象は、Ural 2〜3台とBuilder 3〜4人で立ち上げる機動FOBである。敵が継続的に迫撃砲・砲兵を集中できる状況になったら、耐え続けることを成功条件にしない。

評価指標:

- `TTE`: Time To Effect
- `TTD`: Time To Displace
- `TTR`: Time To Restore
- `PAR`: Players At Risk
- `CAR`: Cash At Risk
- `CAV`: Critical Assets Visible

単一FOBのsurvival timeは補助指標として扱う。

## blast footprintとtargeting footprintを分ける

構造物を点として扱うと、中心間距離だけ満たしても構造物端部が同じ爆風に入る可能性がある。

爆心から距離`R`以内にある構造物が加害されると仮定し、構造物`i`と`j`のfootprintを、それぞれ半径`R`だけ外側へ膨張させる。2つの膨張領域が交差しなければ、同じ着弾点が両方を同時に加害することはない。

構造物を保守的なbounding circleで近似する場合、中心間距離`d`の十分条件は次になる。

```text
d > r_i + 2R + r_j
```

- `R`: 検証済みの実効加害半径
- `r_i`, `r_j`: 各footprintを包含する円の半径

ただしv2では、このblast条件を満たすだけで安全とみなさない。

`targeting footprint`は、一回の観測・修正機会から敵が位置を把握し、次弾以降のtargetingへ移行できる領域を指す。shell camera等が実質的な偵察手段として機能するなら、blast circleより大きなfailure domainを形成し得る。

## Drill×2は「完全冗長」ではない

Drill Rigを2基に分けても、FOB Coreへの依存が残るならシステム全体が二重化されたわけではない。

そのため、次を区別する。

- `asset dispersion`: 一つのsite内で設備を分散する
- `site redundancy`: effect source自体を複数siteへ分ける

MDF-30 / MDF-55は前者、PTF-2は後者を検証する候補である。

Core破壊後も既設Drillが稼働を続けるか、再補給や再建築が可能かは現行ビルドで確認する。それまではCoreをSPOF候補として扱う。

## failure domainを分離する

局所運用効率だけを理由に、Drill、Mortar、AA、spawn vehicle、Uralを一点へ集めない。

原則:

```text
DRILL NODE != FIRE SUPPORT NODE
SPAWN NODE != PRIMARY DRILL NODE
URAL != STATIC FOB COMPONENT
```

統合する場合は、追加CoreやBuilder-timeを節約できる等の定量的な理由を記録する。

## 物流車両は基地構造物にしない

Uralは荷下ろし後にFOBから離脱できることを基本とする。車両を防壁として置き続ける案は標準アーキタイプに含めない。

理由:

- 砲撃に重要資産と車両を同時に晒す
- TTDを悪化させる
- 出入口が車両位置に依存する
- 再現性が車両の停止精度に左右される
- 物流trafficそのものがsiteの価値を高める可能性がある

必要であれば`unload point`と`temporary staging`は定義するが、完成状態の必須部品にはしない。

## rebuild-in-placeを既定動作にしない

敵が同一地点へ修正射撃できる状況では、破壊された設備を同じ場所へ再建することが最適とは限らない。

v2では、次を比較する。

```text
repair / rebuild in place
vs
abandon / displace / regenerate elsewhere
```

どちらが有利かはTTR、CAR、PARで判断する。

## 座標系

アーキタイプは右手系の2Dローカル座標で定義する。

```text
origin: archetypeごとに定義
+x: right
+y: nominal front
unit: meter
rotation: 任意
```

MDF系ではCore中心をoriginとしてよい。PTF-2等のmulti-site構成では、Cellごとのlocal originとsystem-level originを分けてもよい。

ゲームマップへ配置するときだけ、ローカル座標を地図座標へ変換する。これにより、詳細図の幾何とマップ位置を分離する。

## OverviewとDetailを分ける

### Overview

戦術マップ上で読む図。正確な地図位置、各Cell、build area、alternate site、接近路、離脱方向、周辺FOBとの干渉を見る。

### Detail

1 m単位で読む施工図。footprint、設備間距離、blast envelope、targeting assumption、車両導線、Build Stage、Builder担当を見る。

Overviewを拡大してDetailの代わりにしたり、Detailを地図画像へ直接焼き込んで設計原本にしたりしない。

## regular geometryはbaseline、実戦候補は必要に応じてirregularにする

正三角形等のregular geometryは、距離条件やvalidatorを比較する基準として有用である。

一方、実戦候補では規則性そのものを目的にしない。build-area制約、地形、Ural導線、targeting footprintを見て、非対称配置やoblique配置を許容する。

「綺麗に置ける」ことを「敵から分散している」ことと混同しない。
