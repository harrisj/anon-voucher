# Anonymous Voucher Prototype

The idea of a system where anonymous users could have champions vouch for them seemed like an interesting one, so I chose it for my tech challenge. Lately, anonymous posting has been getting a bad reputation due to multiple ways in which bad actors have abused anonymity:

- Sock puppet accounts have been been part of online abuse campaigns or astroturfing
- High-follower fakes have abused trust for influence or grifting
- Fake "alt" accounts pretend to share insider information for clout
- Phishing accounts pretend to be real accounts to mislead the public

This has resulted in multiple calls
FIXME

# Tech Stack

# Development Decision Log

- **Picked Sinatra as the web framework**: been playing around with Ruby lately, easier to make stuff without scaffolds
- **Picked Minitest as the testing library**
- **Decided on basic models in a SQLite DB** nothing fancy here, and the DB will be something that can be reset
- **Picked Bulma as a CSS framework** it seems pretty decent
- **Decided against migrations and auto-loading** these would be part of using Rails or even Hanami, but want to keep things basic and not spend my time setting them up for my project due to limited timespan