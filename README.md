# SeventeenMon

SeventeenMon simply help you find location by IP address. Data is totally based on [17MON.CN](http://tool.17mon.cn/).


## Compatibility

I have tested it on Ruby >= 1.9.3. Other versions are not tested but should work on well. Please contact me if not.

## Installation

Add this line to your application's Gemfile:

    gem 'seventeen_mon', git: "git@github.com:mycolorway/SeventeenMon.git"

And then execute:

    $ bundle

Or you can install simply by

    $ gem install seventeen_mon

## Usage

### In Ruby
```(ruby)
SM.find_by_ip "119.75.216.20"
# => {:country=>"中国", :province=>"北京", :city=>"北京"}

SM.find_by_address "http://taobao.com"
# => {:country=>"中国", :province=>"浙江", :city=>"杭州"}
```

### In Command Line

```(bash)
$ seventeen ip 188.74.78.234
Country:   英国
City:      英国


$ seventeen address https://github.com
Country:   美国
City:      美国
```

## Contributing

1. Fork it ( http://github.com/<my-github-username>/seventeen_mom/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Thanks

[高春辉 Paul Gao](http://tool.17mon.cn/) - for his awesome data.