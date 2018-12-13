module SeventeenMon
  require 'singleton'

  class IPDB
    include Singleton

    def ip_db_path
      @ip_db_path ||= File.expand_path'../../data/17monipdb.dat', __FILE__
    end
    def ip_db
      @ip_db ||= File.open ip_db_path, 'rb'
    end

    def offset
      @offset ||= IO.read(ip_db_path, 4, 0).unpack("Nlen")[0]
    end

    def index
      @index ||= IO.read(ip_db_path, (offset - 4), 4)
    end

    def max_comp_length
      @max_comp_length ||= offset - 1028
    end

    def seek(_offset, length)
      IO.read(ip_db_path, length, offset + _offset - 1024).split "\t"
    end
  end
end
