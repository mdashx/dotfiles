# Subagent Packets

Subagents may be used for independent inventory, comparison, and extraction
tasks. The coordinator owns final classification and edits to canonical files.

## Packet Shape

```text
Packet ID:
Objective:
Source scope:
Do not read:
Output file:
Evidence required:
Stopping condition:
Coordinator promotion rule:
```

## Initial Packet Ideas

```text
PLC-SA-001 dotfiles agents/research inventory
PLC-SA-002 wingman-26 research process inventory
PLC-SA-003 rad-nlp research process/example inventory
PLC-SA-004 principlelabs workbench research inventory
PLC-SA-005 template extraction review
```

Workers should not edit final `agents/`, `prompts/`, `practices/`,
`templates/`, or `examples/` directories unless a later ticket assigns a
disjoint write scope.
