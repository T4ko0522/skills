---
name: functional-cohesion-components
description: Design or review React/TypeScript components when deciding whether product responsibilities belong together, should split, or can share a meaningful unit.
---

# Functional Cohesion Components

Use functional cohesion to align a component with one product responsibility, workflow, or role. Visual similarity alone does not make code shareable.

## Decide the boundary

1. Identify the user intent, data ownership, actions, permissions, and states that the UI represents.
2. Split when those differ by role, workflow, or discriminated data variant and the difference would otherwise spread through the component. Keep the branch at the route, page, list mapper, or small dispatcher that owns that choice.
3. Share a unit only when its requirements, domain concept, data shape, and local conventions agree. Intentional duplication is preferable to a component that switches between unrelated responsibilities.
4. Keep a component together when splitting would produce wrappers with no meaningful job. A small, feature-named prop or slot is appropriate for a local variation; accumulating role or mode flags is a signal to split.

Check the affected roles, empty/error states, navigation, validation, and mobile behaviour before deciding. Use exhaustive handling where a discriminated API union owns the variation.

For worked route, dispatcher, and extension-point examples, read [references/patterns.md](references/patterns.md) only when needed.

## Review output

State the current cohesion, the responsibility that is at risk, the recommended boundary, and the deliberate share-or-duplicate decision. Recommend the smallest change that makes ownership clear.
