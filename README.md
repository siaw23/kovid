[![Gem Version](https://badge.fury.io/rb/kovid.svg)](https://badge.fury.io/rb/kovid)
[![Open Source Helpers](https://www.codetriage.com/siaw23/kovid/badges/users.svg)](https://www.codetriage.com/siaw23/kovid)


If you're looking to consume this in your Ruby-based application, you might want to check [Sarskov](https://github.com/siaw23/sarskov) out. Sarskov returns statistics in a JSON format.

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
* `kovid check COUNTRY` aliased as `kovid country COUNTRY`.
* `kovid check COUNTRY -f` aliased as `kovid country COUNTRY --full`.

You can get continental information with the following commands:

* `kovid africa`.
* `kovid europe`.
* `kovid eu`. (The European Union)
* `kovid sa`. (South America)
* `kovid asia`.
* `kovid world`. (Worldwide Statistics)

🇺🇸🇺🇸🇺🇸

You can fetch US state-specific data:
* `kovid state STATE` OR `kovid state "STATE NAME"`.
* `kovid states --all` or `kovid states -a` for data on all US states.

Provinces

You can fetch province specific data:

* `kovid province PROVINCE` or `kovid province "PROVINCE NAME"`.

___
😷 **Comparing**
* `kovid compare FOO BAR` (sorts by cases DESC).
* `kovid compare FOO BAR -f` OR `kovid compare FOO BAR --full` (sorts by cases DESC).

Where `FOO` and `BAR` are different countries.

You can compare as many countries as you want; `kovid compare FOO BAR BAZ` OR `kovid compare FOO BAR BAZ -f`

🇺🇸🇺🇸🇺🇸

You can compare US states with:
* `kovid states STATE STATE` Example: `kovid states illinois "new york" california`

You can compare provicnes with:
* `kovid provinces PROVINCE PROVINCE` Example: `kovid provinces ontario manitoba`
___
😷 **History**
* `kovid history COUNTRY` (full history).
* `kovid history COUNTRY N` (history in the last N days).
___

**NOTE:** If you find it irritating to have to type `kovid state STATE`, `covid state STATE` works as well.

#### Histogram (Experimental) 🧪

`kovid histogram COUNTRY M.YY` (draws a histogram of cases in the given month `M` and years `YY`)
(If the histogram appears messy, you might want to resize your window.)

#### Commands Details
To fetch basic data on a country run:

`kovid check ghana`. If the location contains spaces: `kovid check "Diamond Princess"`

![kovid](https://i.gyazo.com/1d86ba2cd05f215b16c8d1fd13085c6e.png "Covid data.")

For full table info on a country:

`kovid check italy -f` OR `kovid check italy --full`

![kovid](https://i.gyazo.com/1d9720b9fa2c08fb801f5361fba359bb.png "Covid data.")

To compare country stats:

`kovid compare germany poland spain`

![kovid](https://i.gyazo.com/4100e845fea6936f5c8d21d78617110d.png "Covid data.")

To compare a countries stats with a full table:

`kovid compare poland italy usa china -f` OR `kovid compare poland italy usa china --full`

![kovid](https://i.gyazo.com/8b57865ae9b28f5afa895ebc49a2de31.png "Covid data.")

To fetch state-specific data run:

`kovid state colorado` OR `kovid state "north carolina"`

![kovid](https://i.gyazo.com/51509c3986f56bbc25068e0d541d9bdd.png "Covid data.")

To fetch EU data run:

`kovid eu`

![kovid](https://i.gyazo.com/0a78afae2a5b9d2beb9f2c61dc1d3ac7.png "Covid data.")

To fetch data on Africa:

`kovid africa`

![kovid](https://i.gyazo.com/bc45fa53e2ff688e8a1f759f1bd1b972.png "Covid data.")

You can check historical statistics by running

`kovid history italy 7` eg:

![kovid](https://i.gyazo.com/bc18fdaf99cacf2c921086f189d542b4.png "Covid data.")

To check for total figures:

`kovid world`

![kovid](https://i.gyazo.com/e01f4769a2b9e31ce50cec212e55810c.png "Covid data.")

## 👩🏾‍🔬 Experimental Feature

`kovid histogram italy 3.20` tries to build a histogram on number of cases. In the example here `3.20` is date in the format of `M.YY`. If you can please play with it and report issues on how this could be improved.

![kovid](https://i.gyazo.com/35833cba37be8ca10830fad066b85bb3.png "Covid data.")


## Data Source
> [JHU CSSE GISand Data](https://gisanddata.maps.arcgis.com/apps/opsdashboard/index.html#/bda7594740fd40299423467b48e9ecf6) and https://www.worldometers.info/coronavirus/ via [NovelCOVID/API](https://github.com/novelcovid/api)


## 👨‍💻 Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.


## 🤲 Contributing

There are multiple areas in this repo that can be improved or use some refactoring(there's a lot to be refactored in fact!). For that reason, bug reports and pull requests are welcome! This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/siaw23/kovid/blob/master/CODE_OF_CONDUCT.md).


## 🔖 License

The gem is available as open-source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## ❤️ Code of Conduct

Everyone interacting in the Kovid project's codebases and issue trackers is expected to follow the [code of conduct](https://github.com/siaw23/kovid/blob/master/CODE_OF_CONDUCT.md).
