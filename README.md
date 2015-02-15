GET GOING SINATRA
=================

Get Going is a series of boilerplate/starting point setups for web devevelopment. This is the Sinatra flavour, wich includes a setup of a classic style Sinatra application running haml templates.

Features included:

- Authentication with Oauth (LinkedIn, but can easily be changed) and Warden.
- Templateing with Sinatra Partials (running HAML)
- SQ Lite db and Active Record models


SETUP
-----

The setup is based on on ruby 2.1.3

Rename /app/config/settings_example.rb to example.rb and set the accurate values for your application.

Setup application with

```
bundle install
```

Run with

```
bundle exec ruby application.rb
```
NOTE: bundle exec is needed to get the right Rack version (due to a bug in Sinatra < 1.6, we have do use Rack 1.5.2).
