# 🦠 Kovid

Kovid is a small CLI app to fetch data surrounding the coronavirus pandemic of 2019. I found myself checking [Wikipedia](https://en.wikipedia.org/wiki/2019%E2%80%9320_coronavirus_pandemic) constantly for information so I thought I'd build this to provide info directly in the terminal. It's where some of us spend time more.

Code contribution and ideas welcome.


## ⚙️ Installation

To install:

* ️ Wash your hands with soap and water for at least 20 seconds.

*  Run `gem install kovid`.

It's recommended you update often with `gem update kovid`.

## ⚒️ Usage

You can run `kovid --help` to see the full list of available commands.

#### Commands Overview
😷 **Fetching**
* `kovid check COUNTRY` OR `kovid country COUNTRY`.
* `kovid check COUNTRY -f` OR `kovid check COUNTRY --full`.

🇪🇺🇪🇺🇪🇺

You can fetch aggregated EU (all 27 countries combined) data:
* `kovid eu`.

🇺🇸🇺🇸🇺🇸

You can fetch US state-specific data:
* `kovid state STATE` OR `kovid state "STATE NAME"`.

😷 **Comparing**
* `kovid compare FOO BAR` (sorts by cases DESC).
* `kovid compare FOO BAR -f` OR `kovid compare FOO BAR --full` (sorts by cases DESC).

Where `FOO` and `BAR` are different countries.

You can compare as many countries as you want; `kovid compare FOO BAR BAZ` OR `kovid compare FOO BAR BAZ -f`

😷 **History**
* `kovid history COUNTRY` (full history).
* `kovid history COUNTRY N` (history in the last N days).

😷 **Total figures**
* `kovid cases` (summary of reported incidents globally).

**NOTE:** If you find it irritating to have to type `kovid state STATE`, `covid state STATE` works as well.

#### Commands Details
To fetch basic data on a country run:

`kovid check ghana`. If the location contains spaces: `kovid check "Diamond Princess"`

![kovid](https://i.gyazo.com/ab779c3fc838ac279bae5b9d6d10d617.png "Covid data.")

For full table info on a country:

`kovid check italy -f` OR `kovid check italy --full`

![kovid](https://i.gyazo.com/789fa6795d06f529a9b5f37cb51fb516.png "Covid data.")

To compare country stats:

`kovid compare germany poland`

![kovid](https://i.gyazo.com/be3bcba3d2943c60618b59ae82a3c586.png "Covid data.")

To compare a countries stats with a full table:

`kovid compare poland italy usa china -f` OR `kovid compare poland italy usa china --full`

![kovid](https://i.gyazo.com/79ad61c33114a0bee0a9e2ab94a3d46e.png "Covid data.")

To fetch state-specific data run:

`kovid state colorado` OR `kovid state "north carolina"`

![kovid](https://i.gyazo.com/d00b1c5bbb6251cbd517f801c856ba66.png "Covid data.")

To fetch EU data run:

`kovid eu`

![kovid](https://i.gyazo.com/51d2adcb8e9feb0a0fbe38ff9cf4c550.png "Covid data.")

You can check historical statistics by running

`kovid history italy 7` eg:

![kovid](https://i.gyazo.com/e4872b5047eeaebbd354847a943de268.png "Covid data.")

To check for total figures:

`kovid cases`

![kovid](https://i.gyazo.com/323f0f10d444e2ee629d05a90488adba.png "Covid data.")

## Information Source
> https://www.worldometers.info/coronavirus/ via [NovelCOVID/API](https://github.com/novelcovid/api)


## 👨‍💻 Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.


## 🤲 Contributing

There are multiple areas in this repo that can be improved or use some refactoring(there's a lot to be refactored in fact!). For that reason, bug reports and pull requests are welcome! This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/siaw23/kovid/blob/master/CODE_OF_CONDUCT.md).


## 🔖 License

The gem is available as open-source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## ❤️ Code of Conduct

Everyone interacting in the Kovid project's codebases and issue trackers is expected to follow the [code of conduct](https://github.com/siaw23/kovid/blob/master/CODE_OF_CONDUCT.md).
