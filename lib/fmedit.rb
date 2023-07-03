require "yaml"
require_relative "fmedit/version"

module Fmedit
  class Files
    attr_reader :markdown_files
    def initialize dir
      @markdown_files = File.join(dir)
    end

    def each
      Dir.glob(markdown_files).each do |filename|
        editor = Editor.new filename
        yield editor
      end

      # f.add "hidden", true if f.get("published").nil?
      # f.add "published", true

      # if f.get("hidden") == true && f.get("published") == true
        # f.add "exclude_from_pagination", true
      # end
      # f.remove "hidden"
      # f.print!
      # f.edit "image", /^((?!images\/.+|\/|http).*)$/, "/images/\\1"
      # f.edit "image", /^(images\/.+)$/, "\/\\1"
      # f.print!
    end
  end

  class Editor
    attr_reader :filename, :frontmatter, :contents

    def initialize filename
      @filename = filename
      @frontmatter = {}
      @contents = ""
      parse
    end

    def parse
      File.open(filename, "r") do |file|
        in_frontmatter = false
        read_frontmatter = false
        frontmatter_string = ""

        file.each_line do |line|
          if line.start_with? "---"
            # start reading yaml strings
            if !in_frontmatter && !read_frontmatter
              in_frontmatter = true
            elsif in_frontmatter
              in_frontmatter = false
              read_frontmatter = true
            end
          elsif in_frontmatter
            frontmatter_string << line
          else
            @contents << line
          end
        end

        @frontmatter = YAML.safe_load(frontmatter_string)
      end
    end

    def edit key, regex, replacement
      return unless frontmatter[key]

      @frontmatter[key] = @frontmatter[key].gsub(regex, replacement)
    end

    def add key, value
      return if @frontmatter.has_key? key

      add! key, value
    end

    # Add the key/value even if it exists
    def add! key, value
      @frontmatter[key] = value
    end

    # Remove the key/value
    def remove key
      @frontmatter.delete(key)
    end

    # Get the value of the key
    def get key
      @frontmatter[key]
    end

    # Print the frontmatter and contents to stdout
    def print frontmatter_only: true
      puts frontmatter.to_yaml
      puts "---\n"
      if !frontmatter_only
        contents.each_line do |line|
          puts line
        end
      end
    end

    # Save the frontmatter and contents back to the file
    def save!
      File.open(filename, "w") do |file|
        file.puts frontmatter.to_yaml
        file.puts "---\n"
        contents.each_line do |line|
          file.puts line
        end
      end
    end
  end
end
