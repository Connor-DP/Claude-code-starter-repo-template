# Architecture

> Fill this in during project setup. Use `@architect` to help design your system.
> Delete the example content below and replace with your own.

## System Overview

<!-- High-level description of what the system does and how it's structured -->

```
Example: 3-tier web application

┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   Frontend   │────▶│   Backend   │────▶│  Database   │
│  (React/Vue) │     │  (API/BFF)  │     │ (Postgres)  │
└─────────────┘     └──────┬──────┘     └─────────────┘
                           │
                    ┌──────▼──────┐
                    │  External   │
                    │  Services   │
                    └─────────────┘
```

## Key Components

<!-- List each major component with its responsibility -->

| Component | Responsibility | Location |
|-----------|---------------|----------|
| [Frontend] | [User interface, client-side routing] | `src/client/` |
| [API Server] | [REST/GraphQL endpoints, business logic] | `src/server/` |
| [Database] | [Data persistence, migrations] | `src/db/` |
| [Auth] | [Authentication, authorization, sessions] | `src/auth/` |

## Design Patterns

<!-- Document the patterns used and WHY they were chosen -->

- **Pattern**: [e.g., Repository pattern for data access]
  - **Why**: [Abstracts database queries, makes testing easier]
  - **Where**: [src/repositories/]

- **Pattern**: [e.g., Service layer for business logic]
  - **Why**: [Separates concerns from controllers]
  - **Where**: [src/services/]

## Technology Stack

<!-- Specific versions matter — pin them -->

See `docs/TECH_SPEC.md` for the complete tech stack with version numbers.

## Data Flow

<!-- How does data move through the system? -->

```
Example: User creates a resource

User → Frontend → API Request → Auth Middleware → Controller
  → Service (business logic) → Repository → Database
  → Response ← Controller ← Service ← Repository
```

## Integration Points

<!-- External systems this project connects to -->

| System | Purpose | Auth Method | Docs |
|--------|---------|-------------|------|
| [Stripe] | [Payments] | [API Key] | [link] |
| [SendGrid] | [Email] | [API Key] | [link] |

## Scalability Considerations

<!-- How does this system scale? What are the bottlenecks? -->

- **Current capacity**: [e.g., ~1000 concurrent users]
- **Bottlenecks**: [e.g., Database connections, file uploads]
- **Scaling strategy**: [e.g., Horizontal scaling via containers, read replicas]

## Security Architecture

<!-- How is security handled at the architecture level? -->

- **Authentication**: [e.g., JWT with refresh tokens]
- **Authorization**: [e.g., RBAC with middleware]
- **Data encryption**: [e.g., AES-256 at rest, TLS in transit]
- **Secret management**: [e.g., Environment variables, Vault]

---

*Last updated: [YYYY-MM-DD]*
*ADRs for architectural decisions: [docs/adr/](adr/)*
