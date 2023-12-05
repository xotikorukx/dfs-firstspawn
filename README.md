# dfs-firstspawn
Allows you as a server owner to remove all cfx-default resources except baseevents, [system]/[builders] (webpack, yarn), and optionally chat.

**Notes**
- This resource expects you have some semblance of an esx/qb/ox server in place to function. If you don't, you will spawn at `vector3(0,0,0)` as default danny and be unable to respawn without tx or another admin command.
- If you have a solid queue system, it should have already taken over hardcap's job. Check your queue system to make sure it does if your server is already big enough for this to be a concern.
- This is a drag-n-drop resource, just make sure you have removed all cfx-default reosurces except baseevents, [system]/[builders] (webpack, yarn), and optionally chat.
- Some QB resources (looking at you, ambulancejob) call an export in spawnmanager. You can just remove this line from ambulancejob to no negative effect (assuming you are running this script)
