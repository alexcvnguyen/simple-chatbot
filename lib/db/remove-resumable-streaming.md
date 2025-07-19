# Removing Resumable Streaming Functionality from this repository

## Overview

This document outlines the process to remove **resumable streaming** functionality while keeping basic streaming intact. The goal is to simplify the codebase by removing Redis dependencies and complex stream resumption logic.

**What we're removing:**

- Resumable stream context and Redis dependencies
- Stream resumption on connection drops
- Auto-resume functionality
- Stream state persistence

**What we're keeping:**

- Basic streaming responses (word-by-word AI responses)
- Real-time message updates
- All core chat functionality

## Files that need to be removed

- [ ] `app/(chat)/api/chat/[id]/stream/route.ts` - **ENTIRE FILE REMOVAL** (stream resume endpoint)
- [ ] `hooks/use-auto-resume.ts` - **ENTIRE FILE REMOVAL** (auto-resume hook)

## Files that require modification

### Core API Routes

- [ ] `app/(chat)/api/chat/route.ts` - Remove resumable streaming functionality:

  - Remove `createResumableStreamContext`, `ResumableStreamContext` imports from 'resumable-stream'
  - Remove `after` import from 'next/server'
  - Remove `globalStreamContext` variable and `getStreamContext()` function
  - Remove `createStreamId` import from database queries
  - Remove `streamId` generation and `createStreamId()` call
  - Remove `streamContext` logic and `resumableStream` handling
  - **KEEP** `createUIMessageStream`, `JsonToSseTransformStream`, `smoothStream`, `stepCountIs`, `streamText` imports from 'ai' (these are for basic streaming)
  - Replace resumable stream response with simple streaming response:

    ```typescript
    // Replace this:
    if (streamContext) {
      return new Response(
        await streamContext.resumableStream(streamId, () =>
          stream.pipeThrough(new JsonToSseTransformStream())
        )
      );
    } else {
      return new Response(stream.pipeThrough(new JsonToSseTransformStream()));
    }

    // With this:
    return new Response(stream.pipeThrough(new JsonToSseTransformStream()));
    ```

  - Remove `maxDuration = 60` export (if not needed for other reasons)

### Database Schema & Queries

- [ ] `lib/db/schema.ts` - Remove stream table definition:

  - Remove `stream` table definition and `Stream` type
  - Remove stream-related imports and exports

- [ ] `lib/db/queries.ts` - Remove stream-related functions:

  - Remove `createStreamId` function
  - Remove `getStreamIdsByChatId` function
  - Remove `stream` import from schema
  - Remove stream deletion from `deleteChatById` function

- [ ] `lib/db/migrations/0000_initial_schema.sql` - Remove stream table:

  - Remove `CREATE TABLE IF NOT EXISTS "Stream"` statement
  - Remove stream foreign key constraint

- [ ] **Create new migration file** `lib/db/migrations/0001_remove_stream_table.sql`:

  ```sql
  -- Drop foreign key constraint first
  ALTER TABLE "Stream" DROP CONSTRAINT IF EXISTS "Stream_chatId_Chat_id_fk";

  -- Drop the stream table
  DROP TABLE IF EXISTS "Stream";
  ```

### Frontend Components

- [ ] `components/chat.tsx` - Remove resumable streaming functionality:

  - Remove `resumeStream` from `useChat` destructuring
  - Remove `useAutoResume` import and usage
  - Remove `autoResume` prop from component interface
  - Remove `autoResume` prop from component implementation
  - **KEEP** `experimental_throttle: 100` - it's a general performance optimization for UI updates during streaming
  - **KEEP** `DefaultChatTransport` - it's still needed for basic streaming
  - **KEEP** `fetchWithErrorHandlers` - it's a general error handling utility

- [ ] `components/messages.tsx` - Remove resumable streaming status handling:

  - Remove `status === 'streaming'` logic that's specific to resumable streams
  - **KEEP** basic streaming status handling for word-by-word responses
  - Remove resumable stream-specific conditional rendering
  - Simplify message display to handle only completed messages and basic streaming

- [ ] `components/multimodal-input.tsx` - Remove resumable streaming status:

  - Remove resumable stream-specific `status` prop usage
  - **KEEP** basic streaming status for real-time feedback
  - Remove resumable stream-specific UI feedback

- [ ] `components/image-editor.tsx` - Remove resumable streaming status:

  - Remove resumable stream-specific `status === 'streaming'` conditional rendering
  - **KEEP** basic streaming loading states
  - Remove resumable stream-specific `status` prop from component interface

- [ ] `components/sheet-editor.tsx` - Remove resumable streaming status:

  - Remove resumable stream-specific status checks in `areEqual` function
  - Remove resumable stream-specific prop comparisons
  - Remove resumable stream-specific `status` prop from component interface

- [ ] `components/message.tsx` - Remove resumable streaming loading states:

  - Remove resumable stream-specific `isLoading` prop usage
  - **KEEP** basic streaming loading animations
  - Keep `ThinkingMessage` component for basic loading states

### Page Components

- [ ] `app/(chat)/page.tsx` - Remove autoResume prop:

  - Remove `autoResume={false}` from Chat component props

- [ ] `app/(chat)/chat/[id]/page.tsx` - Remove autoResume prop:

  - Remove `autoResume={true}` from Chat component props

### Hooks

- [ ] `hooks/use-messages.tsx` - Remove resumable streaming status handling:

  - Remove resumable stream-specific `status === 'submitted'` logic
  - **KEEP** basic streaming status handling

### Database Migration

- [ ] **Create new migration** to:

  - Drop foreign key constraint: `Stream_chatId_Chat_id_fk`
  - Drop table: `Stream`
  - Update `_journal.json` appropriately

### Error Handling

- [ ] `lib/errors.ts` - Remove stream-related errors:

  - Remove `'stream'` from error types if stream-specific
  - Remove stream-related error messages

### Package Dependencies

- [ ] `package.json` - Remove resumable streaming dependencies:

  - Remove `"redis": "^5.0.0"` (if only used for resumable streaming)
  - Remove `"resumable-stream": "^2.0.0"`
  - Remove `"date-fns": "^4.1.0"` (if only used for stream timing)

- [ ] `pnpm-lock.yaml` - Will be automatically updated:

  - Running `pnpm install` after removing dependencies will clean up lock file references

### Environment & Configuration

- [ ] `.github/workflows/playwright.yml` - Remove Redis environment:

  - Remove `REDIS_URL: ${{ secrets.REDIS_URL }}` from environment variables

- [ ] `README.md` - Update deployment configuration:

  - Remove any references to Redis or resumable streaming setup in deployment instructions
  - Remove `REDIS_URL` from required environment variables

### Test Infrastructure

- [ ] `tests/routes/chat.test.ts` - Remove resumable streaming tests:

  - Remove `test('Ada can resume chat generation', ...)` entire test block
  - Remove `test('Ada can resume chat generation that has ended during request', ...)` test block
  - Remove `test('Ada cannot resume chat generation that has ended', ...)` test block
  - Remove `test('Babbage cannot resume a private chat generation that belongs to Ada', ...)` test block
  - Remove `test('Ada cannot resume stream of chat that does not exist', ...)` test block
  - Remove `normalizeStreamData` helper function
  - Remove resumable stream-related test utilities and assertions
  - Remove SSE (Server-Sent Events) response parsing for resumable streams
  - **KEEP** basic streaming tests for word-by-word responses

- [ ] `tests/prompts/utils.ts` - Remove resumable streaming test utilities:

  - Remove `simulateReadableStream` imports and usage for resumable streams
  - Remove resumable stream simulation logic

- [ ] `lib/ai/models.test.ts` - Remove resumable streaming mocks:

  - Remove resumable stream-specific `doStream` implementations from mock models
  - Remove resumable stream-specific `simulateReadableStream` usage

### Type Definitions

- [ ] `lib/types.ts` - Remove resumable streaming types:

  - Remove any resumable stream-specific type definitions
  - Remove resumable stream related types

### Constants

- [ ] `lib/constants.ts` - Remove resumable streaming constants:

  - Remove any resumable stream-related constants

### Utils

- [ ] `lib/utils.ts` - Remove resumable streaming utilities:

  - **KEEP** `fetchWithErrorHandlers` function - it's a general error handling utility
  - **KEEP** basic `fetcher` function for simple requests
  - Remove any resumable stream-specific utility functions

## Verification Steps

### 1. **Search Verification**

After making changes, run these searches to ensure complete removal:

```bash
# Search for remaining resumable streaming references
grep -r "resumable" --include="*.ts" --include="*.tsx" .
grep -r "createResumableStreamContext" --include="*.ts" --include="*.tsx" .
grep -r "ResumableStreamContext" --include="*.ts" --include="*.tsx" .
grep -r "resumeStream" --include="*.ts" --include="*.tsx" .
grep -r "autoResume" --include="*.ts" --include="*.tsx" .
grep -r "useAutoResume" --include="*.ts" --include="*.tsx" .
grep -r "createStreamId" --include="*.ts" --include="*.tsx" .
grep -r "getStreamIdsByChatId" --include="*.ts" --include="*.tsx" .
grep -r "streamContext" --include="*.ts" --include="*.tsx" .
grep -r "differenceInSeconds" --include="*.ts" --include="*.tsx" .
grep -r "REDIS_URL" --include="*.ts" --include="*.tsx" .
# These should still exist (basic streaming):
grep -r "createUIMessageStream" --include="*.ts" --include="*.tsx" .
grep -r "JsonToSseTransformStream" --include="*.ts" --include="*.tsx" .
grep -r "streamText" --include="*.ts" --include="*.tsx" .
grep -r "smoothStream" --include="*.ts" --include="*.tsx" .
grep -r "stepCountIs" --include="*.ts" --include="*.tsx" .
grep -r "DefaultChatTransport" --include="*.ts" --include="*.tsx" .
grep -r "experimental_throttle" --include="*.ts" --include="*.tsx" .
grep -r "status.*streaming" --include="*.ts" --include="*.tsx" .

# These should still exist (basic streaming):
grep -r "createUIMessageStream" --include="*.ts" --include="*.tsx" .
grep -r "JsonToSseTransformStream" --include="*.ts" --include="*.tsx" .
grep -r "streamText" --include="*.ts" --include="*.tsx" .
grep -r "smoothStream" --include="*.ts" --include="*.tsx" .
grep -r "stepCountIs" --include="*.ts" --include="*.tsx" .
grep -r "DefaultChatTransport" --include="*.ts" --include="*.tsx" .
grep -r "status.*streaming" --include="*.ts" --include="*.tsx" .
```

### 2. **Type Safety Verification**

- [ ] Run `npm run lint` to ensure no TypeScript errors
- [ ] Run `npm run build` to verify build success
- [ ] Check that all resumable streaming type references are removed

### 3. **Functional Verification**

- [ ] Verify chat input works normally with basic streaming
- [ ] Verify messages are sent and received with word-by-word streaming
- [ ] Test message sending works normally with text-only content
- [ ] Verify no resumable streaming-related UI elements remain
- [ ] Test that AI responses appear word-by-word (basic streaming still works)
- [ ] Verify `ThinkingMessage` still shows during AI processing
- [ ] Test that message editing and regeneration still work
- [ ] Verify no auto-resume functionality on page refresh

### 4. **Database Verification**

- [ ] Check that Stream table is removed from schema
- [ ] Test that existing chats still load properly (stream data should be safely ignored)
- [ ] Verify database migrations work correctly
- [ ] Test that new chats can be created without resumable streaming

### 5. **Test Suite Verification**

- [ ] Run `pnpm test` to ensure all tests pass
- [ ] Verify no resumable streaming related test failures
- [ ] Check that all modified test utilities work correctly
- [ ] Verify that basic chat functionality tests still pass

## Clean Up Dependencies

After removing all resumable streaming functionality:

1. **Remove unused dependencies:**

   ```bash
   npm uninstall redis resumable-stream date-fns
   ```

2. **Remove environment secrets:**

   - Remove `REDIS_URL` from Vercel project settings
   - Remove from local `.env.local` file
   - Remove from any CI/CD configurations

3. **Update documentation:**
   - Update README with simplified setup instructions
   - Remove any resumable streaming related documentation
   - Update API documentation if applicable

## Message Format Changes

After removal, the chat will work with:

- Basic streaming (word-by-word AI responses) instead of resumable streaming
- No stream resumption on connection drops
- No auto-resume on page refresh
- No Redis-based stream state management
- No resumable stream context
- Simple SSE (Server-Sent Events) handling for basic streaming
- Standard JSON request/response pattern for non-streaming operations

The simplified chat structure removes all resumable streaming complexity while maintaining the core streaming functionality.

## Comprehensive Review Checklist

Use this checklist to ensure complete removal:

### File System

- [ ] `/app/(chat)/api/chat/[id]/stream/` directory completely removed
- [ ] `/hooks/use-auto-resume.ts` file removed
- [ ] No remaining resumable stream-related temporary files

### Code Patterns

- [ ] All `createResumableStreamContext` references removed
- [ ] All `ResumableStreamContext` references removed
- [ ] All `resumeStream` references removed
- [ ] All `autoResume` prop usage removed
- [ ] All `useAutoResume` hook usage removed
- [ ] All `createStreamId` references removed
- [ ] All `getStreamIdsByChatId` references removed
- [ ] All `streamContext` references removed
- [ ] All `differenceInSeconds` references removed
- [ ] All `REDIS_URL` references removed
- [ ] All resumable stream-specific `experimental_throttle` references removed (keep general throttling)
- [ ] All resumable stream-specific `status === 'streaming'` checks removed

### Database & Types

- [ ] `Stream` table removed from database schema
- [ ] Stream-related functions removed from queries
- [ ] Stream relations removed from migrations
- [ ] Stream types removed from type definitions

### UI & Components

- [ ] Resumable streaming status indicators completely removed from DOM
- [ ] Auto-resume functionality removed
- [ ] Resumable streaming loading states removed
- [ ] Resumable stream resume buttons removed (if any)
- [ ] `ThinkingMessage` still works for basic loading states
- [ ] Message editing and regeneration still functional
- [ ] Basic word-by-word streaming still works

### Tests & Development

- [ ] Resumable streaming E2E tests removed
- [ ] Resumable stream resume test utilities removed
- [ ] Resumable streaming-related test assertions removed
- [ ] Resumable stream test data/fixtures removed
- [ ] Environment variables cleaned up
- [ ] Basic chat functionality tests still pass

## Impact Assessment

**Removed Capabilities:**

- Stream resumption on connection drops
- Page refresh recovery for ongoing responses
- Auto-resume functionality
- Redis-based stream state management
- Resumable stream context
- Complex stream state persistence

**Retained Capabilities:**

- Real-time word-by-word AI responses (basic streaming)
- Text-based conversations
- All AI model interactions (including reasoning models)
- Tool calls (like weather)
- AI-generated content display (images, documents, etc.)
- Message history and persistence
- User authentication and authorization
- Message editing and regeneration
- All other core chat features
- Basic loading states (`ThinkingMessage`)

**Simplified Architecture:**

- No Redis dependencies
- No resumable stream complexity
- No complex stream state management
- Cleaner message types and schemas
- Reduced infrastructure complexity
- Simpler request/response pattern
- No resumable stream transport layer
- No stream state persistence

This removal significantly simplifies the codebase by eliminating resumable streaming, Redis dependencies, and complex stream state management while maintaining all core chatbot functionality including basic streaming.
