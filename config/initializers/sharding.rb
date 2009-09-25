TEXTS_SHARDING_RANGES = {
  0...100   => :shard1,
  100..200  => :shard2,
  :default  => :shard3
}

DbCharmer::Sharding.register_connection(
  :name => :texts,
  :method => :range,
  :ranges => TEXTS_SHARDING_RANGES
)
