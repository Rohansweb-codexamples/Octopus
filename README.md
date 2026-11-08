# Octopus — Presentation Studio

A static presentation maker with a separate presenter window and audience display window. No Render service is used.

## Deploy
1. Import this GitHub repository into Vercel.
2. Choose **Other** / static site. No build command is needed; output directory is the repository root.
3. Deploy. Add your own domain in Vercel if wanted.

## Accounts and durable cloud storage
The app currently works locally in the browser. To enable accounts and cross-device cloud saving:
1. Create a Supabase project.
2. Open **SQL Editor** and run `supabase/schema.sql`.
3. Copy `config.example.js` to `app-config.js` and enter your Supabase Project URL and anon/publishable key.
4. Edit the committed `app-config.js` file with your project URL and public anon/publishable key. The app loads it automatically.
5. Commit and redeploy. Never put a Supabase service-role key in browser code.

Supabase Auth stores accounts; Postgres stores presentation data and links. The SQL uses row-level security so users can only read and edit their own presentations. A separate, explicitly published read-only sharing policy/RPC should be added before enabling public audience links. Do not expose private presentation rows to anonymous users.

## Current controls
- Create and edit presentations and slides.
- Click slide title/body to edit.
- Add slide, text and image.
- Change slide background and speaker notes.
- Open Presenter View and Display Screen in separate browser windows.
- Presenter controls change slides in the audience window through BroadcastChannel.
- Click the audience display to enter fullscreen; Esc exits.
- Browser-local saving works immediately.

## Important
Browser local storage is not a permanent backup and does not sync between devices. Cloud persistence requires configuring Supabase. A website and database cannot be promised to last forever; keep backups and retain control of the hosting/database accounts.
