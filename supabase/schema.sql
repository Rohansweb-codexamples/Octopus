-- Octopus database schema (run in Supabase SQL Editor)
create extension if not exists pgcrypto;

create table if not exists public.presentations (
  id uuid primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  title text not null default 'Untitled presentation',
  slides jsonb not null default '[]'::jsonb,
  is_public boolean not null default false,
  updated_at timestamptz not null default now(),
  created_at timestamptz not null default now()
);

alter table public.presentations enable row level security;

-- Recreate policies so this script can safely repair older/incorrect versions.
drop policy if exists "Owners and viewers can read presentations" on public.presentations;
drop policy if exists "Owners can create presentations" on public.presentations;
drop policy if exists "Owners can update presentations" on public.presentations;
drop policy if exists "Owners can delete presentations" on public.presentations;

-- Public presentations can be viewed by anyone; private ones only by their owner.
create policy "Owners and viewers can read presentations"
on public.presentations for select
to anon, authenticated
using (auth.uid() = user_id or is_public = true);

-- Only a signed-in owner can create, update, or delete their own rows.
create policy "Owners can create presentations"
on public.presentations for insert
to authenticated
with check (auth.uid() = user_id);

create policy "Owners can update presentations"
on public.presentations for update
to authenticated
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

create policy "Owners can delete presentations"
on public.presentations for delete
to authenticated
using (auth.uid() = user_id);

create index if not exists presentations_user_updated_idx
on public.presentations(user_id, updated_at desc);
