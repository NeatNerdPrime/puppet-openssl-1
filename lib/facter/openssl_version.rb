# frozen_string_literal: true

Facter.add(:openssl_version) do
  confine { Facter::Core::Execution.which('openssl') }
  setcode do
    Facter::Core::Execution.execute('openssl version', on_fail: nil).each_line.map do |line|
      Regexp.last_match(1) if line.match(%r{OpenSSL ([0-9.]+[a-z]?)}i)
    end.compact.first
  end
end
