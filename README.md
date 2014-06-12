Welcome to Reservations [![Code Climate](https://codeclimate.com/github/YaleSTC/reservations.png)](https://codeclimate.com/github/YaleSTC/reservations)
=======================

Reservations makes it easy to manage the checking in and out of equipment, much like a library! Here are some of the things Reservations can do:

* manage your inventory of equipment, including storing serial numbers, manuals and other documents, and more.
* present an attractive catalog of equipment, including pictures, so people can browse and search your equipment.
* allow people to reserve equipment in advance, according to rules you set.
* enforce rules on who can reserve what equipment, and for how long.
* manage checking in/out equipment, including unique checklists for each item.

Getting Started
===============

There are two mains steps to setting up Reservations, setting up a deployment server, and installing the Reservations application.

### Prerequisites
You'll need the following to run Reservations:
* [Ruby 1.9](http://www.ruby-lang.org/) and [Rails 3.2](http://rubyonrails.org/)
* a database server ([Sqlite](http://www.sqlite.org/), [MySQL](http://www.mysql.com/) or any database supported by Rails)
* [ImageMagick](http://www.imagemagick.org/script/index.php)

### Installation 
First, checkout a copy of Reservations using git:

```
cd /your/code/directory
git clone https://github.com/YaleSTC/reservations.git
cd reservations
```

Reservations uses [Bundler](http://gembundler.com/) to manage dependencies, so if you don't have it, get it, then install dependencies:

```
gem install bundler
bundle install
```

You'll need to edit config/database.yml to point to your database, including the correct username and password. See [Rails Guides](http://guides.rubyonrails.org/configuring.html#configuring-a-database) for common database examples.

Then, create the database and run migrations to build the structure:

```
rake db:create
rake db:migrate
```

Finally, start the app locally:

```rails server```

Just point your browser to ```localhost:3000``` to use Reservations.

### Deploying to a Server

Reservations is built using [Ruby on Rails](http://rubyonrails.org/), and can be set up (deployed) like most Rails apps. You'll need a server running with the following software:

* [Ruby 1.9](http://www.ruby-lang.org/)
* database server ([MySQL](http://www.mysql.com/) is preferred, but any database supported by Rails should work, including PostgreSQL)
* web server ([apache](http://apache.org/) or [nginx](http://wiki.nginx.org/Main) both work well) 
* Rails application server (usually [Passenger Phusion](http://www.modrails.com/) aka mod_rails)

For a general guide to setting up your web and application servers, including hosting providers, see the [Rails Deployment Guide](http://rubyonrails.org/deploy/).

Further Documentation
==================
* System administrators and end-users may like to review our [help documentation](https://yalestc.github.io/reservations).
* Developers interested in getting involved with *Reservations* can find information on our [project wiki](https://github.com/YaleSTC/reservations/wiki)

Suggestions and Issues
======================

If you have any suggestions, or would like to report an issue, please either:
* Create an issue for [this repository](https://github.com/YaleSTC/reservations/) on Github 
* or, if you don't have a GitHub account, use our [issue submission form](https://docs.google.com/a/yale.edu/spreadsheet/viewform?formkey=dE8zTFprNVB4RTAwdURhWEVTTlpDQVE6MQ#gid=0)

