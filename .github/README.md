# All Seeing Eye

The All Seeing Eye is a Multipurpose Discord bot programmed in Ruby.

## Installation

### Prerequisites

To install this bot. You will need:

* Ruby >= 2.4
* Discordrb
* SQLite3
* SQLite3 Ruby Interface

### Installing SQLite3

If you already do have SQLite3 and the gem installed, head over to the [main installation](#Installing).

1. Download the [windows binaries](https://sqlite.org/download.html) and extract them to your Ruby installation's bin folder.

2. Follow the steps [here](https://stackoverflow.com/questions/15480381/how-do-i-install-sqlite3-for-ruby-on-windows#16023062) and install the gem for sqlite3.

### Installing

1. Clone the repository.

```
$ git clone https://github.com/lordDashh/AllSeeingEye.git
```

2. Use bundler to install Discordrb:
```
bundle install
```
or install it yourself:
```
gem install discordrb --platform=ruby
```

2. In the data folder, Rename `config.example.json` to `config.json` and replace the values with yours.
3. Get into the project's directory and run the bot!

```
cd AllSeeingEye
ruby main.rb
```

## License

This project is licensed under the MIT License.

## Acknowledgments

* The cool people who created Discordrb
* Inspiration
* My fingers
