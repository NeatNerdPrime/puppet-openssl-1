# frozen_string_literal: true

require 'tempfile'
require 'puppet_x'
require_relative '../openssl'

# A utility class to encapsulate the layout of the OpenSSL CA database file
# and provide locked read/append/write access to the database.
#
class PuppetX::OpenSSL::CADB
  # Certificate is valid in the CA database
  VALID = 'V'

  # Certificate is revoked in the CA database
  REVOKED = 'R'

  # Certificate is expired in the CA database
  EXPIRED = 'E'

  # The format of a line in the CA database
  DB_LINE_FORMAT = Regexp.new('^(\S)\t(\d+Z)\t(.*)\t(\S+)\t(.+)\t(.+)')

  # Return a timestamp formatted for the CA database
  def self.timestamp(time)
    time.strftime('%Y%m%d%H%M%SZ')
  end

  # Read the CA database file.
  def self.read(filename)
    done = false
    loop do
      File.open(filename, 'rb') do |db|
        if db.flock(File::LOCK_EX)
          yield db if block_given?
          done = true
        end
      end
      break if done
    end
  end

  # Append to the CA database file.
  def self.append(filename)
    done = false
    loop do
      File.open(filename, 'ab') do |db|
        if db.flock(File::LOCK_EX)
          yield db if block_given?
          done = true
        end
      end
      break if done
    end
  end

  # Replace the CA database file with a new version.
  #
  # The old database file is NOT locked as the code expects that the old
  # database file is already open (and therefore locked) in read mode.
  def self.replace(filename)
    mode = begin
             File::Stat.new(filename) & 0o666
           rescue
             0o644
           end

    # Create new database file with a temporary name
    db = Tempfile.create(File.basename(filename), File.dirname(filename))

    # Use file permissions from the original file
    db.chmod(mode)
    db.binmode

    yield db if block_given?
    db.close

    # Make it the new database file
    File.rename(db.path, filename)
  end
end
