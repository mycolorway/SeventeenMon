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
      @language = params[:language]
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

    def binary_ip
      @binary_ip ||= [ ip2long ].pack("N").unpack("cccc")
    end

    def find
      throw IPDB.instance.check unless :ok == IPDB.instance.check
      four_number # TODO IPV6

      meta_data = IPDB.instance.meta_data
      language_offset = meta_data["languages"][@language]
      fields_length = meta_data["fields"].length
      languages_length= meta_data["languages"].length

      ip_string_list = IPDB.instance.resolve(binary_ip).split("\t", fields_length * languages_length)
      result = ip_string_list[language_offset..language_offset + fields_length - 1]

      {
        country: result[0],
        province: result[1],
        city: result[2]
      }
      # TODO more fields
    end
  end
end
