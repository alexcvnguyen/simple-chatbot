# Removing Streaming Functionality from this repository

## Files that need to be removed

- [ ] `app/(chat)/api/chat/[id]/stream/route.ts` - **ENTIRE FILE REMOVAL** (stream resume endpoint)
- [ ] `hooks/use-auto-resume.ts` - **ENTIRE FILE REMOVAL** (auto-resume hook)

## Files that require modification

### Core API Routes

- [ ] `app/(chat)/api/chat/route.ts` - Remove ALL streaming functionality:

  - Remove `createUIMessageStream`, `JsonToSseTransformStream`, `smoothStream`, `stepCountIs`, `streamText` imports from 'ai'
  - Remove `createResumableStreamContext`, `ResumableStreamContext` imports from 'resumable-stream'
  - Remove `after` import from 'next/server'
  - Remove `globalStreamContext` variable and `getStreamContext()` function
  - Remove `createStreamId` import from database queries
  - Remove `streamId` generation and `createStreamId()` call
  - Remove entire `createUIMessageStream` block and replace with simple AI response
  - Remove `streamContext` logic and `resumableStream` handling
  - Remove `JsonToSseTransformStream` usage
  - Replace streaming response with simple JSON response containing the AI message
  - Remove `maxDuration = 60` export

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

- [ ] `lib/db/migrations/schema.ts` - Remove stream table definition:

  - Remove `stream` table definition and relations

- [ ] `lib/db/migrations/relations.ts` - Remove stream relations:

  - Remove `streams: many(stream)` from chat relations
  - Remove entire `streamRelations` definition

### Frontend Components

- [ ] `components/chat.tsx` - Remove streaming functionality:

  - Remove `resumeStream` from `useChat` destructuring
  - Remove `useAutoResume` import and usage
  - Remove `autoResume` prop from component interface
  - Remove `autoResume` prop from component implementation
  - Remove `experimental_throttle: 100` from useChat options
  - Replace streaming transport with simple fetch-based transport
  - Remove `DefaultChatTransport` import and usage
  - Replace with simple fetch-based message sending

- [ ] `components/messages.tsx` - Remove streaming status handling:

  - Remove `status === 'streaming'` logic for loading states
  - Remove streaming-related conditional rendering
  - Simplify message display to handle only completed messages
  - Remove `isLoading` prop usage for streaming states

- [ ] `components/multimodal-input.tsx` - Remove streaming status:

  - Remove `status` prop usage for streaming states
  - Remove streaming-related UI feedback
  - Remove `status === 'submitted'` checks that are streaming-related

- [ ] `components/image-editor.tsx` - Remove streaming status:

  - Remove `status === 'streaming'` conditional rendering
  - Remove streaming loading states
  - Remove `status` prop from component interface

- [ ] `components/sheet-editor.tsx` - Remove streaming status:

  - Remove streaming status checks in `areEqual` function
  - Remove streaming-related prop comparisons
  - Remove `status` prop from component interface

- [ ] `components/message.tsx` - Remove streaming loading states:

  - Remove `isLoading` prop usage for streaming indicators
  - Remove streaming-related loading animations
  - Keep `ThinkingMessage` component but remove streaming-specific logic

### Page Components

- [ ] `app/(chat)/page.tsx` - Remove autoResume prop:

  - Remove `autoResume={false}` from Chat component props

- [ ] `app/(chat)/chat/[id]/page.tsx` - Remove autoResume prop:

  - Remove `autoResume={true}` from Chat component props

### Hooks

- [ ] `hooks/use-messages.tsx` - Remove streaming status handling:

  - Remove `status === 'submitted'` logic that's streaming-related
  - Simplify to only handle basic message display

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

- [ ] `package.json` - Remove streaming dependencies:

  - Remove `"redis": "^5.0.0"` (if only used for streaming)
  - Remove `"resumable-stream": "^2.0.0"`
  - Remove `"date-fns": "^4.1.0"` (if only used for stream timing)

- [ ] `pnpm-lock.yaml` - Will be automatically updated:

  - Running `pnpm install` after removing dependencies will clean up lock file references

### Environment & Configuration

- [ ] `.github/workflows/playwright.yml` - Remove Redis environment:

  - Remove `REDIS_URL: ${{ secrets.REDIS_URL }}` from environment variables

- [ ] `README.md` - Update deployment configuration:

  - Remove any references to Redis or streaming setup in deployment instructions
  - Remove `REDIS_URL` from required environment variables

### Test Infrastructure

- [ ] `tests/routes/chat.test.ts` - Remove streaming tests:

  - Remove `test('Ada can resume chat generation', ...)` entire test block
  - Remove `test('Ada can resume chat generation that has ended during request', ...)` test block
  - Remove `test('Ada cannot resume chat generation that has ended', ...)` test block
  - Remove `test('Babbage cannot resume a private chat generation that belongs to Ada', ...)` test block
  - Remove `test('Ada cannot resume stream of chat that does not exist', ...)` test block
  - Remove `normalizeStreamData` helper function
  - Remove stream-related test utilities and assertions
  - Remove SSE (Server-Sent Events) response parsing
  - Replace streaming tests with simple request/response tests

- [ ] `tests/prompts/utils.ts` - Remove streaming test utilities:

  - Remove `simulateReadableStream` imports and usage
  - Remove stream simulation logic

- [ ] `lib/ai/models.test.ts` - Remove streaming mocks:

  - Remove `doStream` implementations from mock models
  - Remove `simulateReadableStream` usage

### Type Definitions

- [ ] `lib/types.ts` - Remove streaming types:

  - Remove any stream-specific type definitions
  - Remove resumable stream related types

### Constants

- [ ] `lib/constants.ts` - Remove streaming constants:

  - Remove any stream-related constants

### Utils

- [ ] `lib/utils.ts` - Remove streaming utilities:

  - Remove `fetchWithErrorHandlers` function (if only used for streaming)
  - Keep basic `fetcher` function for simple requests
  - Remove any stream-specific utility functions

## Verification Steps

### 1. **Search Verification**

After making changes, run these searches to ensure complete removal:

```bash
# Search for remaining streaming references
grep -r "stream" --include="*.ts" --include="*.tsx" .
grep -r "resumable" --include="*.ts" --include="*.tsx" .
grep -r "createUIMessageStream" --include="*.ts" --include="*.tsx" .
grep -r "JsonToSseTransformStream" --include="*.ts" --include="*.tsx" .
grep -r "streamText" --include="*.ts" --include="*.tsx" .
grep -r "smoothStream" --include="*.ts" --include="*.tsx" .
grep -r "stepCountIs" --include="*.ts" --include="*.tsx" .
grep -r "resumeStream" --include="*.ts" --include="*.tsx" .
grep -r "autoResume" --include="*.ts" --include="*.tsx" .
grep -r "useAutoResume" --include="*.ts" --include="*.tsx" .
grep -r "createStreamId" --include="*.ts" --include="*.tsx" .
grep -r "getStreamIdsByChatId" --include="*.ts" --include="*.tsx" .
grep -r "streamContext" --include="*.ts" --include="*.tsx" .
grep -r "ResumableStreamContext" --include="*.ts" --include="*.tsx" .
grep -r "createResumableStreamContext" --include="*.ts" --include="*.tsx" .
grep -r "differenceInSeconds" --include="*.ts" --include="*.tsx" .
grep -r "REDIS_URL" --include="*.ts" --include="*.tsx" .
grep -r "DefaultChatTransport" --include="*.ts" --include="*.tsx" .
grep -r "experimental_throttle" --include="*.ts" --include="*.tsx" .
grep -r "status.*streaming" --include="*.ts" --include="*.tsx" .
grep -r "isLoading.*streaming" --include="*.ts" --include="*.tsx" .
```

### 2. **Type Safety Verification**

- [ ] Run `npm run lint` to ensure no TypeScript errors
- [ ] Run `npm run build` to verify build success
- [ ] Check that all streaming type references are removed

### 3. **Functional Verification**

- [ ] Verify chat input works normally without streaming
- [ ] Verify messages are sent and received as complete responses
- [ ] Test message sending works normally with text-only content
- [ ] Verify no streaming-related UI elements remain
- [ ] Test that AI responses appear as complete messages, not word-by-word
- [ ] Verify `ThinkingMessage` still shows during AI processing
- [ ] Test that message editing and regeneration still work

### 4. **Database Verification**

- [ ] Check that Stream table is removed from schema
- [ ] Test that existing chats still load properly (stream data should be safely ignored)
- [ ] Verify database migrations work correctly
- [ ] Test that new chats can be created without streaming

### 5. **Test Suite Verification**

- [ ] Run `pnpm test` to ensure all tests pass
- [ ] Verify no streaming related test failures
- [ ] Check that all modified test utilities work correctly
- [ ] Verify that basic chat functionality tests still pass

## Clean Up Dependencies

After removing all streaming functionality:

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
   - Remove any streaming related documentation
   - Update API documentation if applicable

## Message Format Changes

After removal, the chat will work with:

- Simple request/response pattern instead of streaming
- Complete AI responses instead of word-by-word streaming
- No resumable stream functionality
- No auto-resume on page refresh
- No SSE (Server-Sent Events) handling
- Simple JSON request/response pattern

The simplified chat structure removes all streaming complexity while maintaining the core chat functionality.

## Comprehensive Review Checklist

Use this checklist to ensure complete removal:

### File System

- [ ] `/app/(chat)/api/chat/[id]/stream/` directory completely removed
- [ ] `/hooks/use-auto-resume.ts` file removed
- [ ] No remaining stream-related temporary files

### Code Patterns

- [ ] All `createUIMessageStream` references removed
- [ ] All `JsonToSseTransformStream` references removed
- [ ] All `streamText` references removed
- [ ] All `smoothStream` references removed
- [ ] All `stepCountIs` references removed
- [ ] All `resumeStream` references removed
- [ ] All `autoResume` prop usage removed
- [ ] All `useAutoResume` hook usage removed
- [ ] All `createStreamId` references removed
- [ ] All `getStreamIdsByChatId` references removed
- [ ] All `streamContext` references removed
- [ ] All `ResumableStreamContext` references removed
- [ ] All `createResumableStreamContext` references removed
- [ ] All `differenceInSeconds` references removed
- [ ] All `REDIS_URL` references removed
- [ ] All `DefaultChatTransport` references removed
- [ ] All `experimental_throttle` references removed
- [ ] All `status === 'streaming'` checks removed
- [ ] All `isLoading` streaming-related usage removed

### Database & Types

- [ ] `Stream` table removed from database schema
- [ ] Stream-related functions removed from queries
- [ ] Stream relations removed from migrations
- [ ] Stream types removed from type definitions

### UI & Components

- [ ] Streaming status indicators completely removed from DOM
- [ ] Auto-resume functionality removed
- [ ] Streaming loading states removed
- [ ] Word-by-word streaming display removed
- [ ] Stream resume buttons removed (if any)
- [ ] `ThinkingMessage` still works for basic loading states
- [ ] Message editing and regeneration still functional

### Tests & Development

- [ ] Streaming E2E tests removed
- [ ] Stream resume test utilities removed
- [ ] Streaming-related test assertions removed
- [ ] Stream test data/fixtures removed
- [ ] Environment variables cleaned up
- [ ] Basic chat functionality tests still pass

## Impact Assessment

**Removed Capabilities:**

- Real-time word-by-word AI responses
- Stream resumption on connection drops
- Page refresh recovery for ongoing responses
- Auto-resume functionality
- Redis-based stream state management
- Resumable stream context
- SSE (Server-Sent Events) handling
- Streaming throttling and optimization

**Retained Capabilities:**

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
- No SSE (Server-Sent Events) handling
- Cleaner message types and schemas
- Reduced infrastructure complexity
- Simpler request/response pattern
- No streaming transport layer
- No stream state management

This removal significantly simplifies the codebase by eliminating streaming, resumable streams, Redis dependencies, and real-time response handling while maintaining all core chatbot functionality.
