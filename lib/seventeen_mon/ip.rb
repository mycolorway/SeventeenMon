module SeventeenMon
  class IP
    attr_reader :ip, :ip_addr

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
      @ip = params[:ip] || Socket.getaddrinfo(params[:address], params[:protocol])[0][3]
      @ip_addr = IPAddr.new(ip)
      @language = params[:language]
    end

    def binary_ip
      @binary_ip ||= ip_addr.ipv4? ? ip_addr.hton.unpack('c' * 4) : ip_addr.hton.unpack('c' * 16)
    end

    def find
      checked = IPDB.instance.check
      throw checked unless checked == :ok

      metadata = IPDB.instance.metadata
      language_offset = metadata["languages"][@language]
      fields_length = metadata["fields"].length
      languages_length = metadata["languages"].length

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
