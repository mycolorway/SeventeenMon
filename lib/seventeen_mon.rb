# coding: utf-8

module SeventeenMon
  require "socket"
  require "ipaddr"
  require "seventeen_mon/version"
  require "seventeen_mon/ipdb"
  require "seventeen_mon/ip"

  def self.find_by_ip(_ip, lang = "CN")
    IP.new(ip: _ip, language: lang).find
  end

  def self.find_by_address(_address, lang = "CN")
    prot, addr = _address.split("://")
    IP.new(address: addr, protocol: prot, language: lang).find
  end
end

SM = SeventeenMon
