# 🦠 Kovid

[gem]: https://rubygems.org/gems/kovid

Kovid is a small CLI app to fetch data surrounding the coronavirus pandemic of 2019. I found myself checking [Wikipedia](https://en.wikipedia.org/wiki/2019%E2%80%9320_coronavirus_pandemic) constantly for information and since I work mostly in the terminal, like some of you, I thought I'd build this to put the data right at our fingertips.

Please feel free to contribute or suggest ideas!

## ⚙️ Installation

Before installing:

☝️ Wash your hands with soap and water for at least 20 seconds.

✌️ Run `gem install kovid`



## ⚒️ Usage

You can run `kovid --help` to see the full list of available commands.

**NOTE:** If you find it irritating to have to type `kovid state STATE`, `covid state STATE` works as well.

#### Commands Overview
😷 **Fetching**
* `kovid check COUNTRY`
* `kovid check COUNTRY -f` OR `kovid check COUNTRY --full`

🇺🇸You can fetch US state-specific data 🇺🇸
* `kovid state STATE` OR `kovid state "STATE WITH SPACES"`

😷 **Comparing**
* `kovid compare COUNTRYA COUNTRYB` (sorts by cases DESC)
* `kovid compare COUNTRYA COUNTRYB -f` OR `kovid compare COUNTRYA COUNTRYB --full` (sorts by cases DESC)

You can compare as many countries as you want.

😷 **History**
* `kovid history COUNTRY`

😷 **Total figures**
* `kovid cases`



#### Commands Details
To fetch basic data on a country run:

`kovid check ghana`

If the location contains spaces: `kovid check "Diamond Princess"`

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

`kovid state colorado`

![kovid](https://i.gyazo.com/d00b1c5bbb6251cbd517f801c856ba66.png "Covid data.")

You can check historical statistics by running

`kovid history COUNTRY` eg:

![kovid](https://i.gyazo.com/45d306694cbf793f2e4f7646854cbac8.png "Covid data.")

To check for total figures:

`kovid cases`

![kovid](https://i.gyazo.com/323f0f10d444e2ee629d05a90488adba.png "Covid data.")

## Information Source
> https://www.worldometers.info/coronavirus/ via [NovelCOVID/API](https://github.com/novelcovid/api)


## 👨‍💻 Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.


## 🤲 Contributing

There are multiple areas in this repo that can be improved or use some refactoring(there's a lot to be refactorted in fact!). For that reason, bug reports and pull requests are welcome! This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/siaw23/kovid/blob/master/CODE_OF_CONDUCT.md).


## 🔖 License

The gem is available as open-source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## ❤️ Code of Conduct

Everyone interacting in the Kovid project's codebases and issue trackers is expected to follow the [code of conduct](https://github.com/siaw23/kovid/blob/master/CODE_OF_CONDUCT.md).
