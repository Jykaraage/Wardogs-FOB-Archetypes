# Source register

最終確認: 2026-09-15

この台帳は「参照先」を管理する。ここに掲載されていること自体は、その値が公式または現行ビルドで正しいことを意味しない。

## WARDOGS / game sources

| source_id | 種別 | 参照先 | 本研究で使う情報 | 現在の扱い |
|---|---|---|---|---|
| `wardogs-steam-store` | official | https://store.steampowered.com/app/1867240/WARDOGS/ | 開発元、Early Access、ゲーム概要、Control Zone / Hot Zone等 | official |
| `wardogs-steam-announcements` | official | https://steamcommunity.com/app/1867240/announcements/ | patch / economy / unlock変更 | official |
| `wardogs-hub-base` | community / extracted claim | https://wardogshub.uk/en/base/ | collision由来とされるfootprint、FOB build radius、FOB間距離 | 要ゲーム内照合 |
| `wardogs-zone-base` | community / extracted claim | https://wardogs.zone/loadouts/base | buildables、supplies、耐久、FOB build range | 要ゲーム内照合 |
| `wardogs-zone-artillery` | community | https://wardogs.zone/calculators/artillery | L81/SPH-2の弾道・blast値 | 構造物damageは要実測 |
| `wardogs-calculator` | OSS community | https://github.com/apollyon-sys/wardogs-calculator | map座標、map renderer、drawing、artillery | MIT code / assets別扱い |
| `wardogs-fob-builder` | OSS community | https://github.com/Bernardo-Andreatta/wardogs-fob-builder | top-down editor、Build Stage、Builder assignment | ライセンス確認前はコード非流用 |
| `natural-japanese` | third-party skill | https://github.com/coji/natural-japanese | 日本語文書の設計・推敲・lint | MIT / pinned submodule |

## Current meta observations

次は2026-09-15時点のコミュニティ観測であり、公式仕様ではない。v2のthreat hypothesisを作るために使い、再現できる項目はゲーム内実測へ移す。

| source_id | 種別 | 参照先 | 観測内容 | 扱い |
|---|---|---|---|---|
| `reddit-mortar-overview-camera` | community | https://www.reddit.com/r/WarDogs/comments/1wdyr6p/mortar_shells_overview_camera_need_to_be_removed/ | mortar shell cameraが構造物・車両・人員の偵察手段として機能するという報告 | targeting-footprint仮説 |
| `reddit-official-mortar-feedback` | community | https://www.reddit.com/r/OfficialWARDOGS/comments/1wfw44y/feedback_on_mortars_the_shell_camera_is_too/ | mortar spam、top-down observation、再建位置の把握に関する報告 | targeting-cycle仮説 |
| `reddit-mortar-vision` | community | https://www.reddit.com/r/WarDogs/comments/1wdvjjk/mortars_should_not_grant_vision/ | 1発目でFOB内部を把握し、Drill等へ修正射撃したという複数報告 | CAV / sequential kill仮説 |
| `reddit-drill-meta` | community | https://www.reddit.com/r/WarDogs/comments/1wec40u/devs_dont_let_the_drill_become_the_only_meta/ | 複数Drill、複数FOBによるDrill運用の観測 | site-redundancy比較の背景 |

Redditの得票数や投稿者の断言は仕様根拠にしない。特にHardcore mode、敵map上のDrill表示、SPH-2の挙動等は現行ゲーム内で別途確認する。

## Modern survivability / sustainment references

これらはWARDOGSの仕様資料ではない。FOB設計の評価概念を整理するための外部参照である。

| source_id | 種別 | 参照先 | 本研究で使う概念 | 扱い |
|---|---|---|---|---|
| `army-economics-survivability-2026` | army-hosted lessons learned / professional analysis | https://api.army.mil/e2/c/downloads/2026/09/10/20a85297/26-1216-economics-of-survivability-sep-26-public.pdf | signature management、convenience compression、sensor exposure、dispersion、pulsed logistics、micro-dispersal、route masking | doctrineそのものではない |

`The Economics of Survivability`はU.S. Army公式サイトで公開されているが、本文に「著者見解であり、Department of DefenseまたはArmyの公式見解を必ずしも示さず、既存の公式出版物を変更・代替しない」と明記されている。したがって本repoでは`official_doctrine`ではなく`army_hosted_lessons_learned / professional_analysis`として扱う。

同資料が参照するFM/ADPは、必要に応じて別source IDで一次資料を確認してから利用する。

## 現時点で確認できている公式変更

2026-09-09のSeason 1変更点では、公式Steam announcementに以下が掲載されている。

- Forward Operating Base vendor price: `$2,500 -> $7,500`
- Large Hammer vendor price: `$1,600 -> $2,400`
- Support Large Hammer unlock: level `7 -> 8`
- Driver URAL unlock: level `4 -> 3`
- Driver URAL unlock cost: `$50,000 -> $35,000`

これらは装備調達条件の参考にはなるが、FOBの幾何・blast判定・建築速度・targeting footprintの根拠にはならない。

## 現在の主要な未確定値

| claim | 現在見えている値 | source | status |
|---|---:|---|---|
| FOB build range | 60 m | Wardogs Hub / Wardogs Zone | shape・境界を要実測 |
| FOB間距離 | 120 m | Wardogs Hub | PTF-2の前提として要実測 |
| Drill Rig supply cost | 1801 | Wardogs Zone | 現行ゲームで照合 |
| L81 blast radius | 10 m | Wardogs Zone | 構造物への実効範囲は未確定 |
| map coordinate scale (Bakurani) | 100 m / unit | wardogs-calculator | ゲーム内Mark Coordinatesで校正 |
| shell-camera targeting footprint | unknown | community reports | v2 P0実測 |
| active Drill enemy-side visibility | unknown | community reports | v2 P0実測 |
| Core loss -> Drill dependency | unknown | none verified | v2 P0実測 |

## 矛盾を発見した場合

値を上書きする前に、build/date/定義を確認する。例えばFOB build areaを`circle`とする資料と`square`とする資料が存在する場合、単純にどちらかを採用せず`docs/research-plan.md`へ検証項目を追加する。

`community`の一致は`official`への昇格条件ではない。再現可能なゲーム内試験が取れた場合のみ`in_game_verified`へ移す。
