require File.join( "spec", "spec_helper" )
require File.join( "lib", "packit" )

describe Packit do
  describe "[]" do
    it "should return a Record instance" do
      record_name = :name
      Packit[ record_name ].should be_nil

      record = create_backend_record record_name

      Packit[ record_name ].should == record
    end
  end

  describe "Field" do
    describe "#size"
  end

  describe "Record" do
    before do
      @record = Packit::Record.new
    end

    describe "#add" do
      it "should add a Field to a record" do
        old_size = @record.to_a.size

        @record.add :a

        old_size.should < @record.to_a.size
      end
    end

    describe "#bring" do
      it "should include the fields from a 'brought in' record" do
        record_b_name = :b_name
        record_b = create_backend_record record_b_name do | record |
           record.add :b
           record.add :c
        end

        @record.to_a.should_not include( *record_b.to_a )

        @record.bring record_b_name

        @record.to_a.should include( *record_b.to_a )
      end
    end

    describe "#size" do
      it "should be zero" do
        @record.size.should be_zero
      end
    end

    describe "to_a" do
      it "should return an array" do
        @record.to_a.should be_a_kind_of( Array )
      end
    end
  end

  describe "Backend" do
    before do
      @backend = Packit::Backend
      @backend.clear
    end

    describe "#new" do
      it "should create a record but not add to the backend" do
        old_count = @backend.count

        new_record = @backend.new do | record |
          record.add :a
          record.add :b
        end

        new_record.should be_a_kind_of( Packit::Record )
        old_count.should == @backend.count
      end
    end

    describe "#create" do
      it "should create a record and add it to the backend" do
        record_name = :name
        old_count = @backend.count

        new_record = @backend.create record_name do | record |
          record.add :a
          record.add :b
        end

        new_record.should be_a_kind_of( Packit::Record )
        old_count.should < @backend.count

        @backend.find( record_name ).should == new_record
      end
    end

    describe "#find" do
      before do
        @name = :new_record
        @record = create_backend_record @name
      end

      describe "given an instance" do
        it "should return itself" do
          @backend.find( @record ).should == @record
        end
      end

      describe "given a symbol" do
        it "should return a record instance" do
          record = @backend.find( @name )
          record.should == @record

          record.should be_a_kind_of( Packit::Record )
        end
      end
    end

    describe "#count" do
      it "should change when a new record is added" do
        old_count = @backend.count

        create_backend_record

        old_count.should_not == @backend.count
      end
    end

    describe "#clear" do
      it "should remove all records" do
        create_backend_record
        @backend.count.should > 0

        @backend.clear

        @backend.count.should be_zero
      end
    end
  end

  describe "Utils" do
    [ nil, {}, 0b0011, "word", 32903290329032, [], // ].each do | key |
      klass = if key.respond_to? :to_sym
        key.to_sym.class
      else
        key.class
      end

      describe "#cache_key_for(#{ key.inspect })" do
        it "should return a #{ klass.to_s.downcase }" do
          Packit::Utils.cache_key_for( key ).should be_a_kind_of( klass )
        end
      end
    end
  end
end
