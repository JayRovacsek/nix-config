---
name: market-research
version: "1.0.0"
description: Provides tools and frameworks for synthesising external market data, analysing competitors, and defining user personas to inform product strategy.
user-invocable: true
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - WebSearch
  - WebFetch
---

# Market Research Skill

This skill helps you look _outward_ to validate assumptions, understand the competitive landscape, and deeply empathise with users. It provides the strategic "Why" that fuels the Product Management "What".

## Core Methodologies

### 1. Competitor Analysis

Don't just list features. analyse **Strategy**.

- **Direct Competitors:** Solve the same problem for the same customer (e.g., Coke vs. Pepsi).
- **Indirect Competitors:** Solve the same problem differently (e.g., Zoom vs. Business Travel).
- **Replacement Competitors:** The status quo (e.g., Excel, Pen & Paper).

Use the `competitor-analysis.md` template to structure this data.

### 2. "Jobs to be Done" (JTBD)

Focus on the user's underlying motivation, not their demographics.

- **Formula:** "When I [situation], I want to [motivation], so I can [expected outcome]."
- _Example:_ "When I am late for a meeting, I want to find the fastest route, so I can minimize embarrassment."

### 3. Fact vs. Inference

When conducting research, strictly separate what you _know_ from what you _guess_.

- **Fact:** "Competitor X charges $10/month." (Verified via pricing page)
- **Inference:** "Competitor X is targeting SMBs." (Deduced from pricing tier)

## Template Library

Templates are located in the `templates/` directory relative to this skill.

### 1. Competitor Analysis Matrix (`templates/competitor-analysis.md`)

A side-by-side comparison tool. Use this to identify gaps in the market or "table stakes" features you must build.

- **Feature Parity:** Do we have feature parity?
- **UX/UI Patterns:** How do they solve the interaction?
- **Pricing/Positioning:** Where do they fit in the market?

### 2. Persona Profile (`templates/persona-profile.md`)

A deep-dive into a specific user archetype. Use this to humanise the "Target Audience" section of a PRD.

- **Psychographics:** Values, fears, and motivations.
- **Tech Literacy:** How comfortable are they with new tools?
- **Pain Points:** What keeps them up at night?
