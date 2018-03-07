require 'spec_helper'

describe 'openssl::dhparam' do
  let(:pre_condition) do
    'class { "::openssl":
       default_key_dir       => "/key",
       default_cert_dir      => "/crt",
       cert_source_directory => "/foo",
       root_group            => "wheel"
     }'
  end

  let(:title) { '/foo/dh.pem' }

  on_supported_os.each do |os, facts|
    let(:facts) { facts }

    context "on #{os} with default parameters" do
      it {
        is_expected.to contain_class('openssl')

        is_expected.to contain_exec('openssl dhparam -out /foo/dh.pem -2 2048').
          with_creates('/foo/dh.pem').
          with_timeout('1800').
          that_requires('Package[openssl]').
          that_comes_before('File[/foo/dh.pem]')

        is_expected.to contain_file('/foo/dh.pem').
          with_ensure('file').
          with_owner('root').
          with_group('wheel').
          with_mode('0644')
      }
    end

    context "on #{os} with bits => 4096" do
      let(:params) do
        { bits: '4096' }
      end

      it {
        is_expected.to contain_class('openssl')

        is_expected.to contain_exec('openssl dhparam -out /foo/dh.pem -2 4096').
          with_creates('/foo/dh.pem').
          with_timeout('1800').
          that_requires('Package[openssl]').
          that_comes_before('File[/foo/dh.pem]')

        is_expected.to contain_file('/foo/dh.pem').
          with_ensure('file').
          with_owner('root').
          with_group('wheel').
          with_mode('0644')
      }
    end

    context "on #{os} with generator => 5" do
      let(:params) do
        { generator: '5' }
      end

      it {
        is_expected.to contain_class('openssl')

        is_expected.to contain_exec('openssl dhparam -out /foo/dh.pem -5 2048').
          with_creates('/foo/dh.pem').
          with_timeout('1800').
          that_requires('Package[openssl]').
          that_comes_before('File[/foo/dh.pem]')

        is_expected.to contain_file('/foo/dh.pem').
          with_ensure('file').
          with_owner('root').
          with_group('wheel').
          with_mode('0644')
      }
    end

    context "on #{os} with mode => 0642" do
      let(:params) do
        { mode: '0642' }
      end

      it {
        is_expected.to contain_class('openssl')

        is_expected.to contain_exec('openssl dhparam -out /foo/dh.pem -2 2048').
          with_creates('/foo/dh.pem').
          with_timeout('1800').
          that_requires('Package[openssl]').
          that_comes_before('File[/foo/dh.pem]')

        is_expected.to contain_file('/foo/dh.pem').
          with_ensure('file').
          with_owner('root').
          with_group('wheel').
          with_mode('0642')
      }
    end

    context "on #{os} with owner => mysql" do
      let(:params) do
        { owner: 'mysql' }
      end

      it {
        is_expected.to contain_class('openssl')

        is_expected.to contain_exec('openssl dhparam -out /foo/dh.pem -s 2048').
          with_creates('/foo/dh.pem').
          with_timeout('1800').
          that_requires('Package[openssl]').
          that_comes_before('File[/foo/dh.pem]')

        is_expected.to contain_file('/foo/dh.pem').
          with_ensure('file').
          with_owner('mysql').
          with_group('wheel').
          with_mode('0644')
      }
    end

    context "on #{os} with group => mysql" do
      let(:params) do
        { group: 'mysql' }
      end

      it {
        is_expected.to contain_class('openssl')

        is_expected.to contain_exec('openssl dhparam -out /foo/dh.pem -2 2048').
          with_creates('/foo/dh.pem').
          with_timeout('1800').
          that_requires('Package[openssl]').
          that_comes_before('File[/foo/dh.pem]')

        is_expected.to contain_file('/foo/dh.pem').
          with_ensure('file').
          with_owner('root').
          with_group('mysql').
          with_mode('0644')
      }
    end

    context "on #{os} with ensure => absent" do
      let(:params) do
        { ensure: 'absent' }
      end

      it {
        is_expected.to contain_class('openssl')
        is_expected.to contain_file('/foo/dh.pem').with_ensure('absent')
      }
    end
  end
end
