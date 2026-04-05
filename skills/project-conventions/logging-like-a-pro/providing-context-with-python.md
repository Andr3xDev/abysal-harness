# Providing context with Python

Log attributes can be added in Python by using the `extra` field, like:

## Do that
logger.info("☁️ Connecting to AWS", extra={"user": "X"})
...
logger.info("☁️✅ Connection to AWS has been successful", extra={"user": "X"})

## Don't do that
logger.info("🔄 Connecting to third-party", extra={"user": "X", "third-party": "AWS"})

Messages should be clear and leave no room for questions about what's going on. Context should enrich the experience by providing info about deeper details and allow you to find out why something happened.
