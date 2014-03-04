# coding: utf-8

require "seventeen_mon/version"
require "socket"
require "iconv"

module SeventeenMon
  class IPDB

    private_class_method :new

    def ip_db_path
      @ip_db_path ||= File.expand_path'../data/17monipdb.dat', __FILE__
    end
    def ip_db
      @ip_db ||= File.open ip_db_path, 'rb'
    end

    def offset
      @offset ||= ip_db.read(4).unpack("Nlen")[0]
    end

    def index
      @index ||= ip_db.read(offset - 4)
    end

    def max_comp_length
      @max_comp_length ||= offset - 1028
    end

    def start
      @start ||= begin
        tmp_offset = IP.find_by_ip ip
      end
    end

    def self.instance
      @instance ||= self.send :new
    end

    def seek(_offset, length)
      IO.read(ip_db_path, length, offset + _offset - 1024).split "\t"
    end
  end

  class IP
    attr_reader :ip

    def initialize(ip: nil, address: nil, protocol: nil)
      @ip = ip || Socket.getaddrinfo(address, protocol)[0][3]
    end

    def four_number
      @four_number ||= begin
        fn = ip.split(".").map(&:to_i)
        raise "ip is no valid" if fn.length != 4 || fn.any?{ |d| d < 0 || d > 255}
        fn
      end
    end

    def ip2long
      four_number[0] + four_number[1] * 256 + four_number[2] * 65536
        + four_number[3] * 16777216
    end

    def packed_ip
      [ ip2long ].pack 'N'
    end
  end

  def self.find_by_ip(_ip)
    ip = IP.new ip: _ip

    tmp_offset = ip.four_number[0] * 4
    start = IPDB.instance.index[tmp_offset..(tmp_offset + 3)].unpack("Vlen")[0] * 8 + 1024

    index_offset = nil

    while start < IPDB.instance.max_comp_length

      if IPDB.instance.index[start..(start + 3)] >= ip.packed_ip
        index_offset = "#{IPDB.instance.index[(start + 4)..(start + 6)]}\x0".unpack("Vlen")[0]
        index_length = IPDB.instance.index[(start + 7)].unpack("Clen")[0]
        break
      end
      start += 8
    end

    return "N/A" unless index_offset

    # puts index_offset, index_length
    IPDB.instance.seek(index_offset, index_length).map do |str|
      Iconv.conv("UTF-8", "UTF-8", str)
    end
  end
end