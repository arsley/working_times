# WorkingTimes

![GitHub tag (latest by date)](https://img.shields.io/github/v/tag/arsley/working_times?style=flat-square)
[![Gem](https://img.shields.io/gem/v/working_times?style=flat-square)](https://rubygems.org/gems/working_times)
![GitHub](https://img.shields.io/github/license/arsley/working_times?style=flat-square)
![Travis (.com) branch](https://img.shields.io/travis/com/arsley/working_times/master?style=flat-square)

Store your working(worked) time simply.
It's just record woking timestamp on specific file.
By default, use `~/.wtconf` as a configuration, `~/.wt` as a data directory and `~/.wt/default` as a file to record.

## Feature

- Simple CLI
- Store working times like CSV format
- Customizeable config storeing directory and work group

## Installation

```
$ gem install working_times
```

## Usage

### CLI

```
$ wt

Commands:
  wt fi [COMMENT]              # Short hand for *finish*
  wt finish [COMMENT]          # Finish working on current group.
  wt help [COMMAND]            # Describe available commands or one specific command
  wt st [COMMENT]              # Short hand for *start*
  wt start [COMMENT] <option>  # Start working with comment.
```

Start working with `wt start`.

```
$ wt start
```

You can set comment with it.

```
$ wt start "Today, I will implement some great feature!"
```

And also, you can specify group depends on your work type.
If you not specify group, WorkingTimes uses `DEFAULTWORK` on configuration.

```
$ wt start --work-on=remote1
$ wt start -w daily
```

Finish working with `wt finish`.
It ends **current** working so you have not to specify group.

```
$ wt finish
```

Yes, you can set comment.

```
$ wt finish "What a sleepy day..."
```

Short hands are available.

```
$ wt st # same as 'wt start'
$ wt fi # same as 'wt finish'
```

### Config file

WorkingTimes loads configuration file at `~/.wtconf`.
Currently, you can set 2 values: `DATADIR` and `DEFAULTWORK`.
Here is a default configurations below.

```
# ~/.wtconf

DATADIR=/your/home/.wt
DEFAULTWORK=default
```

## Development

Install dependencies.

```
$ bin/setup
```

Run tests.

```
$ bundle exec rake
```

Check behavior without installation.

```
$ bundle exec exe/wt
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/arsley/working_times. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Code of Conduct

Everyone interacting in the WorkingTimes project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/arsley/working_times/blob/master/CODE_OF_CONDUCT.md).
