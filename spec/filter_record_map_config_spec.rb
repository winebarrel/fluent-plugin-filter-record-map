describe 'Fluent::RecordMapFilter#configure' do
  subject do |example|
    param = example.full_description.split(/\s+/)[1]
    create_driver(fluentd_conf).instance.send(param)
  end

  let(:fluentd_conf) do |example|
    param = example.full_description.split(/\s+/)[1]
    {map1: 'record'}.merge(param.to_sym => example.example_group.description)
  end

  describe 'map1' do
    context 'new_record["new_foo"] = record["foo"].upcase; new_record["bar"] = 100' do
      it { is_expected.to eq 'new_record["new_foo"] = record["foo"].upcase; new_record["bar"] = 100' }
    end
  end

  describe 'map2' do
    context 'new_record["new_foo"] = record["foo"].upcase; new_record["bar"] = 100' do
      it { is_expected.to eq 'new_record["new_foo"] = record["foo"].upcase; new_record["bar"] = 100' }
    end
  end
end
