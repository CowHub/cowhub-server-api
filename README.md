# CowHub Server API

## Getting Started

There is a sequence of actions you need to take to get going with the project, alongside a number of actions and tasks you should run every time you start your developer environment.

_The below instructions assume that you use `zsh`, although the steps which influence this should be very similar if you use a different shell._

---
<br>

## Installing dependencies

### Ruby and Rails

_Regardless of whether you are running a Mac or Ubuntu machine, these instructions are the same._

#### Install ruby environment

To manage your ruby environment, it is recommended that you use `rbenv`. This allows you to use any version of ruby you wish for particular applications, whilst maintaining permissions at the user level ensuring that no superuser access is required for system-level administration.

Firstly, clone the `rbenv` and `ruby-build` repositories (the latter is required for installing different version of ruby).

```bash
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
```

Secondly, we need to tell our shell to load the above into our path on initialisation. Add the following to the bottom of `~/.zshrc`.

```bash
# rbenv
RBENV_PATH="$HOME/.rbenv/bin"
export PATH="$RBENV_PATH:$PATH"
[ -d $RBENV_PATH ] && eval "$(rbenv init -)"
```

Thirdly, having edited our `~/.zshrc`, we need to reload it for the current shell to have `rbenv` available. In every running shell you have run `source ~/.zshrc`

Now you should be able to run `rbenv versions` and it will show you what versions of ruby are available. Install the latest stable ruby version that which we will be using.

```bash
rbenv install 2.3.1
```

To make a version of ruby your global default, simply run `rbenv global <RUBY_VERSION>` replacing `<RUBY_VERSION>` with `2.3.1` in the example above.

#### Install Ruby Gems

Having installed ruby successfully above, you need to install `bundler`, used for managing prerequisites for our project, to setup and run our project successfully.

```bash
gem install bundler
```

We won't install everything (including rails itself) for the project just yet as some dependencies won't be satisfied - see below.

### PostgreSQL

#### Mac

_If you don't have Homebrew installed, you should - go [here](https://brew.sh) and you'll be forgiven of your sins._

We need the basics including `pg_config` and so forth and the easiest way to do that is to install everything with `brew`.

```bash
brew install postgresql
```

We now want to actually run PostgreSQL itself, and thanks to geniuses, we can do that really easily on the Mac with the [Postgres.app](http://postgresapp.com/). Download and install this and after adding the following to your `~/.zshrc` you're good to go.

```bash
# Prioritise contained Postgres
export PATH="/Applications/Postgres.app/Contents/Versions/latest/bin:$PATH"
```

_Don't forget to run `source ~/.zshrc`_

#### Ubuntu

You do need system access on Ubuntu to install Postgres with the following install.

```bash
sudo apt-get install postgresql libpq-dev
```

You're now ready to go with the database.

---
<br>

## Project Setup

Assuming you are in this directory on your local machine, you can now install all project prerequisites.

```bash
bundle install
```

This will install all ruby dependencies for the project - successful installation means you are ready to go!

---
<br>

## Running the server for the first-time on a machine

At this point you should have everything installed and ready to go. If you don't, reach out to @FreddieLindsey and we'll get it fixed!

### Setting up and migrating the database

#### Creating a Postgres user

Create a postgres user for our application with the following:

```bash
createuser cowhub-server-api -d -P
```

Enter the password as per the `config/database.yml` file.

#### Creating and using our database

Run the following. For any issues, contact @FreddieLindsey

```bash
bundle exec rake db:setup db:migrate
```

---
<br>

## Start the server

To test that the server actually works, run `rails s` and go to [your browser](http://localhost:3000) - you should see a welcome to rails page.

Given this, you have everything setup and are ready to develop using the API.
