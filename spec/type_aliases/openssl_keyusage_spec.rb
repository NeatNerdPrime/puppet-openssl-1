# frozen_string_literal: true

require 'spec_helper'

describe 'Openssl::Keyusage' do
  %w[digitalSignature nonRepudiation
     keyEncipherment dataEncipherment
     keyAgreement keyCertSign
     cRLSign encipherOnly decipherOnly].each do |value|
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) { facts }

        context "can be #{value}" do
          it {
            is_expected.to allow_value(value)
          }
        end
      end
    end
  end
end
