
class SearchEntries < ApplicationService

    def call
      filter
    end

    private

    attr_reader :resources, :options

    def initialize(resources, options)
      @resources = resources
      @options   = options
    end

    def filter
      if options[:user_id]
        @resources = resources.where(user_id: options[:user_id])
      end

      if options[:title]
        @resources = resources.where("lower(title) LIKE ?", "%#{options[:title].downcase}%")
      end

      if options[:place]
        @resources = resources.where("lower(description) LIKE ?", "%#{options[:description].downcase}%")
      end

      if options[:note]
        @resources = resources.where("lower(category) LIKE ?", "%#{options[:category].downcase}%")
      end

      if options[:search_phrase]
        @resources = (resources.where("lower(title) LIKE ?", "%#{options[:search_phrase].downcase}%"))
        .or(resources.where("lower(place) LIKE ?", "%#{options[:search_phrase].downcase}%"))
        .or(resources.where("lower(note) LIKE ?", "%#{options[:search_phrase].downcase}%"))
        .or(resources.where("lower(weather) LIKE ?", "%#{options[:search_phrase].downcase}%"))
      end

      resources
    end
  end
