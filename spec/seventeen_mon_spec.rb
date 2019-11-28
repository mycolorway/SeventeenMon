require 'spec_helper'

describe SeventeenMon do
  describe "# IPDB loading" do
    it 'should be eager loaded' do
      ipdb_1 = SM::IPDB.instance
      ipdb_2 = SM::IPDB.instance

      expect(ipdb_1.object_id).to eq(ipdb_2.object_id)
    end
  end

  describe "# query test" do
    before do
      @ip_param = "129.215.5.255"
      @url_param = "http://www.ruby-lang.com"
    end

    it "can find location by ip" do
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
  end
end