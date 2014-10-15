class FlickrBackup
  def initialize(directory, flickr_object)
    @directory = directory
  end

  def start
    puts 'Backup starting...'
    Dir.mkdir(@directory) unless File.exist?(@directory)
    build_filetree(@directory)
  end

  def build_filetree(directory)
    flickr.collections.getTree.each { |col| process_collection(col) }
  end

  def process_collection(collection, directory = @directory)
    dir = "#{directory}/#{collection['title'].downcase.gsub(/\s/, '_')}"
    Dir.mkdir(dir) unless File.exist?(dir)
    if collection.to_hash.key?('set')
      collection['set'].each { |s| process_set(s, dir) }
    else
      collection['collection'].each { |c| process_collection(c, dir) }
    end
  end

  def process_set(set, directory)
    dir = "#{directory}/#{set['title'].downcase.gsub(/\s/, '_')}"
    Dir.mkdir(dir) unless File.exist?(dir)
    download_set(set, "#{directory}/#{set['title'].downcase.gsub(/\s/, '_')}")
  end

  def download_set(set, dir)
    set = flickr.photosets.getInfo(photoset_id: set['id'])
    page_count = (set['photos'].to_f / 500.0).ceil
    current_page = 1

    while current_page <= page_count
      photo_list =
        flickr.photosets.getPhotos(photoset_id: set['id'], extras: 'url_o',
                                   page: current_page, per_page: 500)
      photo_list = photo_list['photo']

      current_page += 1
      download(extract_urls_from(photo_list), dir, set['title'])
    end
  end

  def extract_urls_from(photo_list)
    photo_urls = []
    photo_list.map do |photo|
      photo_urls << if !photo["url_o"].nil?
        photo["url_o"]
      elsif !FlickRaw.url_b(photo).nil?
        FlickRaw.url_b(photo).to_s
      elsif !FlickRaw.url_c(photo).nil?
        FlickRaw.url_c(photo).to_s
      elsif !FlickRaw.url_z(photo).nil?
        FlickRaw.url_z(photo).to_s
      end
    end
    photo_urls
  end

  def download(image_urls, directory, title)
    concurrency = 8

    puts "\nDownloading #{image_urls.count} photos from the '#{title}' set with concurrency=#{concurrency} ..."
    FileUtils.mkdir_p(directory) unless File.exist?(directory)

    already_had = 0

    image_urls.each_slice(concurrency).each do |group|
      threads = []
      group.each do |url|
        threads << Thread.new {
          begin
            file = Mechanize.new.get(url)
            filename = File.basename(file.uri.to_s.split('?')[0])

            if File.exists?("#{directory}/#{filename}")
              puts "Already have #{url}"
              already_had += 1
            else
              puts "Saving photo #{url} to #{directory}/#{filename}"
              file.save_as("#{directory}/#{filename}")
            end

          rescue Mechanize::ResponseCodeError
            puts "Error getting file, #{$!}"
          end
        }
      end
      threads.each{|t| t.join }
    end
  end
end
