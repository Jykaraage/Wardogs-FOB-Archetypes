# ゲーム内検証計画

Current line: **v2.0.0-pre**

## 目的

MDF-30 / MDF-55 / PTF-2 / FSNを、「それらしい配置」から現行WARDOGSで比較可能なFOBアーキタイプへ進める。

v2では、最終図を描くためだけに測定しない。単一FOBのblast耐性に加え、敵のtargeting cycle、site redundancy、displacement、effect regenerationを評価できる制約値を確定する。

## 記録の共通条件

各セッションで次を残す。

- 実施日・時刻
- WARDOGSのbuild/version（画面またはSteam build IDで確認できる範囲）
- map / server / mode
- squad人数
- 使用車両・装備
- Tactical Mapのスクリーンショット
- 測定対象を含む動画または連続スクリーンショット
- 期待値と観測値
- 失敗した試行も含むtrial数
- 使用アーキタイプとrevision

ファイル名の例:

```text
2026-09-15_build-xxxxx_bakurani_fob-radius_trial-01.png
```

主要比較では、可能な限りBuilder人数、Ural台数、Drill数、計測開始条件を揃える。

---

## P0 — build areaの形状とFOB間最小距離を確定する

### 問い

- FOBの建築可能領域はcircleかsquareか。
- 60 mというコミュニティ値は半径、辺長、別の定義のどれか。
- 境界判定は構造物中心かfootprint全体か。
- FOB同士の最小距離は何を基準に測るか。

### 方法

平坦で障害物が少ない場所にFOBを1基設置する。方位0/45/90/135度方向に同じ小型buildableを移動し、設置可否が反転する境界を記録する。1 m相当の座標変化を校正できる場合は境界付近を細かく刻む。

FOB間距離は同一平坦地で2基目Coreの設置可否が切り替わる位置を複数方位で測る。

### 完了条件

MDF-55のouter-ring validatorとPTF-2のCell間配置に使える形状・寸法・境界ルールが得られること。

---

## P0 — L81 / SPH-2の構造物に対する実効加害領域を確定する

### 問い

コミュニティDBにあるblast radiusと、FOB Core / Drill Rigへの実効ダメージ判定は同じか。

### 方法

同種の構造物を十分離して置き、既知の着弾点から距離を変えて単発射撃する。耐久値または破壊に必要な弾数の差から、少なくとも「ダメージあり/なし」の境界を測る。

構造物ごとに判定点が異なる可能性があるため、CoreとDrillの双方で行う。

### 完了条件

`R_effective`を、定義・対象構造物・build付きで記録できること。プレイヤー向けblast radiusを代用しない。

---

## P0 — targeting footprintを測る

### 問い

- L81 / SPH-2のshell cameraから何が見えるか。
- 一つのDrillへ着弾したとき、どの距離・方向のCore / Drill / vehicleまで位置を把握できるか。
- shell camera以外にmap markerやactive Drill表示がtarget acquisitionを補助しているか。
- Hardcore等のmode差があるか。

### 方法

MDF-30と、可能ならMDF-55相当の外縁配置を同一条件で用意する。観測者側で一つのcritical node付近へ単発射撃し、最初の観測機会だけで把握できたassetを記録する。

記録項目:

- 観測地点
- shell trajectory / impact location
- assetごとのvisibility
- 追加修正なしで推定可能だった位置
- target acquisitionから命中までの時間

### 完了条件

少なくとも`CAV`をMDF-30 / MDF-55で比較できること。blast radiusとtargeting footprintを別データとして記録する。

---

## P0 — active Drillの敵側露呈を確認する

### 問い

- Drillがactiveになった時点で敵Tactical Mapへ何が表示されるか。
- 表示は正確な位置か、範囲か。
- active前後で露呈条件が変わるか。

### 完了条件

「FOB geometryを隠してもDrill位置がゲームUIから自動露呈する」等の仕様を設計へ反映できること。

---

## P0 — Core破壊時のDrill依存を確認する

### 問い

- Core破壊後、既設Drillは採掘を継続するか。
- cooldown、回収、補給、再建築に何が起きるか。
- Coreを再設置した場合に復旧するか。

### 完了条件

「Drill×2が何を冗長化し、何を冗長化しないか」を仕様として説明できること。

---

## P1 — Drill×2の独立性を確認する

同一FOB内にDrillを2基置き、activation / cooldown / outputが共有されるか独立するかを記録する。パッチで変更されやすい項目として扱う。

---

## P1 — 建築スループットとTTEを測る

同じ構成をLarge Hammerで建て、次を比較する。

- Builder 3人
- Builder 4人
- 同一構造物を複数人で叩く場合
- 複数構造物へ分散する場合
- MDF-30
- MDF-55
- PTF-2の最初のCell / 両Cell

計測区間を明示する。Drill系では基本的に「最初のblueprint設置」から「所定のDrill効果が利用可能」までを`TTE`とする。

単純な`人数倍`を仮定しない。

---

## P1 — Ural 2台/3台の物流成立性とTTDを確認する

確認項目:

- 1台あたりの実cargo capacity
- Build/Fuel palletの搭載単位
- FOB初期資源の有無と量
- Drillを立ち上げるまでに必要な搬入量
- Uralを基地内に残さず離脱できるか
- YELLOW/RED判定後、車両が危険域を離れるまでの時間

2台案と3台案を別々に成立判定する。3台案が必要なら、その理由を「余裕」ではなく不足するcargoまたは運用上の役割で説明する。

`TTD`の起点は「撤収判断が出た瞬間」とする。

---

## P1 — MDF-30 vs MDF-55のCAV / TTE / TTD比較

同じBuilder人数・Ural数・Drill数で比較する。

最低記録:

- TTE
- TTD
- critical-node pair distance
- CAV
- 一回の修正射撃サイクルで破壊されたcritical asset数
- vehicle ingress / egress conflict

MDF-55が距離だけ広くても、TTEやTTDを大幅に悪化させるなら採用しない。

---

## P1 — MDF-55 vs PTF-2のsite redundancy比較

### 問い

追加Coreの負担を払ってでも二Cell化する価値があるか。

### 方法

同じDrill総数で比較する。片側siteへ間接射撃を集中させ、mobile assetを生存させたまま残存siteまたはalternate siteへ移す。

記録:

- `TTE`
- `TTD`
- `TTR`
- `PAR`
- `CAR`
- `CAV`
- 追加Coreのcash / supply / builder-time

### 完了条件

「PTF-2の方が分散している」ではなく、追加コストとTTR/CAR/CAV改善量を比較できること。

---

## P1 — FSN分離効果を確認する

Drill node内にMortarを置く構成と、fire supportを別nodeへ分離する構成を比較する。

確認項目:

- fire support発砲後にDrill nodeへcounter-fireが誘導される頻度
- FSN喪失時のDrill継続性
- 追加Core / Builder cost
- MortarのTTR
- Drill側CAV / CARの変化

---

## P1 — displacement triggerを調整する

暫定GREEN / YELLOW / RED基準を実戦ログから調整する。

測るもの:

- 初弾から修正弾までの時間
- 最初のcritical hitまでの時間
- rebuild-in-placeした場合の再破壊時間
- 即時離脱した場合のmobile asset生存率
- alternate siteでのTTR

「何発食らったら逃げる」と先に固定しない。敵のtargeting cycleが成立した兆候を探す。

---

## P2 — 配置再現性とterrain adaptationを測る

最低3地点の平坦地で同じportable templateを試す。さらに、同じアーキタイプを既存建物・樹林・depression等へ適応させる。

記録:

- templateから変更した座標
- 変更理由
- 必須制約を維持できたか
- CAV / TTE / TTDへの影響

地形へ適応した結果、別アーキタイプになるほど形状を変えた場合は派生型として分離する。

---

## P2 — alternate site事前選定の効果を測る

PTF-2または単一FOBのdisplacementで、次を比較する。

- alternate site未選定
- Tactical Map上で候補だけ選定
- Ural導線まで事前計画

`TTR`短縮量が大きければ、Overview図にalternate siteを標準表示する。

---

## P3 — マップ描画の校正

`apollyon-sys/wardogs-calculator`はBakuraniで`coordinateMetersPerUnit: 100`を公開している。ただし同repo自身が校正値は今後改善され得るとしているため、ゲーム内のMark Coordinatesと既知距離を使って確認する。

Overviewの座標変換とDetailの1 m座標を別モジュールにし、マップ校正の変更でアーキタイプ幾何が変わらない構成にする。

v2では単一FOBだけでなく、PTF-2の複数Cell、FSN、mobile spawn、alternate siteを同一Overview上へ重ねられることを目標とする。
