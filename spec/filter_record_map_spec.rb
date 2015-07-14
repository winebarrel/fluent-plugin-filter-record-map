describe Fluent::RecordMapFilter do
  let(:driver) { create_driver(fluentd_conf) }
  let(:time) { Time.parse('2015/05/24 18:30 UTC').to_i }

  let(:records) do
    [
      {"foo"=>"bar", "zoo"=>"baz"},
      {"foo"=>"zoo", "bar"=>"baz"}
    ]
  end

  before do
    allow(Socket).to receive(:gethostname) { 'my-host' }

    records.each do |record|
      driver.emit(record, time)
    end

    driver.run
  end

  subject { driver.emits }

  context 'single map' do
    let(:fluentd_conf) do |example|
      {map1: example.example_group.description }
    end

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

    context 'new_record["hostname"] = hostname' do
      it do
        is_expected.to eq [
          ["test.default", time, {"hostname"=>"my-host"}],
          ["test.default", time, {"hostname"=>"my-host"}]
        ]
      end
    end
  end

  context 'multi map' do
    let(:fluentd_conf) do |example|
      conf = {}

      example.example_group.description.split(';').each_with_index do |expr, i|
        i += 1
        conf["map#{i}".to_sym] = expr
      end

      conf
    end

    context 'new_record["new_foo"] = record["foo"].upcase; new_record["bar"] = 100' do
      it do
        is_expected.to eq [
          ["test.default", time, {"new_foo"=>"BAR", "bar"=>100}],
          ["test.default", time, {"new_foo"=>"ZOO", "bar"=>100}]
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
end
