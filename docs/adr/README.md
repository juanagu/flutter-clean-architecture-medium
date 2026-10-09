# Architecture decision records

One decision per file: its context, the decision, the alternatives considered and the consequences. An ADR records a decision at a point in time. If one is reversed, add a dated amendment and a new ADR; do not rewrite it.

| ADR | Title | Status |
| --- | --- | --- |
| [0001](0001-feature-composition-roots.md) | Feature classes as composition roots | Accepted |
| [0002](0002-either-and-sealed-failures.md) | `Either` results with sealed failures and states | Accepted |
| [0003](0003-remote-config-feature-toggles.md) | Feature toggles from Remote Config, checked at the entry widget | Accepted |
| [0004](0004-custom-i18n-loader.md) | Custom JSON i18n loader | Accepted |
| [0005](0005-in-memory-backend.md) | In-memory backend behind a compile-time define | Accepted |

Format for a new ADR: `NNNN-short-title.md` with sections Status, Context, Decision, Alternatives considered, Consequences. Keep it to one or two screens.
