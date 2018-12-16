# SeventeenMon

SeventeenMon simply help you find location by IP address. Data is totally based on [IPIP.NET](https://www.ipip.net/product/client.html).

Version >= 2.0 only support ipdb format.

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
$ seventeen ip 119.75.216.20
Country:   中国
Province:  北京
City:      北京


$ seventeen seventeen address http://taobao.com
Country:   中国
Province:  浙江
City:      杭州
```

## TODO

* [ ] More meta data info
* [ ] Support paid version format

## Contributing

1. Fork it ( http://github.com/<my-github-username>/seventeen_mom/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Thanks

[高春辉 Paul Gao](https://www.ipip.net) - for his awesome data.
