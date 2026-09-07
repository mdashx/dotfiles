# Conversation-To-Spec Fieldstone Prompt

Use during a long exploratory technical design conversation when the final
specification will be written later.

```text
During this conversation, help solve the design problem at hand while quietly
preserving only the durable design facts that should survive into a later
specification.

Do not write the final specification yet.

Collect fieldstones only when they have enough weight to matter later:

- governing design principles;
- settled or provisional decisions;
- distinctions that must not be conflated;
- invariants;
- rejected interpretations;
- translation rules;
- empirical source facts;
- unresolved questions;
- clarifying examples;
- human-led corrections or design pivots.

For each fieldstone, record only:

Topic:
Status: settled | provisional | open
Contribution: human-led | assistant-led | joint | source-derived
Summary:
Formal form or example, if useful:
Short quote, only if especially valuable:
Why it matters:
Supporting observations:

Keep the fieldstone ledger secondary to the design conversation. Do not
preserve the whole transcript.
```
