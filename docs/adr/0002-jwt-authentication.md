# ADR 0002: JWT-Based Authentication

**Status:** Accepted
**Date:** 2026-01-10
**Deciders:** Product Owner, Claude (AI Architect)
**Related Task:** [Add User Authentication](../../ai/TASKS/archive/2026-01-10-add-user-authentication/)

---

## Context and Problem Statement

We need to implement user authentication for the application. Users should be able to register, log in, and access protected resources securely. The authentication system must:

- Support both web and future mobile clients
- Scale horizontally as the application grows
- Follow industry-standard security practices
- Provide good user experience (not re-authenticating constantly)

**Key Question:** Should we use session-based authentication or token-based authentication (JWT)?

---

## Decision Drivers

- **Scalability:** Need to support horizontal scaling without shared session store
- **Mobile Support:** Planning to add mobile apps in future
- **API-First Architecture:** Our app is built as an API with separate frontend
- **Statelessness:** Prefer stateless authentication for simpler infrastructure
- **Security:** Must prevent common vulnerabilities (session hijacking, token theft, etc.)
- **User Experience:** Users shouldn't have to log in too frequently

---

## Considered Options

### Option 1: Session-Based Authentication
Traditional server-side sessions with session cookies.

**Pros:**
- Simple to implement
- Easy to invalidate sessions server-side
- Well-understood security model
- Works great for server-rendered apps

**Cons:**
- Requires session store (Redis, database)
- Harder to scale horizontally (need shared session storage)
- Not ideal for mobile apps
- Requires CORS configuration for API-first architecture
- Session store becomes single point of failure

### Option 2: JWT Tokens (Chosen)
Stateless JSON Web Tokens for authentication.

**Pros:**
- Stateless (no server-side session storage)
- Works perfectly for APIs and mobile clients
- Easy to scale horizontally (no shared state)
- Includes claims (user info) in token itself
- Industry standard for modern web apps

**Cons:**
- Can't invalidate tokens server-side (mitigated with short expiry + refresh tokens)
- Token size larger than session ID (not significant for our use case)
- Requires careful secret management

### Option 3: OAuth2 Only (Delegated Authentication)
Use third-party providers (Google, GitHub) exclusively.

**Pros:**
- Delegate security to experts (Google, Microsoft, etc.)
- No password storage/management
- Social features easier to add

**Cons:**
- Not all users have OAuth accounts
- Still need JWT or sessions for our app
- Adds complexity for simple use case
- Third-party dependency for core functionality

---

## Decision Outcome

**Chosen:** Option 2 - JWT-Based Authentication with Refresh Tokens

### Implementation Details

1. **Access Tokens (JWT)**
   - Expiry: 24 hours
   - Contains: user ID, email, issued timestamp
   - Signed with HS256 algorithm
   - Secret stored in environment variable

2. **Refresh Tokens**
   - Expiry: 30 days
   - Stored in database (can be invalidated)
   - Used to obtain new access tokens
   - One-time use (rotated on refresh)

3. **Password Security**
   - Hashed with bcrypt
   - Cost factor: 12
   - Salt automatically generated

4. **Rate Limiting**
   - 5 attempts per minute per IP
   - Prevents brute force attacks
   - In-memory store (migrate to Redis when scaling)

### Why This Approach

The JWT + refresh token pattern gives us:
- **Statelessness:** Access tokens are self-contained, no database lookup
- **Security:** Short-lived access tokens limit damage if stolen
- **Revocation:** Can invalidate refresh tokens in database
- **Scalability:** No session store required
- **Mobile-Ready:** Works great for mobile apps
- **UX Balance:** 24-hour access tokens = less friction than 15-minute tokens

---

## Consequences

### Positive

- ✅ Application can scale horizontally without shared session store
- ✅ Same authentication works for web, mobile, and API consumers
- ✅ Reduced infrastructure complexity (no Redis for sessions)
- ✅ Token contains user info (reduces database queries)
- ✅ Standard, well-documented approach

### Negative

- ⚠️ Can't immediately revoke access tokens (mitigated by 24h expiry)
- ⚠️ Need to carefully manage JWT secret (must be strong, never committed)
- ⚠️ Slightly larger payload than session ID (marginal impact)

### Neutral

- ℹ️ Need to implement token refresh logic (one-time effort)
- ℹ️ Frontend must handle token expiry gracefully (standard practice)

---

## Implementation Notes

### Security Measures Taken

1. **Timing Attack Prevention:** Always hash password even if user doesn't exist
2. **Information Leakage Prevention:** Generic error messages ("Invalid credentials")
3. **Rate Limiting:** Prevents brute force attacks
4. **Password Strength:** Minimum 8 characters, 1 uppercase, 1 number
5. **HTTPS Only:** Tokens only sent over HTTPS in production

### Testing Coverage

- Unit tests for all authentication functions
- Integration tests for full auth flows
- Security tests for common vulnerabilities
- Edge case testing (expired tokens, invalid tokens, etc.)

---

## Alternatives Considered for Future

1. **OAuth2 Social Login:** Add in future task (complementary, not replacement)
2. **Magic Links (Passwordless):** Consider for v2 if user feedback suggests
3. **2FA/MFA:** Good enhancement, separate task
4. **Refresh Token Rotation:** More secure, but adds complexity - revisit if needed

---

## References

- [RFC 7519: JSON Web Token (JWT)](https://tools.ietf.org/html/rfc7519)
- [RFC 8725: JWT Best Current Practices](https://tools.ietf.org/html/rfc8725)
- [OWASP Authentication Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Authentication_Cheat_Sheet.html)
- [JWT.io - Introduction to JWT](https://jwt.io/introduction)

---

## Revision History

| Date | Change | Author |
|------|--------|--------|
| 2026-01-10 | Initial decision | Claude (AI Architect) |
