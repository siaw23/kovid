# 🦠 Kovid

Kovid is a very simple CLI to to fetch data surrounding the coronavirus pandemic. I found myself checking [Wikipedia](https://en.wikipedia.org/wiki/2019%E2%80%9320_coronavirus_pandemic) constantly for information and since I work mostly in the terminal, like most of you, I thought I'd build this to put the data right at our fingertips.

Please feel free to contribute or suggest ideas!

## ⚙️ Installation


You can install it by running:

    $ gem install kovid

## ⚒️ Usage

To fetch basic data on a country run:

`kovid country ghana`

![kovid](https://i.gyazo.com/c95aa03d01c63ee1256dd28f66e1b657.png "Covid data.")

For a full table info on a country:

`kovid country poland -f` OR `kovid country poland --full`

![kovid](https://i.gyazo.com/48797cc6314e5685a34146d4cd749fa3.png "Covid data.")

## 👨‍💻 Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## 🤲 Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/siaw23/kovid. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/siaw23/kovid/blob/master/CODE_OF_CONDUCT.md).


## 🔖 License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## ❤️ Code of Conduct

Everyone interacting in the Kovid project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/siaw23/kovid/blob/master/CODE_OF_CONDUCT.md).
