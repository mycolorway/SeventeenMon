module SeventeenMon
  class IPDBMetadata
    attr_reader :build_time, :fields, :ip_version, :languages, :node_count, :total_size, :origin_metadata

    def initialize(metadata)
      @origin_metadata = metadata
      @build_time = Time.at(metadata['build'])
      @fields     = metadata['fields']
      @ip_version = metadata['ip_version']
      @languages  = metadata['languages']
      @node_count = metadata['node_count']
      @total_size = metadata['total_size']
    end
  end
end
