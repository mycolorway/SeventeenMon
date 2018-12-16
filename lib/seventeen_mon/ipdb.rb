module SeventeenMon
  require 'singleton'
  require 'json'

  class IPDB
    include Singleton

    def ip_db_path
      @ip_db_path ||= File.expand_path'../../data/ipip.ipdb', __FILE__
    end

    def ip_db
      @ip_db ||= File.open ip_db_path, 'rb'
    end

    def meta_length
      @meta_length ||= IO.read(ip_db_path, 4, 0).unpack("N")[0]
    end

    # {
    #   "build"      => 1535696240,
    #   "ip_version" => 1,
    #   "languages"  => { "CN" => 0 },
    #   "node_count" => 385083,
    #   "total_size" => 3117287,
    #   "fields"     => [ "country_name", "region_name", "city_name" ]
    # }
    def meta_data
      @meta_data ||= JSON.parse(IO.read(ip_db_path, meta_length, 4))
    end

    def meta_data_offset
      @meta_data_offset ||= 4 + meta_length
    end

    def data_length
      @data_length ||= file_length - meta_data_offset
    end

    def data
      @data ||= IO.read(ip_db_path, data_length, meta_data_offset)
    end

    def check
      @check_meta_data ||= check_meta_data
    end

    def check_meta_data
      if data_length != meta_data["total_size"]
        return "database file size error"
      end

      :ok
    end

    def ipv4_offset
      @ipv4_offset ||= _ipv4_offset
    end

    def file_length
      @file_length ||= File.size(ip_db)
    end

    def resolve(binary_ip)
      node = find_node(binary_ip)

      resoloved = node - meta_data["node_count"] + meta_data["node_count"] * 8

      if resoloved >= file_length
        throw "database resolve error"
      end

      size = data.byteslice(resoloved + 1, 1).unpack("c")[0]
      if data_length < (resoloved + 2 + size)
        throw "database resolve error"
      end

      data.byteslice(resoloved + 2, size).encode("UTF-8", "UTF-8")
    end

    private

    def find_node(binary)
      # TODO IPV6
      bit = 4 * 8
      node = ipv4_offset

      for i in 0..bit - 1
        if node > meta_data["node_count"]
          return node
        end

        node = read_node(node, 1 & ((0xFF & binary[i / 8]) >> 7 - (i % 8)))
      end

      throw "ip not found"
    end

    def _ipv4_offset
      node = 0
      if 1 == meta_data["ip_version"]
        i = 0
        while i < 96 && node < meta_data["node_count"]
          if i >= 80
            node = read_node(node, 1)
          else
            node = read_node(node, 0)
          end

          i += 1
        end
      end

      node
    end

    def read_node(node, index)
      off = node * 8 + index * 4
      data.byteslice(off, 4).unpack("N")[0]
    end
  end
end
