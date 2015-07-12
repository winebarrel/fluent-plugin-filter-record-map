describe Fluent::RecordMapFilter do
  let(:driver) { create_driver(fluentd_conf) }
  let(:time) { Time.parse('2015/05/24 18:30 UTC').to_i }

  let(:records) do
    [
      {"foo"=>"bar", "zoo"=>"baz"},
      {"foo"=>"zoo", "bar"=>"baz"}
    ]
  end

  let(:fluentd_conf) do |example|
    {map: example.example_group.description }
  end

  before do
    records.each do |record|
      driver.emit(record, time)
    end

    driver.run
  end

  subject { driver.emits }

  context 'new_record["new_foo"] = record["foo"].upcase' do
    it do
      is_expected.to eq [
        ["test.default", time, {"new_foo"=>"BAR"}],
        ["test.default", time, {"new_foo"=>"ZOO"}]
      ]
    end
  end

  context 'new_record["new_foo"] = record["foo"].upcase; new_record["bar"] = 100' do
    it do
      is_expected.to eq [
        ["test.default", time, {"new_foo"=>"BAR", "bar"=>100}],
        ["test.default", time, {"new_foo"=>"ZOO", "bar"=>100}]
      ]
    end
  end

  context 'record.each {|k, v| new_record["prefix." + k] = v.upcase }' do
    it do
      is_expected.to eq [
        ["test.default", time, {"prefix.foo"=>"BAR", "prefix.zoo"=>"BAZ"}],
        ["test.default", time, {"prefix.foo"=>"ZOO", "prefix.bar"=>"BAZ"}]
      ]
    end
  end

  context 'new_record["foo"] = tag + "." + record["foo"]; new_record["bar"] = tag_parts[1]' do
    it do
      is_expected.to eq [
        ["test.default", time, {"foo"=>"test.default.bar", "bar"=>"default"}],
        ["test.default", time, {"foo"=>"test.default.zoo", "bar"=>"default"}]
      ]
    end
  end
end
