# Technical Specification

<!--
INSTRUCTIONS FOR FILLING OUT THIS DOCUMENT:

This is the "Blueprint". It tells the AI HOW to build your product.

CRITICAL: Be specific about versions and libraries to prevent the AI from picking random ones.

Examples:
  ❌ BAD:  "Language: TypeScript"
  ✅ GOOD: "Language: TypeScript 5.3.x"

  ❌ BAD:  "Database: PostgreSQL"
  ✅ GOOD: "Database: PostgreSQL 16.x"

If you're unsure what stack to use, ask Claude:
  "What tech stack would you recommend for [your project type]?
   I want something [simple/scalable/production-ready]."

After Claude suggests a stack, make sure to:
1. Copy the suggestions into this file with specific versions
2. Update .claude/settings.json with the commands for your stack
   (See examples section in that file for Python, Go, Rust configs)
-->

## Purpose

This document defines HOW we build the product: stack choices, schemas, APIs, and libraries.

---

## Technology Stack

### Frontend
<!-- Be specific! Include version numbers. -->
- **Framework**: *[e.g., React 18.x, Vue 3.x, Angular 17.x]*
- **Language**: *[e.g., TypeScript 5.3.x, JavaScript ES2023]*
- **Build Tool**: *[e.g., Vite 5.x, Webpack 5.x, Parcel 2.x]*
- **Styling**: *[e.g., CSS Modules, Tailwind 3.x, styled-components 6.x]*
- **State Management**: *[e.g., Redux Toolkit 2.x, MobX 6.x, Context API]*

### Backend
<!-- Specify versions! This prevents the AI from using deprecated or incompatible versions. -->
- **Runtime**: *[e.g., Node.js 20.x LTS, Python 3.12.x, Go 1.22.x]*
- **Framework**: *[e.g., Express 4.x, FastAPI 0.110.x, Gin 1.9.x]*
- **Language**: *[e.g., TypeScript 5.3.x, Python 3.12.x, Go 1.22.x]*
- **API Style**: *[e.g., REST, GraphQL, gRPC]*

### Database
<!-- Include version numbers for databases too! -->
- **Primary DB**: *[e.g., PostgreSQL 16.x, MongoDB 7.x, MySQL 8.x]*
- **Caching**: *[e.g., Redis 7.x, Memcached 1.6.x]*
- **ORM/Query Builder**: *[e.g., Prisma 5.x, TypeORM 0.3.x, SQLAlchemy 2.x]*

### Infrastructure
- **Hosting**: *[e.g., AWS (EC2, RDS), GCP (Cloud Run), Azure, Vercel]*
- **CI/CD**: *[e.g., GitHub Actions, CircleCI, Jenkins]*
- **Monitoring**: *[e.g., Sentry, DataDog, New Relic]*

---

## System Architecture

<!-- Draw a simple ASCII diagram or describe your system architecture.
This helps the AI understand how components interact.

Keep it simple for MVP. You can always expand later. -->

```
[High-level architecture diagram or description]

Example for a simple web app:
┌─────────────┐
│   Client    │  (React frontend)
└──────┬──────┘
       │ HTTPS
       v
┌─────────────┐
│   API GW    │  (Express server)
└──────┬──────┘
       │
       v
┌─────────────┐     ┌─────────────┐
│  App Server │────▶│  Database   │  (PostgreSQL)
└─────────────┘     └─────────────┘
```

---

## Data Models

<!-- Define your database schema here. Use the language syntax your project uses.
For TypeScript: interfaces. For Python: dataclasses or Pydantic models. For Go: structs. -->

### Model 1: [Entity Name]
<!-- Example: "User" -->

```typescript
interface Entity {
  id: string;          // UUID or auto-incrementing ID
  field1: string;      // Example: email
  field2: number;      // Example: age
  createdAt: Date;     // Timestamp when created
  updatedAt: Date;     // Timestamp when last updated
}
```

**Relationships**:
<!-- Example: "One User has many Projects (one-to-many)" -->
- *[Relationship to other entities]*

**Indexes**:
<!-- Only add indexes for fields you'll query frequently -->
- `field1` - for [reason - e.g., "fast user lookup by email"]
- `createdAt` - for [reason - e.g., "sorting by recency"]

---

### Model 2: [Entity Name]

```typescript
interface Entity {
  // Fields
}
```

---

## API Contracts

<!-- Define your API endpoints here. Be specific about request/response formats.
This ensures the AI generates APIs that match your expected contract. -->

### Endpoint: [Name]
<!-- Example: "Create User" or "Get Invoice by ID" -->

**Method**: `GET | POST | PUT | DELETE`
**Path**: `/api/v1/resource`
<!-- Example: `/api/v1/users` or `/api/v1/invoices/:id` -->

**Request**:
<!-- Show exact JSON structure expected -->
```json
{
  "field1": "value",
  "field2": 123
}
```

**Response** (200 OK):
<!-- Show exact JSON structure returned -->
```json
{
  "data": {
    "id": "uuid",
    "field1": "value"
  }
}
```

**Error** (400 Bad Request):
<!-- Define error response format -->
```json
{
  "error": {
    "code": "INVALID_INPUT",
    "message": "Field1 is required"
  }
}
```

---

## External Dependencies

<!-- List third-party libraries you'll use and WHY.
This prevents the AI from adding unnecessary dependencies. -->

### Library: [Name]
<!-- Example: "bcrypt" or "Stripe SDK" -->

**Purpose**: *[Why we're using this - e.g., "Password hashing"]*
**Version**: *[Specific version - e.g., "bcrypt ^5.1.0"]*
**Alternatives Considered**: *[e.g., "argon2, scrypt"]*
**Justification**: *[e.g., "Industry standard, well-audited, good performance"]*

---

## Configuration

### Environment Variables

<!-- Define all environment variables your app needs.
This ensures the AI generates code that uses the correct variable names. -->

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `API_KEY` | Yes | - | API key for external service |
| `PORT` | No | 3000 | Server port |
| `DB_URL` | Yes | - | Database connection string |
<!-- Add more rows as needed. Example: DATABASE_URL, JWT_SECRET, STRIPE_KEY -->

---

## Security Considerations

<!-- Security is critical! Be specific about how you'll handle auth, data protection, etc. -->

### Authentication
- **Method**: *[e.g., JWT with bcrypt, OAuth 2.0, Session-based]*
- **Token Storage**: *[e.g., "JWT in httpOnly cookie", "localStorage (with XSS protection)"]*
- **Expiration**: *[e.g., "Access token: 15min, Refresh token: 7 days"]*

### Authorization
- **Model**: *[e.g., RBAC (Role-Based Access Control), ABAC (Attribute-Based)]*
- **Implementation**: *[e.g., "Middleware checks user role before route access"]*

### Data Protection
- **Encryption at Rest**: *[e.g., "PostgreSQL transparent data encryption", "None for MVP"]*
- **Encryption in Transit**: *[e.g., "TLS 1.3, Let's Encrypt certificates"]*
- **Sensitive Data**: *[e.g., "Passwords hashed with bcrypt (10 rounds), PII encrypted with AES-256"]*

---

## Performance Requirements

- **Response Time**: *[Target latency]*
- **Throughput**: *[Requests per second]*
- **Concurrency**: *[Simultaneous users]*
- **Data Volume**: *[Expected data size]*

---

## Deployment

### Build Process
```bash
npm run build
```

### Deployment Steps
1. *[Step 1]*
2. *[Step 2]*
3. *[Step 3]*

### Rollback Procedure
*[How to rollback if deployment fails]*
