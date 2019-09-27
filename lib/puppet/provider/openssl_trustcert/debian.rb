# debian.rb --- Create a trusted certificate on debian

Puppet::Type.type(:openssl_trustcert).provide(:openssl_trustcert) do
  desc <<-EOT
    This provider implements the openssl_trustcert type on Debian.
  EOT

  confine :operatingsystem => :debian

  commands openssl: 'openssl'

  def gethash(certificate)
    param = ['openssl', 'x509', '-noout', '-hash']
    param << '-in' << certificate

    hash, status = Open3.capture2(*param)

    if status.success?
      hash.chomp!
      Puppet.debug("openssl_trustcert: #{certificate} has hash '#{hash}'")
      hash
    else
      Puppet.debug('openssl_trustcert: unable to get certificate hash')
      nil
    end
  end

  def exists?
    return false unless File.exist?(resource[:certificate])

    dest = File.dirname(resource[:certificate])
    hash = gethash(resource[:certificate])

    return false if hash.nil?

    link = File.join(dest, hash + '.0')
    return false unless File.exist?(link)

    Puppet.debug("openssl_trustcert: #{link} exists")

    return false unless File.symlink?(link)

    Puppet.debug("openssl_trustcert: #{link} is a symlink")

    linkdest = File.readlink(link)

    Puppet.debug("openssl_trustcert: #{link} -> #{linkdest}")

    return false unless linkdest == resource[:certificate]

    true
  end

  def create
    dest = File.dirname(resource[:certificate])
    hash = gethash(resource[:certificate])
    link = File.join(dest, hash + '.0')

    Puppet.debug("openssl_trustcert: creating link #{link} -> #{resource[:certificate]}")

    # Remove old junk first
    File.unlink(link) if File.exist?(link)
    File.symlink(resource[:certificate], link)
  end

  def destroy
    dest = File.dirname(resource[:certificate])
    hash = gethash(resource[:certificate])
    link = File.join(dest, hash + '.0')

    Puppet.debug("openssl_trustcert: removing link #{link} -> #{resource[:certificate]}")

    File.unlink(link)
  end
end
