module Jekyll
  class JekyllService
    FEED_DIRECTORY = 'feed'
    POSTS_DIRECTORY = '_posts'

    def create_post(name, post)
      date = post.date.strftime('%Y-%m-%d')
      post_file = "#{date}-#{name}.md"

      post_path = File.join(FEED_DIRECTORY, post.categories, POSTS_DIRECTORY, post_file)

      # Create the feed directory
      FileUtils.mkdir_p(File.dirname(post_path))

      generate_markdown(post_path, post)
    end

    private

    def generate_markdown(path, post)
      date = post.date.strftime('%Y-%m-%d %H:%M:%S %z')
      categories = post.categories.join(' ')

      File.open(path, 'w') do |file|
        file.puts '---'
        file.puts "layout: #{post.layout}"
        file.puts "title: #{post.title}"
        file.puts "date: #{date}"
        file.puts "categories: #{categories}"
        file.puts '---'
        file.puts post.content
      end
    end
  end
end
