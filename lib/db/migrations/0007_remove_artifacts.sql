-- Drop foreign key constraints first
DO $$ BEGIN
 ALTER TABLE "Suggestion" DROP CONSTRAINT IF EXISTS "Suggestion_documentId_documentCreatedAt_Document_id_createdAt_fk";
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "Suggestion" DROP CONSTRAINT IF EXISTS "Suggestion_userId_User_id_fk";
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "Document" DROP CONSTRAINT IF EXISTS "Document_userId_User_id_fk";
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
-- Drop tables
DROP TABLE IF EXISTS "Suggestion";
--> statement-breakpoint
DROP TABLE IF EXISTS "Document"; 