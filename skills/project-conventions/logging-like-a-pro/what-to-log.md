# What to log?

To keep logs "descriptive" and "contextual", you need to provide the correct set of information, and that's impossible to tell you which are they without knowing your case.

Adding such data make logs noisy because they're impossible to react: I got nothing to do! I still should be able to gather details by reading attributes (who, when, why, etc). If you're willing to measure something you should be using metrics, not logs.



## Successful logs example:

| Message | Instant knowledge | Context |
|---|---|---|
| Connecting to AWS | AWS operation started | Log attributes should allow me to find out who triggered it |
| Retrieved instances from all regions | One relevant progress has been made | - |
| Connection to AWS has been successful | AWS operation finished | Log attributes should allow me to find who got positively affected |

## Error logs example:

Consider that retrieving instances from region `af-south-1` failed due to some random issue over that region.

| Message | Instant knowledge | Context |
|---|---|---|
| Connecting to AWS | AWS operation started | Log attributes should allow me to find out who triggered it |
| Failed to retrieve instances from regions af-south-1 when connecting to AWS for user X | AWS operation didn't finish, region af-south-1 failed, user X got affected | I should be able to see the error's stack trace to dive into the "why" it failed |
