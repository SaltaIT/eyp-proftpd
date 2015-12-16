require 'spec_helper'
describe 'proftpd' do

  context 'with defaults for all parameters' do
    it { should contain_class('proftpd') }
  end
end
