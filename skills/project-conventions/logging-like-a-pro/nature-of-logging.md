# The nature of logging: good logging matters

Logs are:

- Descriptive: because they tell you what happened in the sense that they give you a piece of information
- Contextual: because they give you an overview of the state of things at the moment
- Reactive: because they allow you to take action only after something happened (even though your logs are sent/consumed real-time, there's not really something you can do to change what just happened).

If you don't respect the nature of a log, you're going to produce only noise, which decreases performance. Logs are private intel from the software to keep aware and react to situations. Any log that can't give this ability is pure noise.
