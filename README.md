# 🦠 Kovid

Kovid is a small CLI app to fetch data surrounding the coronavirus pandemic of 2019. I found myself checking [Wikipedia](https://en.wikipedia.org/wiki/2019%E2%80%9320_coronavirus_pandemic) constantly for information and since I work mostly in the terminal, like most of you, I thought I'd build this to put the data right at our fingertips.



Please feel free to contribute or suggest ideas!

## ⚙️ Installation

Before installing:

☝️ Wash your hands with soap and water for at least 20 seconds.

✌️ Run `$ gem install kovid`


After installing:

☝️ Avoid touching your eyes, nose and mouth with unwashed hands later.

✌️ Disinfect your phones, keys, doorknobs and anything you touch often than you should.



## ⚒️ Usage

You can run `kovid --help` to see full list of available commands.

#### Commands Overview
 **Fetching**
* `kovid check ghana`
* `kovid check ghana -f` OR `kovid check ghana --full`

**Comparing**
* `kovid compare ghana poland`
* `kovid compare ghana poland -f` OR `kovid compare ghana poland --full`

**Total figures**
* `kovid cases`



#### Commands Details
To fetch basic data on a country run:

`kovid check ghana`

If the location contains spaces: `kovid check "Diamond Princess"`

![kovid](https://i.gyazo.com/ca57d9250c7523a921d0d7e1104716be.png "Covid data.")

For full table info on a country:

`kovid check ghana -f` OR `kovid check ghana --full`

![kovid](https://i.gyazo.com/628f07faf8e3c1c2a0b6ab05e4a86404.png "Covid data.")

To compare country stats:

`kovid compare ghana poland`

![kovid](https://i.gyazo.com/a15922e13e9e6c1ba804ccf5beeb863b.png "Covid data.")

To compare a countries stats with a full table:

`kovid compare ghana poland -f` OR `kovid compare ghana poland --full`

![kovid](https://i.gyazo.com/d0b72207765090b118a5b76d72ddde19.png "Covid data.")

To check for total figures:

`kovid cases`

![kovid](https://i.gyazo.com/f8a21ae54152cd945fbb124b72d12ff7.png "Covid data.")

## 👨‍💻 Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## 🤲 Contributing

There are multiple areas in this repo that can be improved  or use some refactoring and for thats why bug reports and pull requests are welcome here on GitHub. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/siaw23/kovid/blob/master/CODE_OF_CONDUCT.md).


## 🔖 License

The gem is available as open-source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## ❤️ Code of Conduct

Everyone interacting in the Kovid project's codebases and issue trackers is expected to follow the [code of conduct](https://github.com/siaw23/kovid/blob/master/CODE_OF_CONDUCT.md).
