# frozen_string_literal: true

require 'spec_helper'

describe 'Openssl::Extendedkeyusage' do
  %w[serverAuth clientAuth codeSigning emailProtection
     timeStamping OCSPSigning ipsecIKE
     msCodeInd msCodeCom msCTLSign msEFS].each do |value|
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
