# Graph Report - vault/Research/10_Wiki  (2026-04-15)

## Corpus Check
- Corpus is ~8,052 words - fits in a single context window. You may not need a graph.

## Summary
- 36 nodes · 110 edges · 6 communities detected
- Extraction: 69% EXTRACTED · 31% INFERRED · 0% AMBIGUOUS · INFERRED: 34 edges (avg confidence: 0.82)
- Token cost: 0 input · 0 output

## Community Hubs (Navigation)
- [[_COMMUNITY_AI & Knowledge Tools|AI & Knowledge Tools]]
- [[_COMMUNITY_Exosuit Hardware Platform|Exosuit Hardware Platform]]
- [[_COMMUNITY_H-Walker Gait Rehab|H-Walker Gait Rehab]]
- [[_COMMUNITY_Motor Control & Safety|Motor Control & Safety]]
- [[_COMMUNITY_Motor Driver Selection|Motor Driver Selection]]
- [[_COMMUNITY_CAN Bus Protection|CAN Bus Protection]]

## God Nodes (most connected - your core abstractions)
1. `Exosuit Handoff` - 15 edges
2. `Exosuit Hardware Overview` - 13 edges
3. `Skiro Learnings` - 8 edges
4. `Teensy 4.1` - 7 edges
5. `Elmo Driver Comparison` - 7 edges
6. `CAN Communication` - 7 edges
7. `Cable-Driven Mechanism` - 6 edges
8. `Robot Hardware Protection` - 6 edges
9. `EBIMU IMU` - 6 edges
10. `Gait Analysis` - 6 edges

## Surprising Connections (you probably didn't know these)
- `Skiro Learnings` --conceptually_related_to--> `Robot Hardware Protection`  [INFERRED]
  vault/Research/10_Wiki/skiro-learnings.md → vault/Research/10_Wiki/robot-hardware-protection.md
- `Exosuit Handoff` --shares_data_with--> `Skiro Learnings`  [INFERRED]
  vault/Research/10_Wiki/exosuit-handoff.md → vault/Research/10_Wiki/skiro-learnings.md
- `Exosuit Hardware Overview` --conceptually_related_to--> `Cable-Driven Mechanism`  [INFERRED]
  vault/Research/10_Wiki/exosuit-hardware-overview.md → vault/Research/10_Wiki/cable-driven-mechanism.md
- `Exosuit Handoff` --conceptually_related_to--> `Cable-Driven Mechanism`  [INFERRED]
  vault/Research/10_Wiki/exosuit-handoff.md → vault/Research/10_Wiki/cable-driven-mechanism.md
- `Robot Hardware Protection` --conceptually_related_to--> `CAN Communication`  [INFERRED]
  vault/Research/10_Wiki/robot-hardware-protection.md → vault/Research/10_Wiki/can-communication.md

## Hyperedges (group relationships)
- **Exosuit Core Hardware System** —  [INFERRED 0.90]
- **Exosuit Sensing Subsystem** —  [INFERRED 0.85]
- **Motor Control Chain** —  [INFERRED 0.85]
- **Gait Rehabilitation Research** —  [INFERRED 0.85]
- **AI Knowledge Management** —  [INFERRED 0.70]

## Communities

### Community 0 - "AI & Knowledge Tools"
Cohesion: 0.54
Nodes (8): Antigravity IDE, Gemma 4, Graphify, LLM Wiki, Naver Blog Pipeline, Obsidian, P-Reinforce, 0xhenry.dev

### Community 1 - "Exosuit Hardware Platform"
Cohesion: 0.54
Nodes (8): CANopen Protocol, EBIMU IMU, Exosuit Handoff, Exosuit Hardware Overview, FreeRTOS, Jetson Orin NX, STM32H743, ZED X Mini

### Community 2 - "H-Walker Gait Rehab"
Cohesion: 0.61
Nodes (8): Admittance Control, 2026 Bumbuche Grant, Cable-Driven Mechanism, Gait Analysis, H-Walker, Realtime Pose Estimation, Stroke Gait Experiment, 3D Assistance

### Community 3 - "Motor Control & Safety"
Cohesion: 0.67
Nodes (6): AK60 Motor, CAN Communication, Exosuit Safety, Motor Benchmark, Skiro Learnings, Teensy 4.1

### Community 4 - "Motor Driver Selection"
Cohesion: 1.0
Nodes (4): Elmo Driver Comparison, Elmo Gold Twitter, Exosuit Protection, Motor Selection

### Community 5 - "CAN Bus Protection"
Cohesion: 1.0
Nodes (2): ISO1050 Isolated CAN, Robot Hardware Protection

## Knowledge Gaps
- **Thin community `CAN Bus Protection`** (2 nodes): `ISO1050 Isolated CAN`, `Robot Hardware Protection`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `Exosuit Handoff` connect `Exosuit Hardware Platform` to `H-Walker Gait Rehab`, `Motor Control & Safety`, `Motor Driver Selection`, `CAN Bus Protection`?**
  _High betweenness centrality (0.116) - this node is a cross-community bridge._
- **Why does `Exosuit Hardware Overview` connect `Exosuit Hardware Platform` to `H-Walker Gait Rehab`, `Motor Driver Selection`, `CAN Bus Protection`?**
  _High betweenness centrality (0.062) - this node is a cross-community bridge._
- **Why does `Skiro Learnings` connect `Motor Control & Safety` to `Exosuit Hardware Platform`, `H-Walker Gait Rehab`, `CAN Bus Protection`?**
  _High betweenness centrality (0.025) - this node is a cross-community bridge._
- **Are the 4 inferred relationships involving `H-Walker` (e.g. with `Exosuit Safety` and `Elmo Gold Twitter`) actually correct?**
  _`H-Walker` has 4 INFERRED edges - model-reasoned connections that need verification._
- **Are the 5 inferred relationships involving `Exosuit Handoff` (e.g. with `ISO1050 Isolated CAN` and `Robot Hardware Protection`) actually correct?**
  _`Exosuit Handoff` has 5 INFERRED edges - model-reasoned connections that need verification._
- **Are the 4 inferred relationships involving `Exosuit Hardware Overview` (e.g. with `Cable-Driven Mechanism` and `Robot Hardware Protection`) actually correct?**
  _`Exosuit Hardware Overview` has 4 INFERRED edges - model-reasoned connections that need verification._
- **Are the 2 inferred relationships involving `Admittance Control` (e.g. with `Exosuit Handoff` and `Elmo Gold Twitter`) actually correct?**
  _`Admittance Control` has 2 INFERRED edges - model-reasoned connections that need verification._