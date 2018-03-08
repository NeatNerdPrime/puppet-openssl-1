require 'spec_helper'

describe 'openssl::key' do
  let(:pre_condition) do
    'class { "::openssl":
       default_key_dir       => "/key",
       default_cert_dir      => "/crt",
       cert_source_directory => "/foo",
       root_group            => "wheel"
     }'
  end

  let(:title) { 'key' }

  before do
    MockFunction.new('file') do |f|
      f.stubbed.with('/foo/key.key').returns("# /foo/key.key\n")
      f.stubbed.with('/foo/secret.key').returns("# /foo/secret.key\n")
    end
  end

  on_supported_os.each do |os, facts|
    let(:facts) { facts }

    context "on #{os} with default parameters" do
      it {
        is_expected.to contain_class('openssl')

        is_expected.to contain_file('/key/key.key').
          with_ensure('file').
          with_owner('root').
          with_group('wheel').
          with_mode('0400').
          with_content("# /foo/key.key\n").
          with_backup('false').
          with_show_diff('false').
          that_requires('Package[openssl]')
      }
    end

    context "on #{os} with key => secret" do
      let(:params) do
        { key: 'secret' }
      end

      it {
        is_expected.to contain_class('openssl')

        is_expected.to contain_file('/key/secret.key').
          with_ensure('file').
          with_owner('root').
          with_group('wheel').
          with_mode('0400').
          with_content("# /foo/key.key\n").
          with_backup('false').
          with_show_diff('false').
          that_requires('Package[openssl]')
      }
    end

    context "on #{os} with source => secret" do
      let(:params) do
        { source: 'secret' }
      end

      it {
        is_expected.to contain_class('openssl')

        is_expected.to contain_file('/key/key.key').
          with_ensure('file').
          with_owner('root').
          with_group('wheel').
          with_mode('0400').
          with_content("# /foo/secret.key\n").
          with_backup('false').
          with_show_diff('false').
          that_requires('Package[openssl]')
      }
    end

    context "on #{os} with extension => pem" do
      let(:params) do
        { extension: 'pem' }
      end

      it {
        is_expected.to contain_class('openssl')

        is_expected.to contain_file('/key/key.pem').
          with_ensure('file').
          with_owner('root').
          with_group('wheel').
          with_mode('0400').
          with_content("# /foo/key.key\n").
          with_backup('false').
          with_show_diff('false').
          that_requires('Package[openssl]')
      }
    end

    context "on #{os} with key_mode => 0642" do
      let(:params) do
        { key_mode: '0642' }
      end

      it {
        is_expected.to contain_class('openssl')

        is_expected.to contain_file('/key/key.key').
          with_ensure('file').
          with_owner('root').
          with_group('wheel').
          with_mode('0642').
          with_content("# /foo/key.key\n").
          with_backup('false').
          with_show_diff('false').
          that_requires('Package[openssl]')
      }
    end

    context "on #{os} with key_owner => mysql" do
      let(:params) do
        { key_owner: 'mysql' }
      end

      it {
        is_expected.to contain_class('openssl')

        is_expected.to contain_file('/key/key.key').
          with_ensure('file').
          with_owner('mysql').
          with_group('wheel').
          with_mode('0400').
          with_content("# /foo/key.key\n").
          with_backup('false').
          with_show_diff('false').
          that_requires('Package[openssl]')
      }
    end

    context "on #{os} with key_group => mysql" do
      let(:params) do
        { key_group: 'mysql' }
      end

      it {
        is_expected.to contain_class('openssl')

        is_expected.to contain_file('/key/key.key').
          with_ensure('file').
          with_owner('root').
          with_group('mysql').
          with_mode('0400').
          with_content("# /foo/key.key\n").
          with_backup('false').
          with_show_diff('false').
          that_requires('Package[openssl]')
      }
    end

    context "on #{os} with key_dir => /baz" do
      let(:params) do
        { key_dir: '/baz' }
      end

      it {
        is_expected.to contain_class('openssl')

        is_expected.to contain_file('/baz/key.key').
          with_ensure('file').
          with_owner('root').
          with_group('wheel').
          with_mode('0400').
          with_content("# /foo/key.key\n").
          with_backup('false').
          with_show_diff('false').
          that_requires('Package[openssl]')
      }
    end

    context "on #{os} with key_file => /baz/key.pem" do
      let(:params) do
        { key_file: '/baz/key.pem' }
      end

      it {
        is_expected.to contain_class('openssl')

        is_expected.to contain_file('/baz/key.pem').
          with_ensure('file').
          with_owner('root').
          with_group('wheel').
          with_mode('0400').
          with_content("# /foo/key.key\n").
          with_backup('false').
          with_show_diff('false').
          that_requires('Package[openssl]')
      }
    end

    context "on #{os} with ensure => absent" do
      let(:params) do
        { ensure: 'absent' }
      end

      it {
        is_expected.to contain_class('openssl')
        is_expected.to contain_file('/key/key.key').with_ensure('absent')
      }
    end
  end
end