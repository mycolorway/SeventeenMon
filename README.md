# SeventeenMon

SeventeenMon simply help you find location by IP address. Data is totally based on [17MON.CN](http://tool.17mon.cn/).


## Installation

Add this line to your application's Gemfile:

    gem 'seventeen_mon', git: "git@github.com:mycolorway/SeventeenMon.git"

And then execute:

    $ bundle

Or you can install simply by

    $ gem install seventeen_mon

## Usage

```(ruby)
SeventeenMon.find_by_ip ip: "YOUR_IP_ADDRESS"
# => {:country=>"英国", :city=>"英国"}

SM.find_by_address address: "ruby-lang.com", protocol: "http"
# => {:country=>"荷兰", :city=>"荷兰"}
```

## Contributing

1. Fork it ( http://github.com/<my-github-username>/seventeen_mom/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Thanks

[高春辉 Paul Gao](http://tool.17mon.cn/) - for his awesome data.