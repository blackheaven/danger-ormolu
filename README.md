# danger-ormolu

A danger plugin for the Haskell code formatter ormolu

## Installation

    $ gem install danger-ormolu

## Usage
Be sure to have `ormolu` and `diff` in your `PATH`, include it in your `Gemfile`:

```
# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

# gem "rails"
gem 'danger'
gem 'danger-ormolu'
```

Finally use this line in your `Dangerfile`:

```
# get all affected files by the changes in the current diff
affected_files = git.added_files + git.modified_files

# limit files to .hs files
haskell_files = affected_files.select { |file| file.end_with?('.hs') }

ormolu.check haskell_files
```
    Methods and attributes from this plugin are available in
    your `Dangerfile` under the `ormolu` namespace.

## Development

1. Clone this repo
2. Run `bundle install` to setup dependencies.
3. Run `bundle exec rake spec` to run the tests.
4. Use `bundle exec guard` to automatically have tests run as you make changes.
5. Make your changes.
