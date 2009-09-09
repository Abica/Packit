require File.join( "spec", "spec_helper" )
require File.join( "lib", "packit" )

def create_record( name = :temp )
	Packit::Backend.create name do | record |
		if block_given?
			yield record
		else
			record.add :field_1
			record.add :field_2
			record.add :field_3
		end
	end
end

describe "Packit::Field" do
	it "ssdsd"
end

describe "Packit::Record" do
	it "ssdsd"
end

describe "Packit::Backend" do
	before do
		@backend = Packit::Backend
		@backend.clear
	end

	describe "#new" do
		it "should create a record but not add to the backend" do
			old_count = @backend.count

			@backend.new do | record |
				record.add :a
				record.add :b
				record.add :c
			end

			old_count.should == @backend.count
			
		end
	end

	describe "#create" do
		it "ssdsd"
	end

	describe "#find" do
		before do
			@name = :new_record
			@record = create_record @name
			
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

			create_record

			old_count.should_not == @backend.count
		end
	end

	describe "#clear" do
		it "should remove all records" do
			create_record
			@backend.count.should > 0

			@backend.clear

			@backend.count.should be_zero
		end
	end
end

describe "Packit::Utils" do
	it ""
end
