It's really hard to catch up with what's going on when thousands of customers are triggering "Connecting to Slack" logs. As you produce logs and several customers use your application, you should be able to filter information by relevance.

To make things simple, here's a rule of thumb for you (be flexible!):

| **Level** | **When to use** |
|---|---|
| DEBUG | For some really repetitive information. It might be useful to understand the whole context of what's going on, most of the time it's not so useful. |
| INFO | When something relevant happened, something worthy of being aware of most of the time. |
| WARNING | Something weird happened (but didn't interrupt the flow/operation). If any other issue happens later on it might give you a hint. |
| ERROR | An error happened, it should be resolved as soon as possible. |
| CRITICAL | A very serious error happened, it needs immediate intervention. Prefer ERROR if unsure. |
