# Fmedit

A small library for manipulating the frontmatter in markdown files.

It assumes that the frontmatter is deliniated by `---` and in YAML format.

Fair warning: it worked when I used it but tests are… non existant. I assume you will be using it on version controlled files that can be easily compared and restored.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add fmedit

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install fmedit

## Usage

There's no CLI (yet?) but this provides a little utility library for writing scripts to manipulate the frontmatter in markdown files.

For example, to add the "published" attribute to all your posts and save them:

```ruby
require "fmedit"

Fmedit::Files.new("src/_posts/*") do |file|
    file.edit! published, true
    file.save!
end
```

To unpublish all hidden posts, and remove the hidden attribute:

```ruby
require "fmedit"

Fmedit::Files.new("src/_posts/*") do |file|
  file.add "published", false if f.get("hidden")
  file.remove "hidden"
end
```

`Fmedit::Files.new` takes a directory wildcard as a argument, e.g. `"src/_posts/*"`. It requires a block to be passed, to which an instance of Fmedit::Editor will be passed.

The following operations can be performed:

`add`: Add a key/value pair only if it doesn't already exist

`add!`: Add a key/value pair even if one exists (overwrites it)

`edit`: Update a key if the value matches a regex. Replaces using regex groups. This is the most complex operation and allows you to use regular expressions to match values, then use those groups for the replacement. Uses String#gsub under the hood.

```
file.edit "image", /^((?!images\/.+|\/|http).*)$/, "/images/\\1"
file.edit "image", /^(images\/.+)$/, "\/\\1"
```

`remove`: Remove a key, if it exists

`get`: Get the value of a key

`print`: Print the contents of the frontmatter

`save!`: Save the file

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ideasasylum/fmedit. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/ideasasylum/fmedit/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Fmedit project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/ideasasylum/fmedit/blob/master/CODE_OF_CONDUCT.md).
