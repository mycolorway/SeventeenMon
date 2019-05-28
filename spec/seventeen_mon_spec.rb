require 'spec_helper'

describe SeventeenMon do
  describe "# IPDB loading" do
    it 'should be eager loaded' do
      ipdb1 = SM::IPDB.instance
      ipdb2 = SM::IPDB.instance

      expect(ipdb1.object_id).to eq(ipdb2.object_id)
    end
  end

  describe "# query test" do
    before do
      @ip_param = "129.215.5.255"
      @url_param = "http://www.ruby-lang.com"
      @threads = 100
    end

    it "can find location by IP" do
      result = SM.find_by_ip @ip_param
      expect(result).to include(:city)
      expect(result).to include(:province)
      expect(result).to include(:country)
    end

    it "can find location by address" do
      result = SM.find_by_address @url_param
      expect(result).to include(:city)
      expect(result).to include(:province)
      expect(result).to include(:country)
    end

    it "can find location by local IP" do
      result = SM.find_by_ip '127.0.0.1'
      expect(result).to include(:city)
      expect(result).to include(:province)
      expect(result).to include(:country)
    end

    it "can run in a multi-threaded environment" do
      threads = []
      @threads.times { threads << Thread.new { SM.find_by_ip(@ip_param) } }
      threads.each { |t| t.join }
    end

    it "can get IPDB metadata" do
      expect(SM.metadata).to respond_to(
        :build_time,
        :fields,
        :ip_version,
        :languages,
        :node_count,
        :total_size,
        :origin_metadata
      )

      require 'set'
      result = Set.new(SM.metadata.origin_metadata.keys)
      expect(result).to eq(Set.new(%w[build fields ip_version languages node_count total_size]))
    end
  end
end
