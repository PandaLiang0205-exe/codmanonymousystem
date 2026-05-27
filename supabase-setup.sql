-- =========================================================================
-- 匿名查詢系統 — Supabase 初始設定 SQL
-- 用法：在 Supabase 後台左側選單 → SQL Editor → New query，
--       把整段貼上後按 Run 執行一次即可。
-- =========================================================================

-- 1) 建立資料表
--    id：每筆資料的唯一編號（自動產生）
--    name：名字
--    code：匿名亂碼（設為 UNIQUE，資料庫會自動擋掉重複的亂碼）
--    created_at：建立時間（用來排序）
create table if not exists public.entries (
  id          uuid primary key default gen_random_uuid(),
  name        text not null,
  code        text not null unique,
  created_at  timestamptz not null default now()
);

-- 2) 開啟 Row Level Security（沒開啟的話，下面的權限規則不會生效）
alter table public.entries enable row level security;

-- 3) 權限規則（RLS）
--    讀取：所有人（含未登入的訪客）都可以查詢
create policy "anyone_can_read"
  on public.entries
  for select
  to anon, authenticated
  using (true);

--    新增 / 修改 / 刪除：只有「已登入」(authenticated) 的使用者可以做
--    → 也就是只有用你的帳號登入後才能寫入，訪客完全不能改。
create policy "authenticated_can_insert"
  on public.entries
  for insert
  to authenticated
  with check (true);

create policy "authenticated_can_update"
  on public.entries
  for update
  to authenticated
  using (true)
  with check (true);

create policy "authenticated_can_delete"
  on public.entries
  for delete
  to authenticated
  using (true);

-- =========================================================================
-- 完成後請參考說明：
-- (1) 到 Authentication → Users → Add user 建立你的管理員帳號（Email + 密碼）。
-- (2) 到 Settings → API 複製 Project URL 與 anon public key，貼進 index.html。
-- (3) 預設那 121 筆資料不需要在這裡手動匯入：
--     第一次用管理員身分登入網站時，程式會自動把預設資料寫進這張表。
-- (4)（選用）想讓所有人「即時」看到更新，可到 Database → Replication
--     把 entries 這張表的 Realtime 打開；不開也行，重新整理就會看到最新。
-- =========================================================================
