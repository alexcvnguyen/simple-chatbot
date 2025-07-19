# Removing File Upload Functionality from this repository

## Files that need to be removed

- [ ] `app/(chat)/api/files/upload/route.ts` - **ENTIRE FILE REMOVAL** (main upload endpoint)
- [ ] `app/(chat)/api/files/` - **ENTIRE DIRECTORY REMOVAL** (if no other files exist in this directory)
- [ ] `components/preview-attachment.tsx` - **ENTIRE FILE REMOVAL** (attachment preview component)
- [ ] `public/images/mouth of the seine, monet.jpg` - **REMOVE TEST IMAGE** (used for file upload testing)
- [ ] `public/images/demo-thumbnail.png` - **REVIEW AND POTENTIALLY REMOVE** (check if used for file upload demos)

## Files that require modification

### Core Chat & UI Components

- [ ] `components/multimodal-input.tsx` - Remove ALL file upload functionality:

  - Remove `fileInputRef`, `uploadQueue`, and `setUploadQueue` state
  - Remove `uploadFile` function and related async file handling
  - Remove `handleFileChange` callback
  - Remove file input element (`<input type="file">`)
  - Remove `AttachmentsButton` component and related logic
  - Remove attachments preview section and upload queue rendering
  - Remove attachment-related props and logic from `sendMessage`
  - Remove attachment handling in `submitForm` function
  - Remove `attachments` and `setAttachments` props from component interface
  - Remove `PreviewAttachment` import and usage
  - Remove upload queue checks in `SendButton` disabled state
  - Remove `PaperclipIcon` import

- [ ] `components/chat.tsx` - Remove attachment state management:

  - Remove `const [attachments, setAttachments] = useState<Array<Attachment>>([]);`
  - Remove `attachments={attachments}` and `setAttachments={setAttachments}` props passed to `MultimodalInput`
  - Remove `Attachment` import from types

- [ ] `components/message.tsx` - Remove attachment display:

  - Remove `attachmentsFromMessage` filtering logic
  - Remove attachment rendering section (lines ~78-93)
  - Remove `PreviewAttachment` import and component usage
  - Remove attachment-related data-testid attributes

### Type Definitions & Schemas

- [ ] `lib/types.ts` - Remove attachment interface:

  - Remove `export interface Attachment { name: string; url: string; contentType: string; }`

- [ ] `app/(chat)/api/chat/schema.ts` - Remove file part schema:

  - Remove `filePartSchema` definition
  - Remove file part from `partSchema` union (keep only `textPartSchema`)
  - Remove file-related media type enums (`'image/jpeg'`, `'image/png'`)

- [ ] `app/(chat)/api/chat/route.ts` - Remove file part handling:
  - Remove any file-specific message processing if present
  - Ensure only text parts are handled in message conversion

### Database Schema

- [ ] `lib/db/schema.ts` - Remove attachments field:
  - Remove `attachments: json('attachments').notNull(),` from message table
  - **CRITICAL**: _This will NOT require a new database migration, all projects will start on a clean slate_

### Icons & UI Elements

- [ ] `components/icons.tsx` - Remove file-related icons:

  - Remove `export const AttachmentIcon` function
  - Remove `export const PaperclipIcon` function
  - Remove `export const UploadIcon` function (if not used elsewhere)

- [ ] `components/ui/input.tsx` - Clean up file input CSS:

  - Remove `file:border-0 file:bg-transparent file:text-sm file:font-medium file:text-foreground` CSS classes
  - These are file input specific styling rules that won't be needed

- [ ] `components/chat-header.tsx` - Clean up Vercel deploy integration:
  - Remove `{"type":"blob"}` from the products array in the Vercel deploy URL
  - This removes blob storage integration from one-click deployment

### Test Infrastructure

- [ ] `tests/e2e/chat.test.ts` - Remove file upload tests:

  - Remove `test('Upload file and send image attachment with message', ...)` entire test block
  - Remove any attachment-related assertions in other tests

- [ ] `tests/pages/chat.ts` - Remove file upload test utilities:

  - Remove `async addImageAttachment()` method
  - Remove attachment-related helper methods
  - Remove `attachments` property from message interface in test utilities

- [ ] `tests/prompts/basic.ts` - Remove attachment test data:

  - Remove `USER_IMAGE_ATTACHMENT` test constant if present

- [ ] `tests/prompts/utils.ts` - Remove attachment test utilities:
  - Remove any `TEST_PROMPTS.USER_IMAGE_ATTACHMENT` references and related logic

### Package Dependencies

- [ ] `package.json` - Remove blob storage dependency:

  - Remove `"@vercel/blob": "^0.24.1",` from dependencies

- [ ] `pnpm-lock.yaml` - Will be automatically updated:
  - Running `pnpm install` after removing @vercel/blob will clean up lock file references

### Environment & Configuration

- [ ] `.github/workflows/playwright.yml` - Remove blob token:

  - Remove `BLOB_READ_WRITE_TOKEN: ${{ secrets.BLOB_READ_WRITE_TOKEN }}` from environment variables

- [ ] `README.md` - Update deployment configuration (if applicable):
  - Remove any references to blob storage or file upload setup in deployment instructions
  - Remove `BLOB_READ_WRITE_TOKEN` from required environment variables

### API Route Dependencies

- [ ] `middleware.ts` - Review for file upload route handling:
  - Ensure no special middleware logic exists for `/api/files/*` routes
  - **VERIFIED**: No specific file upload route handling found in current middleware

### Message Part Types & Processing

- [ ] `tests/prompts/utils.ts` - Remove file part comparison:

  - Remove `if (item1.type === 'file' && item2.type === 'file')` logic
  - Remove commented mimeType comparison: `// if (item1.mimeType !== item2.mimeType) return false;`

- [ ] `tests/prompts/basic.ts` - Remove file part test data:
  - Remove `type: 'file'` test message parts
  - Remove `mediaType: '...'` references

### Additional Code Patterns Found

- [ ] Look for any remaining references to:
  - `pathname` variable used for file names (in upload response handling)
  - `filename` extraction from FormData
  - `arrayBuffer()` calls for file processing
  - `file.size` and `file.type` property access
  - File validation logic (`5 * 1024 * 1024` size limits, MIME type checks)

### Components to Review (but likely keep)

- [ ] `components/image-editor.tsx` - **REVIEW BUT LIKELY KEEP**:

  - Contains `src={data:image/png;base64,${content}}` for AI-generated images
  - This is for displaying AI-generated content, NOT user uploads
  - Should be retained unless you want to remove AI image generation entirely

- [ ] `next.config.ts` - **KEEP AS IS**:
  - Contains `remotePatterns` for `avatar.vercel.sh` (for user avatars)
  - This is NOT related to file uploads, it's for external avatar images

### Database Migration

- Current schema in `lib/db/migrations/0000_initial_schema.sql` shows `"attachments" json NOT NULL`, please just remove it.
- New projects will start on a clean slate.

## Verification Steps

### 1. **Search Verification**

After making changes, run these searches to ensure complete removal:

```bash
# Search for remaining file upload references
grep -r "upload" --include="*.ts" --include="*.tsx" .
grep -r "attachment" --include="*.ts" --include="*.tsx" .
grep -r "blob" --include="*.ts" --include="*.tsx" .
grep -r "PaperclipIcon" --include="*.ts" --include="*.tsx" .
grep -r "FormData" --include="*.ts" --include="*.tsx" .
grep -r "fileInputRef" --include="*.ts" --include="*.tsx" .
grep -r "uploadQueue" --include="*.ts" --include="*.tsx" .
grep -r "filechooser" --include="*.ts" --include="*.tsx" .
grep -r "arrayBuffer" --include="*.ts" --include="*.tsx" .
grep -r "image/jpeg\|image/png" --include="*.ts" --include="*.tsx" .
grep -r "filename" --include="*.ts" --include="*.tsx" .
grep -r "contentType.*attachment\|attachment.*contentType" --include="*.ts" --include="*.tsx" .
```

### 2. **Type Safety Verification**

- Run `npm run lint` to ensure no TypeScript errors
- Run `npm run build` to verify build success
- Check that all file and attachment type references are removed

### 3. **Functional Verification**

- Verify chat input no longer shows paperclip/attachment button
- Verify messages cannot include file attachments
- Test message sending works normally with text-only content
- Verify no upload-related UI elements remain

### 4. **Database Verification**

- Check that Message table schema no longer includes attachments column
- Test that existing chats still load properly (attachment data should be safely ignored)

### 5. **Test Suite Verification**

- Run `pnpm test` to ensure all tests pass
- Verify no file upload related test failures
- Check that all modified test utilities work correctly

## Clean Up Dependencies

After removing all file upload functionality:

1. **Remove unused dependencies:**

   ```bash
   npm uninstall @vercel/blob
   ```

2. **Remove environment secrets:**

   - Remove `BLOB_READ_WRITE_TOKEN` from Vercel project settings
   - Remove from local `.env.local` file
   - Remove from any CI/CD configurations

3. **Update documentation:**
   - Update README with simplified setup instructions
   - Remove any file upload related documentation
   - Update API documentation if applicable

## Message Format Changes

After removal, messages will only support:

- Text parts (`{ type: 'text', text: string }`)
- Tool calls (existing functionality)

The simplified message structure removes all file/attachment complexity while maintaining the core chat functionality.

## Comprehensive Review Checklist

Use this checklist to ensure complete removal:

### File System

- [ ] `/app/(chat)/api/files/` directory completely removed
- [ ] `/components/preview-attachment.tsx` file removed
- [ ] Test images in `/public/images/` reviewed and removed if file-upload related
- [ ] No remaining `.blob` or upload-related temporary files

### Code Patterns

- [ ] All `@vercel/blob` imports removed
- [ ] All `PaperclipIcon`, `AttachmentIcon`, `UploadIcon` references removed
- [ ] All `fileInputRef` references removed
- [ ] All `uploadQueue` state and logic removed
- [ ] All `FormData` file upload usage removed
- [ ] All file validation logic removed (`file.size`, `file.type`, MIME type checks)
- [ ] All `arrayBuffer()` file processing removed
- [ ] All `filename`/`pathname` file naming logic removed

### Database & Types

- [ ] `attachments` column removed from Message table
- [ ] `Attachment` interface removed from types
- [ ] `filePartSchema` removed from API schemas
- [ ] File part types removed from message part unions

### UI & Components

- [ ] File input elements completely removed from DOM
- [ ] Attachment preview sections removed
- [ ] Upload progress indicators removed
- [ ] File drag-and-drop areas removed (if any)
- [ ] Blob storage product removed from Vercel deploy button

### Tests & Development

- [ ] File upload E2E tests removed
- [ ] File chooser test utilities removed
- [ ] Attachment-related test assertions removed
- [ ] File upload test data/fixtures removed
- [ ] Environment variables cleaned up

## Impact Assessment

**Removed Capabilities:**

- Users can no longer upload images to chat
- No file attachment previews
- No file storage via Vercel Blob
- No multimodal input (files + text)
- Simplified message structure (text + tool calls only)

**Retained Capabilities:**

- Text-based conversations
- All AI model interactions (including reasoning models)
- Tool calls (like weather)
- AI-generated content display (images, documents, etc.)
- Message history and persistence
- User authentication and authorization
- All other core chat features

**Simplified Architecture:**

- No blob storage dependencies
- No file validation/processing pipelines
- No multipart form handling
- Cleaner message types and schemas
- Reduced attack surface (no file uploads)
- Lower infrastructure complexity

This removal significantly simplifies the codebase by eliminating file handling, storage, validation, and multimodal input complexity while maintaining all core chatbot functionality.
