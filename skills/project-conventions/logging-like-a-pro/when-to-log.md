# When to log?

To keep logs "reactive" you need to log "events". Make them as clear and easy to read.

As a rule of thumb consider logging:

- At the start of relevant operations or flows (e.g. Connection to third-party, etc);
- At any relevant progress (e.g. Authentication successful, got a valid response code, etc);
- At the conclusion of an operation (e.g. EITHER succeeded or failed);

Logs should tell you a story, every story has a beginning, middle, and end.

Be strict with "relevant", it's easier to add logs than to remove them, anything below relevant is noise.
