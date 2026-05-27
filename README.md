# 匿名查詢系統

一個可分享的匿名查詢網站：輸入名字或匿名亂碼即時查詢，資料存在 Supabase 雲端，
所有人看到同一份。訪客只能查詢，只有登入的管理員可以新增 / 編輯 / 刪除
（由資料庫的 RLS 權限規則強制保護）。

## 檔案說明

- `index.html` — 整個網站（HTML + CSS + JavaScript，單一檔案）
- `supabase-setup.sql` — 在 Supabase 建立資料表與權限的 SQL（執行一次）
- `.nojekyll` — 讓 GitHub Pages 不要用 Jekyll 處理，純靜態輸出

## 一、先設定 Supabase（約 10 分鐘）

1. 到 supabase.com 註冊並建立一個新專案。
2. 左側 **SQL Editor → New query**，貼上 `supabase-setup.sql` 全部內容並 Run。
3. 左側 **Authentication → Users → Add user**，建立你的管理員帳號
   （Email + 密碼，建立時把 Auto Confirm 打開）。
4. 左側 **Settings → API**，複製 **Project URL** 與 **anon public** key。
5. 打開 `index.html`，把最上面這兩行填入你的值：

   ```js
   const SUPABASE_URL = "https://YOUR-PROJECT.supabase.co";
   const SUPABASE_ANON_KEY = "YOUR-ANON-KEY";
   ```

> 第一次用管理員身分登入網站時，預設資料會自動匯入雲端，不需手動匯入。

## 二、上架到 GitHub Pages

1. 在 GitHub 建立一個新的 repository（可設為 Public）。
2. 把 `index.html`、`.nojekyll`、`supabase-setup.sql`、`README.md`
   全部上傳到 repo 根目錄（直接用網頁 Upload files 拖進去即可）。
3. 進入該 repo 的 **Settings → Pages**。
4. 在 **Build and deployment → Source** 選 **Deploy from a branch**，
   Branch 選 `main`、資料夾選 `/ (root)`，按 Save。
5. 等一兩分鐘，頁面上方會出現你的網址，格式像：
   `https://你的帳號.github.io/你的repo名稱/`
6. 打開網址即可使用，把這個網址分享給朋友。

之後要更新內容或改密碼，只要把修改後的 `index.html` 重新上傳覆蓋，網址不變。

## 安全須知

- `index.html` 裡放的是 **anon public** key，這把鑰匙本來就是設計給前端公開使用的，
  放在公開的 GitHub repo 沒問題——真正保護寫入權限的是資料庫的 RLS 規則。
- **絕對不要**把 Supabase 的 `service_role` key 放進程式或 commit 上去，
  那把鑰匙會繞過所有權限。
