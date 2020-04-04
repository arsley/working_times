# WorkingTimes

![GitHub tag (latest by date)](https://img.shields.io/github/v/tag/arsley/working_times?style=flat-square)
[![Gem](https://img.shields.io/gem/v/working_times?style=flat-square)](https://rubygems.org/gems/working_times)
![GitHub](https://img.shields.io/github/license/arsley/working_times?style=flat-square)
![GitHub Workflow Status](https://img.shields.io/github/workflow/status/arsley/working_times/Ruby?label=Ruby&style=flat-square)

Store your working(worked) time simply.
It's just record woking timestamp on specific file.
Default record format is:

```
STARTED_AT,FINISHED_AT,REST_SEC,COMMENT
```

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
  wt fi [COMMENT]                  # Short hand for *finish*
  wt finish [COMMENT]              # Finish working on current group.
  wt help [COMMAND]                # Describe available commands or one specific command
  wt init WORKON [TERM] [COMPANY]  # initialize data directory for your working
  wt rest DURATION                 # Record resting time. e.g. 'wt rest 1h30m''wt rest 1 hour 30 minutes'
  wt st [COMMENT]                  # Short hand for *start*
  wt start [COMMENT]               # Start working with comment.
```

Before start work, you have to initialize directory which stores *working times*.

```
$ wt init company_worktime
```

It creates directories like:

```
company_worktime
├── terms/
└── wtconf.json
```

You can also set 'term' (default is 'default') and 'company' (default is '') name (both is optional).

```
$ wt init company_worktime week1 'Arsley co.,ltd'
```

Start working with `wt start`.

```
$ wt start
```

You can set comment with it.

```
$ wt start "Today, I will implement some great feature!"
```

A: How long do you want to take a rest? <br>
B: I need 45 minutes. <br>
C: Ah... 1 hour? <br>
D: '1h 30m' <br>
A:

```
$ wt rest 45m # B
$ wt rest 1h  # C
$ wt rest '1h 30m' # D
```

(You can use 'hour' as 'h' and 'minute' as 'm')
(`DURATION` must be a **single** string)

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

WorkingTimes loads configuration file at `current_directory/wtconf.json`.
Currently, you can set 2 values: `term` and `company`. (You also set on `wt init`)
Here is a default configurations below.

```
# wtconf.json

{
  "term": "week1",
  "company": "Arsley co.,ltd"
}
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
$ bundle exec wt
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/arsley/working_times. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Code of Conduct

Everyone interacting in the WorkingTimes project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/arsley/working_times/blob/master/CODE_OF_CONDUCT.md).
