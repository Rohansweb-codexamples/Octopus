-- Octopus database schema (Supabase SQL Editor)
create extension if not exists pgcrypto;
create table if not exists public.presentations (
  id uuid primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  title text not null default 'Untitled presentation',
  slides jsonb not null default '[]'::jsonb,
  updated_at timestamptz not null default now(),
  created_at timestamptz not null default now()
);
alter table public.presentations enable row level security;
create policy "Owners can read presentations" on public.presentations for select using (auth.uid() = user_id);
create policy "Owners can create presentations" on public.presentations for insert with check (auth.uid() = user_id);
create policy "Owners can update presentations" on public.presentations for update using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "Owners can delete presentations" on public.presentations for delete using (auth.uid() = user_id);
create index if not exists presentations_user_updated_idx on public.presentations(user_id, updated_at desc);
-- Public share links are best implemented using a separate read-only RPC or a
-- published flag + carefully scoped policy. Do not make every private deck public.
