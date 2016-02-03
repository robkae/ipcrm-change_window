require 'spec_helper'
require 'hiera'

describe 'change_window::apply', :type => :define do
  let :title do
    'test_change_window_apply'
  end
  let :default_params do
    {
      :class_list => [
        'test_notify_simple',
          { 'test_notify_parameter' => {
              'mesg' => 'test_notify_parameter'
            }
          } ]
    }
  end

  describe 'with_false_change_window' do
    let :params do
      default_params.merge({
        :change_window_set => [
          [ '-05:00', 'window', {'start' => 'Sunday', 'end' => 'Sunday'}, {'start' => '23:59', 'end' => '23:59' }],
        ]
      })
    end
    it { is_expected.to contain_notify('test_notify_simple').with_noop(true) }
    it { is_expected.to contain_notify('test_notify_parameter').with_noop(true) }
    it { is_expected.to contain_class('test_notify_simple') }
    it { is_expected.to contain_class('test_notify_parameter') }
  end


  describe 'with_true_change_window' do
    let :params do
      default_params.merge({
        :change_window_set => [
          [ '-05:00', 'window', {'start' => 'Tuesday', 'end' => 'Thursday'}, {'start' => '08:00', 'end' => '22:00' }],
          [ '-05:00', 'window', {'start' => 'Wednesday', 'end' => 'Thursday'}, {'start' => '22:00', 'end' => '02:00' }],
        ]
      })
    end
    it { is_expected.to contain_notify('test_notify_simple').without_noop }
    it { is_expected.to contain_notify('test_notify_parameter').without_noop }
    it { is_expected.to contain_class('test_notify_simple') }
  end

  describe 'with_bad_change_window_set' do
    let :params do
      default_params.merge({
        :change_window_set => ""
      })
    end
    it { is_expected.not_to compile }
  end

end
