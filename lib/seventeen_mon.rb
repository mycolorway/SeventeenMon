module SeventeenMon
  require "socket"
  require "ipaddr"
  require "seventeen_mon/version"
  require "seventeen_mon/ipdb"
  require "seventeen_mon/ipdb_metadata"
  require "seventeen_mon/ip"

  class << self
    def find_by_ip(ip, lang = "CN")
      IP.new(ip: ip, language: lang).find
    end

    def find_by_address(address, lang = "CN")
      prot, addr = address.split("://")
      IP.new(address: addr, protocol: prot, language: lang).find
    end

    def metadata
      IPDBMetadata.new(IPDB.instance.metadata)
    end
  end
end

SM = SeventeenMon
