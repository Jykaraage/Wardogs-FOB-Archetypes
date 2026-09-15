# FSN — Fire Support Node

Status: **v2 supporting candidate / unvalidated**

## 目的

`FSN`は、MortarやAA等の火力・対空設備をDrill economy nodeから切り離し、**offensive signatureとeconomic infrastructureを別failure domainへ分離する**ための補助アーキタイプである。

Drill FOBでMortarを発砲すると、敵のcounter-fireやshell-camera観測を同じ地点へ誘導し、Drillやspawn vehicleまで巻き込む可能性がある。FSNはこの結合を減らす。

## 原則

```text
DRILL NODE != FIRE SUPPORT NODE
```

- DrillをFSNの必須構成にしない
- Mortar / AA等、敵の注意を引きやすい設備を優先して切り出す
- 追加Coreが必要なら、そのcash / builder-timeを明示する
- spawn vehicleやUralをFSN内へ常駐させない
- counter-fire成立後はrebuild-in-placeを前提にしない

## 概念図

```text
        Drill Cell A
             o

     FSN o               o Drill Cell B

            mobile spawn
                 o

     Uralは各nodeへ短時間だけ接触する
```

## 成立条件

FSNの追加コストに対し、少なくとも次のどれかが確認できること。

- Drill nodeへのcounter-fire誘導が減る
- Drill nodeの`CAV / CAR`が改善する
- FSN喪失後もeconomy機能が継続する
- Mortar再展開の`TTR`が改善する

追加FOBを建てるだけでplayer-minute costが増え、Drillの実効稼働時間が落ちるなら不採用とする。

## 未確定事項

- Mortar / SPH-2の現行metaが短期patchでどう変わるか
- fire-support用FOBの最小構成
- Mortar発砲地点とDrill地点をどこまで離す必要があるか
- counter-fireがどの情報から成立するか
- AAをDrill側に残すべき条件

詳細な上位原則は[`../../docs/doctrine-v2.md`](../../docs/doctrine-v2.md)を参照する。
