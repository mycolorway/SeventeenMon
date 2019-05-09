module SeventeenMon
  require 'singleton'
  require 'json'

  class IPDB
    include Singleton

    def ip_db_path
      @ip_db_path ||= File.expand_path('../data/ipip.ipdb', __dir__)
    end

    def ip_db_bin
      @ip_db_bin = File.binread ip_db_path
    end

    # Length of the entire IPDB file.
    def file_length
      @file_length ||= ip_db_bin.length
    end

    # The first 4 bytes(32-bit unsigned integer) of data are used to record the length of the metadata.
    META_LENGTH_OFFSET = 4

    # Length of metadata.
    def meta_length
      @meta_length ||= ip_db_bin[0...META_LENGTH_OFFSET].unpack('N')[0]
    end

    # Length of the entire non-data area.
    def metadata_offset
      @metadata_offset ||= META_LENGTH_OFFSET + meta_length
    end

    # Metadata.
    # @return [Hash]
    # @example
    # {
    #   "build"      => 1535696240,
    #   "ip_version" => 1,
    #   "languages"  => { "CN" => 0 },
    #   "node_count" => 385083,
    #   "total_size" => 3117287,
    #   "fields"     => [ "country_name", "region_name", "city_name" ]
    # }
    def metadata
      @metadata ||= JSON.parse(ip_db_bin[META_LENGTH_OFFSET...metadata_offset])
    end

    def node_count
      @node_count ||= metadata["node_count"]
    end

    # Length of data.
    def data_length
      @data_length ||= file_length - metadata_offset
    end

    def data
      @data ||= ip_db_bin[metadata_offset...file_length]
    end

    def check
      @check ||= check_metadata
    end

    def check_metadata
      return "database file size error" if data_length != metadata["total_size"]

      :ok
    end

    # @param [:v4, :v6] ip_version
    def ip_offset(ip_version)
      ip_version == :v4 ? @ip_offset_v4 ||= _ip_offset(ip_version) : @ip_offset_v6 ||= _ip_offset(ip_version)
    end

    def resolve(binary_ip)
      node = find_node(binary_ip)

      resoloved = node - node_count + node_count * 8

      throw "database resolve error" if resoloved >= file_length

      size = data.byteslice(resoloved + 1, 1).unpack("c")[0]

      throw "database resolve error" if data_length < (resoloved + 2 + size)

      data.byteslice(resoloved + 2, size).encode("UTF-8", "UTF-8")
    end

    private

    def find_node(binary)
      bit = binary.length * 8
      node = ip_offset(bit == 32 ? :v4 : :v6)

      (0...bit).each do |i|
        break if node > node_count

        node = read_node(node, 1 & ((0xFF & binary[i / 8]) >> 7 - (i % 8)))
      end

      return node if node > node_count

      throw "ip not found"
    end

    def _ip_offset(ip_version)
      node = 0

      return node if ip_version == :v6

      if metadata["ip_version"] == 1
        i = 0
        while i < 96 && node < node_count
          node = if i >= 80
                   read_node(node, 1)
                 else
                   read_node(node, 0)
                 end

          i += 1
        end
      end

      node
    end

    def read_node(node, index)
      off = node * 8 + index * 4
      data.byteslice(off, 4).unpack('N')[0]
    end
  end
end
