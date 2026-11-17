# PROJECT-NAME

One or two lines: what the project is and who it is for.

## Stack

- Backend: (e.g. Node.js + Express)
- Frontend: (e.g. React + Vite)
- Database: (e.g. MySQL)

## Commands

- Install: `npm install`
- Dev: `npm run dev`
- Tests: `npm test`
- Lint/format: `npm run lint`

## Structure

- `src/` source code
- `docs/` documentation
- `docs/decisions/` decision records (created with `/jzuletadev-core:decision`)

## Conventions

- Naming: camelCase for variables, PascalCase for components.
- Commits: Conventional Commits in English (draft them with `/jzuletadev-core:commit`).
- Never commit or push unless explicitly asked.

## Definition of done

- Every acceptance criterion has evidence: a test or a command output.
- Tests, lint and build pass.
- The reviewer reports no critical or high findings (`/jzuletadev-core:verify` checks this list).
- Docs and decision records are updated when behavior or architecture changes.

## Review checklist

Project-specific checks the reviewer applies. Add one when a review, a bug or a correction shows a mistake that can happen again (`/jzuletadev-core:retro` proposes them).

- (e.g. Every new endpoint validates its input and has a test for invalid input.)

## Do not touch

- `.env` files and secrets.
- Migrations that were already applied.
