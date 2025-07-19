# Removing 'Artifacts' from this repository

## Folders that need to be removed

- [ ] `artifacts/`
- [ ] `lib/artifacts/`

## Files that need to be removed

- [ ] `components/artifact.tsx`
- [ ] `components/artifact-actions.tsx`
- [ ] `components/artifact-close-button.tsx`
- [ ] `components/artifact-messages.tsx`
- [ ] `components/create-artifact.tsx`
- [ ] `hooks/use-artifact.ts`
- [ ] `tests/e2e/artifacts.test.ts`
- [ ] `tests/pages/artifact.ts`
- [ ] `lib/ai/tools/create-document.ts`
- [ ] `lib/ai/tools/update-document.ts`
- [ ] `app/(chat)/api/document/route.ts`
- [ ] `components/document.tsx`
- [ ] `components/document-preview.tsx`
- [ ] `components/document-skeleton.tsx`
- [ ] `components/version-footer.tsx`
- [ ] `components/text-editor.tsx`
- [ ] `components/suggestion.tsx`
- [ ] `lib/editor/functions.tsx`
- [ ] `lib/editor/diff.js`
- [ ] `lib/editor/config.ts`
- [ ] `tests/routes/document.test.ts`

## Files that require some modification

### Core Chat & UI

- [ ] `app/(chat)/layout.tsx` - Remove `DataStreamProvider` wrapper if only used for artifacts
- [ ] `components/chat.tsx` - Remove artifact imports, visibility logic, and data stream artifact handling
- [ ] `components/chat-header.tsx`
- [ ] `components/messages.tsx` - Remove `isArtifactVisible` prop and logic
- [ ] `components/console.tsx` - Remove `useArtifactSelector` import and usage
- [ ] `hooks/use-chat-visibility.ts`
- [ ] `components/data-stream-handler.tsx` - Remove ALL artifact streaming logic and data type handling
- [ ] `components/suggestion.tsx` - Remove `ArtifactKind` import and usage
- [ ] `app/(chat)/page.tsx` - Remove `DataStreamHandler` import
- [ ] `app/(chat)/chat/[id]/page.tsx` - Remove `DataStreamHandler` import

### AI & Prompts

- [ ] `lib/ai/prompts.ts` - Remove entire `artifactsPrompt`, `updateDocumentPrompt`, and all `ArtifactKind` references
- [ ] `lib/ai/providers.ts` - Remove `artifact-model` from language models
- [ ] `lib/ai/models.test.ts` - Remove `artifactModel` export and mock
- [ ] `lib/ai/tools/request-suggestions.ts` - ENTIRE FILE REMOVAL (document-dependent)
- [ ] `tests/prompts/basic.ts` - Remove `createDocument` tool references
- [ ] `tests/prompts/utils.ts` - Remove ALL `createDocument` tool calls and document creation logic

### Database

- [ ] `lib/db/schema.ts` - Remove `document` and `suggestion` table definitions and types
- [ ] `lib/db/queries.ts` - Remove ALL document-related functions (`saveDocument`, `getDocumentById`, `deleteSuggestionsByDocumentIdAfterTimestamp`, `saveSuggestions`, `getSuggestionsByDocumentId`) and `ArtifactKind` import
- [ ] `lib/db/migrations/0001_sparkling_blue_marvel.sql` - Document/Suggestion table creation (NEED ROLLBACK MIGRATION)
- [ ] `lib/db/migrations/0004_odd_slayback.sql` - Document `text` column addition (NEED ROLLBACK MIGRATION)
- [ ] `lib/db/migrations/meta/0001_snapshot.json` - Document/Suggestion table definitions
- [ ] `lib/db/migrations/meta/0002_snapshot.json` - Document/Suggestion table definitions
- [ ] `lib/db/migrations/meta/0003_snapshot.json` - Document/Suggestion table definitions
- [ ] `lib/db/migrations/meta/0004_snapshot.json` - Document/Suggestion table definitions
- [ ] `lib/db/migrations/meta/0005_snapshot.json` - Document/Suggestion table definitions
- [ ] `lib/db/migrations/meta/0006_snapshot.json` - Document/Suggestion table definitions

### Editor & Suggestions System

- [ ] `lib/editor/suggestions.tsx` - Remove ALL artifact/document integration
- [ ] All `lib/editor/` files may need complete removal if only used for artifacts

### Types & Actions

- [ ] `lib/types.ts` - Remove `createDocument`, `updateDocument`, `requestSuggestions` tool types, `CustomUIDataTypes` (contains ALL artifact streaming types), and `ArtifactKind` imports
- [ ] `app/(chat)/actions.ts`

### API Routes

- [ ] `app/(chat)/api/chat/[id]/stream/route.ts` - May have artifact-specific streaming logic
- [ ] `app/(chat)/api/chat/route.ts` - Remove `createDocument`, `updateDocument`, `requestSuggestions` tools from experimental_activeTools and tools object
- [ ] `app/(chat)/api/suggestions/route.ts` - ENTIRE FILE REMOVAL (document-dependent)

### Message Handling & Streaming

- [ ] `components/message.tsx` - Remove `tool-createDocument` and `tool-updateDocument` handling, and data stream usage if artifact-specific
- [ ] `components/toolbar.tsx` - Remove ALL artifact definitions and toolbar logic
- [ ] `components/data-stream-provider.tsx` - May need complete removal if only used for artifacts, or modification to remove artifact-specific data types

### History & Sidebar

- [ ] `components/sidebar-history.tsx`

### Miscellaneous Components

- [ ] `components/multimodal-input.tsx` - Remove any artifact-related test IDs
- [ ] `hooks/use-auto-resume.ts` - May use data streaming for artifacts specifically

### Error Handling

- [ ] `lib/errors.ts` - Remove `suggestions` from error types if document-specific

### New Database Migration

- [ ] **Create new migration** to:
  - Drop foreign key constraints: `Suggestion_documentId_documentCreatedAt_Document_id_createdAt_fk`, `Suggestion_userId_User_id_fk`, `Document_userId_User_id_fk`
  - Drop tables: `Suggestion` and `Document`
  - Update `_journal.json` appropriately

### Stream Data Types Cleanup

- [ ] Remove ALL streaming data types from codebase:
  - `data-textDelta`, `data-imageDelta`, `data-sheetDelta`, `data-codeDelta`
  - `data-suggestion`, `data-kind`, `data-id`, `data-title`, `data-clear`, `data-finish`

### Test Infrastructure

- [ ] `tests/routes/document.test.ts` - ENTIRE FILE REMOVAL
- [ ] All test utilities that create/mock documents
- [ ] Update any integration tests that may create artifacts

### Configuration Files

- [ ] Check `next.config.ts`, `tailwind.config.ts` for any artifact-specific configurations
- [ ] Check `drizzle.config.ts` for document table references

## Multi-Pronged Verification Approach

### 1. **Dependency Analysis**

### 2. **Data Flow Analysis**

### 3. **API Endpoint Analysis**

### 4. **Database Relationship Analysis**

### 5. **Type System Analysis**

### 6. **Component Tree Analysis**

### 7. **Stream/Event Analysis**

### 8. **Test Coverage Analysis**
