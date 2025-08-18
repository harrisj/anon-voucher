# About This Site

This is a simple demo of a social-media-type site that allows for anonymous comments to be validated and approved by "champions" who are trusted sources whose approval grants legitimacy. This exercise represents only four hours of work, but it does include the following basic components of an implementation:

- A SQLite database with a basic model for posts, users and tracking approvals
- A basic Sinatra web application that allows interactions
- A basic seeding of the data with some starter accounts and posts
- Actions to post content, vouch and unvouch content with audit trails generated
- Unit-testing for those actions to validate correct performance

# What You Can Do

Currently, this demo is for a system where:

- All users can post messages (regular, anonymous and champions)
- Anonymous user messages will be flagged with a warning if not vouched or a checkmark if they are
- Champion accounts can vouch for anonymous messages

Right now, this system has the following endpoints:

- [/timeline/regular_user](/timeline/regular_user) - timeline for a regular user
- [/timeline/anon](/timeline/anon) - timeline for an anonymous user
- [/timeline/champion](/timeline/champion) - timeline for a champion who can vouch for anonymous messages
- [/danger/reset](/danger/reset) - resets the database to what's in the seeded data

# What Could Be Next

Being a very quick demo/prototype there are some obvious short-cuts that would not be in a more polished system:

- There is no authentication/authorization in this implementation
- Code could be better organized into the MVC pattern
- HTMX usage feels like it could be improved to be less hackish
- This system would use a persistent data store for messages, etc.

What this doesn't include, but which could be part of a production implementation:

- A workflow for vouching that could include the champion documenting why this statement should be trusted, but also with the anonymous poster being able to review in case that documentation would leak info
- A checklist for how to vouch different types of anonymous content
- Gradations in what could be vouched. For instance, it may be there is value in asserting things like "I don't have any way of proving that this person works for the Department of Education, but they demonstrate a strong familiarity with its systems and internal processes that suggests they likely are an employee."
- Better handling changes in status that could happen over time. For instance, an account goes from being anonymous to not (or vice versa). Vouching is revoked and then re-extended. Vouching entities are stripped of their status (or new champions are designated, etc.)
- Champions are given great power that should come with the responsibility of exercising sufficient due diligence. Some enhancements to this could include giving them notifications on message edits (and the opportunity to re-approve), notifying all users if a champion revokes their vouching of a post, etc. as well as some public way to present the work of champions.
- Do we allow for champions to vouch for entire accounts (vs. individual messages)? Do we give them tools to check if an account is deviating in some ways that they could revoke such approvals (for instance, if an account is hacked and posts incendiary content that attracts a large ratio of replies/reposts vs. favorites)?
- What's in it for the champions in this system? Under this model, they have extra work to do AND they can face reputational risk. This might appeal to journalistic organizations that are already used to do source verification, but typically they don't share their assessments of sources publicly like this model would require. So, why would someone be a champion in this model and how do we best support them?
- Really exploring the concept of having an event-based model (perhaps in Kafka) as the source of truth for other derived tables, etc. in the database.
- Obviously improving the experience for regular users, champions and anonymous users to be consistent and compelling.

What is likely out of scope for such a system:

- Formal cryptographic models of trust
- Reputation scoring mechanisms (ala [Advogato](https://en.wikipedia.org/wiki/Advogato))
- More sophisticated SQL schema models for protecting anonymity (ala [Translucent Databases](https://wayner.org/books/td/))
- The blockchain
