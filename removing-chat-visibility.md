# Removing Chat Visibility Functionality from this repository

## Files that need to be removed

- [x] `hooks/use-chat-visibility.ts` - **ENTIRE FILE REMOVAL** (chat visibility hook)
- [x] `components/visibility-selector.tsx` - **ENTIRE FILE REMOVAL** (visibility selector component)

## Files that require modification

### Core Chat & UI Components

- [x] `components/chat.tsx` - Remove visibility state management:

  - Remove `import type { VisibilityType } from './visibility-selector';`
  - Remove `import { useChatVisibility } from '@/hooks/use-chat-visibility';`
  - Remove `initialVisibilityType` from component props interface
  - Remove `initialVisibilityType: VisibilityType;` from props type
  - Remove `const { visibilityType } = useChatVisibility({ chatId: id, initialVisibilityType });`
  - Remove `selectedVisibilityType: visibilityType,` from prepareSendMessagesRequest
  - Remove `selectedVisibilityType={initialVisibilityType}` from ChatHeader props
  - Remove `selectedVisibilityType={visibilityType}` from MultimodalInput props

- [x] `components/chat-header.tsx` - Remove visibility selector:

  - Remove `import { type VisibilityType, VisibilitySelector } from './visibility-selector';`
  - Remove `selectedVisibilityType` from component props interface
  - Remove `selectedVisibilityType: VisibilityType;` from props type
  - Remove entire `<VisibilitySelector>` component and its props
  - Remove visibility-related conditional rendering

- [x] `components/sidebar-history-item.tsx` - Remove visibility controls:

  - Remove `import { useChatVisibility } from '@/hooks/use-chat-visibility';`
  - Remove `import { CheckCircleFillIcon, GlobeIcon, LockIcon, MoreHorizontalIcon, ShareIcon, TrashIcon } from './icons';`
  - Remove `import { DropdownMenuSub, DropdownMenuSubContent, DropdownMenuSubTrigger, DropdownMenuPortal } from './ui/dropdown-menu';`
  - Remove `const { visibilityType, setVisibilityType } = useChatVisibility({ chatId: chat.id, initialVisibilityType: chat.visibility });`
  - Remove entire visibility submenu section (lines ~64-99)
  - Remove visibility-related dropdown menu items
  - Remove visibility state management and UI updates
  - Remove `DropdownMenuPortal` usage if not used elsewhere

- [x] `components/multimodal-input.tsx` - Remove visibility prop:

  - Remove `import type { VisibilityType } from './visibility-selector';`
  - Remove `selectedVisibilityType` from component props interface
  - Remove `selectedVisibilityType: VisibilityType;` from props type
  - Remove `selectedVisibilityType={selectedVisibilityType}` from sendMessage call
  - Remove visibility-related prop comparison in memo

- [x] `components/suggested-actions.tsx` - Remove visibility prop:

  - Remove `import type { VisibilityType } from './visibility-selector';`
  - Remove `selectedVisibilityType` from component props interface
  - Remove `selectedVisibilityType: VisibilityType;` from props type
  - Remove visibility-related prop comparison in memo

### Database & API Components

- [x] `lib/db/schema.ts` - Remove visibility field:

  - Remove `visibility: varchar('visibility', { enum: ['public', 'private'] }).notNull().default('private'),` from chat table
  - **CRITICAL**: _This will NOT require a new database migration, all projects will start on a clean slate_

- [x] `lib/db/queries.ts` - Remove visibility-related functions:

  - Remove `import type { VisibilityType } from '@/components/visibility-selector';`
  - Remove `visibility` parameter from `saveChat` function
  - Remove `visibility: VisibilityType;` from saveChat interface
  - Remove `visibility,` from saveChat values
  - Remove `updateChatVisiblityById` function entirely
  - Remove visibility-related error handling

- [x] `app/(chat)/actions.ts` - Remove visibility action:

  - Remove `import type { VisibilityType } from '@/components/visibility-selector';`
  - Remove `updateChatVisibility` function entirely

- [x] `app/(chat)/api/chat/route.ts` - Remove visibility handling:

  - Remove `import type { VisibilityType } from '@/components/visibility-selector';`
  - Remove `selectedVisibilityType` from request body destructuring
  - Remove `selectedVisibilityType: VisibilityType;` from request body type
  - Remove `visibility: selectedVisibilityType,` from saveChat call
  - Remove visibility-related logging

- [x] `app/(chat)/api/chat/schema.ts` - Remove visibility schema:

  - Remove `selectedVisibilityType: z.enum(['public', 'private']),` from postRequestBodySchema

- [x] `app/(chat)/api/chat/[id]/stream/route.ts` - Remove visibility checks:

  - Remove visibility check logic: `if (chat.visibility === 'private' && chat.userId !== session.user.id)`
  - Remove visibility-related authorization logic

### Page Components

- [x] `app/(chat)/page.tsx` - Remove visibility prop:

  - Remove `initialVisibilityType="private"` from Chat component props
  - Remove visibility-related prop passing

- [x] `app/(chat)/chat/[id]/page.tsx` - Remove visibility logic:

  - Remove visibility check logic: `if (chat.visibility === 'private')`
  - Remove visibility-related authorization checks
  - Remove `initialVisibilityType={chat.visibility}` from Chat component props
  - Remove visibility-related conditional rendering

### Icons & UI Elements

- [x] `components/icons.tsx` - Remove visibility-related icons:

  - Remove `export const GlobeIcon` function (if not used elsewhere)
  - Remove `export const LockIcon` function (if not used elsewhere)
  - Remove `export const CheckCircleFillIcon` function (if not used elsewhere)
  - Remove `export const ShareIcon` function (if not used elsewhere)
  - Remove `export const MoreHorizontalIcon` function (if not used elsewhere)

### Test Infrastructure

- [x] `tests/pages/chat.ts` - Remove visibility test utilities:

  - Remove `getSelectedVisibility()` method
  - Remove `chooseVisibilityFromSelector()` method
  - Remove visibility-related test helpers

- [x] `tests/routes/chat.test.ts` - Remove visibility from API tests:

  - Remove `selectedVisibilityType: 'private'` from all test request bodies
  - Remove `selectedVisibilityType: 'public'` from test request bodies
  - Remove the entire test case `'Babbage can resume a public chat generation that belongs to Ada'` (lines ~316-367)
  - Remove `test.fixme()` call in the public chat test
  - Remove visibility-related test assertions and expectations

### Database Migration

- [x] `lib/db/migrations/0000_initial_schema.sql` - Remove visibility column:

  - Remove `"visibility" varchar CHECK ("visibility" IN ('public', 'private')) DEFAULT 'private' NOT NULL` from Chat table
  - **CRITICAL**: _This will NOT require a new database migration, all projects will start on a clean slate_

- [x] `lib/db/migrations/meta/0000_snapshot.json` - Remove visibility from schema snapshot:

  - Remove the entire `"visibility"` object from the Chat table schema (lines ~35-42)
  - This ensures the migration snapshot is consistent with the schema changes

## Verification Steps

### 1. **Search Verification**

After making changes, run these searches to ensure complete removal:

```bash
# Search for remaining visibility references
grep -r "visibility" --include="*.ts" --include="*.tsx" .
grep -r "VisibilityType" --include="*.ts" --include="*.tsx" .
grep -r "useChatVisibility" --include="*.ts" --include="*.tsx" .
grep -r "VisibilitySelector" --include="*.ts" --include="*.tsx" .
grep -r "GlobeIcon" --include="*.ts" --include="*.tsx" .
grep -r "LockIcon" --include="*.ts" --include="*.tsx" .
grep -r "CheckCircleFillIcon" --include="*.ts" --include="*.tsx" .
grep -r "ShareIcon" --include="*.ts" --include="*.tsx" .
grep -r "MoreHorizontalIcon" --include="*.ts" --include="*.tsx" .
grep -r "DropdownMenuSub" --include="*.ts" --include="*.tsx" .
grep -r "DropdownMenuPortal" --include="*.ts" --include="*.tsx" .
grep -r "public.*private\|private.*public" --include="*.ts" --include="*.tsx" .
grep -r "selectedVisibilityType" --include="*.ts" --include="*.tsx" .
grep -r "initialVisibilityType" --include="*.ts" --include="*.tsx" .
grep -r "chat\.visibility" --include="*.ts" --include="*.tsx" .
```

### 2. **Type Safety Verification**

- [x] Run `npm run lint` to ensure no TypeScript errors
- [x] Run `npm run build` to verify build success
- [x] Check that all visibility type references are removed

### 3. **Functional Verification**

- [x] Verify chat header no longer shows visibility selector
- [x] Verify sidebar history items no longer show visibility controls
- [x] Test chat creation works normally without visibility options
- [x] Verify no visibility-related UI elements remain
- [x] Test that existing chats still load properly (visibility data should be safely ignored)

### 4. **Database Verification**

- [x] Check that Chat table schema no longer includes visibility column
- [x] Test that existing chats still load properly (visibility data should be safely ignored)

### 5. **Test Suite Verification**

- [x] Run `pnpm test` to ensure all tests pass
- [x] Verify no visibility related test failures
- [x] Check that all modified test utilities work correctly

## Clean Up Dependencies

After removing all chat visibility functionality:

1. **Remove unused dependencies:**

   - No specific dependencies to remove (visibility was built-in)

2. **Remove environment secrets:**

   - No specific environment variables to remove

3. **Update documentation:**
   - Update README with simplified setup instructions
   - Remove any visibility related documentation
   - Update API documentation if applicable

## Message Format Changes

After removal, chats will only support:

- Private chats only (no public sharing)
- Simplified chat structure (no visibility complexity)
- All existing chat functionality (messages, history, etc.)

The simplified chat structure removes all visibility complexity while maintaining the core chat functionality.

## Comprehensive Review Checklist

Use this checklist to ensure complete removal:

### File System

- [x] `/hooks/use-chat-visibility.ts` file completely removed
- [x] `/components/visibility-selector.tsx` file removed
- [x] No remaining visibility-related temporary files

### Code Patterns

- [x] All `VisibilityType` imports removed
- [x] All `useChatVisibility` references removed
- [x] All `VisibilitySelector` references removed
- [x] All `GlobeIcon`, `LockIcon`, `CheckCircleFillIcon` references removed
- [x] All `ShareIcon`, `MoreHorizontalIcon` references removed
- [x] All `DropdownMenuSub`, `DropdownMenuPortal` visibility usage removed
- [x] All `selectedVisibilityType` prop passing removed
- [x] All `initialVisibilityType` prop passing removed
- [x] All `chat.visibility` property access removed
- [x] All visibility-related authorization logic removed

### Database & Types

- [x] `visibility` column removed from Chat table
- [x] `VisibilityType` interface removed from types
- [x] `selectedVisibilityType` removed from API schemas
- [x] Visibility-related database functions removed
- [x] Migration snapshot updated to remove visibility column

### UI & Components

- [x] Visibility selector elements completely removed from DOM
- [x] Visibility controls removed from sidebar history items
- [x] Visibility-related dropdown menus removed
- [x] No visibility-related UI elements remain

### Tests & Development

- [x] Visibility E2E tests removed
- [x] Visibility test utilities removed
- [x] Visibility-related test assertions removed
- [x] Visibility test data/fixtures removed
- [x] API route tests updated to remove visibility parameters
- [x] Public chat test case removed (test.fixme() test)

## Impact Assessment

**Removed Capabilities:**

- Users can no longer set chat visibility to public/private
- No visibility selector in chat header
- No visibility controls in sidebar history
- No public chat sharing functionality
- Simplified chat authorization (all chats are effectively private)
- No public chat access for other users
- No visibility-related test cases

**Retained Capabilities:**

- Text-based conversations
- All AI model interactions (including reasoning models)
- Tool calls (like weather)
- AI-generated content display (images, documents, etc.)
- Message history and persistence
- User authentication and authorization
- All other core chat features

**Simplified Architecture:**

- No visibility state management
- No visibility-related UI components
- No visibility database queries
- Cleaner chat types and schemas
- Reduced authorization complexity
- Lower UI complexity
- Simplified test suite (no visibility test cases)
- Cleaner database schema (no visibility column)

This removal significantly simplifies the codebase by eliminating visibility controls, state management, and authorization logic while maintaining all core chatbot functionality.
