---
trigger: always_on
---

### Description

Build frontend applications without a real backend or database by using a structured mock data system that mimics real API behavior.
The architecture must ensure that the application can be upgraded to fullstack later **without rewriting UI or business logic**.

This rule applies to all frontend frameworks (React, Next.js, Flutter, Vue, etc.).

---

### Core Principles

1. **Strict Separation of Concerns**

   * UI layer: rendering only
   * Domain/logic layer: handles business logic
   * Data layer: handles data fetching (mock or real)

2. **Data Source Agnostic UI**

   * UI must not know whether data comes from mock or real backend

3. **API Simulation First**

   * Even without backend, all data must behave like it is coming from an API

---

### Folder / Module Structure (Abstract)

Each feature must follow this structure:

* `components/` → UI only
* `services/` → use cases / business logic
* `repositories/` or `data_sources/` → data access
* `mocks/` → mock data + mock handlers
* `types/` or `models/` → data contracts

---

### Rule 1: No Hardcoded Data in UI

❌ Forbidden:

* Static arrays/objects inside UI components
* Inline mock data in screens/widgets

✅ Required:

* UI must only consume data via service/usecase layer

---

### Rule 2: All Data Access Goes Through Data Layer

Every data request must follow:

UI → Service → Repository/DataSource → (Mock or API)

Example pattern (pseudo-code):

```
UI calls: userService.getUsers()

userService calls: userRepository.getUsers()

userRepository decides:
  if USE_MOCK → return mock
  else → call real API
```

---

### Rule 3: Mock Must Behave Like Real API

Mock implementations must:

* Be asynchronous (Promise/Future)
* Include artificial delay (300ms–1500ms)
* Support error simulation
* Support empty state

Example:

```
wait(500ms)
if (randomError) throw error
return mockData
```

---

### Rule 4: Define Data Contracts First

Before writing mock data, define models/types:

```
User {
  id: string
  name: string
  status: enum
}
```

Rules:

* Mock data MUST follow the same schema as future backend
* No “temporary fields” that will be removed later

---

### Rule 5: API Contract First (Even Without Backend)

Define endpoints logically before implementation:

* GET /users
* POST /messages
* GET /channels/:id

Mock must follow these contracts.

---

### Rule 6: Environment-Based Switching

System must support switching between mock and real:

```
USE_MOCK = true | false
```

Switch must be:

* Centralized
* Not scattered across codebase

---

### Rule 7: No Direct Networking in UI

❌ Forbidden:

* fetch/http/dio directly in UI

✅ Required:

* All network logic inside repository/data layer

---

### Rule 8: Adapter / Mapping Layer (Highly Recommended)

Always map raw data → domain model:

```
mapApiUserToUser(raw) → User
```

Purpose:

* Protect UI from backend changes
* Allow flexible backend evolution

---

### Rule 9: Consistent Data Access Pattern

Every feature must follow the same pattern:

* list → getList()
* detail → getById(id)
* create → create(data)
* update → update(id, data)
* delete → delete(id)

Even in mock stage.

---

### Rule 10: Mock Storage Strategy

Mock data must be:

* Centralized (not duplicated)
* Organized per feature
* Easily replaceable

Optional advanced:

* In-memory state (simulate DB)
* Local persistence (localStorage / device storage)

---

### Rule 11: Simulate Real UX States

Every async flow must support:

* loading
* success
* error
* empty

UI must be designed for all states.

---

### Rule 12: Avoid Over-Engineering Backend Early

* Do NOT build partial backend
* Either:

  * fully mock
  * or use BaaS

---

### Rule 13: Reusability Across Projects

All patterns must be:

* reusable
* copy-paste friendly
* consistent naming

---

### Rule 14: Naming Conventions

* `*Service` → business logic
* `*Repository` → data access
* `*Mock` → mock provider
* `*Model` / `*Type` → schema

---

### Rule 15: Future Migration Guarantee

The system is considered correct only if:

✅ Switching from mock → real API requires:

* changing data layer only

❌ NOT allowed:

* rewriting UI
* rewriting business logic

---

### Optional Advanced Rules (For Scaling)

* Use API mocking tools (e.g. interceptors)
* Add pagination simulation
* Add auth simulation
* Add real-time simulation (timers, sockets mock)

---

### Anti-Patterns (Strictly Forbidden)

* UI directly imports mock data
* Different data shape between mock and real
* Mixing business logic inside UI
* Multiple inconsistent data access patterns
* Temporary hacks that will be removed later

---

### Success Criteria

A project follows this rule if:

1. UI works without knowing data source
2. Mock can be replaced by real API with minimal change
3. All features follow same architecture
4. Code is scalable to fullstack without rewrite

---
