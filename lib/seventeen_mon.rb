# coding: utf-8

module SeventeenMon
  require "socket"
  require "iconv"
  require "ipaddr"
  require "seventeen_mon/version"
  require "seventeen_mon/ipdb"
  require "seventeen_mon/ip"

  def self.find_by_ip(_ip)
    IP.new(ip: _ip).find
  end

  def self.find_by_address(address: nil, protocol: "http")
    IP.new(address: address, protocol: protocol).find
  end
end

SM = SeventeenMon