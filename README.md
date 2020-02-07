# AutomateApi

This is a quick and dirty ruby api client for the [Chef](https://chef.io) [Automate](https://automate.chef.io) v2 API

## Installation

```
git clone https://github.com/teknofire/automate_api
cd automate_api
bundle
```


## Usage

Checkout the [examples](tree/master/examples) directory for how to use the various resource models.

To run the examples you will need to create a config file with the following content.

Save this as `~/.a2_cli.rb`
```
url "https://A2_SERVER_HOSTNAME"
token "A2_ADMIN_TOKEN"
ssl_verify false
```

To run all of the examples

```
rake examples
```

or if you want to run an individual example

```
ruby -I lib examples/compliance_nodes.rb
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/teknofire/automate_api.

## TODO

TODO: Publish as a gem so these instructions will work

Add this line to your application's Gemfile:

```ruby
gem 'automate_api', github: 'teknofire/automate_api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install automate_api
