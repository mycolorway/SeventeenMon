module SeventeenMon
  class IP
    attr_reader :ip

    # Initialize IP object
    #
    # == parameters:
    # params::
    #   Might contain address(hostname) and protocol, or just IP
    #
    # == Returns:
    # self
    #
    def initialize(params = {})
      @ip = params[:ip] ||
        Socket.getaddrinfo(params[:address], params[:protocol])[0][3]
    end

    def four_number
      @four_number ||= begin
        fn = ip.split(".").map(&:to_i)
        raise "ip is no valid" if fn.length != 4 || fn.any?{ |d| d < 0 || d > 255}
        fn
      end
    end

    def ip2long
      @ip2long ||= ::IPAddr.new(ip).to_i
    end

    def packed_ip
      @packed_ip ||= [ ip2long ].pack 'N'
    end

    def find
      tmp_offset = four_number[0] * 4
      start = IPDB.instance.index[tmp_offset..(tmp_offset + 3)].unpack("V")[0] * 8 + 1024

      index_offset = nil

      while start < IPDB.instance.max_comp_length
        if IPDB.instance.index[start..(start + 3)] >= packed_ip
          index_offset = "#{IPDB.instance.index[(start + 4)..(start + 6)]}\x0".unpack("V")[0]
          index_length = IPDB.instance.index[(start + 7)].unpack("C")[0]
          break
        end
        start += 8
      end

      return "N/A" unless index_offset

      result = IPDB.instance.seek(index_offset, index_length).map do |str|
        str.encode("UTF-8", "UTF-8")
      end

      {
        country: result[0],
        province: result[1],
        city: result[2]
      }
    end
  end
end