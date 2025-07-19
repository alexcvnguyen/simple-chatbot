# Removing Deprecated Message & Vote Systems from this repository

## Current State Analysis

The codebase currently maintains cross-compatibility between:

- **Old Message system**: `messageDeprecated` → 'Message' table (content: json) - **STILL EXISTS IN DB**
- **New Message system**: `message` → 'Message_v2' table (parts: json, attachments: json) - **ACTIVELY USED**
- **Old Vote system**: `voteDeprecated` → 'Vote' table (references deprecated Message table) - **STILL EXISTS IN DB**
- **New Vote system**: `vote` → 'Vote_v2' table (references Message_v2 table) - **ACTIVELY USED**

**CRITICAL FINDING**: Both old and new table pairs coexist in the database! The application uses v2 tables, but deprecated tables remain with their own foreign key relationships intact.

**Goal**: Remove all deprecated systems and rename v2 systems to be the primary systems.

## Database Tables that need to be DROPPED

- [ ] `Message` table (deprecated message table)
- [ ] `Vote` table (deprecated vote table)

## Database Tables that need to be RENAMED

- [ ] `Message_v2` → `Message`
- [ ] `Vote_v2` → `Vote`

## Files that need to be REMOVED

- [ ] `lib/db/helpers/01-core-to-parts.ts` - Migration helper (entire file removal)

## Files that require modification

### Database Schema & Queries

- [ ] `lib/db/schema.ts` - Remove `messageDeprecated` and `voteDeprecated` table definitions and types, rename `message` table from 'Message_v2' to 'Message', rename `vote` table from 'Vote_v2' to 'Vote', remove all deprecation comments with migration guide URLs
- [ ] `lib/db/queries.ts` - No changes needed (already uses current v2 systems)

### Database Migration Complete Reset

- [ ] **Remove ALL existing migration files**:

  - `lib/db/migrations/0000_keen_devos.sql`
  - `lib/db/migrations/0001_sparkling_blue_marvel.sql`
  - `lib/db/migrations/0002_wandering_riptide.sql`
  - `lib/db/migrations/0003_cloudy_glorian.sql`
  - `lib/db/migrations/0004_odd_slayback.sql`
  - `lib/db/migrations/0005_wooden_whistler.sql`
  - `lib/db/migrations/0006_marvelous_frog_thor.sql`

- [ ] **Remove ALL migration metadata files**:

  - `lib/db/migrations/meta/_journal.json`
  - `lib/db/migrations/meta/0000_snapshot.json`
  - `lib/db/migrations/meta/0001_snapshot.json`
  - `lib/db/migrations/meta/0002_snapshot.json`
  - `lib/db/migrations/meta/0003_snapshot.json`
  - `lib/db/migrations/meta/0004_snapshot.json`
  - `lib/db/migrations/meta/0005_snapshot.json`
  - `lib/db/migrations/meta/0006_snapshot.json`

- [ ] **Create single seed migration**: `lib/db/migrations/0000_initial_schema.sql`
- [ ] **Create single seed snapshot**: `lib/db/migrations/meta/0000_snapshot.json`
- [ ] **Create minimal journal**: `lib/db/migrations/meta/_journal.json`

### New Migration Files to Create

- [ ] `lib/db/migrations/0000_initial_schema.sql` - Complete seed schema (User, Chat, Message, Vote, Stream)
- [ ] `lib/db/migrations/meta/0000_snapshot.json` - Snapshot matching the seed schema
- [ ] `lib/db/migrations/meta/_journal.json` - Minimal journal with single entry

### Data Migration Script for Existing Databases

- [ ] **Create temporary migration script** for existing installations:

  ```sql
  -- Export data from current v2 tables
  CREATE TABLE temp_messages AS SELECT * FROM "Message_v2";
  CREATE TABLE temp_votes AS SELECT * FROM "Vote_v2";
  CREATE TABLE temp_chats AS SELECT * FROM "Chat";
  CREATE TABLE temp_users AS SELECT * FROM "User";
  CREATE TABLE temp_streams AS SELECT * FROM "Stream";

  -- Drop all existing tables and constraints
  -- Apply 0000_initial_schema.sql
  -- Import data back into new clean tables
  ```

- [ ] **Note**: This script would be run once per existing database before the clean schema

### Minimal Journal Structure

```json
{
  "version": "7",
  "dialect": "postgresql",
  "entries": [
    {
      "idx": 0,
      "version": "7",
      "when": <timestamp>,
      "tag": "0000_initial_schema",
      "breakpoints": true
    }
  ]
}
```

## Additional Missing Details Found

### Test Files Analysis

- [ ] `tests/e2e/chat.test.ts` - Contains vote functionality tests that should continue working
- [ ] `tests/pages/chat.ts` - Contains test utilities for voting that reference `/api/vote` endpoints
- [ ] Test files use current API endpoints (already compatible)

### API Endpoints Analysis

- [ ] `app/(chat)/api/vote/route.ts` - Uses current `vote` table (Vote_v2) - no changes needed
- [ ] All API endpoints already use the v2 systems

### Migration History Context

- [ ] PR #868 introduced the v2 migration system with `lib/db/helpers/01-core-to-parts.ts`
- [ ] PR #969 refined the migration script for better ordering and deduplication
- [ ] The migration helper is commented out and was designed as a one-time migration tool

### Current Database State (from 0006 snapshot)

- **Message table**: `id`, `chatId`, `role`, `content`, `createdAt` (deprecated, still exists)
- **Message_v2 table**: `id`, `chatId`, `role`, `parts`, `attachments`, `createdAt` (current)
- **Vote table**: `chatId`, `messageId`, `isUpvoted` (deprecated, references old Message, still exists)
- **Vote_v2 table**: `chatId`, `messageId`, `isUpvoted` (current, references Message_v2)

## Multi-Pronged Verification Approach

### 1. **Database Constraint Analysis**

- Verify exact constraint names from 0006 snapshot are used in migration
- **Current deprecated constraints**: `Vote_messageId_Message_id_fk`, `Vote_chatId_Chat_id_fk`, `Message_chatId_Chat_id_fk`
- **Current v2 constraints**: `Vote_v2_messageId_Message_v2_id_fk`, `Vote_v2_chatId_Chat_id_fk`, `Message_v2_chatId_Chat_id_fk`
- Ensure all constraints are properly renamed to match new table names

### 2. **Schema Export Analysis**

- Ensure `DBMessage` type (currently from Message_v2) maps to renamed Message table
- Ensure `Vote` type (currently from Vote_v2) maps to renamed Vote table
- Remove `MessageDeprecated` and `VoteDeprecated` type exports completely
- Remove all deprecation comments with migration guide URLs

### 3. **Application Usage Analysis**

- ✅ All application code already uses the v2 systems via schema exports
- ✅ No application code references deprecated table names directly
- ✅ API endpoints use schema exports, not raw table names
- No changes needed to application code

### 4. **Migration Chain Integrity**

- **COMPLETE RESET**: Remove all migration history (0000-0006)
- **Single Seed**: Create 0000_initial_schema.sql with final clean schema
- **Clean Start**: New databases will have clean schema from the beginning
- **Existing Databases**: Will need data migration before applying clean schema

### 5. **Data Migration Strategy**

- **New Installations**: Will use clean 0000_initial_schema.sql
- **Existing Databases**: Need to export data from Message_v2/Vote_v2 before schema reset
- **Production Warning**: This is a breaking change requiring careful data backup
- Final schema has Message/Vote tables (no v2 suffix) with parts/attachments structure

## Detailed Changes Required

### lib/db/schema.ts

```typescript
// REMOVE these completely:
// - messageDeprecated table definition
// - MessageDeprecated type export
// - voteDeprecated table definition
// - VoteDeprecated type export
// - All deprecation comments

// RENAME these:
// - message table: 'Message_v2' → 'Message'
// - vote table: 'Vote_v2' → 'Vote'
```

### New Seed Migration (0000_initial_schema.sql)

```sql
-- Create User table
CREATE TABLE IF NOT EXISTS "User" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"email" varchar(64) NOT NULL,
	"password" varchar(64)
);

-- Create Chat table
CREATE TABLE IF NOT EXISTS "Chat" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"createdAt" timestamp NOT NULL,
	"title" text NOT NULL,
	"userId" uuid NOT NULL,
	"visibility" varchar CHECK ("visibility" IN ('public', 'private')) DEFAULT 'private' NOT NULL
);

-- Create Message table (final version - no v2 suffix)
CREATE TABLE IF NOT EXISTS "Message" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"chatId" uuid NOT NULL,
	"role" varchar NOT NULL,
	"parts" json NOT NULL,
	"attachments" json NOT NULL,
	"createdAt" timestamp NOT NULL
);

-- Create Vote table (final version - no v2 suffix)
CREATE TABLE IF NOT EXISTS "Vote" (
	"chatId" uuid NOT NULL,
	"messageId" uuid NOT NULL,
	"isUpvoted" boolean NOT NULL,
	CONSTRAINT "Vote_chatId_messageId_pk" PRIMARY KEY("chatId","messageId")
);

-- Create Stream table
CREATE TABLE IF NOT EXISTS "Stream" (
	"id" uuid DEFAULT gen_random_uuid() NOT NULL,
	"chatId" uuid NOT NULL,
	"createdAt" timestamp NOT NULL,
	CONSTRAINT "Stream_id_pk" PRIMARY KEY("id")
);

-- Add foreign key constraints
DO $$ BEGIN
 ALTER TABLE "Chat" ADD CONSTRAINT "Chat_userId_User_id_fk" FOREIGN KEY ("userId") REFERENCES "public"."User"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "Message" ADD CONSTRAINT "Message_chatId_Chat_id_fk" FOREIGN KEY ("chatId") REFERENCES "public"."Chat"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "Vote" ADD CONSTRAINT "Vote_chatId_Chat_id_fk" FOREIGN KEY ("chatId") REFERENCES "public"."Chat"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "Vote" ADD CONSTRAINT "Vote_messageId_Message_id_fk" FOREIGN KEY ("messageId") REFERENCES "public"."Message"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE "Stream" ADD CONSTRAINT "Stream_chatId_Chat_id_fk" FOREIGN KEY ("chatId") REFERENCES "public"."Chat"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
```

## Post-Migration Verification

### Database Verification

- [ ] Run `npm run db:migrate` to apply new migration
- [ ] Verify schema matches expected final state
- [ ] Test application functionality with renamed tables

### Code Verification

- [ ] Confirm all queries work with renamed tables
- [ ] Verify foreign key relationships function correctly
- [ ] Run test suite to ensure no regressions

## Completion Criteria

**Database Changes**

- All deprecated table definitions removed from schema.ts
- Message and Vote tables use final structure (parts/attachments, no v2 suffix)
- All migration history reset to single 0000_initial_schema.sql
- Clean database schema for new installations

**Code Changes**

- `MessageDeprecated` and `VoteDeprecated` types removed from exports
- All deprecation comments and migration guide URLs removed
- `lib/db/helpers/01-core-to-parts.ts` deleted (already commented out)

**Verification**

- All tests pass (especially vote-related e2e tests)
- No references to deprecated systems remain in codebase
- Foreign key relationships work correctly with renamed tables
- API endpoints continue functioning (they use schema exports)
- Database migration chain integrity maintained
