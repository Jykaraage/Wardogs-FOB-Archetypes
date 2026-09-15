# 描画・マップツール調査

## 結論

現時点では、**地図座標系は`apollyon-sys/wardogs-calculator`を主要リファレンス、詳細施工図のUXは`Bernardo-Andreatta/wardogs-fob-builder`を参考**にするのが効率的である。ただし、どちらもそのまま本repoの設計原本にはしない。

本repoでは`archetype.json -> SVG -> PNG`を基本パイプラインとし、WARDOGSマップへのoverlayは別レイヤーとして扱う。

## 1. apollyon-sys/wardogs-calculator

Repository: https://github.com/apollyon-sys/wardogs-calculator

### 利用価値

README上、L81/SPH-2計算だけでなく、tactical map、drawing、zone/polygon、marker、JSON保存、live team lobbyを持つ。FOB研究では、特に次が参考になる。

- tiled tactical map
- in-game coordinateとの対応
- mapごとのbounds
- map-independent renderer
- drawing / circular zone / polygon
- JSONでの状態管理

`docs/maps.md`ではBakuraniの設定例として`coordinateMetersPerUnit: 100`を公開しており、1 coordinate unit = 100 m、0.01 = 1 mという変換を採用している。同文書は、校正が利用可能なゲーム内参照データに基づき、今後改善され得ることも明記している。

### ライセンス上の注意

ソースコードはMIT。READMEは、WARDOGS assets等のthird-party materialsをMITの対象外としている。したがって、コードの考え方を利用できることと、マップタイルやゲーム由来画像を再配布できることを分けて考える。

本repoでは、外部マップ画像のURLやユーザー自身のcaptureを入力にできる設計を優先し、ゲームassetを無条件にvendorしない。

## 2. Bernardo-Andreatta/wardogs-fob-builder

Repository: https://github.com/Bernardo-Andreatta/wardogs-fob-builder

### 利用価値

README上、top-down grid editorとして次を備える。

- grid snap
- structure rotation / group move
- free-draw annotation
- JSON import/export
- PNG export
- Build Stage
- Builder assignment
- stage/builder別schematic export

「完成図」だけでなく、誰が・どの段階で建てるかを図面へ持ち込む発想が本研究と相性がよい。

### 制約

現状READMEに掲載されたstructure catalogは壁・Gate・Bunker等が中心で、本研究が最初に必要とするFOB Core / Drill Rig / Uralの正確な幾何を保証しない。また、確認時点でrepo rootに`LICENSE`が見当たらなかったため、**ライセンスを確認するまでコードをコピーしない**。UI・情報設計の参考に留める。

## 3. Wardogs Hub Base Builder

URL: https://wardogshub.uk/en/base/

FOBのbuild radiusや構造物寸法について、game collision box由来と説明している。構造物footprintを測る際の有力な二次資料になる。

一方で非公式community hubであるため、本repoでは`extracted`または`community`として記録し、自前のゲーム内挙動と照合する。

## 4. Wardogs Zone Base Builder / Artillery

Base Builder: https://wardogs.zone/loadouts/base

Artillery: https://wardogs.zone/calculators/artillery

Drill Rigのsupplies、FOB build range、L81のblast radius等を確認できる。ここもBULKHEAD公式ではないため、設計定数を確定するための一次情報にはしない。

特にL81の`10 m blast radius`を、そのまま「FOB構造物への実効加害半径10 m」と読み替えない。`docs/research-plan.md`のゲーム内試験で確認する。

## 5. 本repoの描画アーキテクチャ

```text
                         +----------------------+
                         | game map / screenshot|
                         +-----------+----------+
                                     |
                          map calibration layer
                                     |
                                     v
+------------------+       +--------------------+
| archetype.json   |------>| Overview renderer  |----> overview.svg/png
+--------+---------+       +--------------------+
         |
         | local geometry
         v
+------------------+
| Detail renderer  |----> detail.svg ----> detail.png
+------------------+
```

### canonical data

配置・寸法・source statusはJSON側に置く。SVG/PNGから数値を読み戻して設計データにしない。

### canonical drawing

詳細図はSVGを原本とする。SVGならCodexが寸法線・円・矩形・ラベルをテキストとして生成・差分レビューできる。PNGは共有用exportとする。

### future validator

最低限、次を自動判定できるようにする。

- critical node間距離
- blast-expanded footprintの交差
- FOB build area containment
- structure footprint collision
- Ural ingress / egress clearance
- build supply budget
- Build Stageごとの担当と必要人数
