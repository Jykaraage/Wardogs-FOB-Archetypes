# FOB Doctrine v2.0.0-pre

Status: **pre-release / hypothesis-driven**  
Target game state: **WARDOGS Early Access, 2026-09-15時点**

## 1. v2で何を変えるか

v1系では、FOB CoreとDrill Rig ×2を迫撃砲1発で同時損傷しにくい距離へ離し、一定の平地へ再現可能な小規模FOBを作ることを主眼に置いていた。

v2では、これを一段上流から捉え直す。

設計対象は「壊れにくいFOB」ではない。

> **敵のtargeting cycleが成立しても、Drill能力・spawn能力・物流能力を同時に失わず、少人数・少数車両で別地点へ効果を再生成できる分散システム**

を設計対象とする。

MDF-30は無効化しない。単発blastに対する幾何学的baselineとして残し、v2候補との比較対象にする。

---

## 2. 設計目標をsurvival timeからeffect regenerationへ変える

FOB単体の生存時間を最大化すると、壁・火器・車両・補給・spawnを一点へ集めたSuper FOBへ収束しやすい。しかしWARDOGSでは、建設・防衛へ拘束したプレイヤーはControl Zoneや他任務へ投入できず、固定拠点には明確なplayer-minute costがある。

そのためv2では、FOBを次の指標で評価する。

| 指標 | 定義 |
|---|---|
| `TTE` | Time To Effect。最初の展開開始から、Drill等が目的効果を発揮するまで |
| `TTD` | Time To Displace。撤収判断から、人員・車両が危険域を離れるまで |
| `TTR` | Time To Restore。旧サイト放棄から、別サイトで同等効果を再生成するまで |
| `PAR` | Players At Risk。FOB維持へ継続拘束される人数 |
| `CAR` | Cash At Risk。一つの敵targeting cycleで失い得る投資額 |
| `CAV` | Critical Assets Visible。一つの観測機会で把握され得る重要資産数 |

v2では特に`TTR`と`CAV`を重視する。

5分長く耐えるFOBより、敵に捕捉された後に短時間で別地点へDrill能力を復旧できる構成の方が、ゲーム内価値が高い可能性がある。

---

## 3. threat modelをblast radiusからtargeting footprintへ拡張する

MDF-30は主にsingle-blast multi-killを避ける設計だった。これは必要だが十分ではない。

2026-09-15時点のコミュニティ観測では、L81/SPH-2のshell cameraによって着弾地点周辺の構造物・車両・人員を上空から確認し、次弾を個別の設備へ修正できることが強く問題視されている。

この環境では、次の二つを分離して考える。

```text
blast footprint
  = 1発の爆発が直接加害し得る領域

targeting footprint
  = 1回の観測・修正射撃機会から、敵が位置を把握し継続攻撃へ移行できる領域
```

設計基準も、

```text
critical asset spacing > blast requirement
```

だけではなく、

```text
one observed node -> how many other critical nodes become targetable?
```

へ拡張する。

### 参考となる現代戦側の概念

U.S. ArmyのTransformation and Lessons Learned Manager-Armyが2026年9月に公開した`The Economics of Survivability`は、公式ドクトリンそのものではなく著者見解を含むlessons-learned文書である。その点を留保したうえで、FOB設計へ転用可能な評価概念がある。

同資料は、分散を単なる規定間隔ではなく`sensor exposure`、すなわち「一つの車両を検出したとき、同じfield of viewから他に何両が露呈するか」で評価する考え方を提示している。また、内部都合で資産を密集させる`convenience compression`が高価値目標を作ると指摘している。

WARDOGSではこれを、

> Drill Aへの着弾観測から、Drill B、FOB Core、Mortar、spawn vehicle、Uralまで一度に把握されるか

というゲーム内指標へ翻訳する。

---

## 4. regular geometryを比較基準にし、実戦候補はirregular geometryへ寄せる

MDF-30の正三角形は、距離条件を比較するbaselineとして優れている。一方で実戦配置としては、規則的かつ狭い範囲へcritical nodeを集めるため、敵が一つの資産を発見した後に他資産を推定しやすい。

v2では次を原則とする。

- 正三角形等のregular geometryは**試験基準**として使う
- 実戦候補はbuild area内でcritical nodeを外縁へ寄せる
- 直線的・対称的な配置を必須にしない
- 既存地形が使える場合は遮蔽・建物・高低差へ合わせてgeometryを変形する
- ただし地形がなくても成立するportable geometryを維持する

これは「terrain independent」と「terrain blind」を分けるという意味である。

---

## 5. asset redundancyよりsite redundancyを上位概念にする

Drill Rig ×2を同じFOB Coreへぶら下げても、Coreが機能上のSPOFなら完全冗長ではない。

v2では冗長性を二層に分ける。

### Layer A — asset dispersion

一つのFOB内でCore / Drill / その他重要設備を分散し、単一着弾や局所攻撃によるmulti-killを避ける。

### Layer B — site redundancy

FOBそのものを複数cellへ分け、一つのサイトがtargeting cycleへ捕捉されても別サイトが効果を継続できるようにする。

したがって、v2の上位原則は次になる。

> **redundant drillではなく、redundant effect sourceを作る。**

---

## 6. failure domainを分ける

Super FOBは、Drill、Mortar、AA、spawn vehicle、Ural、補給、Builderを一つのfailure domainへ集約する。

これは局所運用効率が高い一方、一度捕捉されると複数機能を同時に失いやすい。

v2では少なくとも次を別failure domainとして扱う。

```text
Drill / economy node
Fire support node
Spawn / mobility node
Logistics traffic
```

原則:

```text
DRILL NODE != FIRE SUPPORT NODE
SPAWN NODE != PRIMARY DRILL NODE
URAL != STATIC FOB COMPONENT
```

ゲーム仕様上、分離コストが大きすぎる場合は例外を認めるが、「同居が楽だから」だけでは統合しない。

---

## 7. Uralは基地構成物ではなくpulsed logisticsとして扱う

現代のsustainment研究では、継続的なstagingではなく短時間の同期drop、micro-dispersal、route maskingといった考え方が提示されている。

WARDOGSでは単純化して、次を標準とする。

```text
Ural arrives
    -> rapid unload
    -> builders consume supplies
    -> Ural exits immediately
```

UralをFOBの壁、常設倉庫、固定遮蔽物として扱わない。

標準FOBが完成した状態でUralがcritical area内に残っているなら、設計上の負債として扱う。

---

## 8. withdrawalではなくdisplacementを設計する

v2では「撤去して回収すること」を成功条件にしない。

優先順位は原則として、

1. Builder
2. Ural / spawn vehicle等の再利用可能なmobile asset
3. 将来再展開に必要なsupplies
4. 現在地の固定構造物

とする。

FOB設備はsunk costとして放棄できる設計にする。

### provisional displacement trigger

ゲーム内実測前の暫定SOP:

**GREEN**
- 敵間接射撃なし
- Drill運用継続

**YELLOW**
- 初弾着弾、ranging、またはshell cameraによる観測成立が疑われる
- 新規固定設備の追加を止める
- Uralを退避
- Builderの一部を次サイト準備へ移す

**RED**
- 同じcritical nodeへ修正射撃が成立
- SPH-2等から継続砲撃を受ける
- attack helicopter等が継続的にFOBへ到達可能

行動:
- rebuild-in-placeを原則停止
- mobile assetを離脱
- 既設設備を放棄可能とする
- alternate siteでeffectを再生成

この閾値はゲーム内試験で調整する。

---

## 9. v2 archetype family

万能FOBを一つ作るのではなく、脅威と資源量に応じて選ぶ。

| ID | 構成 | 主目的 | 状態 |
|---|---|---|---|
| `MDF-30` | Core ×1 + Drill ×2 / 30 m triangle | blast-separation baseline | legacy candidate / benchmark |
| `MDF-55` | Core ×1 + Drill ×2 / build-area外縁利用 | single-siteでtarget densityを下げる | v2 candidate |
| `PTF-2` | Core ×2 + Drill ×1 × 2 sites | site redundancy / effect continuity | v2 primary candidate |
| `FSN` | Mortar / AA等のfire-support-only node | offensive signatureをDrillから分離 | v2 supporting candidate |

spawn vehicle / MSV / APCは固定FOB archetypeの構成要素ではなく、可能な限り独立したmobile nodeとして扱う。

---

## 10. MDF-55 — single-site refinement

`MDF-55`は、FOB build areaが約60 m radiusというコミュニティ値が現行ビルドで確認された場合に検証する。

基本思想:

- Coreから各Drillをbuild area外縁付近へ寄せる
- Drill AとDrill Bを可能な限り反対側へ分離する
- 180度の完全直線は必須にせず、地形・車両導線に応じ150〜165度程度のoblique配置も比較する
- 目標は「30 mを守る」ことではなく「build area制約内でcritical-node separationを最大化する」こと

したがって`55`も最終確定値ではない。

概念図:

```text
       Drill A
          o

      ~50-55 m

            o Core

                  ~50-55 m

                         o Drill B
```

---

## 11. PTF-2 — v2の本命候補

`PTF-2`はPulsed Twin FOBの略称とする。

一つのCoreへDrillを二重化するのではなく、二つのsmall cellへ機能を分割する。

```text
Cell A                         Cell B
+----------------+           +----------------+
| FOB Core       |           | FOB Core       |
| Drill A        |           | Drill B        |
| minimum extras |           | minimum extras |
+----------------+           +----------------+

        mobile spawn node / Ural logisticsは別位置
```

狙い:

- Cell Aが捕捉・砲撃されてもCell Bが継続
- 一つのshell-camera観測で両Cellの詳細配置を把握されにくくする
- Builder/UralをAからBへ転用可能にする
- enemy firesを一つの高密度目標へ集中させない

未確定事項:

- FOB間最小距離
- 追加Coreのcash / supply / builder-time cost
- Drillの位置が敵map上でどの程度露呈するか
- Cell間距離をどこまで広げると運用摩擦が大きくなるか

これらを実測して、MDF-55よりTTR / CAV / CARが改善するかを比較する。

---

## 12. FSN — Fire Support Node

Mortar、AA等をDrill FOBと同居させると、攻撃行為で発生したsignatureが経済ノードを巻き込む。

`FSN`では、火力設備を別FOBまたは別nodeへ切り出す。

評価項目:

- Drill nodeへのcounter-fire誘導を減らせるか
- 追加Core / Hammer / Builder costを上回る効果があるか
- Mortar fireの継続性が改善するか
- FSN破壊後もDrill economyが生き残るか

現時点ではsupporting archetypeであり、単独採用を前提にしない。

---

## 13. terrain adaptationは二層構造にする

### Layer 1 — portable template

- 必要平坦面積
- 最低critical-node separation
- Ural ingress / unload / egress
- Builder動線
- build-area containment

をローカル座標で定義する。

### Layer 2 — terrain exploitation

実際の配置時に、

- 建物
- industrial clutter
- depression
- tree line
- cliff / berm
- road access

等を利用してgeometryを変形する。

Layer 2はLayer 1の制約を壊さない範囲で上書きする。

---

## 14. v2の検証優先順位

### P0

1. shell camera / SPH-2を含むtargeting footprintのゲーム内実態
2. active Drillが敵map / UIへどの程度位置露呈するか
3. Core破壊時のDrill依存
4. FOB build areaとFOB間最小距離
5. Ural離脱を含む`TTD`

### P1

1. MDF-30 vs MDF-55の`CAV`比較
2. MDF-55 vs PTF-2の`TTR / CAR / PAR`比較
3. Drill nodeとFSNを分けた場合の生存性
4. Builder 3人 / 4人でのsite-to-site再展開時間

### P2

1. 3地点以上でのterrain adaptation
2. alternate siteを事前選定した場合のTTR短縮量
3. regular / irregular geometryが敵の修正射撃へ与える影響

---

## 15. 根拠と留保

### Official / primary game context

- WARDOGS Steam Store: https://store.steampowered.com/app/1867240/WARDOGS/
- WARDOGS Steam Announcements: https://steamcommunity.com/app/1867240/announcements/

Early Access中であり、balance / economy / vehicle availability / visibility mechanicsは短期間で変更され得る。v2の数値ではなく**設計原則**をパッチ耐性のある成果物とする。

### Army-hosted lessons learned / professional publication

- `The Economics of Survivability`, Transformation and Lessons Learned Manager-Army, Sep 2026: https://api.army.mil/e2/c/downloads/2026/09/10/20a85297/26-1216-economics-of-survivability-sep-26-public.pdf

この文書はU.S. Army公式サイトで公開されているが、本文自身が「著者見解であり、Department of DefenseまたはArmyの公式見解を必ずしも示さず、既存の公式出版物を変更・代替しない」と明記している。したがって本repoでは`official doctrine`ではなく`army-hosted lessons learned / professional analysis`として扱う。

本研究で参照する概念:

- signature management
- convenience compression
- sensor exposure
- tactical dispersion
- pulsed logistics
- micro-dispersal
- route masking
- irregular / dispersed fires positioning

### Community meta observations

- Mortar shell cameraによるFOB観測問題: https://www.reddit.com/r/WarDogs/comments/1wdyr6p/mortar_shells_overview_camera_need_to_be_removed/
- shell camera / mortar meta discussion: https://www.reddit.com/r/OfficialWARDOGS/comments/1wfw44y/feedback_on_mortars_the_shell_camera_is_too/
- mortar visionからDrill等を順次破壊できるという報告: https://www.reddit.com/r/WarDogs/comments/1wdvjjk/mortars_should_not_grant_vision/
- multi-Drill metaの観測: https://www.reddit.com/r/WarDogs/comments/1wec40u/devs_dont_let_the_drill_become_the_only_meta/

これらはゲーム内メタの観測であり、公式仕様ではない。設計上のthreat hypothesisとして使い、現行ビルドで再現できる項目は実測へ昇格させる。

---

## 16. v2 pre-releaseの判断基準

`v2.0.0-pre`では次を確定しない。

- MDF-55の55 m
- PTF-2のCell間距離
- YELLOW / RED triggerの秒数・着弾数
- shell cameraの実効観測半径
- Core破壊後のDrill挙動

これらは`needs_validation`のまま保持する。

v2の確定成果は数値ではなく、次の設計転換である。

> **FOBを一点の基地として最適化せず、分散したeffect-generating nodesとmobile logisticsの組み合わせとして設計する。**
