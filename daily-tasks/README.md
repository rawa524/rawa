# ڕۆژانە — Daily tasks

A Kurdish (Sorani), right-to-left daily task manager. Add tasks with optional due dates, mark them complete, filter the list, and delete tasks with confirmation. Data stays in this browser's local storage; there is no account or server database. Clearing browser data removes saved tasks.

From `/workspace/rawa`, run:

```sh
python -m http.server 8000 --directory daily-tasks
```

Open `http://localhost:8000` in your own browser when running locally. No packages or build step are required. Keep the same host and port to retain access to your saved tasks.
