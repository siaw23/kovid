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

![kovid](https://i.gyazo.com/ee88b41c05da3be0295dd3a158e7ba70.png "Covid data.")

For full table info on a country:

`kovid check italy -f` OR `kovid check italy --full`

![kovid](https://i.gyazo.com/7e5afce548d8a01b9bdf3f8bdb529cd1.png "Covid data.")

To compare country stats:

`kovid compare germany poland`

![kovid](https://i.gyazo.com/876b19988da4cd7b375cde3e23376ba7.png "Covid data.")

To compare a countries stats with a full table:

`kovid compare poland italy usa china -f` OR `kovid compare poland italy usa china --full`

![kovid](https://i.gyazo.com/8b57865ae9b28f5afa895ebc49a2de31.png "Covid data.")

To fetch state-specific data run:

`kovid state colorado` OR `kovid state "north carolina"`

![kovid](https://i.gyazo.com/51509c3986f56bbc25068e0d541d9bdd.png "Covid data.")

To fetch EU data run:

`kovid eu`

![kovid](https://i.gyazo.com/0a78afae2a5b9d2beb9f2c61dc1d3ac7.png "Covid data.")

You can check historical statistics by running

`kovid history italy 7` eg:

![kovid](https://i.gyazo.com/bc18fdaf99cacf2c921086f189d542b4.png "Covid data.")

To check for total figures:

`kovid cases`

![kovid](https://i.gyazo.com/e01f4769a2b9e31ce50cec212e55810c.png "Covid data.")

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
