# Removing 'Artifacts' from this repository

## Folders that need to be removed

- [x] `artifacts/`
- [x] `lib/artifacts/`

## Files that need to be removed

- [x] `components/artifact.tsx`
- [x] `components/artifact-actions.tsx`
- [x] `components/artifact-close-button.tsx`
- [x] `components/artifact-messages.tsx`
- [x] `components/create-artifact.tsx`
- [x] `hooks/use-artifact.ts`
- [x] `tests/e2e/artifacts.test.ts`
- [x] `tests/pages/artifact.ts`
- [x] `lib/ai/tools/create-document.ts`
- [x] `lib/ai/tools/update-document.ts`
- [x] `app/(chat)/api/document/route.ts`
- [x] `components/document.tsx`
- [x] `components/document-preview.tsx`
- [x] `components/document-skeleton.tsx`
- [x] `components/version-footer.tsx`
- [x] `components/text-editor.tsx`
- [x] `components/suggestion.tsx`
- [x] `lib/editor/functions.tsx`
- [x] `lib/editor/diff.js`
- [x] `lib/editor/config.ts`
- [x] `tests/routes/document.test.ts`
- [x] `lib/ai/tools/request-suggestions.ts` - ENTIRE FILE REMOVAL (document-dependent)
- [x] `app/(chat)/api/suggestions/route.ts` - ENTIRE FILE REMOVAL (document-dependent)
- [x] `lib/editor/` - ENTIRE DIRECTORY REMOVAL (artifact-specific)
- [x] `components/data-stream-handler.tsx` - ENTIRE FILE REMOVAL (artifact-specific)
- [x] `components/data-stream-provider.tsx` - ENTIRE FILE REMOVAL (artifact-specific)
- [x] `components/console.tsx` - ENTIRE FILE REMOVAL (artifact-specific)
- [x] `components/toolbar.tsx` - ENTIRE FILE REMOVAL (artifact-specific)
- [x] `components/diffview.tsx` - ENTIRE FILE REMOVAL (artifact-specific)
- [x] `components/code-editor.tsx` - ENTIRE FILE REMOVAL (artifact-specific)

## Files that require some modification

### Core Chat & UI

- [x] `app/(chat)/layout.tsx` - Remove `DataStreamProvider` wrapper if only used for artifacts
- [x] `components/chat.tsx` - Remove artifact imports, visibility logic, and data stream artifact handling
- [x] `components/chat-header.tsx`
- [x] `components/messages.tsx` - Remove `isArtifactVisible` prop and logic
- [x] `components/console.tsx` - Remove `useArtifactSelector` import and usage
- [x] `hooks/use-chat-visibility.ts`
- [x] `components/data-stream-handler.tsx` - Remove ALL artifact streaming logic and data type handling
- [x] `components/suggestion.tsx` - Remove `ArtifactKind` import and usage
- [x] `app/(chat)/page.tsx` - Remove `DataStreamHandler` import
- [x] `app/(chat)/chat/[id]/page.tsx` - Remove `DataStreamHandler` import
- [x] `lib/utils.ts` - Remove `Document` import and `getDocumentTimestampByIndex` function

### AI & Prompts

- [x] `lib/ai/prompts.ts` - Remove entire `artifactsPrompt`, `updateDocumentPrompt`, and all `ArtifactKind` references
- [x] `lib/ai/providers.ts` - Remove `artifact-model` from language models
- [x] `lib/ai/models.test.ts` - Remove `artifactModel` export and mock
- [x] `lib/ai/tools/request-suggestions.ts` - ENTIRE FILE REMOVAL (document-dependent)
- [x] `tests/prompts/basic.ts` - Remove `createDocument` tool references
- [x] `tests/prompts/utils.ts` - Remove ALL `createDocument` tool calls and document creation logic

### Database

- [x] `lib/db/schema.ts` - Remove `document` and `suggestion` table definitions and types
- [x] `lib/db/queries.ts` - Remove ALL document-related functions (`saveDocument`, `getDocumentById`, `deleteSuggestionsByDocumentIdAfterTimestamp`, `saveSuggestions`, `getSuggestionsByDocumentId`) and `ArtifactKind` import

### Editor & Suggestions System

- [x] `lib/editor/suggestions.tsx` - Remove ALL artifact/document integration
- [x] All `lib/editor/` files may need complete removal if only used for artifacts

### Types & Actions

- [x] `lib/types.ts` - Remove `createDocument`, `updateDocument`, `requestSuggestions` tool types, `CustomUIDataTypes` (contains ALL artifact streaming types), and `ArtifactKind` imports
- [x] `app/(chat)/actions.ts`

### API Routes

- [x] `app/(chat)/api/chat/[id]/stream/route.ts` - May have artifact-specific streaming logic
- [x] `app/(chat)/api/chat/route.ts` - Remove `createDocument`, `updateDocument`, `requestSuggestions` tools from experimental_activeTools and tools object
- [x] `app/(chat)/api/suggestions/route.ts` - ENTIRE FILE REMOVAL (document-dependent)

### Message Handling & Streaming

- [x] `components/message.tsx` - Remove `tool-createDocument` and `tool-updateDocument` handling, and data stream usage if artifact-specific
- [x] `components/toolbar.tsx` - Remove ALL artifact definitions and toolbar logic
- [x] `components/data-stream-provider.tsx` - May need complete removal if only used for artifacts, or modification to remove artifact-specific data types

### History & Sidebar

- [x] `components/sidebar-history.tsx`

### Miscellaneous Components

- [x] `components/multimodal-input.tsx` - Remove any artifact-related test IDs
- [x] `hooks/use-auto-resume.ts` - May use data streaming for artifacts specifically

### Error Handling

- [x] `lib/errors.ts` - Remove `suggestions` from error types if document-specific

### New Database Migration

- [x] **Create new migration** to:
  - Drop foreign key constraints: `Suggestion_documentId_documentCreatedAt_Document_id_createdAt_fk`, `Suggestion_userId_User_id_fk`, `Document_userId_User_id_fk`
  - Drop tables: `Suggestion` and `Document`
  - Update `_journal.json` appropriately

### Stream Data Types Cleanup

- [x] Remove ALL streaming data types from codebase:
  - `data-textDelta`, `data-imageDelta`, `data-sheetDelta`, `data-codeDelta`
  - `data-suggestion`, `data-kind`, `data-id`, `data-title`, `data-clear`, `data-finish`

### Test Infrastructure

- [x] `tests/routes/document.test.ts` - ENTIRE FILE REMOVAL
- [x] All test utilities that create/mock documents
- [x] Update any integration tests that may create artifacts

### Configuration Files

- [x] Check `next.config.ts`, `tailwind.config.ts` for any artifact-specific configurations
- [x] Check `drizzle.config.ts` for document table references

## Multi-Pronged Verification Approach

### 1. **Dependency Analysis**

### 2. **Data Flow Analysis**

### 3. **API Endpoint Analysis**

### 4. **Database Relationship Analysis**

### 5. **Type System Analysis**

### 6. **Component Tree Analysis**

### 7. **Stream/Event Analysis**

### 8. **Test Coverage Analysis**
