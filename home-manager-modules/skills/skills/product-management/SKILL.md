---
name: product-management
version: "1.0.0"
description: Provides the "Best-Outcome" PRD framework and standard operating procedures for Product Managers. Includes templates for full PRDs, light specs, and user stories.
user-invocable: true
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - WebSearch
---

# Product Management Skill

This skill equips you with the standard operating procedures (SOPs) and templates required to deliver "Best-Outcome" Product Requirements Documents (PRDs).

## The "Best-Outcome" Protocol

To ensure engineering success, you must follow this 3-step protocol for every significant feature request.

### Phase 1: The Clarification Loop (Mandatory)

**Never draft a PRD from a vague prompt.** You must ask questions until you can fill out the "Strategic Context" section of the PRD.

- **Problem:** What user pain point are we solving? (vs. just building a feature)
- **Goal:** What is the specific business metric we want to move? (e.g., "Increase conversion by 5%", not "Make it better")
- **Constraint:** What are the hard technical or timeline limits?

### Phase 2: Definition & Trade-offs

Once clarified, define the solution boundaries using these frameworks:

- **MoSCoW Prioritisation:**
  - **Must Have:** Non-negotiable for launch.
  - **Should Have:** Important but can wait for a fast-follow.
  - **Could Have:** "Nice to have" if time permits.
  - **Won't Have:** Explicitly out of scope for this release.
- **RICE Scoring (for deciding between features):**
  - **(R)each x (I)mpact x (C)onfidence / (E)ffort**

### Phase 3: The Specification

Draft the PRD using the appropriate template.

- **Use `prd-full.md` for:** New products, major features, or complex architectural changes.
- **Use `prd-light.md` for:** Iterations, minor enhancements, or UI tweaks.

## Template Library

Templates are located in the `templates/` directory relative to this skill.

### 1. The Full PRD (`templates/prd-full.md`)

The "Gold Standard" for engineering specifications. It forces you to think through:

- **Happy Paths vs. Edge Cases:** (e.g., What if the user is offline?)
- **Data Models:** (e.g., specific JSON schemas or SQL table changes)
- **NFRs:** (Performance, Security, Accessibility)

### 2. The Light PRD (`templates/prd-light.md`)

A streamlined format for speed. Focuses on:

- **Context:** Why are we changing this?
- **Changes:** specific "Before" vs. "After" descriptions.
- **Acceptance Criteria:** A checklist for QA.

### 3. User Story Bank (`templates/user-story-bank.md`)

A structured file for collecting Gherkin-style requirements:

- `Given [context]`, `When [action]`, `Then [outcome]`.
- Use this to bridge the gap between Product and QA/Automation.

## Best Practices

1.  **Be Specific:** Avoid words like "fast", "easy", or "intuitive". Use "loads in <200ms", "requires <3 clicks", or "passes WCAG AA standards".
2.  **Define Counter-Metrics:** What _shouldn't_ happen? (e.g., "We want to increase signups, but NOT increase support tickets").
3.  **Live Documents:** Treat PRDs as living specs. If requirements change during development, update the PRD.
