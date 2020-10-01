# frozen_string_literal: true

# Local files/folders compressor service
class Compressor
  TEMP_DIR = '/tmp'

  def prepare(path)
    timestamp = Time.now.to_s.gsub(/[+:\s+]/, '_')
    basename = File.basename(path)
    archivename = "#{basename}_#{timestamp}.tar.gz"
    @artefact_path = "#{TEMP_DIR}/#{archivename}"
    `tar czf #{@artefact_path} #{path} > /dev/null 2>&1`
    @artefact_path
  end

  def cleanup!
    File.delete(@artefact_path) if @artefact_path
  end
end
