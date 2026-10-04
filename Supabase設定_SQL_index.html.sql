-- 京都大阪行程 App — Supabase 後端設定
-- 用法：Supabase 專案 → 左側 SQL Editor → New query → 貼上全部 → Run

-- 1) 建立資料表
create table if not exists public.toggles (
  id text primary key,            -- 例：checks:c3 / visits:d2s0 / bought:b5
  done boolean default true,
  updated_at timestamptz default now()
);

create table if not exists public.expenses (
  id text primary key,
  day text,
  amount numeric,
  label text,
  author text,                    -- 記帳的人名字
  ts bigint
);

-- 2) 開啟 RLS 並允許「匿名(免登入)」讀寫（信任小圈子共用）
alter table public.toggles  enable row level security;
alter table public.expenses enable row level security;

drop policy if exists "anon_all_toggles" on public.toggles;
create policy "anon_all_toggles" on public.toggles
  for all to anon using (true) with check (true);

drop policy if exists "anon_all_expenses" on public.expenses;
create policy "anon_all_expenses" on public.expenses
  for all to anon using (true) with check (true);

-- 3) 開啟 Realtime 即時同步（若顯示已存在，忽略該行即可）
alter publication supabase_realtime add table public.toggles;
alter publication supabase_realtime add table public.expenses;
