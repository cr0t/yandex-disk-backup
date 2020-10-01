# frozen_string_literal: true

# Service that handles Yandex.Disk REST API calls
# https://tech.yandex.ru/disk/api/concepts/about-docpage/
class YandexDisk
  API_PREFIX = 'https://cloud-api.yandex.net/v1/disk'
  BACKUPS_LIMIT = 3
  UPLOAD_TIMEOUT = 600

  def initialize(access_token)
    @connection = Faraday.new do |conn|
      conn.request(:authorization, 'OAuth', access_token)
      conn.adapter(Faraday.default_adapter)
    end
  end

  def create_folder!(path)
    url = "#{API_PREFIX}/resources?path=#{path}"
    check_resp = @connection.get(url)
    return if check_resp.status == 200

    put(url) # to create folder, we need to send PUT to the same URL
  end

  def upload(local_path, remote_path)
    filename = File.basename(local_path)
    destination = CGI.escape("/#{remote_path}/#{filename}")
    url = "#{API_PREFIX}/resources/upload?path=#{destination}"
    resp = get(url)
    upload_href = JSON.parse(resp.body)['href']
    upload_to_storage(local_path, upload_href)
  end

  private

  # Upload connection doesn't need to send tokens
  # https://yandex.ru/dev/disk/api/reference/upload-docpage/#response-upload
  def upload_to_storage(local_path, repository)
    storage_connection = Faraday.new do |conn|
      conn.request(:multipart)
      conn.adapter(Faraday.default_adapter)
    end
    payload = { file: Faraday::UploadIO.new(local_path, 'application/binary') }
    storage_connection.put(repository, payload)
  end

  def get(url)
    resp = @connection.get(url)
    json = JSON.parse(resp.body)
    raise json['error'] if resp.status != 200

    resp
  end

  def put(url)
    resp = @connection.put(url)
    json = JSON.parse(resp.body)
    raise json['error'] if resp.status != 201

    resp
  end
end
