-- Run ONCE in Supabase SQL Editor to enable unverified (news-sourced) hotspots.
-- Safe to re-run (idempotent).

-- 1. New columns
alter table hotspots add column if not exists verified boolean not null default false;
alter table hotspots add column if not exists source text;

-- 2. Mark all pre-existing rows as verified (they're the official seed data).
--    Run this BEFORE any unverified rows are inserted.
update hotspots set verified = true where verified = false;

-- 3. Let the admin flip verified (moderation). Delete is already admin-only.
drop policy if exists "Owner update" on hotspots;
create policy "Owner update" on hotspots
  for update to authenticated
  using      ( (auth.jwt() ->> 'email') = 'neletienne18@gmail.com' )
  with check ( (auth.jwt() ->> 'email') = 'neletienne18@gmail.com' );
