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

This is a basic Sinatra application running locally. I don't even have Docker running for it yet. That is one of the things I would likely setup for a regular project, especially one with multiple developers, but I didn't want to spend my limited time tweaking Dockerfiles. Sorry!

In order to run this, you'll have to install Ruby locally on your machine (it might already be installed). Then you simply need to try the following commands

```bash
bundle install
rake db:create
rake db:seed
bundle exec ruby app.rb
```

This will launch a local Sinatra instance running on http://localhost:4567/

# HACK Comments
Because this is an attempt to create a prototype quickly without using any web frameworks that would help, I am running at full speed with multiple sets of scissors in my hands. This means that there are many examples where I am bypassing how things _should_ be done in favor of what I can do now quickly. In some especially egregious cases, I have tried to put in a special `HACK` comment, but there might be other cases where I have forgotten to explicitly call it out. If you find something that seems wrong, just assume I'm aware of it too! ;)