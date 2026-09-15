# Source register

最終確認: 2026-09-15

この台帳は「参照先」を管理する。ここに掲載されていること自体は、その値が公式または現行ビルドで正しいことを意味しない。

| source_id | 種別 | 参照先 | 本研究で使う情報 | 現在の扱い |
|---|---|---|---|---|
| `wardogs-steam-store` | official | https://store.steampowered.com/app/1867240/WARDOGS/ | 開発元、Early Access、ゲーム概要 | official |
| `wardogs-steam-announcements` | official | https://steamcommunity.com/app/1867240/announcements/ | patch / economy / unlock変更 | official |
| `wardogs-hub-base` | community / extracted claim | https://wardogshub.uk/en/base/ | collision由来とされるfootprint、FOB build radius、FOB間距離 | 要ゲーム内照合 |
| `wardogs-zone-base` | community / extracted claim | https://wardogs.zone/loadouts/base | buildables、supplies、耐久、FOB build range | 要ゲーム内照合 |
| `wardogs-zone-artillery` | community | https://wardogs.zone/calculators/artillery | L81/SPH-2の弾道・blast値 | 構造物damageは要実測 |
| `wardogs-calculator` | OSS community | https://github.com/apollyon-sys/wardogs-calculator | map座標、map renderer、drawing、artillery | MIT code / assets別扱い |
| `wardogs-fob-builder` | OSS community | https://github.com/Bernardo-Andreatta/wardogs-fob-builder | top-down editor、Build Stage、Builder assignment | ライセンス確認前はコード非流用 |
| `natural-japanese` | third-party skill | https://github.com/coji/natural-japanese | 日本語文書の設計・推敲・lint | MIT / pinned submodule |

## 現時点で確認できている公式変更

2026-09-09のSeason 1変更点では、公式Steam announcementに以下が掲載されている。

- Forward Operating Base vendor price: `$2,500 -> $7,500`
- Large Hammer vendor price: `$1,600 -> $2,400`
- Support Large Hammer unlock: level `7 -> 8`
- Driver URAL unlock: level `4 -> 3`
- Driver URAL unlock cost: `$50,000 -> $35,000`

これらは装備調達条件の参考にはなるが、FOBの幾何・blast判定・建築速度の根拠にはならない。

## 現在の主要な未確定値

| claim | 現在見えている値 | source | status |
|---|---:|---|---|
| FOB build range | 60 m | Wardogs Hub / Wardogs Zone | shape・境界を要実測 |
| FOB間距離 | 120 m | Wardogs Hub | 要実測 |
| Drill Rig supply cost | 1801 | Wardogs Zone | 現行ゲームで照合 |
| L81 blast radius | 10 m | Wardogs Zone | 構造物への実効範囲は未確定 |
| map coordinate scale (Bakurani) | 100 m / unit | wardogs-calculator | ゲーム内Mark Coordinatesで校正 |

## 矛盾を発見した場合

値を上書きする前に、build/date/定義を確認する。例えばFOB build areaを`circle`とする資料と`square`とする資料が存在する場合、単純にどちらかを採用せず`docs/research-plan.md`へ検証項目を追加する。
