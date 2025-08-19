# Anonymous Voucher Prototype

The idea of a system where anonymous users could have champions vouch for them seemed like an interesting one, so I chose it for my tech challenge. Lately, anonymous posting has been getting a bad reputation due to multiple ways in which bad actors have abused anonymity:

- Sock puppet accounts have been been part of online abuse campaigns or astroturfing
- High-follower fakes have abused trust for influence or grifting
- Fake "alt" accounts pretend to share insider information for clout
- Phishing accounts pretend to be real accounts for disinformation

This has resulted in multiple calls by governmnt and technology organizations to eliminate the use of anonymous accounts and require all users to go through some sort of identity proofing. Such measures haven't been shown to really help with the problems above and eliminating anonymity would eliminate many of the good reasons that people might use anonymous accounts:
 
- Safety: people in vulnerable groups or others seeking justice and equity might need anonymity for their safety
- Privacy: maybe you want your online account to just be a specific aspect of your personality ("I only discuss telesopes"). You shouldn't have to identify yourself any more than you'd want to.
- Self-expression: online accounts can be liberatory in allowing people to try on new identities and forms of self-expression that differ from their official identity. As long as it's not harming anybody, what's the harm in that?
- Whimsy: sock puppets aren't the only anonymous bots out there. For instance, does a bot that finds haiku in posts need to be vetted to a specific person?

and so on. Unfortunately, the damage from disinformation and abuse is making it hard to justify anonymity in online forums, especially where in news-related forums. But, it seems wrong to me to throw out the protections of privacy and anonymity because of the actions of bad actors. This is a more complicated topic than can be solved in a 4-hour exercise, but I'd like to try out what it might look like to have a system where authoritative sources could vouch for anonymous posts.

# Specific Questions Answered

## Your assumptions and technical design considerations for the prototype_

The instructions made it very clear that I shouldn't use a framework for prototyping like Rails that uses code generation to automate away boilerplate. This ban would also cover other rapid prototyping frameworks in Ruby (Hanami), Python (Django and FastAPI) and so on. So, I decided to go with a simpler framework like Ruby's Sinatra (itself inspired by Flask).

Although many of the suggested possibilities were LLM-related, I don't yet feel confident in my experience to do this exercise using them. But I was intrigued by the idea of supporting anonymous comments with "champions" who can vouch for them. So, it seemed liked a fun thing to do!

## Where you got to in the prototype-constraints, challenges, observations, and remaining explorations you might have wanted to try with more time and resources

Being a very quick demo/prototype there are some obvious short-cuts that would not be in a more polished system:

- There is no authentication/authorization in this implementation
- Code could be better organized into the MVC pattern
- HTMX usage feels like it could be improved to be less hackish
- This system would use a persistent data store for messages, etc.
- I sketched the outline of a model built on top of actions and event-driven processing that I would formalize more

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

## What app metrics would be useful to drive user-based insights and how might instrument the app to collect them?

Some possible metrics that could give insight into the process:

- Is there a difference in engagement for vouched post vs. ones that aren't vouched for? (web analytics)
- What is the mean time for different types of content to be reviewed? (data from the database)
- Categorizing the types of anonymous content and the engagement/reviews for them? (LLM, clustering, etc.)
- Does this reduce spam reports? Does it disincentivize bad behavior?

# Tech Stack
I have been programming again in Ruby lately for fun and I felt like it would be a good choice for this exercise because Ruby's support for metaprogramming, reflection and domain-specific languages (DSL) make it easy to build prototypes like this (even though we might consider a different language for production based on those requirements)

This exercise specifically rejected Ruby on Rails for its scaffolding generators, so I will be using a different stack of hand-rolled components. I understand that the purpose of this restriction is to make sure you can tell what code has been written by the applicant, but it also means removing some powerful tools to build prototypes quickly by code generation, dynamic loading and enforcing naming and project layout conventions. All of which is to say, since I am rolling my own layout (and not even using a bootstrap starter on Github or similar), there will be some quirks that would be organized differently in production systems.

This project uses the following components:
- Sinatra for the server code
- SQLite for a database (however, this database will just be prepopulated with fixtures and not persisted)
- Sequel as an object-relational mapping layer (ORM)
- Rubocop for linting
- Minitest for testing
- Serbea for templating
- Bulma for the CSS layout
- HTMX for form submission

To keep things simple, I will probably not have a lot of front end code at first for this prototype, sorry!

# Development Decision Log

- **Picked Sinatra as the web framework**: been playing around with Ruby lately, easier to make stuff without scaffolds
- **Picked Minitest as the testing library**
- **Decided on basic models in a SQLite DB** nothing fancy here, and the DB will be something that can be reset
- **Picked Bulma as a CSS framework** it seems pretty decent as a grid layout system and I will likely use its Media Object component in my timeline.
- **Picked Serbea for templating** I have been doing a lot of work within Bridgetown for a personal site and using the Serbea template engine there
- **Decided against migrations and auto-loading** these would be part of using Rails or even Hanami, but want to keep things basic and not spend my time setting them up for my project due to limited timespan
- **Wrote a seed file for loading data** this was useful for testing as well as it will let me give the DB a reset button in a demo
- **Using HTMX for interactive elements** I've wanted to try it and this seemed like a good application for its model of AJAX with DOM replacement of HTML.
- **Using fly.io for deployment**

# Running Things Locally
In order to run this, you'll have to install Ruby locally on your machine (it might already be installed). Then you simply need to try the following commands

```bash
bundle install
rake db:create
rake db:seed
bundle exec rackup
```

This will launch a local Sinatra instance running on http://localhost:9292/

Or you can use docker-compose to run the app instead. For that, you just can access it at http://localhost/

# HACK Comments
Because this is an attempt to create a prototype quickly without using any web frameworks that would help, I am running at full speed with multiple sets of scissors in my hands. This means that there are many examples where I am bypassing how things _should_ be done in favor of what I can do now quickly. In some especially egregious cases, I have tried to put in a special `HACK` comment, but there might be other cases where I have forgotten to explicitly call it out. If you find something that seems wrong, just assume I'm aware of it too! ;)