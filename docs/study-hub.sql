CREATE TABLE "users" (
  "id" uuid PRIMARY KEY,
  "email" varchar UNIQUE NOT NULL,
  "username" varchar UNIQUE NOT NULL,
  "password_hash" varchar,
  "avatar_url" text,
  "avatar_public_id" varchar,
  "bio" text,
  "level" integer DEFAULT 1,
  "xp" bigint DEFAULT 0,
  "streak" integer DEFAULT 0,
  "status" varchar DEFAULT 'ACTIVE',
  "last_login_at" timestamp,
  "created_at" timestamp,
  "updated_at" timestamp,
  "is_deleted" boolean DEFAULT false
);

CREATE TABLE "subject_categories" (
  "id" uuid PRIMARY KEY,
  "code" varchar UNIQUE,
  "name" varchar,
  "icon_url" varchar,
  "is_active" boolean,
  "created_at" timestamp
);

CREATE TABLE "subjects" (
  "id" uuid PRIMARY KEY,
  "code" varchar UNIQUE,
  "name" varchar,
  "category_id" uuid,
  "created_at" timestamp
);

CREATE TABLE "user_subjects" (
  "user_id" uuid NOT NULL,
  "subject_id" uuid NOT NULL,
  "level" varchar,
  "created_at" timestamp
);

CREATE TABLE "refresh_tokens" (
  "id" uuid PRIMARY KEY,
  "user_id" uuid NOT NULL,
  "token_hash" varchar NOT NULL,
  "device_name" varchar,
  "ip_address" varchar,
  "expires_at" timestamp,
  "revoked_at" timestamp,
  "created_at" timestamp
);

CREATE TABLE "oauth_accounts" (
  "id" uuid PRIMARY KEY,
  "user_id" uuid NOT NULL,
  "provider" varchar NOT NULL,
  "provider_user_id" varchar NOT NULL,
  "provider_email" varchar,
  "linked_at" timestamp,
  "created_at" timestamp
);

CREATE TABLE "tasks" (
  "id" uuid PRIMARY KEY,
  "user_id" uuid NOT NULL,
  "title" varchar NOT NULL,
  "description" text,
  "status" varchar DEFAULT 'TODO',
  "priority" varchar DEFAULT 'HIGH',
  "due_at" timestamp,
  "completed_at" timestamp,
  "created_at" timestamp,
  "updated_at" timestamp,
  "is_deleted" boolean DEFAULT false
);

CREATE TABLE "checklist_items" (
  "id" uuid PRIMARY KEY,
  "task_id" uuid NOT NULL,
  "content" varchar NOT NULL,
  "is_done" boolean DEFAULT false,
  "position" integer,
  "created_at" timestamp
);

CREATE TABLE "notes" (
  "id" uuid PRIMARY KEY,
  "user_id" uuid NOT NULL,
  "title" varchar,
  "content_json" json,
  "last_opened_at" timestamp,
  "created_at" timestamp,
  "updated_at" timestamp,
  "is_deleted" boolean DEFAULT false
);

CREATE TABLE "flashcard_sets" (
  "id" uuid PRIMARY KEY,
  "user_id" uuid NOT NULL,
  "title" varchar NOT NULL,
  "description" text,
  "created_at" timestamp
);

CREATE TABLE "flashcards" (
  "id" uuid PRIMARY KEY,
  "set_id" uuid NOT NULL,
  "question" text NOT NULL,
  "answer" text NOT NULL,
  "difficulty" integer DEFAULT 1,
  "review_count" integer DEFAULT 0,
  "last_reviewed_at" timestamp,
  "position" integer
);

CREATE TABLE "pomodoro_settings" (
  "id" uuid PRIMARY KEY,
  "user_id" uuid NOT NULL,
  "focus_minutes" integer DEFAULT 50,
  "break_minutes" integer DEFAULT 10,
  "loop_mode" varchar DEFAULT 'FINITE',
  "loop_count" integer DEFAULT 1,
  "updated_at" timestamp
);

CREATE TABLE "study_rooms" (
  "id" uuid PRIMARY KEY,
  "host_user_id" uuid NOT NULL,
  "name" varchar NOT NULL,
  "room_type" varchar DEFAULT 'PUBLIC',
  "password_hash" varchar,
  "max_capacity" integer DEFAULT 10,
  "status" varchar DEFAULT 'WAITING',
  "current_cycle" integer DEFAULT 1,
  "created_at" timestamp,
  "last_active_at" timestamp
);

CREATE TABLE "room_participants" (
  "id" uuid PRIMARY KEY,
  "room_id" uuid NOT NULL,
  "user_id" uuid NOT NULL,
  "joined_at" timestamp,
  "left_at" timestamp,
  "is_host" boolean DEFAULT false,
  "mic_on" boolean DEFAULT false,
  "cam_on" boolean DEFAULT false,
  "screen_share_on" boolean DEFAULT false,
  "connection_status" varchar DEFAULT 'ONLINE'
);

CREATE TABLE "messages" (
  "id" uuid PRIMARY KEY,
  "room_id" uuid NOT NULL,
  "sender_user_id" uuid NOT NULL,
  "content" text NOT NULL,
  "message_type" varchar DEFAULT 'TEXT',
  "sent_at" timestamp,
  "edited_at" timestamp,
  "deleted_at" timestamp
);

CREATE TABLE "pomodoro_sessions" (
  "id" uuid PRIMARY KEY,
  "user_id" uuid NOT NULL,
  "room_id" uuid,
  "task_id" uuid,
  "started_at" timestamp,
  "ended_at" timestamp,
  "actual_focus_minutes" integer,
  "status" varchar DEFAULT 'COMPLETED',
  "xp_claimed" boolean DEFAULT false,
  "created_at" timestamp
);

CREATE TABLE "room_requests" (
  "id" uuid PRIMARY KEY,
  "room_id" uuid NOT NULL,
  "user_id" uuid NOT NULL,
  "status" varchar DEFAULT 'PENDING',
  "requested_at" timestamp,
  "reviewed_at" timestamp,
  "reviewed_by" uuid
);

CREATE TABLE "friend_requests" (
  "id" uuid PRIMARY KEY,
  "sender_id" uuid NOT NULL,
  "receiver_id" uuid NOT NULL,
  "status" varchar DEFAULT 'PENDING',
  "created_at" timestamp,
  "responded_at" timestamp
);

CREATE TABLE "friendships" (
  "id" uuid PRIMARY KEY,
  "user_id_1" uuid NOT NULL,
  "user_id_2" uuid NOT NULL,
  "created_at" timestamp
);

CREATE TABLE "notifications" (
  "id" uuid PRIMARY KEY,
  "user_id" uuid NOT NULL,
  "type" varchar NOT NULL,
  "title" varchar,
  "body" text,
  "payload_json" json,
  "is_read" boolean DEFAULT false,
  "read_at" timestamp,
  "created_at" timestamp
);

CREATE TABLE "reports" (
  "id" uuid PRIMARY KEY,
  "reporter_id" uuid NOT NULL,
  "target_user_id" uuid,
  "room_id" uuid,
  "message_id" uuid,
  "reason" varchar,
  "detail" text,
  "status" varchar DEFAULT 'PENDING',
  "resolved_by" uuid,
  "resolved_at" timestamp,
  "created_at" timestamp
);

CREATE TABLE "xp_history" (
  "id" uuid PRIMARY KEY,
  "user_id" uuid NOT NULL,
  "session_id" uuid,
  "xp_amount" integer NOT NULL,
  "reason" varchar,
  "idempotency_key" varchar UNIQUE,
  "created_at" timestamp
);

CREATE TABLE "block_list" (
  "id" uuid PRIMARY KEY,
  "blocker_id" uuid NOT NULL,
  "blocked_id" uuid NOT NULL,
  "created_at" timestamp
);

ALTER TABLE "refresh_tokens" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "oauth_accounts" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "tasks" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "checklist_items" ADD FOREIGN KEY ("task_id") REFERENCES "tasks" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "notes" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "flashcard_sets" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "flashcards" ADD FOREIGN KEY ("set_id") REFERENCES "flashcard_sets" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "pomodoro_settings" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "study_rooms" ADD FOREIGN KEY ("host_user_id") REFERENCES "users" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "room_participants" ADD FOREIGN KEY ("room_id") REFERENCES "study_rooms" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "room_participants" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "messages" ADD FOREIGN KEY ("room_id") REFERENCES "study_rooms" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "messages" ADD FOREIGN KEY ("sender_user_id") REFERENCES "users" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "pomodoro_sessions" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "pomodoro_sessions" ADD FOREIGN KEY ("room_id") REFERENCES "study_rooms" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "pomodoro_sessions" ADD FOREIGN KEY ("task_id") REFERENCES "tasks" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "room_requests" ADD FOREIGN KEY ("room_id") REFERENCES "study_rooms" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "room_requests" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "room_requests" ADD FOREIGN KEY ("reviewed_by") REFERENCES "users" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "friend_requests" ADD FOREIGN KEY ("sender_id") REFERENCES "users" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "friend_requests" ADD FOREIGN KEY ("receiver_id") REFERENCES "users" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "friendships" ADD FOREIGN KEY ("user_id_1") REFERENCES "users" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "friendships" ADD FOREIGN KEY ("user_id_2") REFERENCES "users" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "notifications" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "reports" ADD FOREIGN KEY ("reporter_id") REFERENCES "users" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "reports" ADD FOREIGN KEY ("target_user_id") REFERENCES "users" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "reports" ADD FOREIGN KEY ("room_id") REFERENCES "study_rooms" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "reports" ADD FOREIGN KEY ("message_id") REFERENCES "messages" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "reports" ADD FOREIGN KEY ("resolved_by") REFERENCES "users" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "xp_history" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "xp_history" ADD FOREIGN KEY ("session_id") REFERENCES "pomodoro_sessions" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "block_list" ADD FOREIGN KEY ("blocker_id") REFERENCES "users" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "block_list" ADD FOREIGN KEY ("blocked_id") REFERENCES "users" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "user_subjects" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "user_subjects" ADD FOREIGN KEY ("subject_id") REFERENCES "subjects" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "subjects" ADD FOREIGN KEY ("category_id") REFERENCES "subject_categories" ("id") DEFERRABLE INITIALLY IMMEDIATE;
