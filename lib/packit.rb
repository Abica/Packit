module Packit
  class Field
    attr_accessor :name, :args

    def initialize( name, args )
      @name = Utils.cache_key_for name
      @args = args
    end

    def size
      0
    end
  end

  class Record
    def initialize
      @fields = []
    end

    def add name, args = {}
      @fields << Field.new( name.to_sym, args )
      self
    end

    def bring holder
      @fields += Backend.find( holder ).to_a
      self
    end

    def size
      @fields.inject( 0 ) { | sum, f | sum + f }
    end

    def to_a
      @fields.to_a
    end
  end

  class Backend
    class << self
      def new &block
        block.call( Record.new )
      end

      def create name, &block
        key = Utils.cache_key_for name
        records[ key ] ||= new &block
      end

      def find record
        return record if record.respond_to? :bring
        records[ Utils.cache_key_for( record ) ]
       end

      def count
        records.size
      end

      def clear
        records.clear
      end

      private
      def records
        @@records ||= {}
      end
    end
  end

  class Utils
    def self.cache_key_for name
      return name.to_sym if name.respond_to? :to_sym
      name
    end
  end

  class << self
    def [] name
      Backend.find name
    end
  end
end
